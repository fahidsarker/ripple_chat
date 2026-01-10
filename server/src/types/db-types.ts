import { chats, messages } from "../db/schema";

export type MessageRow = typeof messages.$inferSelect;
export type ChatRow = typeof chats.$inferSelect;
