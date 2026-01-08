# Ripple Chat

<div align="center">
  <img src="ui/logo.png" alt="Ripple Chat Logo" width="100">
  <br><br>
  <strong>A modern real-time chat application</strong>
  <br>
  <em>Built with Node.js and Flutter</em>
</div>

## Overview

**Ripple Chat** is a streamlined, real-time messaging application designed for simplicity and ease of deployment. Built with modern technologies, it offers a clean, responsive interface across mobile and desktop platforms while maintaining the essential features needed for effective communication.

> **⚠️ Development Status:** This project is currently in VERY EARLY STAGE OF active development. While core features are being implemented, the application is not yet ready for production use.

## Why Ripple Chat?

Ripple Chat addresses the need for a straightforward messaging solution without the complexity of enterprise-grade protocols. While platforms like Matrix offer extensive federation and bridging capabilities, Ripple Chat focuses on core messaging and call functionality with simple and straight forward self-hosting solution. **The end goal is to provide a reliable, easy-to-use chat application that can be quickly deployed for personal or small team use.**

## Features

### Current

- ✅ User authentication
- ✅ Profile management
- ✅ File Upload and Token-based access
- ✅ Direct messages

### Planned

- 🏗️ Send attachments (images, videos, files) with messages
- 📝 View all Files sent by to to me
- 📝 Real-time messaging with WebSockets
- 📝 Message read/delivered receipts and typing indicators
- 📝 Group chats
- 📝 User presence (online/offline status)
- 📝 Responsive design for mobile and desktop
- 📝 Audio and video calls (via LiveKit integration)
- 📝 Push notifications
- 📝 File thumbnail generation and optimisation for delivery
- 📝 End-to-end encryption for secure communication

## Architecture

Ripple Chat follows a modern client-server architecture:

**Backend (Node.js)**

- RESTful API for user management and message handling
- WebSocket connections for real-time communication
- PostgreSQL database for data persistence
- Optional Redis integration for caching and session management

**Frontend (Flutter)**

- Cross-platform UI supporting iOS, Android, Web, and Desktop
- Material Design components for consistent user experience
- Real-time message synchronization
- Responsive layouts optimized for different screen sizes

## Prerequisites

Before setting up Ripple Chat, ensure you have the following installed:

- **Node.js** (v18 or higher)
- **Flutter SDK** (latest stable version)
- **PostgreSQL** database
- **Redis** server (optional, for caching)
- **LiveKit** server (optional, for audio/video calls)

## How to Build and Run Locally

### 1. Clone the Repository

```bash
git clone <your-repository-url>
cd ripple_chat
```

### 2. Backend Setup

Navigate to the server directory and install dependencies:

```bash
cd server
npm install
```

Create a `.env` file in the server directory with the following variables:

```env
NODE_ENV=development

SERVER_PORT=3000
DATABASE_URL=postgresql://username:password@localhost:5432/ripple_chat
SERVER_URL=http://localhost:3000
# WS_URL=ws://localhost:3000 # Uncomment if using WebSocket server separately. No need to provide if using same server for WS.
JWT_SECRET=your-jwt-secret-key

LIVEKIT_API_KEY=your-livekit-api-key
LIVEKIT_API_SECRET=your-livekit-api-secret
LIVEKIT_WS_URL=ws://localhost:7880

FILE_STORAGE_PATH=./temp/uploads
```

Set up the database:

> using bun but you can also use npm/pnpm/yarn if preferred

```bash
# Generate database migrations
bun run db:generate

# Apply migrations to your database
bun run db:migrate

# Optional: Open Drizzle Studio to view your database
bun run db:studio
```

Build and start the server:

```bash
# For development (with hot reload)
bun run dev

# Or build and start for production
bun run build
bun start
```

The backend server will be available at `http://localhost:3000`.

### 3. Client Setup

Navigate to the client directory and install dependencies:

```bash
cd ../client
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

Run the Flutter application:

```bash
# For web
flutter run -d chrome

# For iOS simulator
flutter run -d ios

# For Android emulator
flutter run -d android

# For desktop (macOS/Windows/Linux)
flutter run -d macos    # or windows/linux
```

### 4. Database Setup

Make sure PostgreSQL is running and create a database for the application:

```sql
CREATE DATABASE ripple_chat;
CREATE USER ripple_user WITH PASSWORD 'your_password';
GRANT ALL PRIVILEGES ON DATABASE ripple_chat TO ripple_user;
```

Update the `DATABASE_URL` in your `.env` file accordingly.

### 5. Optional: LiveKit Setup

For audio and video call functionality, set up a LiveKit server locally or use LiveKit Cloud:

- **Local setup**: Follow the [LiveKit self-hosting guide](https://docs.livekit.io/realtime/self-hosting/)
- **Cloud setup**: Sign up at [LiveKit Cloud](https://cloud.livekit.io/) and get your API credentials

Update the LiveKit-related environment variables in your `.env` file.

**More details on docker-based setup and deployment will be provided in future updates.**

## Installation

The application is currently in active development. Use the local setup instructions above to run the project for development purposes.

## Contributing

We welcome contributions to Ripple Chat! Please feel free to submit issues, feature requests, or pull requests to help improve the project.
