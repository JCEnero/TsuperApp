/**
 * STEP 2 — Jeepney Mock Simulator
 *
 * Simulates jeepneys moving along real QC road routes.
 * Each jeepney follows a fixed route (array of waypoints from OSRM),
 * advancing one waypoint at a time on a timer.
 *
 * This replaces the static mock data in the Flutter JeepneyService.
 * When real drivers are onboarded, this simulator is simply turned off
 * and real GPS data takes over through the same Socket.IO events.
 */

import { QC_ROUTES, QcRoute } from '../data/qc-routes';

// ─── Types ─────────────────────────────────────────────────────────────────

export type JeepneyStatus =
  | 'available'
  | 'on_route'
  | 'full'
  | 'on_break'
  | 'maintenance';

export interface SimulatedJeepney {
  id: string;
  routeId: string;
  routeName: string;
  driverName: string;
  plateNumber: string;
  latitude: number;
  longitude: number;
  heading: number;
  occupancy: number;
  maxCapacity: number;
  status: JeepneyStatus;
  lastUpdated: string;
  color: string; // Route color for the marker
}

// ─── Internal state per jeepney ────────────────────────────────────────────

interface JeepneyState {
  jeepney: SimulatedJeepney;
  waypointIndex: number;
  route: QcRoute;
  direction: 1 | -1; // 1 = forward, -1 = reverse (ping-pong)
  ticksAtStop: number; // How many ticks spent "waiting" at terminal
}

// ─── Mock driver names ─────────────────────────────────────────────────────

const DRIVER_NAMES = [
  'Juan Dela Cruz',
  'Maria Santos',
  'Pedro Reyes',
  'Ana Garcia',
  'Carlos Mendoza',
  'Elena Rodriguez',
  'Miguel Torres',
  'Sofia Hernandez',
  'Ramon Villanueva',
  'Luz Bautista',
  'Jose Aquino',
  'Rosa Pascual',
];

const PLATE_NUMBERS = [
  'ABC-1234', 'DEF-5678', 'GHI-9012', 'JKL-3456',
  'MNO-7890', 'PQR-1357', 'STU-2468', 'VWX-9753',
  'YZA-8642', 'BCD-7531', 'EFG-6420', 'HIJ-5319',
];

// ─── Simulator Class ───────────────────────────────────────────────────────

export class JeepneySimulator {
  private states: Map<string, JeepneyState> = new Map();
  private timer: ReturnType<typeof setInterval> | null = null;
  private updateCallback: ((jeepney: SimulatedJeepney) => void) | null = null;

  // How many waypoints to skip per tick (controls speed)
  // Higher = faster movement along route
  private readonly WAYPOINTS_PER_TICK = 3;

  // Interval between ticks in milliseconds
  private readonly TICK_INTERVAL_MS = 2000;

  constructor() {
    this.initializeJeepneys();
  }

  /**
   * Spread 12 mock jeepneys across our 4 QC routes,
   * starting them at different positions so they're not all bunched up.
   */
  private initializeJeepneys() {
    const routeIds = Object.keys(QC_ROUTES);
    let driverIndex = 0;

    // 3 jeepneys per route = 12 total
    routeIds.forEach((routeId, routeIndex) => {
      const route = QC_ROUTES[routeId];
      const totalWaypoints = route.waypoints.length;

      for (let i = 0; i < 3; i++) {
        const id = `jeepney_${routeIndex}_${i}`;

        // Spread starting positions evenly along the route
        const startIndex = Math.floor((totalWaypoints / 3) * i);
        const startWaypoint = route.waypoints[startIndex];

        const jeepney: SimulatedJeepney = {
          id,
          routeId,
          routeName: route.name,
          driverName: DRIVER_NAMES[driverIndex % DRIVER_NAMES.length],
          plateNumber: PLATE_NUMBERS[driverIndex % PLATE_NUMBERS.length],
          latitude: startWaypoint[0],
          longitude: startWaypoint[1],
          heading: this.calculateHeading(
            route.waypoints[startIndex],
            route.waypoints[Math.min(startIndex + 1, totalWaypoints - 1)]
          ),
          occupancy: Math.floor(Math.random() * 15) + 2,
          maxCapacity: 20,
          status: 'on_route',
          lastUpdated: new Date().toISOString(),
          color: route.color,
        };

        this.states.set(id, {
          jeepney,
          waypointIndex: startIndex,
          route,
          direction: 1,
          ticksAtStop: 0,
        });

        driverIndex++;
      }
    });

    console.log(`🚌 Simulator initialized with ${this.states.size} jeepneys across ${routeIds.length} routes`);
  }

  /**
   * Start the simulation timer.
   * onUpdate is called every tick with the updated jeepney data.
   */
  start(onUpdate: (jeepney: SimulatedJeepney) => void) {
    this.updateCallback = onUpdate;

    this.timer = setInterval(() => {
      this.tick();
    }, this.TICK_INTERVAL_MS);

    console.log(`▶️  Jeepney simulator started (${this.TICK_INTERVAL_MS}ms interval)`);
  }

  stop() {
    if (this.timer) {
      clearInterval(this.timer);
      this.timer = null;
      console.log('⏹️  Jeepney simulator stopped');
    }
  }

  /**
   * Get current state of all jeepneys.
   * Used for the initial snapshot when a passenger connects.
   */
  getAllJeepneys(): SimulatedJeepney[] {
    return Array.from(this.states.values()).map((s) => s.jeepney);
  }

  getJeepneyById(id: string): SimulatedJeepney | undefined {
    return this.states.get(id)?.jeepney;
  }

  /**
   * One simulation tick — move every jeepney forward along its route.
   */
  private tick() {
    this.states.forEach((state, id) => {
      // If waiting at terminal, count down ticks
      if (state.ticksAtStop > 0) {
        state.ticksAtStop--;
        state.jeepney.status = 'available';
        state.jeepney.lastUpdated = new Date().toISOString();
        this.updateCallback?.(state.jeepney);
        return;
      }

      const waypoints = state.route.waypoints;
      const totalWaypoints = waypoints.length;

      // Advance waypoint index
      let nextIndex = state.waypointIndex + (this.WAYPOINTS_PER_TICK * state.direction);

      // Reached end of route — wait at terminal then reverse
      if (nextIndex >= totalWaypoints - 1) {
        nextIndex = totalWaypoints - 1;
        state.direction = -1;
        state.ticksAtStop = 3; // Wait 3 ticks (~6 seconds) at terminal
        state.jeepney.status = 'available';
        state.jeepney.occupancy = Math.max(0, state.jeepney.occupancy - Math.floor(Math.random() * 8 + 5));
      }

      // Reached start of route — wait then go forward again
      if (nextIndex <= 0) {
        nextIndex = 0;
        state.direction = 1;
        state.ticksAtStop = 3;
        state.jeepney.status = 'available';
        state.jeepney.occupancy = Math.floor(Math.random() * 8) + 2;
      }

      state.waypointIndex = nextIndex;
      const newPos = waypoints[nextIndex];
      const nextPos = waypoints[Math.min(nextIndex + 1, totalWaypoints - 1)];

      // Update occupancy realistically (passengers board/alight)
      state.jeepney.occupancy = this.simulateOccupancy(state.jeepney.occupancy);
      state.jeepney.status = this.calculateStatus(state.jeepney.occupancy);
      state.jeepney.latitude = newPos[0];
      state.jeepney.longitude = newPos[1];
      state.jeepney.heading = this.calculateHeading(newPos, nextPos);
      state.jeepney.lastUpdated = new Date().toISOString();

      this.updateCallback?.(state.jeepney);
    });
  }

  /**
   * Simulate passengers boarding and alighting.
   * Occupancy changes by ±1-3 per tick randomly.
   */
  private simulateOccupancy(current: number): number {
    const change = Math.floor(Math.random() * 5) - 2; // -2 to +2
    return Math.max(0, Math.min(20, current + change));
  }

  private calculateStatus(occupancy: number): JeepneyStatus {
    if (occupancy >= 20) return 'full';
    if (occupancy === 0) return 'available';
    return 'on_route';
  }

  /**
   * Calculate compass heading (degrees) from point A to point B.
   * Used to rotate the jeepney marker in the direction of travel.
   */
  private calculateHeading(
    from: [number, number],
    to: [number, number]
  ): number {
    const lat1 = (from[0] * Math.PI) / 180;
    const lat2 = (to[0] * Math.PI) / 180;
    const dLng = ((to[1] - from[1]) * Math.PI) / 180;

    const y = Math.sin(dLng) * Math.cos(lat2);
    const x =
      Math.cos(lat1) * Math.sin(lat2) -
      Math.sin(lat1) * Math.cos(lat2) * Math.cos(dLng);

    const bearing = (Math.atan2(y, x) * 180) / Math.PI;
    return (bearing + 360) % 360;
  }
}
