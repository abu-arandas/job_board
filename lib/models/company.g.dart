// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Company _$CompanyFromJson(Map<String, dynamic> json) => Company(
  id: json['id'] as String,
  name: json['name'] as String,
  logo: json['logo'] as String?,
  description: json['description'] as String?,
  website: json['website'] as String?,
  location: json['location'] as String?,
  industry: json['industry'] as String?,
  employeeCount: (json['employeeCount'] as num?)?.toInt(),
  foundedYear: json['foundedYear'] == null
      ? null
      : DateTime.parse(json['foundedYear'] as String),
);

Map<String, dynamic> _$CompanyToJson(Company instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'logo': instance.logo,
  'description': instance.description,
  'website': instance.website,
  'location': instance.location,
  'industry': instance.industry,
  'employeeCount': instance.employeeCount,
  'foundedYear': instance.foundedYear?.toIso8601String(),
};
