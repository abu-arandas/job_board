import 'package:json_annotation/json_annotation.dart';
import 'company.dart';

part 'job.g.dart';

enum JobType {
  @JsonValue('full-time')
  fullTime,
  @JsonValue('part-time')
  partTime,
  @JsonValue('contract')
  contract,
  @JsonValue('internship')
  internship,
  @JsonValue('freelance')
  freelance,
}

extension JobTypeExtension on JobType {
  String get displayName {
    switch (this) {
      case JobType.fullTime:
        return 'Full-time';
      case JobType.partTime:
        return 'Part-time';
      case JobType.contract:
        return 'Contract';
      case JobType.internship:
        return 'Internship';
      case JobType.freelance:
        return 'Freelance';
    }
  }
}

enum ExperienceLevel {
  @JsonValue('entry')
  entry,
  @JsonValue('junior')
  junior,
  @JsonValue('mid')
  mid,
  @JsonValue('senior')
  senior,
  @JsonValue('lead')
  lead,
  @JsonValue('executive')
  executive,
}

enum WorkLocation {
  @JsonValue('remote')
  remote,
  @JsonValue('onsite')
  onsite,
  @JsonValue('hybrid')
  hybrid,
}

@JsonSerializable()
class Job {

  const Job({
    required this.id,
    required this.title,
    required this.description,
    required this.company,
    required this.location,
    required this.jobType,
    required this.experienceLevel,
    required this.workLocation,
    required this.requirements, required this.benefits, required this.skills, required this.postedDate, this.salaryMin,
    this.salaryMax,
    this.salaryCurrency = 'USD',
    this.applicationUrl,
    this.applicationEmail,
    this.applicationDeadline,
    this.isActive = true,
    this.isFeatured = false,
  });

  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);
  final String id;
  final String title;
  final String description;
  final Company company;
  final String location;
  final JobType jobType;
  final ExperienceLevel experienceLevel;
  final WorkLocation workLocation;
  final double? salaryMin;
  final double? salaryMax;
  final String? salaryCurrency;
  final List<String> requirements;
  final List<String> benefits;
  final List<String> skills;
  final String? applicationUrl;
  final String? applicationEmail;
  final DateTime postedDate;
  final DateTime? applicationDeadline;
  final bool isActive;
  final bool isFeatured;
  Map<String, dynamic> toJson() => _$JobToJson(this);

  String get salaryRange {
    if (salaryMin != null && salaryMax != null) {
      return '\$${salaryMin!.toInt()}k - \$${salaryMax!.toInt()}k';
    } else if (salaryMin != null) {
      return '\$${salaryMin!.toInt()}k+';
    } else if (salaryMax != null) {
      return 'Up to \$${salaryMax!.toInt()}k';
    }
    return 'Salary not specified';
  }

  String get jobTypeDisplayName {
    switch (jobType) {
      case JobType.fullTime:
        return 'Full-time';
      case JobType.partTime:
        return 'Part-time';
      case JobType.contract:
        return 'Contract';
      case JobType.internship:
        return 'Internship';
      case JobType.freelance:
        return 'Freelance';
    }
  }

  String get experienceLevelDisplayName {
    switch (experienceLevel) {
      case ExperienceLevel.entry:
        return 'Entry Level';
      case ExperienceLevel.junior:
        return 'Junior';
      case ExperienceLevel.mid:
        return 'Mid Level';
      case ExperienceLevel.senior:
        return 'Senior';
      case ExperienceLevel.lead:
        return 'Lead';
      case ExperienceLevel.executive:
        return 'Executive';
    }
  }

  String get workLocationDisplayName {
    switch (workLocation) {
      case WorkLocation.remote:
        return 'Remote';
      case WorkLocation.onsite:
        return 'On-site';
      case WorkLocation.hybrid:
        return 'Hybrid';
    }
  }

  // Backward compatibility properties
  bool get isRemote => workLocation == WorkLocation.remote || workLocation == WorkLocation.hybrid;
  String get type => jobTypeDisplayName;

  Job copyWith({
    String? id,
    String? title,
    String? description,
    Company? company,
    String? location,
    JobType? jobType,
    ExperienceLevel? experienceLevel,
    WorkLocation? workLocation,
    double? salaryMin,
    double? salaryMax,
    String? salaryCurrency,
    List<String>? requirements,
    List<String>? benefits,
    List<String>? skills,
    String? applicationUrl,
    String? applicationEmail,
    DateTime? postedDate,
    DateTime? applicationDeadline,
    bool? isActive,
    bool? isFeatured,
  }) => Job(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      company: company ?? this.company,
      location: location ?? this.location,
      jobType: jobType ?? this.jobType,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      workLocation: workLocation ?? this.workLocation,
      salaryMin: salaryMin ?? this.salaryMin,
      salaryMax: salaryMax ?? this.salaryMax,
      salaryCurrency: salaryCurrency ?? this.salaryCurrency,
      requirements: requirements ?? this.requirements,
      benefits: benefits ?? this.benefits,
      skills: skills ?? this.skills,
      applicationUrl: applicationUrl ?? this.applicationUrl,
      applicationEmail: applicationEmail ?? this.applicationEmail,
      postedDate: postedDate ?? this.postedDate,
      applicationDeadline: applicationDeadline ?? this.applicationDeadline,
      isActive: isActive ?? this.isActive,
      isFeatured: isFeatured ?? this.isFeatured,
    );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Job && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Job{id: $id, title: $title, company: ${company.name}, location: $location}';
}
