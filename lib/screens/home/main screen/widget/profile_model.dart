class ProfileModel {
  final String name;
  final String headline;
  final String about;
  final String email;
  final String phone;
  final String department;
  final String year;
  final String github;
  final String linkedin;
  final String portfolio;
  final String photoUrl;

  const ProfileModel({
    required this.name,
    required this.headline,
    required this.about,
    required this.email,
    required this.phone,
    required this.department,
    required this.year,
    required this.github,
    required this.linkedin,
    required this.portfolio,
    required this.photoUrl,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> data) {
    return ProfileModel(
      name: data["name"] ?? "",
      headline: data["headline"] ?? "",
      about: data["about"] ?? "",
      email: data["email"] ?? "",
      phone: data["phone"] ?? "",
      department: data["department"] ?? "",
      year: data["year"] ?? "",
      github: data["github"] ?? "",
      linkedin: data["linkedin"] ?? "",
      portfolio: data["portfolio"] ?? "",
      photoUrl: data["photoUrl"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "headline": headline,
      "about": about,
      "email": email,
      "phone": phone,
      "department": department,
      "year": year,
      "github": github,
      "linkedin": linkedin,
      "portfolio": portfolio,
      "photoUrl": photoUrl,
    };
  }

  ProfileModel copyWith({
    String? name,
    String? headline,
    String? about,
    String? email,
    String? phone,
    String? department,
    String? year,
    String? github,
    String? linkedin,
    String? portfolio,
    String? photoUrl,
  }) {
    return ProfileModel(
      name: name ?? this.name,
      headline: headline ?? this.headline,
      about: about ?? this.about,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      department: department ?? this.department,
      year: year ?? this.year,
      github: github ?? this.github,
      linkedin: linkedin ?? this.linkedin,
      portfolio: portfolio ?? this.portfolio,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}