import 'package:json_annotation/json_annotation.dart';

part 'company.g.dart';

@JsonSerializable()
class Company {

  const Company({
    required this.id,
    required this.name,
    this.logo,
    this.description,
    this.website,
    this.location,
    this.industry,
    this.employeeCount,
    this.foundedYear,
  });

  factory Company.fromJson(Map<String, dynamic> json) => _$CompanyFromJson(json);
  final String id;
  final String name;
  final String? logo;
  final String? description;
  final String? website;
  final String? location;
  final String? industry;
  final int? employeeCount;
  final DateTime? foundedYear;
  Map<String, dynamic> toJson() => _$CompanyToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Company && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Company{id: $id, name: $name, location: $location}';
}
