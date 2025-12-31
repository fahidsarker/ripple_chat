import {
  pgTable,
  serial,
  varchar,
  timestamp,
  boolean,
  integer,
} from "drizzle-orm/pg-core";
import { relations } from "drizzle-orm";

// Users table
export const users = pgTable("users", {
  id: serial("id").primaryKey(),
  name: varchar("name", { length: 255 }).notNull(),
  email: varchar("email", { length: 255 }).notNull().unique(),
  passwordHash: varchar("password_hash", { length: 255 }).notNull(),
  createdAt: timestamp("created_at").defaultNow().notNull(),
});

// Chats table
export const chats = pgTable("chats", {
  id: serial("id").primaryKey(),
  isGroup: boolean("is_group").default(false).notNull(),
  createdBy: integer("created_by")
    .notNull()
    .references(() => users.id),
  createdAt: timestamp("created_at").defaultNow().notNull(),
});

// Chat members table
export const chatMembers = pgTable("chat_members", {
  id: serial("id").primaryKey(),
  chatId: integer("chat_id")
    .notNull()
    .references(() => chats.id),
  userId: integer("user_id")
    .notNull()
    .references(() => users.id),
});

// Messages table
export const messages = pgTable("messages", {
  id: serial("id").primaryKey(),
  chatId: integer("chat_id")
    .notNull()
    .references(() => chats.id),
  senderId: integer("sender_id")
    .notNull()
    .references(() => users.id),
  content: varchar("content", { length: 1000 }).notNull(),
  createdAt: timestamp("created_at").defaultNow().notNull(),
});

export const messageStatusReceipts = pgTable("message_status_receipts", {
  id: serial("id").primaryKey(),
  messageId: integer("message_id")
    .notNull()
    .references(() => messages.id),
  userId: integer("user_id")
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
  id: serial("id").primaryKey(),
  chatId: integer("chat_id")
    .notNull()
    .references(() => chats.id),
  startedBy: integer("started_by")
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
