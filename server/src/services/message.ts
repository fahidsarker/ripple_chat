import { and, desc, eq, ilike } from "drizzle-orm";
import { db, tables } from "../db";
import { SendMessageInput } from "../validators";
import { files, messages } from "../db/schema";

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
) => {
  return await db.query.messages.findMany({
    where: and(
      eq(messages.chatId, chatId),
      search ? ilike(messages.content, `%${search}%`) : undefined,
      messageId ? eq(messages.id, messageId) : undefined
    ),
    with: {
      sender: {
        columns: { id: true, name: true },
      },
      attachments: {
        where: and(eq(files.parentType, "message")),
        columns: {
          id: true,
          originalName: true,
          ext: true,
          relativePath: true,
        },
      },
    },
    orderBy: [desc(messages.createdAt)],
    limit,
    offset,
  });
};
