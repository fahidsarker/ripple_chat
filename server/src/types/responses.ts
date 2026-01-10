import { ChatRow, MessageRow } from "./db-types";

export type ResMessage = MessageRow & {
  senderName: string;
  attachments: { id: string; ext: string; originalName: string }[];
};
export type ResChat = ChatRow & {
  lastMessage?: ResMessage;
  members: { id: string; name: string }[];
};
