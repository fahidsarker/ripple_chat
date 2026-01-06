import { apiError } from "../core/api-error";
import { db, tables } from "../db";
import { env } from "../env";
import { storageService } from "./storage";
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
  return storageService.absolutePath(payload.filePath);
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

  const token = jwt.sign(jwtPayload, env.JWT_SECRET, {
    noTimestamp: true,
  });
  return `${env.SERVER_URL}/api/files/${fileId}?token=${token}`;
};

export const createFilesEntriesInDB = async <T>({
  files,
  userId,
  before,
  parentType,
  after,
}: {
  files: Express.Multer.File[];
  userId: string;
  parentType: "user" | "message" | "chat";
  before?: (tx: (typeof db.transaction)["arguments"][0]) => Promise<void>;
  after?: (tx: (typeof db.transaction)["arguments"][0]) => Promise<T>;
}) => {
  const fileContents = files.map((file) => {
    return {
      uploaderId: userId,
      parentId: userId,
      parentType: parentType,
      ext: file.originalname.substring(file.originalname.lastIndexOf(".") + 1),
      mimeType: file.mimetype,
      relativePath: storageService.relativePath(file.path),
      size: file.size,
      originalName: file.originalname,
      fileType: "image",
    } satisfies typeof tables.files.$inferInsert;
  });

  return await db.transaction(async (tx) => {
    if (before) {
      await before(tx);
    }

    await tx.insert(tables.files).values(fileContents);

    if (after) {
      return await after(tx);
    }
  });
};
