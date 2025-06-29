import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/animated_widgets.dart';
import '../../widgets/premium_components.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final List<DashboardMetric> _metrics = [
    DashboardMetric(
      title: 'Total Jobs',
      value: '1,247',
      change: '+12%',
      isPositive: true,
      icon: Icons.work,
      color: Colors.blue,
    ),
    DashboardMetric(
      title: 'Active Applications',
      value: '3,891',
      change: '+8%',
      isPositive: true,
      icon: Icons.assignment,
      color: Colors.green,
    ),
    DashboardMetric(
      title: 'Companies',
      value: '156',
      change: '+5%',
      isPositive: true,
      icon: Icons.business,
      color: Colors.orange,
    ),
    DashboardMetric(
      title: 'Job Seekers',
      value: '12,543',
      change: '+15%',
      isPositive: true,
      icon: Icons.people,
      color: Colors.purple,
    ),
  ];

  final List<RecentActivity> _recentActivities = [
    RecentActivity(
      title: 'New job posted',
      description: 'Senior Flutter Developer at TechCorp',
      time: '2 minutes ago',
      icon: Icons.add_circle,
      color: Colors.green,
    ),
    RecentActivity(
      title: 'Application received',
      description: 'John Doe applied for Product Manager role',
      time: '5 minutes ago',
      icon: Icons.assignment_turned_in,
      color: Colors.blue,
    ),
    RecentActivity(
      title: 'Company registered',
      description: 'StartupXYZ joined the platform',
      time: '1 hour ago',
      icon: Icons.business_center,
      color: Colors.orange,
    ),
    RecentActivity(
      title: 'Job expired',
      description: 'Marketing Specialist position expired',
      time: '2 hours ago',
      icon: Icons.schedule,
      color: Colors.red,
    ),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Admin notifications coming soon')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.go('/admin/settings');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome section
            FadeInSlideUp(
              child: GradientCard(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back, Admin!',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Here\'s what\'s happening on your platform today',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.admin_panel_settings,
                      size: 48,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Metrics grid
            FadeInSlideUp(
              delay: const Duration(milliseconds: 200),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemCount: _metrics.length,
                itemBuilder: (context, index) => _buildMetricCard(_metrics[index]),
              ),
            ),
            const SizedBox(height: 24),

            // Quick actions
            FadeInSlideUp(
              delay: const Duration(milliseconds: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: PremiumButton(
                          text: 'Post Job',
                          icon: Icons.add_business,
                          onPressed: () => context.go('/admin/post-job'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: PremiumButton(
                          text: 'Manage Jobs',
                          icon: Icons.work_outline,
                          onPressed: () => context.go('/admin/manage-jobs'),
                          isOutlined: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: PremiumButton(
                          text: 'View Applications',
                          icon: Icons.assignment,
                          onPressed: () => context.go('/admin/applications'),
                          isOutlined: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: PremiumButton(
                          text: 'Analytics',
                          icon: Icons.analytics,
                          onPressed: () => context.go('/admin/analytics'),
                          isOutlined: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Recent activity
            FadeInSlideUp(
              delay: const Duration(milliseconds: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Activity',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _recentActivities.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) => _buildActivityItem(_recentActivities[index]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  Widget _buildMetricCard(DashboardMetric metric) => Card(
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
                    color: metric.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    metric.icon,
                    color: metric.color,
                    size: 24,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: metric.isPositive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        metric.isPositive ? Icons.trending_up : Icons.trending_down,
                        size: 12,
                        color: metric.isPositive ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        metric.change,
                        style: TextStyle(
                          color: metric.isPositive ? Colors.green : Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              metric.value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: metric.color,
              ),
            ),
            Text(
              metric.title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );

  Widget _buildActivityItem(RecentActivity activity) => ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: activity.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          activity.icon,
          color: activity.color,
          size: 20,
        ),
      ),
      title: Text(
        activity.title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(activity.description),
      trailing: Text(
        activity.time,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
}

class DashboardMetric {

  DashboardMetric({
    required this.title,
    required this.value,
    required this.change,
    required this.isPositive,
    required this.icon,
    required this.color,
  });
  final String title;
  final String value;
  final String change;
  final bool isPositive;
  final IconData icon;
  final Color color;
}

class RecentActivity {

  RecentActivity({
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.color,
  });
  final String title;
  final String description;
  final String time;
  final IconData icon;
  final Color color;
}
