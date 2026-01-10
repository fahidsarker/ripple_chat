import express, { Request } from "express";
import { authRequired } from "../middleware/auth";
import { getUser } from "../services/auth";
import { apiHandler, queryParams } from "../core/api-handler";
import { Res } from "../core/response";
import { hasUserAccessToChat } from "../services/chat";
import { upload } from "../core/multer";
import { sendMessageSchema } from "../validators";
import { createNewMessage, getMessages } from "../services/message";
import { broadcastNewMessage } from "../ws/broadcasters";
import { ResMessage } from "../types/responses";

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
    const chatMessages = (await getMessages(chatId, {
      limit,
      offset,
      search,
    })) satisfies ResMessage[];

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

    const insertedMessage = await createNewMessage({
      ...body.data,
      chatId: req.params.cid,
      userId: getUser(req).userId,
    });

    if (!insertedMessage) {
      return Res.error("Failed to send message", 500);
    }

    const [newMessage] = await getMessages(req.params.cid, {
      limit: 1,
      offset: 0,
      messageId: insertedMessage.id,
    });

    if (!newMessage) {
      return Res.error("Failed to retrieve message", 500);
    }

    broadcastNewMessage(req.params.cid, newMessage);
    return Res.json({
      message: newMessage,
    });
  })
);

export default router;
