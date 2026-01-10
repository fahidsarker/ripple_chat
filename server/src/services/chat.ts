import { and, desc, eq, ilike, inArray, or, sql } from "drizzle-orm";
import { db } from "../db";
import { chatMembers, chats, users } from "../db/schema";
import { CreateChatInput } from "../validators";
import { Res } from "../core/response";
import { apiError } from "../core/api-error";

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
}) => {
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
      createdAt: chats.createdAt,

      // Last message fields
      lastMessageId: sql<string>`last_msg.id`,
      lastMessageContent: sql<string>`last_msg.content`,
      lastMessageSenderId: sql<string>`last_msg.sender_id`,
      lastMessageSenderName: sql<string>`last_sender.name`,
      lastMessageCreatedAt: sql<string>`last_msg.created_at`,

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
        return {
          ...chat,
          title,
        };
      })
    );
};
