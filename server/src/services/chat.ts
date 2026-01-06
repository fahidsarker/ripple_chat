import { inArray } from "drizzle-orm";
import { db } from "../db";
import { chatMembers, chats, users } from "../db/schema";
import { CreateChatInput } from "../validators";
import { Res } from "../core/response";

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
    return Res.error("Some users do not exist", 400);
  }

  // Create chat
  const [newChat] = await db
    .insert(chats)
    .values({
      title,
      isGroup,
      createdBy,
    })
    .returning();

  // Add members to chat
  const memberInserts = allMemberIds.map((userId) => ({
    chatId: newChat.id,
    userId,
  }));

  await db.insert(chatMembers).values(memberInserts);
  return newChat;
};
