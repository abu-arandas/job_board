// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Job _$JobFromJson(Map<String, dynamic> json) => Job(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  company: Company.fromJson(json['company'] as Map<String, dynamic>),
  location: json['location'] as String,
  jobType: $enumDecode(_$JobTypeEnumMap, json['jobType']),
  experienceLevel: $enumDecode(
    _$ExperienceLevelEnumMap,
    json['experienceLevel'],
  ),
  workLocation: $enumDecode(_$WorkLocationEnumMap, json['workLocation']),
  salaryMin: (json['salaryMin'] as num?)?.toDouble(),
  salaryMax: (json['salaryMax'] as num?)?.toDouble(),
  salaryCurrency: json['salaryCurrency'] as String? ?? 'USD',
  requirements: (json['requirements'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  benefits: (json['benefits'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  skills: (json['skills'] as List<dynamic>).map((e) => e as String).toList(),
  applicationUrl: json['applicationUrl'] as String?,
  applicationEmail: json['applicationEmail'] as String?,
  postedDate: DateTime.parse(json['postedDate'] as String),
  applicationDeadline: json['applicationDeadline'] == null
      ? null
      : DateTime.parse(json['applicationDeadline'] as String),
  isActive: json['isActive'] as bool? ?? true,
  isFeatured: json['isFeatured'] as bool? ?? false,
);

Map<String, dynamic> _$JobToJson(Job instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'company': instance.company,
  'location': instance.location,
  'jobType': _$JobTypeEnumMap[instance.jobType]!,
  'experienceLevel': _$ExperienceLevelEnumMap[instance.experienceLevel]!,
  'workLocation': _$WorkLocationEnumMap[instance.workLocation]!,
  'salaryMin': instance.salaryMin,
  'salaryMax': instance.salaryMax,
  'salaryCurrency': instance.salaryCurrency,
  'requirements': instance.requirements,
  'benefits': instance.benefits,
  'skills': instance.skills,
  'applicationUrl': instance.applicationUrl,
  'applicationEmail': instance.applicationEmail,
  'postedDate': instance.postedDate.toIso8601String(),
  'applicationDeadline': instance.applicationDeadline?.toIso8601String(),
  'isActive': instance.isActive,
  'isFeatured': instance.isFeatured,
};

const _$JobTypeEnumMap = {
  JobType.fullTime: 'full-time',
  JobType.partTime: 'part-time',
  JobType.contract: 'contract',
  JobType.internship: 'internship',
  JobType.freelance: 'freelance',
};

const _$ExperienceLevelEnumMap = {
  ExperienceLevel.entry: 'entry',
  ExperienceLevel.junior: 'junior',
  ExperienceLevel.mid: 'mid',
  ExperienceLevel.senior: 'senior',
  ExperienceLevel.lead: 'lead',
  ExperienceLevel.executive: 'executive',
};

const _$WorkLocationEnumMap = {
  WorkLocation.remote: 'remote',
  WorkLocation.onsite: 'onsite',
  WorkLocation.hybrid: 'hybrid',
};
