// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String?,
  avatar: json['avatar'] as String?,
  location: json['location'] as String?,
  title: json['title'] as String?,
  bio: json['bio'] as String?,
  skills:
      (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  resumeUrl: json['resumeUrl'] as String?,
  linkedinUrl: json['linkedinUrl'] as String?,
  githubUrl: json['githubUrl'] as String?,
  portfolioUrl: json['portfolioUrl'] as String?,
  jobTitle: json['jobTitle'] as String?,
  experienceLevel: json['experienceLevel'] as String?,
  expectedSalaryMin: (json['expectedSalaryMin'] as num?)?.toInt(),
  expectedSalaryMax: (json['expectedSalaryMax'] as num?)?.toInt(),
  preferredJobTypes:
      (json['preferredJobTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  availability: json['availability'] as String?,
  isOpenToRemote: json['isOpenToRemote'] as bool?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'avatar': instance.avatar,
  'location': instance.location,
  'title': instance.title,
  'bio': instance.bio,
  'skills': instance.skills,
  'resumeUrl': instance.resumeUrl,
  'linkedinUrl': instance.linkedinUrl,
  'githubUrl': instance.githubUrl,
  'portfolioUrl': instance.portfolioUrl,
  'jobTitle': instance.jobTitle,
  'experienceLevel': instance.experienceLevel,
  'expectedSalaryMin': instance.expectedSalaryMin,
  'expectedSalaryMax': instance.expectedSalaryMax,
  'preferredJobTypes': instance.preferredJobTypes,
  'availability': instance.availability,
  'isOpenToRemote': instance.isOpenToRemote,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
