import { ResMessage } from "../types/responses";
import { io } from "./ws";

export const broadcastNewMessage = (chatId: string, message: ResMessage) => {
  const socketIo = io();
  socketIo.to(chatId).emit(`chat:${chatId}:new-message`, message);
};
