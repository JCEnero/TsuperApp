/**
 * Jeepney Routes — REST endpoints for map data
 *
 * These endpoints are called ONCE when the passenger map loads,
 * to get the initial state before Socket.IO takes over with live updates.
 */

import { Router, Request, Response, NextFunction } from 'express';
import { QC_ROUTES } from '../data/qc-routes';
import { getSimulator } from '../socket';
import { AppError } from '../middleware/error-handler';

const router = Router();

/**
 * GET /api/jeepneys
 * Returns current position + status of all simulated jeepneys.
 * Flutter calls this on map screen load for instant population.
 * Socket.IO then keeps it updated in real-time.
 */
router.get('/', (_req: Request, res: Response, next: NextFunction) => {
  try {
    const simulator = getSimulator();
    const jeepneys = simulator.getAllJeepneys();
    res.json({ success: true, data: jeepneys });
  } catch (err) {
    next(err);
  }
});

/**
 * GET /api/jeepneys/:id
 * Returns current state of a single jeepney.
 */
router.get('/:id', (req: Request, res: Response, next: NextFunction) => {
  try {
    const simulator = getSimulator();
    const jeepney = simulator.getJeepneyById(req.params.id as string);

    if (!jeepney) {
      throw new AppError('Jeepney not found', 404);
    }

    res.json({ success: true, data: jeepney });
  } catch (err) {
    next(err);
  }
});

/**
 * GET /api/jeepneys/routes/all
 * Returns all QC route definitions with waypoints.
 * Flutter uses these to draw route polylines on Google Maps.
 */
router.get('/routes/all', (_req: Request, res: Response) => {
  const routes = Object.values(QC_ROUTES).map((route) => ({
    id: route.id,
    name: route.name,
    color: route.color,
    waypoints: route.waypoints,
    distanceKm: route.distanceKm,
    durationMin: route.durationMin,
  }));

  res.json({ success: true, data: routes });
});

export { router as jeepneyRoutes };
