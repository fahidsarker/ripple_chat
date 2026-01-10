import { and, desc, eq, ilike, inArray, or, sql } from "drizzle-orm";
import { db } from "../db";
import { chatMembers, chats, messages, users } from "../db/schema";
import { CreateChatInput } from "../validators";
import { apiError } from "../core/api-error";
import { ResChat } from "../types/responses";

export const getChatMembers = async (chatId: string) => {
  return await db
    .select({ id: users.id, name: users.name })
    .from(chatMembers)
    .innerJoin(users, eq(chatMembers.userId, users.id))
    .where(eq(chatMembers.chatId, chatId));
};

export const createNewChat = async (
  data: CreateChatInput,
  createdBy: string
) => {
  const { isGroup, memberIds, title } = data;

  // Add creator to member list if not already included
  const allMemberIds = [...new Set([createdBy, ...memberIds])];

  // Verify all members exist
  const existingUsers = await db
    .select({ id: users.id })
    .from(users)
    .where(inArray(users.id, allMemberIds));

  if (existingUsers.length !== allMemberIds.length) {
    throw apiError(400, "One or more specified users do not exist");
  }

  // Create chat
  const [newChat] = await db
    .insert(chats)
    .values({
      title,
      isGroup,
      createdBy,
    })
    .returning({ id: chats.id });

  // Add members to chat
  const memberInserts = allMemberIds.map((userId) => ({
    chatId: newChat.id,
    userId,
  }));

  await db.insert(chatMembers).values(memberInserts);
  return newChat;
};

export const hasUserAccessToChat = async (chatId: string, userId: string) => {
  return await db.query.chatMembers.findFirst({
    where: and(eq(chatMembers.chatId, chatId), eq(chatMembers.userId, userId)),
  });
};

export const queryChats = async ({
  userId,
  limit,
  offset,
  search,
  chatId,
}: {
  userId: string;
  limit: number;
  offset: number;
  search?: string;
  chatId?: string;
}): Promise<ResChat[]> => {
  const chatSearchFilter = search
    ? or(
        ilike(chats.title, `%${search}%`),

        sql<boolean>`
            EXISTS (
              SELECT 1
              FROM chat_members cm3
              JOIN users u2 ON u2.id = cm3.user_id
              WHERE cm3.chat_id = ${chats.id}
                AND u2.name ILIKE ${`%${search}%`}
            )
          `
      )
    : undefined;
  const chatIdFilter = chatId ? eq(chats.id, chatId) : undefined;

  return await db
    .select({
      id: chats.id,
      title: chats.title,
      isGroup: chats.isGroup,
      createdBy: chats.createdBy,
      createdAt: chats.createdAt,

      // Last message fields
      lastMessageId: sql<string>`last_msg.id`,
      lastMessageChatId: sql<string>`last_msg.chat_id`,
      lastMessageSenderId: sql<string>`last_msg.sender_id`,
      lastMessageContent: sql<string>`last_msg.content`,
      lastMessageCreatedAt: sql<string>`last_msg.created_at`,
      lastMessageSenderName: sql<string>`last_sender.name`,

      // Last message attachments
      lastMessageAttachments: sql<
        Array<{ id: string; ext: string; originalName: string }>
      >`
          (
            SELECT json_agg(json_build_object('id', f.id, 'ext', f.ext, 'originalName', f.original_name))
            FROM files f
            WHERE f.parent_id = last_msg.id
              AND f.parent_type = 'message'
              AND f.deleted = false
          )
        `,

      // Chat members list
      members: sql<Array<{ id: string; name: string }>>`
          (
            SELECT json_agg(json_build_object('id', u.id, 'name', u.name))
            FROM chat_members cm2
            JOIN users u ON u.id = cm2.user_id
            WHERE cm2.chat_id = ${chats.id}
          )
        `,
    })
    .from(chats)

    // Filter chats by membership
    .innerJoin(chatMembers, eq(chatMembers.chatId, chats.id))
    .where(and(eq(chatMembers.userId, userId), chatSearchFilter, chatIdFilter))

    // LATERAL JOIN: latest message
    .leftJoin(
      sql`
          LATERAL (
            SELECT m.*
            FROM messages m
            WHERE m.chat_id = ${chats.id}
            ORDER BY m.created_at DESC
            LIMIT 1
          ) AS last_msg
        `,
      sql`true`
    )

    // LATERAL JOIN: message sender info
    .leftJoin(
      sql`
          LATERAL (
            SELECT name
            FROM users
            WHERE id = last_msg.sender_id
          ) AS last_sender
        `,
      sql`true`
    )

    .orderBy(sql`last_msg.created_at DESC NULLS LAST`, desc(chats.createdAt))
    .limit(limit)
    .offset(offset)
    .then((chats) =>
      chats.map((chat) => {
        let title = chat.title;
        if (!chat.title) {
          title = chat.members
            .filter((m) => m.id !== userId)
            .map((m) => m.name)
            .join(", ");
        }

        // Build lastMessage object if message exists
        const lastMessage = chat.lastMessageId
          ? {
              id: chat.lastMessageId,
              chatId: chat.lastMessageChatId,
              senderId: chat.lastMessageSenderId,
              content: chat.lastMessageContent,
              createdAt: new Date(chat.lastMessageCreatedAt),
              senderName: chat.lastMessageSenderName,
              attachments: chat.lastMessageAttachments || [],
            }
          : undefined;

        return {
          id: chat.id,
          title,
          isGroup: chat.isGroup,
          createdBy: chat.createdBy,
          createdAt: chat.createdAt,
          lastMessage,
          members: chat.members,
        };
      })
    );
};

//   const chatsRes = await db.query.chats.findMany({
//     orderBy: [desc(messages.createdAt), desc(chats.createdAt)],
//     with: {
//       members: {
//         columns: { id: true },
//         with: {
//           user: { columns: { name: true } },
//         },
//       },

//       messages: {
//         orderBy: [desc(messages.createdAt)],
//         limit: 1,
//         with: {
//           sender: { columns: { name: true } },
//           attachments: { columns: { id: true, ext: true } },
//         },
//       },
//     },
//   });

//   return chatsRes.map((chatRow) => {
//     const { members, messages, ...chat } = chatRow;
//     return {
//       lastMessage: messages.map((mgsRow) => {
//         const { attachments, sender, ...mgs } = mgsRow;
//         return {
//           ...mgs,
//           senderName: sender.name,
//           attachments: attachments,
//         };
//       })[0],
//       ...chat,
//       members: members.map((m) => ({ id: m.id, name: m.user.name })),
//     };
//   });
// };
