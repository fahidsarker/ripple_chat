import express, { Request, Response } from "express";
import { authRequired } from "../middleware/auth";
import { getUser } from "../services/auth";
import { apiHandler, queryParams } from "../core/api-handler";
import { Res } from "../core/response";
import { db } from "../db";
import { chatMembers, chats, users } from "../db/schema";
import { and, desc, eq, ilike, inArray, or } from "drizzle-orm";
import { CreateChatInput, createChatSchema } from "../validators";
import { env } from "../env";

const router = express.Router();

// Apply authentication middleware to all chat routes
router.use(authRequired);

// GET /chats - Get all chats for the authenticated user
router.get(
  "/",
  apiHandler(async (req) => {
    try {
      // custom delay to simulate loading
      // await new Promise((resolve) => setTimeout(resolve, 2000));

      const userId = getUser(req).userId;
      const { limit, offset, search } = queryParams(req);

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
        .where(
          and(
            eq(chatMembers.userId, userId),
            search
              ? or(
                  ilike(chats.title, `%${search}%`),
                  ilike(users.name, `%${search}%`)
                )
              : undefined
          )
        )
        .orderBy(desc(chats.createdAt))
        .limit(limit)
        .offset(offset);

      // res.json(userChats);
      return Res.json({ chats: userChats });
    } catch (error) {
      console.error("Get chats error:", error);
      return Res.error("Internal server error");
    }
  })
);

const createNewChat = async (data: CreateChatInput, createdBy: string) => {
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

// POST /chats - Create a new chat
router.post(
  "/",
  apiHandler(async (req: Request) => {
    try {
      const validatedData = createChatSchema.parse(req.body);
      const createdBy = getUser(req).userId;

      const newChat = await createNewChat(validatedData, createdBy);
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

// todo: tobe removed in production
// router.post(
//   "/create-dummy",
//   apiHandler(async (req: Request) => {
//     if (env.NODE_ENV === "production") {
//       return Res.error("Not found", 404);
//     }
//     try {
//       const createdBy = getUser(req).userId;
//       const length = 100;
//       const members = ["df0e8adb-135d-447c-aafd-aca933fd5249"];

//       for (let i = 0; i < length; i++) {
//         const dummyChatData: CreateChatInput = {
//           isGroup: false,
//           memberIds: members,
//           title: `Dummy Chat ${i + 1}`,
//         };
//         await createNewChat(dummyChatData, createdBy);
//       }

//       console.log(`${length} Dummy chats created successfully`);

//       return Res.json(
//         {
//           message: `${length} Dummy chats created successfully`,
//         },
//         201
//       );
//     } catch (error: any) {
//       if (error.name === "ZodError") {
//         return Res.error("Invalid input", 400);
//       }
//       console.error("Create chat error:", error);
//       return Res.error("Internal server error");
//     }
//   })
// );

export default router;
