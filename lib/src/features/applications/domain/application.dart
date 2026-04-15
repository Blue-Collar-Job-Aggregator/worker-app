enum ApplicationStatus { pending, accepted, rejected }

class Application {
  const Application({
    required this.id,
    required this.jobId,
    required this.workerId,
    required this.status,
    required this.appliedAt,
  });

  final String id;
  final String jobId;
  final String workerId;
  final ApplicationStatus status;
  final DateTime appliedAt;

  Application copyWith({ApplicationStatus? status}) {
    return Application(
      id: id,
      jobId: jobId,
      workerId: workerId,
      status: status ?? this.status,
      appliedAt: appliedAt,
    );
  }
}
