import express, { Request, Response } from "express";
import { authRequired } from "../middleware/auth";
import { getUser } from "../services/auth";
import { apiHandler, queryParams } from "../core/api-handler";
import { Res } from "../core/response";
import { db } from "../db";
import { chatMembers, chats, messages, users } from "../db/schema";
import { and, desc, eq, ilike, inArray, or, sql } from "drizzle-orm";
import { CreateChatInput, createChatSchema } from "../validators";

const router = express.Router();
router.use(authRequired);
router.get(
  "/",
  apiHandler(async (req: Request) => {
    const chatId = req.params.cid;
    const userId = getUser(req).userId;
    const hasAccess = await db.query.chatMembers.findFirst({
      where: and(
        eq(chatMembers.chatId, chatId),
        eq(chatMembers.userId, userId)
      ),
    });

    if (!hasAccess) {
      return Res.error("Access denied", 403);
    }

    const { limit, offset, search } = queryParams(req);
    const chatMessages = await db.query.messages.findMany({
      where: and(
        eq(messages.chatId, chatId),
        search ? ilike(messages.content, `%${search}%`) : undefined
      ),
      with: {
        sender: {
          columns: { id: true, name: true },
        },
        attachments: {
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

    return Res.json({ messages: chatMessages });
  })
);

export default router;
