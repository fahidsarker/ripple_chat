import { and, eq } from "drizzle-orm";
import { db, tables } from "../db";
import { apiError } from "../core/api-error";
import { createFileAccessUrlFromPath } from "./files";

export const getProfileOfUser = async (userId: string) => {
  const [userData] = await db
    .select({
      id: tables.users.id,
      name: tables.users.name,
      email: tables.users.email,
      createdAt: tables.users.createdAt,
      profilePhotoId: tables.files.id,
      profilePhotoPath: tables.files.relativePath,
    })
    .from(tables.users)
    .leftJoin(
      tables.files,
      and(
        eq(tables.files.parentId, tables.users.id),
        eq(tables.files.bucket, "profile_photos"),
        eq(tables.files.deleted, false)
      )
    )
    .where(eq(tables.users.id, userId))
    .limit(1);
  if (!userData) {
    throw apiError(404, "User not found");
  }

  const { profilePhotoId, profilePhotoPath, ...user } = userData;

  return {
    ...user,
    profilePhotoUrl:
      profilePhotoPath && profilePhotoId
        ? createFileAccessUrlFromPath(profilePhotoId, profilePhotoPath)
        : null,
  };
};
