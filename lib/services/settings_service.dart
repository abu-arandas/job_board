import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class SettingsService {
  static const String _settingsKey = 'app_settings';

  /// Gets the current app settings
  Future<AppSettings> getSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_settingsKey);
      
      if (settingsJson != null) {
        final Map<String, dynamic> data = jsonDecode(settingsJson);
        return AppSettings.fromJson(data);
      }
      
      return const AppSettings(); // Return default settings
    } catch (e) {
      return const AppSettings(); // Return default settings on error
    }
  }

  /// Saves the app settings
  Future<bool> saveSettings(AppSettings settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = jsonEncode(settings.toJson());
      await prefs.setString(_settingsKey, settingsJson);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Updates a specific setting
  Future<bool> updateSetting<T>(String key, T value) async {
    try {
      final currentSettings = await getSettings();
      AppSettings updatedSettings;

      switch (key) {
        case 'themeMode':
          updatedSettings = currentSettings.copyWith(themeMode: value as ThemeMode);
          break;
        case 'notificationsEnabled':
          updatedSettings = currentSettings.copyWith(notificationsEnabled: value as bool);
          break;
        case 'jobAlertsEnabled':
          updatedSettings = currentSettings.copyWith(jobAlertsEnabled: value as bool);
          break;
        case 'applicationUpdatesEnabled':
          updatedSettings = currentSettings.copyWith(applicationUpdatesEnabled: value as bool);
          break;
        case 'marketingEmailsEnabled':
          updatedSettings = currentSettings.copyWith(marketingEmailsEnabled: value as bool);
          break;
        case 'language':
          updatedSettings = currentSettings.copyWith(language: value as String);
          break;
        case 'autoApplyFilters':
          updatedSettings = currentSettings.copyWith(autoApplyFilters: value as bool);
          break;
        case 'maxSalaryAlerts':
          updatedSettings = currentSettings.copyWith(maxSalaryAlerts: value as int);
          break;
        default:
          return false;
      }

      return await saveSettings(updatedSettings);
    } catch (e) {
      return false;
    }
  }

  /// Resets settings to default
  Future<bool> resetSettings() async {
    try {
      const defaultSettings = AppSettings();
      return await saveSettings(defaultSettings);
    } catch (e) {
      return false;
    }
  }

  /// Clears all settings
  Future<bool> clearSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_settingsKey);
      return true;
    } catch (e) {
      return false;
    }
  }
}
