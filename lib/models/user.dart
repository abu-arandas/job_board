import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt, this.phone,
    this.avatar,
    this.location,
    this.title,
    this.bio,
    this.skills = const [],
    this.resumeUrl,
    this.linkedinUrl,
    this.githubUrl,
    this.portfolioUrl,
    this.jobTitle,
    this.experienceLevel,
    this.expectedSalaryMin,
    this.expectedSalaryMax,
    this.preferredJobTypes = const [],
    this.availability,
    this.isOpenToRemote,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final String? location;
  final String? title;
  final String? bio;
  final List<String> skills;
  final String? resumeUrl;
  final String? linkedinUrl;
  final String? githubUrl;
  final String? portfolioUrl;
  final String? jobTitle;
  final String? experienceLevel;
  final int? expectedSalaryMin;
  final int? expectedSalaryMax;
  final List<String> preferredJobTypes;
  final String? availability;
  final bool? isOpenToRemote;
  final DateTime createdAt;
  final DateTime? updatedAt;
  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatar,
    String? location,
    String? title,
    String? bio,
    List<String>? skills,
    String? resumeUrl,
    String? linkedinUrl,
    String? githubUrl,
    String? portfolioUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      location: location ?? this.location,
      title: title ?? this.title,
      bio: bio ?? this.bio,
      skills: skills ?? this.skills,
      resumeUrl: resumeUrl ?? this.resumeUrl,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      githubUrl: githubUrl ?? this.githubUrl,
      portfolioUrl: portfolioUrl ?? this.portfolioUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is User && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'User{id: $id, name: $name, email: $email}';
}
