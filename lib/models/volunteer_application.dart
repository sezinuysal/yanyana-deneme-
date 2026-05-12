class VolunteerApplication {
  final String id;
  final String name;
  final String email;
  final String supportArea;
  final String status;

  const VolunteerApplication({
    required this.id,
    required this.name,
    required this.email,
    required this.supportArea,
    required this.status,
  });

  VolunteerApplication copyWith({
    String? id,
    String? name,
    String? email,
    String? supportArea,
    String? status,
  }) {
    return VolunteerApplication(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      supportArea: supportArea ?? this.supportArea,
      status: status ?? this.status,
    );
  }
}

