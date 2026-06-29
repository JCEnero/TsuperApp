# TsuperApp Backend

Node.js + Express + TypeScript backend API for the TsuperApp transport application.

## Architecture

This backend sits between the Flutter app and Supabase:

```
Flutter App  →  Express API  →  Supabase (Postgres + Auth)
                    ↕
              Socket.IO (real-time)
```

## Setup

1. **Install dependencies:**
   ```bash
   npm install
   ```

2. **Create `.env` file** (copy from `.env.example`):
   ```bash
   cp .env.example .env
   ```

3. **Fill in your Supabase credentials:**
   - `SUPABASE_URL` - Your Supabase project URL
   - `SUPABASE_ANON_KEY` - Public anon key
   - `SUPABASE_SERVICE_ROLE_KEY` - Service role key (from Supabase dashboard → Settings → API)

4. **Run in development:**
   ```bash
   npm run dev
   ```

5. **Build for production:**
   ```bash
   npm run build
   npm start
   ```

## API Endpoints

### Auth
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /api/auth/signup | Register new user |
| POST | /api/auth/signin | Sign in |
| POST | /api/auth/signout | Sign out |
| POST | /api/auth/reset-password | Request password reset |
| POST | /api/auth/update-password | Update password (auth required) |
| GET | /api/auth/profile | Get own profile (auth required) |
| PATCH | /api/auth/profile | Update own profile (auth required) |

### Drivers
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/drivers/active | Get all active drivers |
| GET | /api/drivers/route/:route | Get drivers by route |
| GET | /api/drivers/user/:userId | Get driver by user ID |
| GET | /api/drivers/:id | Get driver by ID |
| PATCH | /api/drivers/:id/location | Update location |
| PATCH | /api/drivers/:id/status | Update status |
| PATCH | /api/drivers/:id/occupancy | Update occupancy |
| PUT | /api/drivers/:id | Full update |

### Passengers
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/passengers/user/:userId | Get passenger by user ID |
| GET | /api/passengers/:id | Get by ID |
| PUT | /api/passengers/:id | Update |
| POST | /api/passengers/:id/favorites | Add favorite place |
| DELETE | /api/passengers/:id/favorites/:placeId | Remove favorite |
| POST | /api/passengers/:id/recent-routes | Add recent route |

### Routes
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/routes | List all routes |
| GET | /api/routes/search?origin=&destination= | Search routes |
| GET | /api/routes/:id | Get by ID |
| POST | /api/routes | Create route |
| PUT | /api/routes/:id | Update route |
| DELETE | /api/routes/:id | Delete route |

### Trips
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/trips/user/:userId | Get passenger trips |
| GET | /api/trips/driver/:driverId | Get driver trips |
| GET | /api/trips/:id | Get by ID |
| POST | /api/trips | Create trip |
| PATCH | /api/trips/:id/start | Start trip |
| PATCH | /api/trips/:id/complete | Complete trip |
| PATCH | /api/trips/:id/cancel | Cancel trip |

### Notifications
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/notifications/user/:userId | Get all |
| GET | /api/notifications/user/:userId/unread | Get unread |
| POST | /api/notifications | Create |
| PATCH | /api/notifications/:id/read | Mark read |
| PATCH | /api/notifications/user/:userId/read-all | Mark all read |
| DELETE | /api/notifications/:id | Delete |

## Socket.IO Events

### Client → Server
| Event | Data | Description |
|-------|------|-------------|
| driver:connect | { driverId } | Driver goes online |
| passenger:connect | { passengerId } | Passenger connects |
| route:join | { routeId } | Watch a route |
| route:leave | { routeId } | Stop watching |
| driver:location:update | { driverId, latitude, longitude, routeId? } | GPS update |
| driver:status:update | { driverId, status, routeId? } | Status change |
| driver:occupancy:update | { driverId, occupancy, routeId? } | Seats changed |
| trip:status:update | { tripId, status, driverId?, passengerId? } | Trip state change |

### Server → Client
| Event | Data | Description |
|-------|------|-------------|
| driver:location:changed | { driverId, latitude, longitude } | Live location |
| driver:status:changed | { driverId, status } | Driver went online/offline |
| driver:occupancy:changed | { driverId, occupancy } | Seats available |
| trip:status:changed | { tripId, status } | Trip started/completed/cancelled |

## Project Structure

```
backend/
├── src/
│   ├── config/
│   │   ├── constants.ts      # Table names, roles, statuses
│   │   ├── environment.ts    # Env var loading
│   │   └── supabase.ts       # Supabase client setup
│   ├── middleware/
│   │   ├── auth.ts           # JWT verification
│   │   ├── error-handler.ts  # Global error handling
│   │   └── validate.ts       # Request body validation (Zod)
│   ├── routes/
│   │   ├── auth.routes.ts
│   │   ├── driver.routes.ts
│   │   ├── notification.routes.ts
│   │   ├── passenger.routes.ts
│   │   ├── route.routes.ts
│   │   ├── trip.routes.ts
│   │   └── user.routes.ts
│   ├── socket/
│   │   └── index.ts          # Socket.IO real-time events
│   ├── app.ts                # Express app configuration
│   └── server.ts             # HTTP server entry point
├── .env.example
├── .gitignore
├── package.json
├── README.md
└── tsconfig.json
```
