import express, { Request, Response } from "express";
import fs from "fs";
import mime from "mime";
import { apiHandler } from "../core/api-handler";
import { Res } from "../core/response";
import { authRequired } from "../middleware/auth";
import { getFilePathFromToken } from "../services/files";
import { absolutePath } from "../storage/storage-utils";
import { apiError } from "../core/api-error";
const router = express.Router();

// Apply authentication middleware to all chat routes
router.get(
  "/:fid",
  apiHandler(async (req, res) => {
    const token = req.query.token;
    if (typeof token !== "string") {
      throw apiError(400, "Invalid or missing token");
    }

    const filePath = absolutePath(getFilePathFromToken(req.params.fid, token));

    fs.stat(filePath, (err, stats) => {
      if (err) return res.sendStatus(404);

      res.setHeader("Content-Length", stats.size);
      res.setHeader(
        "Content-Type",
        mime.getType(filePath) || "application/octet-stream"
      );

      fs.createReadStream(filePath).pipe(res);
    });

    return Res.none();
  })
);

export default router;
