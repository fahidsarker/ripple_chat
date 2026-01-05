import { env } from "../env";

import fs from "fs";
import path from "path";

export const storageBucketTags = [
  "profile_photos",
  "message_attachments",
  "chat_attachments",
] as const;

export type StorageBuckets = (typeof storageBucketTags)[number];

const basePath = env.FILE_STORAGE_PATH;
export const relativePath = (absolutePath: string) => {
  return path.relative(basePath, absolutePath);
};
export const absolutePath = (relativePath: string) => {
  return path.join(basePath, relativePath);
};

const uploadBasePath = path.join(basePath, "uploads");
const uploadDirs = storageBucketTags.map((tag) =>
  path.join(uploadBasePath, tag)
);

export const initStorageDirs = () => {
  // upload dirs
  uploadDirs.forEach((fullPath) => {
    if (!fs.existsSync(fullPath)) {
      fs.mkdirSync(fullPath, { recursive: true });
    }
  });
};

const createOrReturnDir = (dirPath: string) => {
  if (!fs.existsSync(dirPath)) {
    fs.mkdirSync(dirPath, { recursive: true });
  }
  return dirPath;
};

const profilePhotosBucket = ({ userId }: { userId: string }) => {
  return createOrReturnDir(path.join(uploadBasePath, "profile_photos", userId));
};

const messageAttachmentsBucket = ({ chatId }: { chatId: string }) => {
  return createOrReturnDir(
    path.join(uploadBasePath, "message_attachments", chatId)
  );
};

const chatAttachmentsBucket = ({ chatId }: { chatId: string }) => {
  return createOrReturnDir(
    path.join(uploadBasePath, "chat_attachments", chatId)
  );
};

export const buckets = {
  profile_photos: profilePhotosBucket,
  message_attachments: messageAttachmentsBucket,
  chat_attachments: chatAttachmentsBucket,
};
