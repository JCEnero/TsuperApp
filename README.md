<div align="center">

<img src="assets/images/tsuper_logo.png" alt="TSUPER Logo" width="120" height="120" />

# 🚌 TSUPER APP

### *Move smarter across Metro Manila*

**A modern jeepney tracking and commute app for passengers and drivers in Quezon City.**

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Node.js](https://img.shields.io/badge/Node.js-Express-339933?style=for-the-badge&logo=node.js&logoColor=white)](https://nodejs.org)
[![Supabase](https://img.shields.io/badge/Supabase-PostgreSQL-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)](https://supabase.com)
[![Socket.IO](https://img.shields.io/badge/Socket.IO-Real--time-010101?style=for-the-badge&logo=socket.io&logoColor=white)](https://socket.io)
[![Google Maps](https://img.shields.io/badge/Google_Maps-API-4285F4?style=for-the-badge&logo=google-maps&logoColor=white)](https://developers.google.com/maps)

</div>

---

## 🗺️ What is TSUPER?

TSUPER is a real-time jeepney tracking application built for Quezon City commuters and drivers. No more guessing when the next jeepney arrives — open the app, search your destination, and watch live jeepneys moving along their routes on the map.

```
👤 Passenger                    🚌 Driver
─────────────────────           ─────────────────────
🔍 Search destination           📍 Select route
🗺️  See live jeepneys           🟢 Go on duty
📊 Check occupancy              📡 GPS auto-broadcasts
⏱️  Get ETA estimates           👥 See passenger pins
📌 Pin your location            🔔 Trip notifications
```

---

## ✨ Key Features

### For Passengers
- 🗺️ **Live Map** — See all jeepneys moving in real-time across 4 QC routes
- 🔍 **Smart Search** — Type your destination, map filters to relevant routes only
- 📊 **Route Info Banner** — Shows which routes serve your destination + live jeepney counts
- 🎯 **Route Polylines** — Color-coded paths drawn on Google Maps using real OSRM road data
- 🟢 **Live/Offline Badge** — Know instantly if the data is real-time or cached

### For Drivers
- 🔐 **Role-based auth** — Separate driver and passenger accounts
- 📍 **Route assignment** — Select your jeepney route before going on duty
- 📡 **GPS broadcasting** — Your location automatically updates all connected passengers

### General
- 🔐 **Supabase Auth** — Email/password with email confirmation flow
- 📱 **Responsive UI** — Works on Android, iOS, and Web
- ⚡ **Socket.IO** — Sub-second real-time updates, no polling

---

## 🏗️ Architecture

```
┌─────────────────┐          ┌─────────────────────┐          ┌──────────────────┐
│   Flutter App   │          │  Node.js + Express  │          │    Supabase       │
│                 │◄────────►│                     │◄────────►│                  │
│ • Passenger UI  │  Socket  │ • REST API (37 eps) │  Admin   │ • PostgreSQL DB  │
│ • Driver UI     │  .IO     │ • Socket.IO server  │  Client  │ • Auth (JWT)     │
│ • Google Maps   │  + HTTP  │ • Jeepney simulator │          │ • User profiles  │
│ • Live tracking │          │ • Security middleware│          │ • Trip history   │
└─────────────────┘          └─────────────────────┘          └──────────────────┘
                                        ▲
                                        │ OSRM (one-time)
                              ┌─────────────────────┐
                              │  Real QC Road Data  │
                              │  1,478 waypoints    │
                              │  4 jeepney routes   │
                              └─────────────────────┘
```

---

## 🛣️ Live Routes (Quezon City)

| Route | Color | Distance | Est. Time |
|-------|-------|----------|-----------|
| 🔵 Nova Bayan → SM Fairview | Blue | 7.2 km | ~16 min |
| 🟢 SM Fairview → SM North EDSA | Green | 10.1 km | ~15 min |
| 🟠 SM North EDSA → Cubao | Orange | 6.2 km | ~9 min |
| 🔴 Cubao → Nova Bayan | Red | 17.4 km | ~25 min |

Routes sourced from **OSRM** (OpenStreetMap Road Network) — real roads, real turns.

---

## 🧰 Tech Stack

### Frontend — Flutter
| Package | Purpose |
|---------|---------|
| `google_maps_flutter` | Map rendering with custom markers and polylines |
| `socket_io_client` | Real-time jeepney position updates |
| `supabase_flutter` | Auth and database |
| `geolocator` | Passenger GPS (optional) |
| `flutter_svg` | Custom jeepney icons |
| `google_fonts` | Poppins typography |
| `material_symbols_icons` | Icon library |

### Backend — Node.js + Express + TypeScript
| Package | Purpose |
|---------|---------|
| `express` | REST API server |
| `socket.io` | Real-time broadcasting |
| `@supabase/supabase-js` | Database + admin auth |
| `zod` | Request validation |
| `helmet` | Security headers |
| `express-rate-limit` | Rate limiting |
| `hpp` | HTTP parameter pollution protection |

### Infrastructure
| Tool | Role |
|------|------|
| **Supabase** | PostgreSQL database + Auth |
| **Google Maps API** | Map tiles + rendering |
| **OSRM** | Road-following route coordinates (one-time fetch) |

---

## 🎨 Design System

```
Colors
──────────────────────────────────────────────
Primary Navy    #243B7A   ████  Main brand color
Dark Navy       #2D3F8F   ████  Gradients, headers
Surface         #F8F9FC   ████  Background
Gray            #9CA3AF   ████  Muted text
Ink             #374151   ████  Body text
Success         #22C55E   ████  Available jeepneys
Warning         #F59E0B   ████  On break
Danger          #EF4444   ████  Full jeepneys

Typography
──────────────────────────────────────────────
Font: Poppins (400, 500, 600, 700)

Design Principles
──────────────────────────────────────────────
• Material 3 inspired, minimalist
• 8pt grid system, 16px rounded corners
• Light theme, clean whitespace
• Dribbble-level polish — inspired by Grab + Waze
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.x+)
- [Node.js](https://nodejs.org) (18+)
- [Supabase account](https://supabase.com) (free tier works)
- Google Maps API Key

---

### 1. Clone the repository

```bash
git clone https://github.com/JCEnero/TsuperApp.git
cd TsuperApp
```

---

### 2. Set up the Backend

```bash
cd backend
npm install
```

Create `backend/.env` (copy from `backend/.env.example`):

```env
PORT=3000
NODE_ENV=development

SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key

CORS_ORIGIN=*
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX=100
AUTH_RATE_LIMIT_MAX=10
```

Start the backend:

```bash
npm run dev
```

You should see:
```
🚌 Simulator initialized with 12 jeepneys across 4 routes
🚀 TsuperApp Backend running on port 3000
🔌 Socket.IO ready for real-time connections
🛡️  Security: rate limiting, helmet, CORS, sanitization active
```

---

### 3. Set up the Flutter App

From the project root:

```bash
flutter pub get
```

Create `.env` in the project root:

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

---

### 4. Run on Web (development)

Make sure the backend is running first, then:

```bash
flutter run -d edge --web-port 8080
# or for Chrome:
flutter run -d chrome --web-port 8080
```

Open `http://localhost:8080`

---

### 5. Run on Android

Update the backend URL in `lib/features/passenger/map/services/jeepney_socket_service.dart`:

```dart
// For Android emulator:
static const String _serverUrl = 'http://10.0.2.2:3000';

// For physical device (use your machine's local IP):
static const String _serverUrl = 'http://192.168.x.x:3000';
```

Then:
```bash
flutter run -d android
```

---

## 📁 Project Structure

```
TsuperApp/
│
├── 📱 lib/                          Flutter app
│   ├── core/
│   │   ├── config/supabase/         Supabase client setup
│   │   ├── models/                  Data models (User, Driver, Passenger...)
│   │   ├── navigation/              Route constants
│   │   └── services/                Auth service
│   │
│   ├── features/
│   │   ├── auth/                    Login, Register, Email confirmation
│   │   ├── passenger/
│   │   │   ├── map/                 Live map screen
│   │   │   │   ├── models/          Jeepney, RouteInfo, PlaceSuggestion
│   │   │   │   ├── services/        JeepneyService, MarkerService, SocketService
│   │   │   │   ├── mock/            Mock routes and places data
│   │   │   │   └── widgets/         SearchSheet, RouteInfoBanner, FilterSheet...
│   │   │   └── shell/               Passenger tab navigation
│   │   └── driver/                  Driver dashboard + shell
│   │
│   └── shared/widgets/              Reusable widgets (GoogleMapWidget, AppButtons...)
│
├── 🖥️ backend/                      Node.js + Express API
│   ├── src/
│   │   ├── config/                  Environment, Supabase clients, constants
│   │   ├── middleware/              Auth, validation, rate limiter, error handler
│   │   ├── routes/                  auth, users, drivers, passengers, routes, trips
│   │   ├── simulation/              Jeepney mock movement simulator
│   │   ├── socket/                  Socket.IO event handlers
│   │   └── data/                    OSRM QC route waypoints (1,478 points)
│   └── scripts/
│       └── fetch-routes.ts          One-time OSRM route fetcher
│
└── 🎨 design/
    └── reference-screen-prompts.md  UI design reference prompts
```

---

## 🔌 API Endpoints

| Group | Endpoints | Auth |
|-------|-----------|------|
| Auth | `POST /signup` `POST /signin` `POST /signout` `POST /reset-password` | Mixed |
| Users | `GET /users/:id` `GET /users?email=` `DELETE /users/:id` | ✅ |
| Drivers | `GET /drivers/active` `PATCH /:id/location` `PATCH /:id/status` | ✅ |
| Passengers | `GET /passengers/user/:id` `POST /:id/favorites` | ✅ |
| Routes | `GET /routes` `GET /routes/search` `POST /routes` | ✅ |
| Trips | `POST /trips` `PATCH /:id/start` `PATCH /:id/complete` | ✅ |
| Notifications | `GET /notifications/user/:id` `PATCH /:id/read` | ✅ |
| Jeepneys | `GET /jeepneys` `GET /jeepneys/routes/all` | Public |

---

## 🔄 Real-time Socket Events

### Server → Client
| Event | Data | Description |
|-------|------|-------------|
| `jeepney:snapshot` | `Jeepney[]` | All current positions on connect |
| `jeepney:update` | `Jeepney` | Single position update every 1.5s |
| `routes:snapshot` | `RouteData[]` | OSRM polylines for map drawing |

### Client → Server
| Event | Data | Description |
|-------|------|-------------|
| `driver:location:update` | `{driverId, lat, lng, routeId}` | Driver GPS update |
| `driver:status:update` | `{driverId, status}` | Online/offline |
| `route:join` | `{routeId}` | Subscribe to route updates |

---

## 🗄️ Database Schema (Supabase)

```
users          — id, email, full_name, role, phone, avatar_url
drivers        — id, user_id, plate_number, status, current_lat, current_lng, occupancy
passengers     — id, user_id, favorite_places[], recent_routes[]
routes         — id, route_name, origin, destination, estimated_fare, estimated_time
trips          — id, user_id, driver_id, route_id, origin, destination, status
notifications  — id, user_id, title, message, type, is_read
```

---

## 👥 Team

Built with ❤️ by the 404 team for QCU students and Quezon City commuters.

---

## 📄 License

This project is for academic and development purposes.

---

<div align="center">

**TSUPER** — *Because every commuter deserves to know when their jeepney arrives.*

🚌 💨

</div>
