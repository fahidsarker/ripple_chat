import express, { Request, Response } from "express";
import { authRequired } from "../middleware/auth";
import { apiHandler, queryParams } from "../core/api-handler";
import { Res } from "../core/response";
import { db, tables } from "../db";
import { ilike, or } from "drizzle-orm";
import { users } from "../db/schema";

const router = express.Router();

router.use(authRequired);

// GET /users - Get all users (except the authenticated user ? todo)
// params: search, limit, offset
router.get(
  "/",
  apiHandler(async (req) => {
    const { limit, offset, search } = queryParams(req);
    try {
      // const userId = getUser(req).userId;
      const allUsers = await db.query.users.findMany({
        limit,
        offset,
        columns: {
          id: true,
          name: true,
          email: true,
          createdAt: true,
        },
        where: search
          ? or(
              ilike(users.name, `%${search}%`),
              ilike(users.email, `%${search}%`)
            )
          : undefined,
      });
      return Res.json({ users: allUsers });
    } catch (error) {
      console.error("Get chats error:", error);
      return Res.error("Internal server error");
    }
  })
);

export default router;
