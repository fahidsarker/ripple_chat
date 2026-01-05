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

### Planned

- 🔄 Group chats and direct messages
- 🔄 Media sharing (images, videos, files)
- 🔄 File thumbnail generation and optimisation for delivery
- 🔄 Real-time messaging with WebSockets
- 🔄 Responsive design for mobile and desktop
- 🔄 Push notifications
- 🔄 Audio and video calls (via LiveKit integration)
- 🔄 End-to-end encryption for secure communication

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

## Installation

Detailed installation instructions will be provided as the project approaches its first stable release. For now, the codebase serves as a reference implementation.

## Contributing

We welcome contributions to Ripple Chat! Please feel free to submit issues, feature requests, or pull requests to help improve the project.
