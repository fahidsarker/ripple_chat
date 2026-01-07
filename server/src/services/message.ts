import { db, tables } from "../db";
import { SendMessageInput } from "../validators";

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
    .returning();
};
