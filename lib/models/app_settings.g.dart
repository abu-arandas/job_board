// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => AppSettings(
  themeMode:
      $enumDecodeNullable(_$ThemeModeEnumMap, json['themeMode']) ??
      ThemeMode.system,
  notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
  jobAlertsEnabled: json['jobAlertsEnabled'] as bool? ?? true,
  applicationUpdatesEnabled: json['applicationUpdatesEnabled'] as bool? ?? true,
  marketingEmailsEnabled: json['marketingEmailsEnabled'] as bool? ?? false,
  language: json['language'] as String? ?? 'en',
  autoApplyFilters: json['autoApplyFilters'] as bool? ?? false,
  maxSalaryAlerts: (json['maxSalaryAlerts'] as num?)?.toInt() ?? 150,
);

Map<String, dynamic> _$AppSettingsToJson(AppSettings instance) =>
    <String, dynamic>{
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'notificationsEnabled': instance.notificationsEnabled,
      'jobAlertsEnabled': instance.jobAlertsEnabled,
      'applicationUpdatesEnabled': instance.applicationUpdatesEnabled,
      'marketingEmailsEnabled': instance.marketingEmailsEnabled,
      'language': instance.language,
      'autoApplyFilters': instance.autoApplyFilters,
      'maxSalaryAlerts': instance.maxSalaryAlerts,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};
