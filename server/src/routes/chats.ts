import express, { Request, Response } from "express";
import { authRequired } from "../middleware/auth";
import { getUser } from "../services/auth";
import { apiHandler, queryParams } from "../core/api-handler";
import { Res } from "../core/response";
import { CreateChatInput, createChatSchema } from "../validators";
import messagesRouter from "./messages";
import { createNewChat, queryChats } from "../services/chat";
import { broadcastNewChat } from "../ws/broadcasters";

const router = express.Router();

router.use(authRequired);

router.get(
  "/",
  apiHandler(async (req) => {
    try {
      const userId = getUser(req).userId;
      const { limit, offset, search } = queryParams(req);
      const userChats = await queryChats({ userId, limit, offset, search });
      // res.json(userChats);
      return Res.json({ chats: userChats });
    } catch (error) {
      console.error("Get chats error:", error);
      return Res.error("Internal server error");
    }
  })
);

router.get(
  "/:cid",
  apiHandler(async (req) => {
    try {
      const userId = getUser(req).userId;
      const [chat] = await queryChats({
        userId,
        limit: 1,
        chatId: req.params.cid!,
        offset: 0,
      });

      if (!chat) {
        return Res.error("Chat not found", 404);
      }

      return Res.json({ chat });
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
      const createdBy = getUser(req).userId;

      const newChatRes = await createNewChat(validatedData, createdBy);
      if (!newChatRes) {
        return Res.error("Failed to create chat", 500);
      }

      const [newChat] = await queryChats({
        userId: createdBy,
        limit: 1,
        chatId: newChatRes.id,
        offset: 0,
      });

      if (!newChat) {
        return Res.error("Chat not found after creation", 500);
      }

      broadcastNewChat(newChat);

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

router.use("/:cid/messages", messagesRouter);

export default router;
