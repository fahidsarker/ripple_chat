import { Request } from "express";
import multer from "multer";
import crypto from "crypto";

import { getUser } from "../services/auth";
import { buckets } from "./storage-utils";
import { apiError } from "../core/api-error";

// if req.path starts with /api/profile -> put it in env.FILE_STORAGE_PATH/profile_photos
// if req.path starts with /api/chat/:id/message -> put it in env.FILE_STORAGE_PATH/message_attachments
// if it is in /api/chat/:id -> put it in env.FILE_STORAGE_PATH/chat_photos
// else put it in env.FILE_STORAGE_PATH/misc

const getStoragePath = (req: Request): string => {
  const userId = getUser(req).userId;

  const reqPath = req.originalUrl;

  if (reqPath.startsWith("/api/profile")) {
    return buckets.profile_photos({ userId });
  } else if (reqPath.startsWith("/api/chat/")) {
    const cid = req.params.cid;
    if (!cid) {
      throw new Error("Chat ID not found in request parameters");
    }
    if (reqPath.includes("/messages")) {
      return buckets.message_attachments({ chatId: cid });
    }
    return buckets.chat_attachments({ chatId: cid });
  } else {
    throw apiError(400, "Invalid upload path");
  }
};

// Configure multer for file uploads
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    // todo: fallback to a default path if env.FILE_STORAGE_PATH is not set
    cb(null, getStoragePath(req)); //  Ensure this directory exists
  },
  filename: (req, file, cb) => {
    const rand = crypto.randomUUID();
    const originalName = file.originalname;
    const extension = originalName.substring(
      originalName.lastIndexOf("."),
      originalName.length
    );
    cb(null, `${rand}${extension}`);
  },
});

export const upload = multer({
  storage: storage,
  limits: {
    fileSize: 5 * 1024 * 1024, // 5MB limit
  },
  fileFilter: (req, file, cb) => {
    // Accept only image files
    if (file.mimetype.startsWith("image/")) {
      cb(null, true);
    } else {
      cb(new Error("Only image files are allowed"));
    }
  },
});
