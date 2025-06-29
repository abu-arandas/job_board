import 'package:json_annotation/json_annotation.dart';

part 'app_settings.g.dart';

enum ThemeMode {
  @JsonValue('system')
  system,
  @JsonValue('light')
  light,
  @JsonValue('dark')
  dark,
}

@JsonSerializable()
class AppSettings {

  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.notificationsEnabled = true,
    this.jobAlertsEnabled = true,
    this.applicationUpdatesEnabled = true,
    this.marketingEmailsEnabled = false,
    this.language = 'en',
    this.autoApplyFilters = false,
    this.maxSalaryAlerts = 150,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) => _$AppSettingsFromJson(json);
  final ThemeMode themeMode;
  final bool notificationsEnabled;
  final bool jobAlertsEnabled;
  final bool applicationUpdatesEnabled;
  final bool marketingEmailsEnabled;
  final String language;
  final bool autoApplyFilters;
  final int maxSalaryAlerts;
  Map<String, dynamic> toJson() => _$AppSettingsToJson(this);

  AppSettings copyWith({
    ThemeMode? themeMode,
    bool? notificationsEnabled,
    bool? jobAlertsEnabled,
    bool? applicationUpdatesEnabled,
    bool? marketingEmailsEnabled,
    String? language,
    bool? autoApplyFilters,
    int? maxSalaryAlerts,
  }) => AppSettings(
      themeMode: themeMode ?? this.themeMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      jobAlertsEnabled: jobAlertsEnabled ?? this.jobAlertsEnabled,
      applicationUpdatesEnabled: applicationUpdatesEnabled ?? this.applicationUpdatesEnabled,
      marketingEmailsEnabled: marketingEmailsEnabled ?? this.marketingEmailsEnabled,
      language: language ?? this.language,
      autoApplyFilters: autoApplyFilters ?? this.autoApplyFilters,
      maxSalaryAlerts: maxSalaryAlerts ?? this.maxSalaryAlerts,
    );

  String get themeModeDisplayName {
    switch (themeMode) {
      case ThemeMode.system:
        return 'System';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettings &&
          runtimeType == other.runtimeType &&
          themeMode == other.themeMode &&
          notificationsEnabled == other.notificationsEnabled &&
          jobAlertsEnabled == other.jobAlertsEnabled &&
          applicationUpdatesEnabled == other.applicationUpdatesEnabled &&
          marketingEmailsEnabled == other.marketingEmailsEnabled &&
          language == other.language &&
          autoApplyFilters == other.autoApplyFilters &&
          maxSalaryAlerts == other.maxSalaryAlerts;

  @override
  int get hashCode => Object.hash(
        themeMode,
        notificationsEnabled,
        jobAlertsEnabled,
        applicationUpdatesEnabled,
        marketingEmailsEnabled,
        language,
        autoApplyFilters,
        maxSalaryAlerts,
      );

  @override
  String toString() => 'AppSettings{themeMode: $themeMode, notificationsEnabled: $notificationsEnabled}';
}
