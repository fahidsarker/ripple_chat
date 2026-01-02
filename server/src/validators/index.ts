import { z } from "zod";

// Auth schemas
export const registerSchema = z.object({
  name: z.string().min(2, "Name must be at least 2 characters"),
  email: z.string().email("Invalid email format"),
  password: z.string().min(6, "Password must be at least 6 characters"),
});

export const loginSchema = z.object({
  email: z.string().email("Invalid email format"),
  password: z.string().min(1, "Password is required"),
});

// Chat schemas
export const createChatSchema = z.object({
  isGroup: z.boolean().default(false),
  memberIds: z
    .array(z.string().min(1, "Member ID must be a non-empty string"))
    .min(1, "At least one member is required"),
});

export const sendMessageSchema = z.object({
  content: z
    .string()
    .min(1, "Message content is required")
    .max(1000, "Message too long"),
});

export const updateMessageStatusSchema = z.object({
  messageIds: z
    .array(z.number().int().positive())
    .min(1, "At least one message ID is required"),
  status: z.enum(["sent", "delivered", "read"]),
});

// Call schemas
export const startCallSchema = z.object({
  chatId: z.number().int().positive(),
});

export const getCallTokenSchema = z.object({
  roomName: z.string().min(1, "Room name is required"),
});

export type RegisterInput = z.infer<typeof registerSchema>;
export type LoginInput = z.infer<typeof loginSchema>;
export type CreateChatInput = z.infer<typeof createChatSchema>;
export type SendMessageInput = z.infer<typeof sendMessageSchema>;
export type UpdateMessageStatusInput = z.infer<
  typeof updateMessageStatusSchema
>;
export type StartCallInput = z.infer<typeof startCallSchema>;
export type GetCallTokenInput = z.infer<typeof getCallTokenSchema>;
