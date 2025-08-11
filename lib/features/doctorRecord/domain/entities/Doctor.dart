class Doctor {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? specialization;
  final String? qualification;
  final int? experienceYears;
  final String? profileUrl;
  final String? hospitalId;
  final String? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Doctor({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.specialization,
    this.qualification,
    this.experienceYears,
    this.profileUrl,
    this.hospitalId,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      specialization: json['specialization'] as String?,
      qualification: json['qualification'] as String?,
      experienceYears: json['experience_years'] as int?,
      profileUrl: json['profile_url'] as String?,
      hospitalId: json['hospital_id'] as String?,
      userId: json['user_id'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'specialization': specialization,
      'qualification': qualification,
      'experience_years': experienceYears,
      'profile_url': profileUrl,
      'hospital_id': hospitalId,
      'user_id': userId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();
}