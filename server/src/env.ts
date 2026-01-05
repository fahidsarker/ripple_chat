import z from "zod";
import dotenv from "dotenv";

dotenv.config();

export const env = z
  .object({
    NODE_ENV: z
      .enum(["development", "production", "test"])
      .default("development"),
    SERVER_PORT: z
      .string()
      .default("3000")
      .transform((val) => parseInt(val, 10)),
    DATABASE_URL: z.string().min(1, "DATABASE_URL is required"),
    SERVER_URL: z.string().min(1, "SERVER_URL is required"),
    JWT_SECRET: z.string().min(1, "JWT_SECRET is required"),
    LIVEKIT_API_KEY: z.string().min(1, "LIVEKIT_API_KEY is required"),
    LIVEKIT_API_SECRET: z.string().min(1, "LIVEKIT_API_SECRET is required"),
    LIVEKIT_WS_URL: z.string().min(1, "LIVEKIT_WS_URL is required"),
    FILE_STORAGE_PATH: z.string().min(1, "FILE_STORAGE_PATH is required"),
  })
  .parse(process.env);
