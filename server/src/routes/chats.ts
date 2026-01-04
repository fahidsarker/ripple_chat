import express, { Request, Response } from "express";
import { authRequired } from "../middleware/auth";
import { getUser } from "../services/auth";
import { apiHandler } from "../core/api-handler";
import { Res } from "../core/response";
import { db } from "../db";
import { chatMembers, chats, users } from "../db/schema";
import { desc, eq, inArray } from "drizzle-orm";
import { CreateChatInput, createChatSchema } from "../validators";

const router = express.Router();

// Apply authentication middleware to all chat routes
router.use(authRequired);

// GET /chats - Get all chats for the authenticated user
router.get(
  "/",
  apiHandler(async (req) => {
    try {
      const userId = getUser(req).userId;

      const userChats = await db
        .select({
          id: chats.id,
          title: chats.title,
          isGroup: chats.isGroup,
          createdBy: chats.createdBy,
          createdAt: chats.createdAt,
          creatorName: users.name,
        })
        .from(chatMembers)
        .innerJoin(chats, eq(chatMembers.chatId, chats.id))
        .innerJoin(users, eq(chats.createdBy, users.id))
        .where(eq(chatMembers.userId, userId))
        .orderBy(desc(chats.createdAt));

      // res.json(userChats);
      return Res.json({ chats: userChats });
    } catch (error) {
      console.error("Get chats error:", error);
      return Res.error("Internal server error");
    }
  })
);

// POST /chats - Create a new chat
router.post(
  "/",
  apiHandler(async (req: Request) => {
    try {
      const validatedData = createChatSchema.parse(req.body);
      const { isGroup, memberIds, title } = validatedData;
      const createdBy = getUser(req).userId;

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

      return Res.json(
        {
          message: "Chat created successfully",
          chat: newChat,
        },
        201
      );
    } catch (error: any) {
      if (error.name === "ZodError") {
        return Res.error("Invalid input", 400);
      }
      console.error("Create chat error:", error);
      return Res.error("Internal server error");
    }
  })
);

export default router;
