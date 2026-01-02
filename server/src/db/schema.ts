import { pgTable, varchar, timestamp, boolean } from "drizzle-orm/pg-core";
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
  content: varchar("content", { length: 1000 }).notNull(),
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

export const messagesRelations = relations(messages, ({ one }) => ({
  chat: one(chats, {
    fields: [messages.chatId],
    references: [chats.id],
  }),
  sender: one(users, {
    fields: [messages.senderId],
    references: [users.id],
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
