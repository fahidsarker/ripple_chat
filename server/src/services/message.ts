import { and, desc, eq, ilike } from "drizzle-orm";
import { db, tables } from "../db";
import { SendMessageInput } from "../validators";
import { files, messages } from "../db/schema";
import { ResMessage } from "../types/responses";

export const createNewMessage = async ({
  content,
  chatId,
  userId,
}: SendMessageInput & {
  chatId: string;
  userId: string;
}) => {
  return await db
    .insert(tables.messages)
    .values({
      content: content,
      chatId: chatId,
      senderId: userId,
    })
    .returning({ id: messages.id })
    .then((result) => result[0]);
};

export const getMessages = async (
  chatId: string,
  {
    limit,
    offset,
    search,
    messageId,
  }: {
    limit?: number;
    offset?: number;
    search?: string;
    messageId?: string;
  }
): Promise<ResMessage[]> => {
  const mRes = await db.query.messages.findMany({
    where: and(
      eq(messages.chatId, chatId),
      search ? ilike(messages.content, `%${search}%`) : undefined,
      messageId ? eq(messages.id, messageId) : undefined
    ),
    with: {
      sender: {
        columns: { name: true },
      },
      attachments: {
        where: and(eq(files.parentType, "message")),
        columns: {
          id: true,
          originalName: true,
          ext: true,
        },
      },
    },
    orderBy: [desc(messages.createdAt)],
    limit,
    offset,
  });

  return mRes.map((m) => {
    const { attachments, sender, ...mgs } = m;
    return {
      ...mgs,
      senderName: sender.name,
      attachments,
    };
  });
};
