import express, { Request, Response } from "express";
import { authRequired } from "../middleware/auth";
import { getUser } from "../services/auth";
import { apiHandler, queryParams } from "../core/api-handler";
import { Res } from "../core/response";
import { db } from "../db";
import { messages } from "../db/schema";
import { and, desc, eq, ilike } from "drizzle-orm";
import { hasUserAccessToChat } from "../services/chat";
import { upload } from "../core/multer";
import { sendMessageSchema } from "../validators";
import { createNewMessage } from "../services/message";

const router = express.Router({ mergeParams: true });
router.use(authRequired);
router.get(
  "/",
  apiHandler(async (req: Request) => {
    const chatId = req.params.cid;
    const userId = getUser(req).userId;
    const hasAccess = await hasUserAccessToChat(chatId, userId);

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

router.post(
  "/",
  upload.array("attachments"),
  apiHandler(async (req: Request) => {
    const body = sendMessageSchema.safeParse(req.body);
    if (!body.success) {
      return Res.error("Invalid input", 400);
    }

    const message = await createNewMessage({
      ...body.data,
      chatId: req.params.cid,
      userId: getUser(req).userId,
    });
    return Res.json({
      message,
    });
  })
);

export default router;
