import express from "express";
import { createServer } from "http";
import { Server } from "socket.io";
import cors from "cors";
import helmet from "helmet";
import { env } from "./env";

const app = express();
const server = createServer(app);
import chatRoutes from "./routes/chats";
import authRoutes from "./routes/auth";
import { globalErrorHandler } from "./middleware/global-error-handle";

const io = new Server(server, {
  cors: {
    origin: "*", // Configure later appropriately for production
    methods: ["GET", "POST"],
  },
});

const PORT = env.SERVER_PORT || 8080;

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json({ limit: "10mb" }));
app.use(express.urlencoded({ extended: true }));

// Health check endpoint
app.get("/health", (req, res) => {
  res.json({
    status: "ok",
    timestamp: new Date().toISOString(),
    hello: "world",
  });
});

app.use("/api/auth", authRoutes);
app.use("/api/chats", chatRoutes);

// 404 handler
app.use("*", (req, res) => {
  res.status(404).json({ error: "Route not found" });
});

// Error handling middleware
app.use(globalErrorHandler);

// Start server
server.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
  console.log(`📡 WebSocket server ready`);
  console.log(`🏥 Health check: http://localhost:${PORT}/health`);
  console.log(`📋 API base URL: http://localhost:${PORT}/api`);
});

// Graceful shutdown
process.on("SIGTERM", () => {
  console.log("SIGTERM received, shutting down gracefully");
  server.close(() => {
    console.log("Server closed");
    process.exit(0);
  });
});

process.on("SIGINT", () => {
  console.log("SIGINT received, shutting down gracefully");
  server.close(() => {
    console.log("Server closed");
    process.exit(0);
  });
});
