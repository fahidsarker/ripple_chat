import { getChatMembers } from "../services/chat";
import { ResChat, ResMessage } from "../types/responses";
import { io } from "./ws";

export const broadcastNewMessage = (chatId: string, message: ResMessage) => {
  const socketIo = io();
  socketIo.to(chatId).emit(`chat:${chatId}:new-message`, message);
  broadcastChatLastMessage(message);
};

export const broadcastNewChat = (chat: ResChat) => {
  const socketIo = io();
  for (const member of chat.members) {
    socketIo.to(member.id).emit(`chat-list:new-chat`, chat);
  }
};

const broadcastChatLastMessage = async (message: ResMessage) => {
  const socketIo = io();
  const members = await getChatMembers(message.chatId);
  for (const member of members) {
    socketIo.to(member.id).emit(`chat-list:update-last-message`, message);
  }
};
