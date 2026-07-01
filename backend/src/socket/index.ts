/**
 * Socket.IO — Real-time Communication Hub
 *
 * Handles two things:
 * 1. Mock simulation — broadcasts simulated jeepney positions to all passengers
 * 2. Real driver updates — when real drivers send GPS, broadcasts to route rooms
 *
 * Socket events (server → client):
 *   jeepney:snapshot   → all current jeepney positions (on connect)
 *   jeepney:update     → single jeepney position update (every 2 seconds)
 *
 * Socket events (client → server):
 *   driver:location:update  → real driver sends GPS coordinates
 *   driver:status:update    → driver goes online/offline
 *   driver:occupancy:update → driver updates passenger count
 *   route:join              → passenger starts watching a route
 *   route:leave             → passenger stops watching a route
 */

import { Server as HttpServer } from 'http';
import { Server, Socket } from 'socket.io';
import { supabaseAdmin } from '../config/supabase';
import { Tables } from '../config/constants';
import { JeepneySimulator } from '../simulation/jeepney-simulator';
import { QC_ROUTES } from '../data/qc-routes';

let io: Server;
let simulator: JeepneySimulator;

export const initializeSocketIO = (httpServer: HttpServer) => {
  io = new Server(httpServer, {
    cors: {
      origin: '*',
      methods: ['GET', 'POST'],
    },
    // Ping timeout settings for mobile clients
    pingTimeout: 60000,
    pingInterval: 25000,
  });

  // ─── Start Mock Simulator ─────────────────────────────────────────────────
  simulator = new JeepneySimulator();

  simulator.start((updatedJeepney) => {
    // Broadcast updated jeepney to ALL connected clients
    io.emit('jeepney:update', updatedJeepney);
  });

  // ─── Connection Handler ───────────────────────────────────────────────────
  io.on('connection', (socket: Socket) => {
    console.log(`🔌 Client connected: ${socket.id}`);

    // ── Send immediate snapshot so passenger sees jeepneys right away ────────
    const snapshot = simulator.getAllJeepneys();
    socket.emit('jeepney:snapshot', snapshot);

    // ── Send route polylines so Flutter can draw them on the map ─────────────
    const routeData = Object.values(QC_ROUTES).map((route) => ({
      id: route.id,
      name: route.name,
      color: route.color,
      waypoints: route.waypoints,
      distanceKm: route.distanceKm,
      durationMin: route.durationMin,
    }));
    socket.emit('routes:snapshot', routeData);

    // ─────────────────────────────────────────────────────────────────────────
    // DRIVER EVENTS (real driver sending GPS from their device)
    // ─────────────────────────────────────────────────────────────────────────

    // Driver connects and joins their personal room
    socket.on('driver:connect', (data: { driverId: string }) => {
      socket.join(`driver:${data.driverId}`);
      console.log(`🚐 Driver ${data.driverId} connected`);
    });

    // Driver sends live GPS location
    socket.on(
      'driver:location:update',
      async (data: {
        driverId: string;
        latitude: number;
        longitude: number;
        heading?: number;
        routeId?: string;
      }) => {
        // Validate coordinates are within Philippines bounds
        if (
          data.latitude < 4.5 || data.latitude > 21.5 ||
          data.longitude < 116.0 || data.longitude > 127.0
        ) {
          socket.emit('error', { message: 'Invalid coordinates' });
          return;
        }

        // Persist to Supabase
        await supabaseAdmin
          .from(Tables.DRIVERS)
          .update({
            current_latitude: data.latitude,
            current_longitude: data.longitude,
          })
          .eq('id', data.driverId);

        // Broadcast to passengers watching this route
        if (data.routeId) {
          io.to(`route:${data.routeId}`).emit('jeepney:update', {
            id: data.driverId,
            latitude: data.latitude,
            longitude: data.longitude,
            heading: data.heading || 0,
            lastUpdated: new Date().toISOString(),
          });
        }
      }
    );

    // Driver updates their status (active, offline, on_break, etc.)
    socket.on(
      'driver:status:update',
      async (data: { driverId: string; status: string; routeId?: string }) => {
        await supabaseAdmin
          .from(Tables.DRIVERS)
          .update({ status: data.status })
          .eq('id', data.driverId);

        if (data.routeId) {
          io.to(`route:${data.routeId}`).emit('driver:status:changed', {
            driverId: data.driverId,
            status: data.status,
          });
        }
      }
    );

    // Driver updates occupancy (passengers boarded/alighted)
    socket.on(
      'driver:occupancy:update',
      async (data: { driverId: string; occupancy: number; routeId?: string }) => {
        if (data.occupancy < 0 || data.occupancy > 20) {
          socket.emit('error', { message: 'Invalid occupancy value' });
          return;
        }

        await supabaseAdmin
          .from(Tables.DRIVERS)
          .update({ occupancy: data.occupancy })
          .eq('id', data.driverId);

        if (data.routeId) {
          io.to(`route:${data.routeId}`).emit('driver:occupancy:changed', {
            driverId: data.driverId,
            occupancy: data.occupancy,
          });
        }
      }
    );

    // ─────────────────────────────────────────────────────────────────────────
    // PASSENGER EVENTS
    // ─────────────────────────────────────────────────────────────────────────

    // Passenger joins their personal notification room
    socket.on('passenger:connect', (data: { passengerId: string }) => {
      socket.join(`passenger:${data.passengerId}`);
      console.log(`👤 Passenger ${data.passengerId} connected`);
    });

    // Passenger subscribes to updates for a specific route
    socket.on('route:join', (data: { routeId: string }) => {
      socket.join(`route:${data.routeId}`);
    });

    // Passenger unsubscribes from route updates
    socket.on('route:leave', (data: { routeId: string }) => {
      socket.leave(`route:${data.routeId}`);
    });

    // ─────────────────────────────────────────────────────────────────────────
    // TRIP EVENTS
    // ─────────────────────────────────────────────────────────────────────────

    socket.on(
      'trip:status:update',
      (data: {
        tripId: string;
        status: string;
        driverId?: string;
        passengerId?: string;
      }) => {
        if (data.driverId) {
          io.to(`driver:${data.driverId}`).emit('trip:status:changed', {
            tripId: data.tripId,
            status: data.status,
          });
        }
        if (data.passengerId) {
          io.to(`passenger:${data.passengerId}`).emit('trip:status:changed', {
            tripId: data.tripId,
            status: data.status,
          });
        }
      }
    );

    // ─────────────────────────────────────────────────────────────────────────
    socket.on('disconnect', () => {
      console.log(`❌ Client disconnected: ${socket.id}`);
    });
  });

  return io;
};

export const getIO = (): Server => {
  if (!io) throw new Error('Socket.IO not initialized');
  return io;
};

export const getSimulator = (): JeepneySimulator => {
  if (!simulator) throw new Error('Simulator not initialized');
  return simulator;
};
