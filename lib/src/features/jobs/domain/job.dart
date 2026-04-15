enum JobStatus { open, filled, closed }

class Job {
  const Job({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.salary,
    required this.employerId,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String description;
  final String location;
  final String salary;
  final String employerId;
  final JobStatus status;
  final DateTime createdAt;

  Job copyWith({JobStatus? status}) {
    return Job(
      id: id,
      title: title,
      description: description,
      location: location,
      salary: salary,
      employerId: employerId,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }
}
