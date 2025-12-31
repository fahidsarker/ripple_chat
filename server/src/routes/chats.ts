import express, { Request, Response } from "express";
import { authRequired } from "../middleware/auth";
import { getUser } from "../services/auth";
import { apiHandler } from "../core/api-handler";
import { Res } from "../core/response";

const router = express.Router();

// Apply authentication middleware to all chat routes
router.use(authRequired);

router.get(
  "/",
  apiHandler(async (req) => {
    console.log("Fetching chats for user:", getUser(req).userId);
    return Res.json({ message: "List of chats" });
  })
);

export default router;
