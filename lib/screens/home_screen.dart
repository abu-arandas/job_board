import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/favorites_provider.dart';
import '../providers/job_provider.dart';
import '../providers/notification_provider.dart';
import '../widgets/animated_widgets.dart';
import '../widgets/featured_job_card.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/job_card.dart';
import '../widgets/premium_components.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JobProvider>().loadFeaturedJobs();
      context.read<JobProvider>().loadJobs();
      context.read<FavoritesProvider>().loadFavorites();
      context.read<NotificationProvider>().loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
    appBar: AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.work, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Job Board', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              Text(
                'Find your dream job',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Consumer<NotificationProvider>(
          builder: (context, notificationProvider, child) => Container(
            margin: const EdgeInsets.only(right: 8),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {
                      context.go('/notifications');
                    },
                  ),
                ),
                if (notificationProvider.unreadCount > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Theme.of(context).colorScheme.surface, width: 2),
                      ),
                      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                      child: Text(
                        '${notificationProvider.unreadCount}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onError,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    ),
    body: RefreshIndicator(
      onRefresh: () async {
        await context.read<JobProvider>().refresh();
        await context.read<FavoritesProvider>().loadFavorites();
      },
      child: Consumer<JobProvider>(
        builder: (context, jobProvider, child) {
          if (jobProvider.isLoading && jobProvider.jobs.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (jobProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
                  const SizedBox(height: 16),
                  Text('Something went wrong', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(jobProvider.error!, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      jobProvider.refresh();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Enhanced Welcome section with search
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary.withOpacity(0.05),
                        Theme.of(context).colorScheme.secondary.withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome back!',
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Find your dream job today',
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF2563EB).withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.work_outline, color: Colors.white, size: 32),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Search jobs, companies, skills...',
                                    hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                                    prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                  ),
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      jobProvider.searchJobs(query: value);
                                    } else {
                                      jobProvider.clearSearchResults();
                                    }
                                  },
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.tune, color: Colors.white),
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) => FilterBottomSheet(
                                        onApplyFilters: (jobType, experienceLevel, workLocation, minSalary, maxSalary) {
                                          jobProvider.searchJobs(
                                            jobType: jobType,
                                            experienceLevel: experienceLevel,
                                            workLocation: workLocation,
                                            minSalary: minSalary,
                                            maxSalary: maxSalary,
                                          );
                                          Navigator.pop(context);
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Enhanced Featured jobs section
                if (jobProvider.featuredJobs.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Featured Jobs',
                              style: Theme.of(
                                context,
                              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, letterSpacing: -0.5),
                            ),
                            Text(
                              'Hand-picked opportunities for you',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                        TextButton.icon(
                          onPressed: () => context.go('/jobs'),
                          icon: const Icon(Icons.arrow_forward, size: 16),
                          label: const Text('View All'),
                          style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.primary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: jobProvider.featuredJobs.length,
                      itemBuilder: (context, index) {
                        final job = jobProvider.featuredJobs[index];
                        return Padding(
                          padding: EdgeInsets.only(right: index == jobProvider.featuredJobs.length - 1 ? 0 : 16),
                          child: SizedBox(
                            width: 300,
                            child: FadeInSlideUp(
                              delay: Duration(milliseconds: index * 100),
                              child: FeaturedJobCard(job: job),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                ],

                // Premium Insights section
                FadeInSlideUp(delay: const Duration(milliseconds: 400), child: _buildPremiumInsights(context)),

                const SizedBox(height: 24),

                // Recent jobs section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Recent Jobs', style: Theme.of(context).textTheme.headlineSmall),
                    TextButton(
                      onPressed: () {
                        context.go('/all-jobs');
                      },
                      child: const Text('See All'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Recent jobs list
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: jobProvider.jobs.take(5).length,
                  itemBuilder: (context, index) {
                    final job = jobProvider.jobs[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: JobCard(job: job),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    ),
  );

  Widget _buildPremiumInsights(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Career Insights', style: Theme.of(context).textTheme.headlineSmall),
      const SizedBox(height: 16),
      const Row(
        children: [
          Expanded(
            child: StatCard(
              title: 'Market Demand',
              value: 'High',
              icon: Icons.trending_up,
              color: Colors.green,
              subtitle: '+15% this month',
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: StatCard(
              title: 'Avg Salary',
              value: r'$95k',
              icon: Icons.attach_money,
              color: Colors.blue,
              subtitle: 'Software Engineer',
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Row(
        children: [
          Expanded(
            child: PremiumButton(
              text: 'Salary Insights',
              icon: Icons.analytics,
              onPressed: () => context.go('/salary-insights'),
              isOutlined: true,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: PremiumButton(
              text: 'Career Tips',
              icon: Icons.lightbulb_outline,
              onPressed: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Career tips feature coming soon')));
              },
              isOutlined: true,
            ),
          ),
        ],
      ),
    ],
  );
}
