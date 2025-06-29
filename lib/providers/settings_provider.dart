import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/settings_service.dart';

class SettingsProvider with ChangeNotifier {
  final SettingsService _settingsService = SettingsService();
  
  AppSettings _settings = const AppSettings();
  bool _isLoading = false;
  String? _error;
  
  // Getters
  AppSettings get settings => _settings;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  /// Loads the current settings
  Future<void> loadSettings() async {
    _setLoading(true);
    _clearError();
    
    try {
      _settings = await _settingsService.getSettings();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load settings: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  /// Updates the theme mode
  Future<bool> updateThemeMode(ThemeMode themeMode) async {
    try {
      final success = await _settingsService.updateSetting('themeMode', themeMode);
      if (success) {
        _settings = _settings.copyWith(themeMode: themeMode);
        notifyListeners();
      }
      return success;
    } catch (e) {
      _setError('Failed to update theme mode: $e');
      return false;
    }
  }
  
  /// Updates notification settings
  Future<bool> updateNotificationSetting(String key, bool value) async {
    try {
      final success = await _settingsService.updateSetting(key, value);
      if (success) {
        switch (key) {
          case 'notificationsEnabled':
            _settings = _settings.copyWith(notificationsEnabled: value);
            break;
          case 'jobAlertsEnabled':
            _settings = _settings.copyWith(jobAlertsEnabled: value);
            break;
          case 'applicationUpdatesEnabled':
            _settings = _settings.copyWith(applicationUpdatesEnabled: value);
            break;
          case 'marketingEmailsEnabled':
            _settings = _settings.copyWith(marketingEmailsEnabled: value);
            break;
        }
        notifyListeners();
      }
      return success;
    } catch (e) {
      _setError('Failed to update notification setting: $e');
      return false;
    }
  }
  
  /// Updates other settings
  Future<bool> updateSetting(String key, value) async {
    try {
      final success = await _settingsService.updateSetting(key, value);
      if (success) {
        switch (key) {
          case 'language':
            _settings = _settings.copyWith(language: value as String);
            break;
          case 'autoApplyFilters':
            _settings = _settings.copyWith(autoApplyFilters: value as bool);
            break;
          case 'maxSalaryAlerts':
            _settings = _settings.copyWith(maxSalaryAlerts: value as int);
            break;
        }
        notifyListeners();
      }
      return success;
    } catch (e) {
      _setError('Failed to update setting: $e');
      return false;
    }
  }
  
  /// Resets all settings to default
  Future<bool> resetSettings() async {
    try {
      final success = await _settingsService.resetSettings();
      if (success) {
        _settings = const AppSettings();
        notifyListeners();
      }
      return success;
    } catch (e) {
      _setError('Failed to reset settings: $e');
      return false;
    }
  }
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }
  
  void _clearError() {
    _error = null;
  }
}
