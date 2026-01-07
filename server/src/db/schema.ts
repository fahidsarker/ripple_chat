import {
  pgTable,
  varchar,
  timestamp,
  boolean,
  doublePrecision,
  text,
} from "drizzle-orm/pg-core";
import { relations } from "drizzle-orm";

const primaryId = (name: string) =>
  varchar(name, { length: 255 })
    .primaryKey()
    .$default(() => crypto.randomUUID());

// Users table
export const users = pgTable("users", {
  id: primaryId("id"),
  name: varchar("name", { length: 255 }).notNull(),
  email: varchar("email", { length: 255 }).notNull().unique(),
  passwordHash: varchar("password_hash", { length: 255 }).notNull(),
  createdAt: timestamp("created_at").defaultNow().notNull(),
});

// Chats table
export const chats = pgTable("chats", {
  id: primaryId("id"),
  title: varchar("title", { length: 255 }),
  isGroup: boolean("is_group").default(false).notNull(),
  createdBy: varchar("created_by", { length: 255 })
    .notNull()
    .references(() => users.id),
  createdAt: timestamp("created_at").defaultNow().notNull(),
});

export const files = pgTable("files", {
  id: primaryId("id"),
  uploaderId: varchar("uploader_id", { length: 255 })
    .notNull()
    .references(() => users.id),
  parentId: varchar("parent_id", { length: 255 }).notNull(), // denotes the entity this file is associated with -> user id, message id, etc.
  parentType: varchar("parent_type", { length: 100 })
    .$type<"user" | "message" | "chat">()
    .notNull(), // denotes the type of entity the file is associated with -> "user", "message
  relativePath: varchar("relative_path", { length: 1000 }).notNull(),
  thumbnailPath: varchar("thumbnail_path", { length: 1000 }), // optional thumbnail path for images/videos
  originalName: varchar("original_name", { length: 255 }).notNull(),
  size: doublePrecision("size").notNull(),
  mimeType: varchar("mime_type", { length: 255 }).notNull(),
  ext: varchar("ext", { length: 50 }).notNull(),
  width: doublePrecision("width"),
  height: doublePrecision("height"),
  duration: doublePrecision("duration"), // for audio/video files
  createdAt: timestamp("created_at").defaultNow().notNull(),
  fileType: varchar("file_type", { length: 50 })
    .$type<"image" | "video" | "audio" | "document" | "other">()
    .notNull(),
  deleted: boolean("deleted").default(false).notNull(), // used to soft delete files -> a script can be run later to permanently delete files marked as deleted
});

// Chat members table
export const chatMembers = pgTable("chat_members", {
  id: primaryId("id"),
  chatId: varchar("chat_id", { length: 255 })
    .notNull()
    .references(() => chats.id),
  userId: varchar("user_id", { length: 255 })
    .notNull()
    .references(() => users.id),
});

// Messages table
export const messages = pgTable("messages", {
  id: primaryId("id"),
  chatId: varchar("chat_id", { length: 255 })
    .notNull()
    .references(() => chats.id),
  senderId: varchar("sender_id", { length: 255 })
    .notNull()
    .references(() => users.id),
  content: text().notNull(),
  createdAt: timestamp("created_at").defaultNow().notNull(),
});

export const messageStatusReceipts = pgTable("message_status_receipts", {
  id: primaryId("id"),
  messageId: varchar("message_id", { length: 255 })
    .notNull()
    .references(() => messages.id),
  userId: varchar("user_id", { length: 255 })
    .notNull()
    .references(() => users.id),
  status: varchar("status", { length: 50 })
    .$type<"sent" | "delivered" | "read">()
    .notNull(),
  updatedAt: timestamp("updated_at")
    .defaultNow()
    .notNull()
    .$onUpdate(() => new Date()),
});

// Calls table
export const calls = pgTable("calls", {
  id: primaryId("id"),
  chatId: varchar("chat_id", { length: 255 })
    .notNull()
    .references(() => chats.id),
  startedBy: varchar("started_by", { length: 255 })
    .notNull()
    .references(() => users.id),
  roomName: varchar("room_name", { length: 255 }).notNull(),
  createdAt: timestamp("created_at").defaultNow().notNull(),
});

// Relations
export const usersRelations = relations(users, ({ many }) => ({
  chats: many(chats),
  chatMembers: many(chatMembers),
  messages: many(messages),
  calls: many(calls),
  files: many(files),
  profilePhotos: many(files, {
    relationName: "userProfilePhotos",
  }),
}));

export const chatsRelations = relations(chats, ({ one, many }) => ({
  createdBy: one(users, {
    fields: [chats.createdBy],
    references: [users.id],
  }),
  members: many(chatMembers),
  messages: many(messages),
  calls: many(calls),
}));

export const chatMembersRelations = relations(chatMembers, ({ one }) => ({
  chat: one(chats, {
    fields: [chatMembers.chatId],
    references: [chats.id],
  }),
  user: one(users, {
    fields: [chatMembers.userId],
    references: [users.id],
  }),
}));

export const messagesRelations = relations(messages, ({ one, many }) => ({
  chat: one(chats, {
    fields: [messages.chatId],
    references: [chats.id],
  }),
  sender: one(users, {
    fields: [messages.senderId],
    references: [users.id],
  }),
  attachments: many(files),
}));

export const filesRelations = relations(files, ({ one }) => ({
  uploader: one(users, {
    fields: [files.uploaderId],
    references: [users.id],
  }),
  parentUser: one(users, {
    fields: [files.parentId],
    references: [users.id],
    relationName: "userProfilePhotos",
  }),
}));

export const callsRelations = relations(calls, ({ one }) => ({
  chat: one(chats, {
    fields: [calls.chatId],
    references: [chats.id],
  }),
  startedBy: one(users, {
    fields: [calls.startedBy],
    references: [users.id],
  }),
}));
