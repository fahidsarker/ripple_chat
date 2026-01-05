import { apiError } from "../core/api-error";
import { db } from "../db";
import { env } from "../env";
import { absolutePath } from "../storage/storage-utils";
import jwt from "jsonwebtoken";

type FileJwtPayload = {
  filePath: string;
  fileId: string;
  expiary: number;
};

export const getFilePathFromToken = (fileId: string, token: string) => {
  let payload: FileJwtPayload;
  try {
    payload = jwt.verify(token, env.JWT_SECRET) as FileJwtPayload;
  } catch (error) {
    throw apiError(400, "Invalid file token");
  }
  if (!payload || !payload.filePath) {
    throw apiError(400, "Invalid file token");
  }
  if (payload.fileId !== fileId) {
    throw apiError(400, "File ID does not match token");
  }
  const expiary = new Date(payload.expiary);
  const now = new Date();
  if (now > expiary) {
    throw apiError(400, "File token has expired");
  }
  return payload.filePath;
};

export const createFileAccessUrlFromPath = (
  fileId: string,
  filePath: string
): string => {
  const jwtPayload = {
    filePath,
    fileId,
    expiary: Date.now() + 3600000, // 1 hour
  } satisfies FileJwtPayload;

  const token = jwt.sign(jwtPayload, env.JWT_SECRET);
  return `${env.SERVER_URL}/api/files/${fileId}?token=${token}`;
};
