import 'package:flutter/material.dart';

import '../services/analytics_service.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_widgets.dart';
import '../widgets/premium_components.dart';

class AnalyticsDashboardScreen extends StatefulWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  State<AnalyticsDashboardScreen> createState() => _AnalyticsDashboardScreenState();
}

class _AnalyticsDashboardScreenState extends State<AnalyticsDashboardScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final _analyticsService = AnalyticsService();
  
  UserAnalytics? _userAnalytics;
  JobAnalytics? _jobAnalytics;
  EngagementAnalytics? _engagementAnalytics;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAnalytics();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAnalytics() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userAnalytics = await _analyticsService.getUserAnalytics();
      final jobAnalytics = await _analyticsService.getJobAnalytics();
      final engagementAnalytics = await _analyticsService.getEngagementAnalytics();

      setState(() {
        _userAnalytics = userAnalytics;
        _jobAnalytics = jobAnalytics;
        _engagementAnalytics = engagementAnalytics;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load analytics: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Analytics Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAnalytics,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'User', icon: Icon(Icons.person)),
            Tab(text: 'Jobs', icon: Icon(Icons.work)),
            Tab(text: 'Engagement', icon: Icon(Icons.insights)),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildUserAnalytics(),
                _buildJobAnalytics(),
                _buildEngagementAnalytics(),
              ],
            ),
    );

  Widget _buildUserAnalytics() {
    if (_userAnalytics == null) {
      return const Center(child: Text('No user analytics available'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overview cards
          FadeInSlideUp(
            child: Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    'Job Views',
                    _userAnalytics!.totalJobViews.toString(),
                    Icons.visibility,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMetricCard(
                    'Applications',
                    _userAnalytics!.totalApplications.toString(),
                    Icons.send,
                    Colors.green,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          FadeInSlideUp(
            delay: const Duration(milliseconds: 200),
            child: Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    'Saved Jobs',
                    _userAnalytics!.totalSavedJobs.toString(),
                    Icons.bookmark,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMetricCard(
                    'Searches',
                    _userAnalytics!.totalSearches.toString(),
                    Icons.search,
                    Colors.purple,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Profile completion
          FadeInSlideUp(
            delay: const Duration(milliseconds: 400),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profile Completion',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_userAnalytics!.profileCompletionPercentage}%',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryBlue,
                                ),
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: _userAnalytics!.profileCompletionPercentage / 100,
                                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                                valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.person,
                            color: AppTheme.primaryBlue,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Application success rate
          FadeInSlideUp(
            delay: const Duration(milliseconds: 600),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Application Success Rate',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${_userAnalytics!.applicationSuccessRate}%',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            'Applications per job view',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.trending_up,
                        color: Colors.green,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobAnalytics() {
    if (_jobAnalytics == null) {
      return const Center(child: Text('No job analytics available'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Job metrics
          FadeInSlideUp(
            child: Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    'Total Views',
                    _jobAnalytics!.totalJobViews.toString(),
                    Icons.visibility,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMetricCard(
                    'Applications',
                    _jobAnalytics!.totalApplications.toString(),
                    Icons.send,
                    Colors.green,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          FadeInSlideUp(
            delay: const Duration(milliseconds: 200),
            child: _buildMetricCard(
              'Daily Average',
              _jobAnalytics!.averageApplicationsPerDay.toStringAsFixed(1),
              Icons.calendar_today,
              Colors.orange,
            ),
          ),
          const SizedBox(height: 24),

          // Top companies viewed
          if (_jobAnalytics!.topCompaniesViewed.isNotEmpty) ...[
            FadeInSlideUp(
              delay: const Duration(milliseconds: 400),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Top Companies Viewed',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ..._jobAnalytics!.topCompaniesViewed.map((entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(entry.key),
                              StatusBadge(
                                text: '${entry.value} views',
                                color: Colors.blue,
                                isOutlined: true,
                              ),
                            ],
                          ),
                        )),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Top companies applied
          if (_jobAnalytics!.topCompaniesApplied.isNotEmpty) ...[
            FadeInSlideUp(
              delay: const Duration(milliseconds: 600),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Top Companies Applied',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ..._jobAnalytics!.topCompaniesApplied.map((entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(entry.key),
                              StatusBadge(
                                text: '${entry.value} applications',
                                color: Colors.green,
                                isOutlined: true,
                              ),
                            ],
                          ),
                        )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEngagementAnalytics() {
    if (_engagementAnalytics == null) {
      return const Center(child: Text('No engagement analytics available'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Engagement metrics
          FadeInSlideUp(
            child: Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    'Sessions',
                    _engagementAnalytics!.totalSessions.toString(),
                    Icons.access_time,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMetricCard(
                    'Avg Duration',
                    '${_engagementAnalytics!.averageSessionDuration.inMinutes}m',
                    Icons.timer,
                    Colors.green,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          FadeInSlideUp(
            delay: const Duration(milliseconds: 200),
            child: Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    'Button Clicks',
                    _engagementAnalytics!.totalButtonClicks.toString(),
                    Icons.touch_app,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMetricCard(
                    'Retention',
                    '${_engagementAnalytics!.retentionRate.toStringAsFixed(1)}%',
                    Icons.repeat,
                    Colors.purple,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Engagement insights
          FadeInSlideUp(
            delay: const Duration(milliseconds: 400),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Engagement Insights',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInsightRow(
                      'Daily Active Users',
                      _engagementAnalytics!.dailyActiveUsers.toString(),
                      Icons.people,
                    ),
                    _buildInsightRow(
                      'Average Session Duration',
                      '${_engagementAnalytics!.averageSessionDuration.inMinutes} minutes',
                      Icons.schedule,
                    ),
                    _buildInsightRow(
                      'User Retention Rate',
                      '${_engagementAnalytics!.retentionRate.toStringAsFixed(1)}%',
                      Icons.trending_up,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) => Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );

  Widget _buildInsightRow(String label, String value, IconData icon) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(label)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
}
