import { Server as HttpServer } from 'http';
import { Server, Socket } from 'socket.io';
import { supabaseAdmin } from '../config/supabase';
import { Tables } from '../config/constants';

let io: Server;

export const initializeSocketIO = (httpServer: HttpServer) => {
  io = new Server(httpServer, {
    cors: {
      origin: '*',
      methods: ['GET', 'POST'],
    },
  });

  io.on('connection', (socket: Socket) => {
    console.log(`🔌 Client connected: ${socket.id}`);

    // Driver joins their personal room
    socket.on('driver:connect', (data: { driverId: string }) => {
      socket.join(`driver:${data.driverId}`);
      console.log(`🚐 Driver ${data.driverId} connected`);
    });

    // Passenger joins their personal room
    socket.on('passenger:connect', (data: { passengerId: string }) => {
      socket.join(`passenger:${data.passengerId}`);
      console.log(`👤 Passenger ${data.passengerId} connected`);
    });

    // Join a route room (to receive updates for that route)
    socket.on('route:join', (data: { routeId: string }) => {
      socket.join(`route:${data.routeId}`);
      console.log(`📍 ${socket.id} joined route ${data.routeId}`);
    });

    // Leave a route room
    socket.on('route:leave', (data: { routeId: string }) => {
      socket.leave(`route:${data.routeId}`);
    });

    // Driver sends location update
    socket.on(
      'driver:location:update',
      async (data: {
        driverId: string;
        latitude: number;
        longitude: number;
        routeId?: string;
      }) => {
        // Save to database
        await supabaseAdmin
          .from(Tables.DRIVERS)
          .update({
            current_latitude: data.latitude,
            current_longitude: data.longitude,
          })
          .eq('id', data.driverId);

        // Broadcast to all passengers watching this route
        if (data.routeId) {
          io.to(`route:${data.routeId}`).emit('driver:location:changed', {
            driverId: data.driverId,
            latitude: data.latitude,
            longitude: data.longitude,
          });
        }
      }
    );

    // Driver status change
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

    // Trip status updates (broadcast to relevant parties)
    socket.on(
      'trip:status:update',
      (data: {
        tripId: string;
        status: string;
        driverId?: string;
        passengerId?: string;
      }) => {
        // Notify the driver
        if (data.driverId) {
          io.to(`driver:${data.driverId}`).emit('trip:status:changed', {
            tripId: data.tripId,
            status: data.status,
          });
        }

        // Notify the passenger
        if (data.passengerId) {
          io.to(`passenger:${data.passengerId}`).emit('trip:status:changed', {
            tripId: data.tripId,
            status: data.status,
          });
        }
      }
    );

    // Occupancy update (broadcast to route watchers)
    socket.on(
      'driver:occupancy:update',
      (data: { driverId: string; occupancy: number; routeId?: string }) => {
        if (data.routeId) {
          io.to(`route:${data.routeId}`).emit('driver:occupancy:changed', {
            driverId: data.driverId,
            occupancy: data.occupancy,
          });
        }
      }
    );

    socket.on('disconnect', () => {
      console.log(`❌ Client disconnected: ${socket.id}`);
    });
  });

  return io;
};

export const getIO = (): Server => {
  if (!io) {
    throw new Error('Socket.IO has not been initialized');
  }
  return io;
};
