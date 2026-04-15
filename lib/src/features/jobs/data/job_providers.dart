import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/job.dart';

final _seedReferenceDate = DateTime(2026, 4, 14, 9);

final _initialJobs = <Job>[
  Job(
    id: 'j-001',
    title: 'Construction Worker',
    description:
        'Construction work for a mid-rise residential project. '
        'Tasks include brick laying, concrete mixing and general site duties. '
        'Safety gear provided. Morning shift, 6 days a week.',
    location: 'Gurugram Sector 45',
    salary: '₹1,200 / day',
    employerId: 'Mehta Builders',
    status: JobStatus.open,
    createdAt: _seedReferenceDate.subtract(const Duration(hours: 2)),
  ),
  Job(
    id: 'j-002',
    title: 'Electrician',
    description:
        'Rewiring work for a residential tower. Fittings, MCB panels and '
        'wall sockets. Experience with commercial sites preferred. '
        'Tools provided on site.',
    location: 'Noida Sector 62',
    salary: '₹1,400 / day',
    employerId: 'Ananya Apartments',
    status: JobStatus.open,
    createdAt: _seedReferenceDate.subtract(const Duration(hours: 5)),
  ),
  Job(
    id: 'j-003',
    title: 'Plumber',
    description:
        'Fixing leaks and installing new piping for 3 bathrooms and a kitchen. '
        'Half-day work, flexible start. Materials reimbursed on submission of bill.',
    location: 'Delhi Connaught Place',
    salary: '₹1,100 / day',
    employerId: 'Arohi Constructions',
    status: JobStatus.open,
    createdAt: _seedReferenceDate.subtract(const Duration(hours: 9)),
  ),
  Job(
    id: 'j-004',
    title: 'Helper',
    description:
        'General helper for ongoing renovation. Assisting masons, cleaning up '
        'and basic lifting. No prior experience needed. Meals included.',
    location: 'Faridabad Sector 21',
    salary: '₹700 / day',
    employerId: 'Khanna Villa',
    status: JobStatus.open,
    createdAt: _seedReferenceDate.subtract(const Duration(hours: 14)),
  ),
  Job(
    id: 'j-005',
    title: 'Painter',
    description:
        'Interior painting for 4 flats. Distemper and emulsion. '
        'Estimated 5 days of work. Paint and brushes provided.',
    location: 'Ghaziabad Raj Nagar',
    salary: '₹1,000 / day',
    employerId: 'Green Meadows Society',
    status: JobStatus.open,
    createdAt: _seedReferenceDate.subtract(const Duration(hours: 26)),
  ),
  Job(
    id: 'j-006',
    title: 'AC Technician',
    description:
        'Servicing and repair of split ACs for a residential customer list. '
        'Gas refilling, coil cleaning and filter replacement. '
        'Own tools preferred.',
    location: 'Delhi Rohini',
    salary: '₹1,300 / day',
    employerId: 'Cool Breeze Services',
    status: JobStatus.open,
    createdAt: _seedReferenceDate.subtract(const Duration(hours: 40)),
  ),
];

class JobNotifier extends StateNotifier<List<Job>> {
  JobNotifier() : super(_initialJobs);

  void addJob(Job job) {
    state = [job, ...state];
  }

  List<Job> getJobs() => state;
}

final jobListProvider = StateNotifierProvider<JobNotifier, List<Job>>((ref) {
  return JobNotifier();
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredJobListProvider = Provider<List<Job>>((ref) {
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  final jobs = ref
      .watch(jobListProvider)
      .where((job) => job.status == JobStatus.open)
      .toList();
  if (query.isEmpty) return jobs;
  return jobs
      .where((job) => job.title.toLowerCase().contains(query))
      .toList();
});

final jobsByEmployerProvider =
    Provider.family<List<Job>, String>((ref, employerId) {
  return ref
      .watch(jobListProvider)
      .where((job) => job.employerId == employerId)
      .toList();
});
