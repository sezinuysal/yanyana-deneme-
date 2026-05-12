class AppUser {
  final String id;
  final String name;
  final String email;
  final String role;
  final String disabilityType;
  final String communicationPreference;
  final List<String> interests;
  final int points;
  final List<String> badges;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.disabilityType,
    required this.communicationPreference,
    required this.interests,
    required this.points,
    required this.badges,
  });

  AppUser copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? disabilityType,
    String? communicationPreference,
    List<String>? interests,
    int? points,
    List<String>? badges,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      disabilityType: disabilityType ?? this.disabilityType,
      communicationPreference:
          communicationPreference ?? this.communicationPreference,
      interests: interests ?? this.interests,
      points: points ?? this.points,
      badges: badges ?? this.badges,
    );
  }
}

