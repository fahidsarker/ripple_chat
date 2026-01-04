import express, { Request, Response } from "express";
import { authRequired } from "../middleware/auth";
import { authService, getUser } from "../services/auth";
import { apiHandler, queryParams } from "../core/api-handler";
import { Res } from "../core/response";
import { db, tables } from "../db";
import { and, eq, ilike, not, or } from "drizzle-orm";
import { users } from "../db/schema";

const router = express.Router();

router.use(authRequired);

router.get(
  "/",
  apiHandler(async (req) => {
    const userId = getUser(req).userId;
    const userData = await db
      .select({
        id: tables.users.id,
        name: tables.users.name,
        email: tables.users.email,
        createdAt: tables.users.createdAt,
      })
      .from(tables.users)
      .where(eq(tables.users.id, userId))
      .limit(1);
    if (userData.length === 0) {
      return Res.error("User not found", 404);
    }
    return Res.json({ user: userData[0] });
  })
);

router.post(
  "/update-name",
  apiHandler(async (req) => {
    const userId = getUser(req).userId;
    const { name } = req.body;
    if (!name || name.trim().length === 0) {
      return Res.error("Name is required");
    }
    await db
      .update(tables.users)
      .set({ name: name.trim() })
      .where(eq(tables.users.id, userId));
    return Res.json({ message: "Name updated successfully" });
  })
);

router.post(
  "/update-password",
  apiHandler(async (req) => {
    const userId = getUser(req).userId;
    const { old_password, new_password } = req.body;
    if (!old_password || !new_password) {
      return Res.error("Old password and new password are required", 400);
    }
    if (old_password === new_password) {
      return Res.error("New password must be different from old password", 400);
    }

    // verify old password
    const userData = await db.query.users.findFirst({
      where: eq(users.id, userId),
    });

    if (!userData) {
      return Res.error("User not found", 404);
    }

    const isValidPassword = await authService.comparePassword(
      old_password,
      userData.passwordHash
    );

    if (!isValidPassword) {
      return Res.error("Old password is incorrect", 400);
    }

    // hash new password
    const newPasswordHash = await authService.hashPassword(new_password);

    // update password
    await db
      .update(tables.users)
      .set({ passwordHash: newPasswordHash })
      .where(eq(tables.users.id, userId));

    return Res.json({ message: "Password updated successfully" });
  })
);

export default router;
