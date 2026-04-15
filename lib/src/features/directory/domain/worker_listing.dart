class WorkerListing {
  const WorkerListing({
    required this.id,
    required this.name,
    required this.trade,
    required this.rating,
    required this.distanceKm,
    required this.hourlyRate,
  });

  final String id;
  final String name;
  final String trade;
  final double rating;
  final double distanceKm;
  final int hourlyRate;

  String get initials {
    final parts = name.split(' ');
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}
