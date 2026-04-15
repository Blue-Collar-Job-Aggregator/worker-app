import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/application.dart';

class ApplicationNotifier extends StateNotifier<List<Application>> {
  ApplicationNotifier() : super(const []);

  /// Returns true if a new application was created, false if the worker had
  /// already applied to this job.
  bool applyToJob(String jobId, String workerId) {
    final alreadyApplied = state.any(
      (a) => a.jobId == jobId && a.workerId == workerId,
    );
    if (alreadyApplied) return false;

    final application = Application(
      id: 'a-${DateTime.now().millisecondsSinceEpoch}',
      jobId: jobId,
      workerId: workerId,
      status: ApplicationStatus.pending,
      appliedAt: DateTime.now(),
    );
    state = [application, ...state];
    return true;
  }

  List<Application> getApplicationsForJob(String jobId) =>
      state.where((a) => a.jobId == jobId).toList();

  List<Application> getApplicationsForWorker(String workerId) =>
      state.where((a) => a.workerId == workerId).toList();

  void updateStatus(String applicationId, ApplicationStatus status) {
    state = [
      for (final a in state)
        if (a.id == applicationId) a.copyWith(status: status) else a,
    ];
  }
}

final applicationListProvider =
    StateNotifierProvider<ApplicationNotifier, List<Application>>((ref) {
  return ApplicationNotifier();
});

final applicationsForJobProvider =
    Provider.family<List<Application>, String>((ref, jobId) {
  return ref
      .watch(applicationListProvider)
      .where((a) => a.jobId == jobId)
      .toList();
});

final applicationsForWorkerProvider =
    Provider.family<List<Application>, String>((ref, workerId) {
  return ref
      .watch(applicationListProvider)
      .where((a) => a.workerId == workerId)
      .toList();
});
