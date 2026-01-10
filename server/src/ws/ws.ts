import { Server, Socket } from "socket.io";
import { authService, getUserFromJwt } from "../services/auth";
let _io: Server | null = null;
export const initWSIO = (io: Server) => {
  if (_io) {
    return _io;
  }
  _io = io;
  startIo(_io);
};

const startIo = (io: Server) => {
  io.on("connection", (socket) => {
    socket.on("auth", (data) => handleAuth(socket, data));
    socket.on("chat:subscribe", (data) => subscribeToRoom(socket, data));
    socket.on("chat:unsubscribe", (data) => unSubscribeFromRoom(socket, data));
    socket.on("disconnect", () => {
      socket.data.user = undefined;
      for (const room of socket.rooms) {
        socket.leave(room);
      }
    });
  });
};
export const io = () => {
  if (!_io) {
    throw new Error("Socket.io not initialized");
  }
  return _io;
};
const subscribeToRoom = (socket: Socket, data: any) => {
  if (socket.data.user === undefined) {
    socket.emit("chat:subscribe:failure", { message: "Not authenticated" });
    return;
  }
  const { chatId } = data;
  if (!chatId) {
    socket.emit("chat:subscribe:failure", { message: "No chatId provided" });
    return;
  }
  socket.join(chatId);
  socket.emit("chat:subscribe:success", {
    message: `Subscribed to chat ${chatId}`,
  });
};

const unSubscribeFromRoom = (socket: Socket, data: any) => {
  const { chatId } = data;
  if (!chatId) {
    socket.emit("chat:unsubscribe:failure", { message: "No chatId provided" });
    return;
  }
  socket.leave(chatId);
  socket.emit("chat:unsubscribe:success", {
    message: `Unsubscribed from chat ${chatId}`,
  });
};

const handleAuth = (socket: Socket, data: any) => {
  const { token } = data;
  if (!token) {
    socket.emit("auth:failure", { message: "No token provided" });
    return;
  }
  try {
    const user = authService.verifyToken(token);
    socket.data.user = user;
    socket.join(user.userId);
    console.log(`User ${user.userId} authenticated via WS`);
    socket.emit("auth:success", { message: "Authentication successful" });
  } catch (error) {
    socket.emit("auth:failure", { message: "Invalid token" });
  }
};
