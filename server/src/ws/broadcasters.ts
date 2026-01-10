import { ResChat, ResMessage } from "../types/responses";
import { io } from "./ws";

export const broadcastNewMessage = (chatId: string, message: ResMessage) => {
  const socketIo = io();
  socketIo.to(chatId).emit(`chat:${chatId}:new-message`, message);
};

export const broadcastNewChat = (chat: ResChat) => {
  const socketIo = io();
  for (const member of chat.members) {
    socketIo.to(member.id).emit(`chat-list:new-chat`, chat);
  }
};
