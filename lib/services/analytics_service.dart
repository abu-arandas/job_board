import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AnalyticsService {
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();
  static final AnalyticsService _instance = AnalyticsService._internal();

  late SharedPreferences _prefs;
  final List<AnalyticsEvent> _eventQueue = [];
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    _prefs = await SharedPreferences.getInstance();
    await _loadQueuedEvents();
    _isInitialized = true;
  }

  // User behavior tracking
  Future<void> trackScreenView(String screenName, {Map<String, dynamic>? parameters}) async {
    await _trackEvent(
      AnalyticsEvent(
        name: 'screen_view',
        parameters: {'screen_name': screenName, 'timestamp': DateTime.now().toIso8601String(), ...?parameters},
      ),
    );
  }

  Future<void> trackJobView(String jobId, String jobTitle, String company) async {
    await _trackEvent(
      AnalyticsEvent(
        name: 'job_view',
        parameters: {
          'job_id': jobId,
          'job_title': jobTitle,
          'company': company,
          'timestamp': DateTime.now().toIso8601String(),
        },
      ),
    );
  }

  Future<void> trackJobApplication(String jobId, String jobTitle, String company) async {
    await _trackEvent(
      AnalyticsEvent(
        name: 'job_application',
        parameters: {
          'job_id': jobId,
          'job_title': jobTitle,
          'company': company,
          'timestamp': DateTime.now().toIso8601String(),
        },
      ),
    );
  }

  Future<void> trackJobSave(String jobId, String jobTitle, String company) async {
    await _trackEvent(
      AnalyticsEvent(
        name: 'job_save',
        parameters: {
          'job_id': jobId,
          'job_title': jobTitle,
          'company': company,
          'timestamp': DateTime.now().toIso8601String(),
        },
      ),
    );
  }

  Future<void> trackSearch(String query, String? location, int resultCount) async {
    await _trackEvent(
      AnalyticsEvent(
        name: 'job_search',
        parameters: {
          'query': query,
          'location': location,
          'result_count': resultCount,
          'timestamp': DateTime.now().toIso8601String(),
        },
      ),
    );
  }

  Future<void> trackFilter(Map<String, dynamic> filters, int resultCount) async {
    await _trackEvent(
      AnalyticsEvent(
        name: 'job_filter',
        parameters: {'filters': filters, 'result_count': resultCount, 'timestamp': DateTime.now().toIso8601String()},
      ),
    );
  }

  Future<void> trackProfileCompletion(int percentage, String level) async {
    await _trackEvent(
      AnalyticsEvent(
        name: 'profile_completion',
        parameters: {
          'completion_percentage': percentage,
          'completion_level': level,
          'timestamp': DateTime.now().toIso8601String(),
        },
      ),
    );
  }

  Future<void> trackSkillAssessment(String skill, int score, String level) async {
    await _trackEvent(
      AnalyticsEvent(
        name: 'skill_assessment',
        parameters: {'skill': skill, 'score': score, 'level': level, 'timestamp': DateTime.now().toIso8601String()},
      ),
    );
  }

  Future<void> trackPremiumUpgrade(String planName, double price, String billingCycle) async {
    await _trackEvent(
      AnalyticsEvent(
        name: 'premium_upgrade',
        parameters: {
          'plan_name': planName,
          'price': price,
          'billing_cycle': billingCycle,
          'timestamp': DateTime.now().toIso8601String(),
        },
      ),
    );
  }

  Future<void> trackJobPromotion(String jobId, String promotionType, double price, int duration) async {
    await _trackEvent(
      AnalyticsEvent(
        name: 'job_promotion',
        parameters: {
          'job_id': jobId,
          'promotion_type': promotionType,
          'price': price,
          'duration_days': duration,
          'timestamp': DateTime.now().toIso8601String(),
        },
      ),
    );
  }

  // User engagement metrics
  Future<void> trackSessionStart() async {
    await _trackEvent(
      AnalyticsEvent(name: 'session_start', parameters: {'timestamp': DateTime.now().toIso8601String()}),
    );
  }

  Future<void> trackSessionEnd(Duration sessionDuration) async {
    await _trackEvent(
      AnalyticsEvent(
        name: 'session_end',
        parameters: {
          'session_duration_seconds': sessionDuration.inSeconds,
          'timestamp': DateTime.now().toIso8601String(),
        },
      ),
    );
  }

  Future<void> trackButtonClick(String buttonName, String screenName) async {
    await _trackEvent(
      AnalyticsEvent(
        name: 'button_click',
        parameters: {
          'button_name': buttonName,
          'screen_name': screenName,
          'timestamp': DateTime.now().toIso8601String(),
        },
      ),
    );
  }

  Future<void> trackError(String errorType, String errorMessage, String? stackTrace) async {
    await _trackEvent(
      AnalyticsEvent(
        name: 'error',
        parameters: {
          'error_type': errorType,
          'error_message': errorMessage,
          'stack_trace': stackTrace,
          'timestamp': DateTime.now().toIso8601String(),
        },
      ),
    );
  }

  // Analytics data retrieval
  Future<UserAnalytics> getUserAnalytics() async {
    final events = await _getAllEvents();
    return _calculateUserAnalytics(events);
  }

  Future<JobAnalytics> getJobAnalytics() async {
    final events = await _getAllEvents();
    return _calculateJobAnalytics(events);
  }

  Future<EngagementAnalytics> getEngagementAnalytics() async {
    final events = await _getAllEvents();
    return _calculateEngagementAnalytics(events);
  }

  // Private methods
  Future<void> _trackEvent(AnalyticsEvent event) async {
    if (!_isInitialized) await initialize();

    _eventQueue.add(event);
    await _saveEventToStorage(event);

    // In a real app, you would send events to your analytics service
    // For now, we'll just store them locally
    print('Analytics Event: ${event.name} - ${event.parameters}');
  }

  Future<void> _saveEventToStorage(AnalyticsEvent event) async {
    final events = _prefs.getStringList('analytics_events') ?? [];
    events.add(json.encode(event.toJson()));

    // Keep only last 1000 events to prevent storage bloat
    if (events.length > 1000) {
      events.removeRange(0, events.length - 1000);
    }

    await _prefs.setStringList('analytics_events', events);
  }

  Future<void> _loadQueuedEvents() async {
    final eventStrings = _prefs.getStringList('analytics_events') ?? [];
    _eventQueue.clear();

    for (final eventString in eventStrings) {
      try {
        final eventJson = json.decode(eventString);
        _eventQueue.add(AnalyticsEvent.fromJson(eventJson));
      } catch (e) {
        // Skip invalid events
      }
    }
  }

  Future<List<AnalyticsEvent>> _getAllEvents() async => List.from(_eventQueue);

  UserAnalytics _calculateUserAnalytics(List<AnalyticsEvent> events) {
    final jobViews = events.where((e) => e.name == 'job_view').length;
    final jobApplications = events.where((e) => e.name == 'job_application').length;
    final jobSaves = events.where((e) => e.name == 'job_save').length;
    final searches = events.where((e) => e.name == 'job_search').length;

    final profileCompletionEvents = events.where((e) => e.name == 'profile_completion').toList();
    final currentProfileCompletion = profileCompletionEvents.isNotEmpty
        ? profileCompletionEvents.last.parameters['completion_percentage'] as int? ?? 0
        : 0;

    final skillAssessments = events.where((e) => e.name == 'skill_assessment').length;

    return UserAnalytics(
      totalJobViews: jobViews,
      totalApplications: jobApplications,
      totalSavedJobs: jobSaves,
      totalSearches: searches,
      profileCompletionPercentage: currentProfileCompletion,
      skillAssessmentsCompleted: skillAssessments,
      applicationSuccessRate: jobViews > 0 ? (jobApplications / jobViews * 100).round() : 0,
    );
  }

  JobAnalytics _calculateJobAnalytics(List<AnalyticsEvent> events) {
    final jobViewEvents = events.where((e) => e.name == 'job_view').toList();
    final jobApplicationEvents = events.where((e) => e.name == 'job_application').toList();

    final jobViewsByCompany = <String, int>{};
    final jobApplicationsByCompany = <String, int>{};

    for (final event in jobViewEvents) {
      final company = event.parameters['company'] as String? ?? 'Unknown';
      jobViewsByCompany[company] = (jobViewsByCompany[company] ?? 0) + 1;
    }

    for (final event in jobApplicationEvents) {
      final company = event.parameters['company'] as String? ?? 'Unknown';
      jobApplicationsByCompany[company] = (jobApplicationsByCompany[company] ?? 0) + 1;
    }

    return JobAnalytics(
      totalJobViews: jobViewEvents.length,
      totalApplications: jobApplicationEvents.length,
      topCompaniesViewed: _getTopEntries(jobViewsByCompany, 5),
      topCompaniesApplied: _getTopEntries(jobApplicationsByCompany, 5),
      averageApplicationsPerDay: _calculateDailyAverage(jobApplicationEvents),
    );
  }

  EngagementAnalytics _calculateEngagementAnalytics(List<AnalyticsEvent> events) {
    final sessionStartEvents = events.where((e) => e.name == 'session_start').toList();
    final sessionEndEvents = events.where((e) => e.name == 'session_end').toList();
    final buttonClickEvents = events.where((e) => e.name == 'button_click').toList();

    final totalSessions = sessionStartEvents.length;
    final totalSessionDuration = sessionEndEvents.fold<int>(
      0,
      (sum, event) => sum + (event.parameters['session_duration_seconds'] as int? ?? 0),
    );

    final averageSessionDuration = totalSessions > 0 ? totalSessionDuration / totalSessions : 0;

    return EngagementAnalytics(
      totalSessions: totalSessions,
      averageSessionDuration: Duration(seconds: averageSessionDuration.round()),
      totalButtonClicks: buttonClickEvents.length,
      dailyActiveUsers: _calculateDailyActiveUsers(events),
      retentionRate: _calculateRetentionRate(events),
    );
  }

  List<MapEntry<String, int>> _getTopEntries(Map<String, int> map, int limit) {
    final entries = map.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries.take(limit).toList();
  }

  double _calculateDailyAverage(List<AnalyticsEvent> events) {
    if (events.isEmpty) return 0;

    final dates = events.map((e) {
      final timestamp = DateTime.parse(e.parameters['timestamp'] as String);
      return DateTime(timestamp.year, timestamp.month, timestamp.day);
    }).toSet();

    return dates.isNotEmpty ? events.length / dates.length : 0;
  }

  int _calculateDailyActiveUsers(List<AnalyticsEvent> events) {
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);

    final todayEvents = events.where((e) {
      final timestamp = DateTime.parse(e.parameters['timestamp'] as String);
      return timestamp.isAfter(todayStart);
    });

    return todayEvents.isNotEmpty ? 1 : 0; // Simplified for single user
  }

  double _calculateRetentionRate(List<AnalyticsEvent> events) {
    // Simplified retention calculation
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));

    final recentEvents = events.where((e) {
      final timestamp = DateTime.parse(e.parameters['timestamp'] as String);
      return timestamp.isAfter(weekAgo);
    });

    return recentEvents.isNotEmpty ? 100.0 : 0.0; // Simplified for demo
  }

  Future<void> clearAnalytics() async {
    await _prefs.remove('analytics_events');
    _eventQueue.clear();
  }
}

class AnalyticsEvent {
  AnalyticsEvent({required this.name, required this.parameters});

  factory AnalyticsEvent.fromJson(Map<String, dynamic> json) =>
      AnalyticsEvent(name: json['name'], parameters: Map<String, dynamic>.from(json['parameters']));
  final String name;
  final Map<String, dynamic> parameters;

  Map<String, dynamic> toJson() => {'name': name, 'parameters': parameters};
}

class UserAnalytics {
  UserAnalytics({
    required this.totalJobViews,
    required this.totalApplications,
    required this.totalSavedJobs,
    required this.totalSearches,
    required this.profileCompletionPercentage,
    required this.skillAssessmentsCompleted,
    required this.applicationSuccessRate,
  });
  final int totalJobViews;
  final int totalApplications;
  final int totalSavedJobs;
  final int totalSearches;
  final int profileCompletionPercentage;
  final int skillAssessmentsCompleted;
  final int applicationSuccessRate;
}

class JobAnalytics {
  JobAnalytics({
    required this.totalJobViews,
    required this.totalApplications,
    required this.topCompaniesViewed,
    required this.topCompaniesApplied,
    required this.averageApplicationsPerDay,
  });
  final int totalJobViews;
  final int totalApplications;
  final List<MapEntry<String, int>> topCompaniesViewed;
  final List<MapEntry<String, int>> topCompaniesApplied;
  final double averageApplicationsPerDay;
}

class EngagementAnalytics {
  EngagementAnalytics({
    required this.totalSessions,
    required this.averageSessionDuration,
    required this.totalButtonClicks,
    required this.dailyActiveUsers,
    required this.retentionRate,
  });
  final int totalSessions;
  final Duration averageSessionDuration;
  final int totalButtonClicks;
  final int dailyActiveUsers;
  final double retentionRate;
}
