import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/worker_listing.dart';

const _mockWorkers = <WorkerListing>[
  WorkerListing(
    id: 'w-001',
    name: 'Ravi Kumar',
    trade: 'Electrician',
    rating: 4.8,
    distanceKm: 1.2,
    hourlyRate: 250,
  ),
  WorkerListing(
    id: 'w-002',
    name: 'Sunita Devi',
    trade: 'Home cleaner',
    rating: 4.9,
    distanceKm: 2.4,
    hourlyRate: 180,
  ),
  WorkerListing(
    id: 'w-003',
    name: 'Amit Sharma',
    trade: 'Plumber',
    rating: 4.7,
    distanceKm: 3.1,
    hourlyRate: 220,
  ),
  WorkerListing(
    id: 'w-004',
    name: 'Kavita Rao',
    trade: 'Painter',
    rating: 4.6,
    distanceKm: 4.0,
    hourlyRate: 200,
  ),
];

final workerDirectoryProvider =
    Provider<List<WorkerListing>>((ref) => _mockWorkers);
