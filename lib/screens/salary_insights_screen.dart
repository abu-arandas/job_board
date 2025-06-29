import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/job_provider.dart';
import '../services/recommendation_service.dart';
import '../widgets/animated_widgets.dart';
import '../widgets/premium_components.dart';

class SalaryInsightsScreen extends StatefulWidget {
  const SalaryInsightsScreen({super.key});

  @override
  State<SalaryInsightsScreen> createState() => _SalaryInsightsScreenState();
}

class _SalaryInsightsScreenState extends State<SalaryInsightsScreen> {
  final _jobTitleController = TextEditingController();
  final _locationController = TextEditingController();
  final _recommendationService = RecommendationService();

  SalaryInsight? _currentInsight;
  bool _isLoading = false;

  final List<String> _popularJobTitles = [
    'Software Engineer',
    'Product Manager',
    'Data Scientist',
    'UX Designer',
    'DevOps Engineer',
    'Frontend Developer',
    'Backend Developer',
    'Full Stack Developer',
    'Mobile Developer',
    'QA Engineer',
  ];

  final List<String> _popularLocations = [
    'San Francisco, CA',
    'New York, NY',
    'Seattle, WA',
    'Austin, TX',
    'Boston, MA',
    'Los Angeles, CA',
    'Chicago, IL',
    'Denver, CO',
    'Remote',
  ];

  @override
  void initState() {
    super.initState();
    // Load default insight
    _jobTitleController.text = 'Software Engineer';
    _locationController.text = 'San Francisco, CA';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchSalaryInsights();
    });
  }

  @override
  void dispose() {
    _jobTitleController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Salary Insights'),
      actions: [IconButton(icon: const Icon(Icons.info_outline), onPressed: _showInfoDialog)],
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search form
          FadeInSlideUp(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Search Salary Data',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    // Job title field
                    TextFormField(
                      controller: _jobTitleController,
                      decoration: const InputDecoration(
                        labelText: 'Job Title',
                        prefixIcon: Icon(Icons.work_outline),
                        hintText: 'e.g., Software Engineer',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Popular job titles
                    Text(
                      'Popular Titles:',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _popularJobTitles
                          .map(
                            (title) => GestureDetector(
                              onTap: () {
                                _jobTitleController.text = title;
                                _searchSalaryInsights();
                              },
                              child: StatusBadge(
                                text: title,
                                color: Theme.of(context).colorScheme.primary,
                                isOutlined: true,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 16),

                    // Location field
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        labelText: 'Location',
                        prefixIcon: Icon(Icons.location_on_outlined),
                        hintText: 'e.g., San Francisco, CA',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Popular locations
                    Text(
                      'Popular Locations:',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _popularLocations
                          .map(
                            (location) => GestureDetector(
                              onTap: () {
                                _locationController.text = location;
                                _searchSalaryInsights();
                              },
                              child: StatusBadge(
                                text: location,
                                color: Theme.of(context).colorScheme.secondary,
                                isOutlined: true,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 24),

                    // Search button
                    SizedBox(
                      width: double.infinity,
                      child: PremiumButton(
                        text: 'Get Salary Insights',
                        icon: Icons.search,
                        onPressed: _searchSalaryInsights,
                        isLoading: _isLoading,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Results
          if (_currentInsight != null) ...[
            FadeInSlideUp(delay: const Duration(milliseconds: 200), child: _buildSalaryInsightCard(_currentInsight!)),
            const SizedBox(height: 16),
            FadeInSlideUp(delay: const Duration(milliseconds: 400), child: _buildSalaryBreakdown(_currentInsight!)),
            const SizedBox(height: 16),
            FadeInSlideUp(delay: const Duration(milliseconds: 600), child: _buildMarketTrends()),
          ],
        ],
      ),
    ),
  );

  Widget _buildSalaryInsightCard(SalaryInsight insight) {
    final formatter = NumberFormat.currency(symbol: r'$', decimalDigits: 0);

    return GradientCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.trending_up, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Salary Insights',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Text(
            insight.jobTitle,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            insight.location,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white.withOpacity(0.9)),
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _buildSalaryStatCard('Average', formatter.format(insight.averageSalary), Icons.analytics),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSalaryStatCard(
                  'Range',
                  '${formatter.format(insight.minSalary)} - ${formatter.format(insight.maxSalary)}',
                  Icons.compare_arrows,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                const Icon(Icons.dataset, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Based on ${insight.sampleSize} job postings',
                  style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalaryStatCard(String label, String value, IconData icon) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
      ],
    ),
  );

  Widget _buildSalaryBreakdown(SalaryInsight insight) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Salary Breakdown',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          _buildPercentileBar('25th Percentile', insight.minSalary, insight.maxSalary, 0.25),
          const SizedBox(height: 12),
          _buildPercentileBar('50th Percentile (Median)', insight.minSalary, insight.maxSalary, 0.5),
          const SizedBox(height: 12),
          _buildPercentileBar('75th Percentile', insight.minSalary, insight.maxSalary, 0.75),
          const SizedBox(height: 12),
          _buildPercentileBar('90th Percentile', insight.minSalary, insight.maxSalary, 0.9),
        ],
      ),
    ),
  );

  Widget _buildPercentileBar(String label, double minSalary, double maxSalary, double percentile) {
    final value = minSalary + ((maxSalary - minSalary) * percentile);
    final formatter = NumberFormat.currency(symbol: r'$', decimalDigits: 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            Text(
              formatter.format(value),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ProgressIndicator(progress: percentile, height: 6),
      ],
    );
  }

  Widget _buildMarketTrends() => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Market Trends', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          const InfoCard(
            title: 'Demand Level',
            subtitle: 'High - Growing 15% year over year',
            icon: Icons.trending_up,
            iconColor: Colors.green,
          ),
          const SizedBox(height: 12),
          const InfoCard(
            title: 'Competition',
            subtitle: 'Moderate - 3.2 applicants per position',
            icon: Icons.people,
            iconColor: Colors.orange,
          ),
          const SizedBox(height: 12),
          const InfoCard(
            title: 'Remote Opportunities',
            subtitle: '68% of positions offer remote work',
            icon: Icons.home_work,
            iconColor: Colors.blue,
          ),
        ],
      ),
    ),
  );

  Future<void> _searchSalaryInsights() async {
    if (_jobTitleController.text.isEmpty || _locationController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter both job title and location')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final jobProvider = context.read<JobProvider>();
      final insight = await _recommendationService.getSalaryInsights(
        jobTitle: _jobTitleController.text,
        location: _locationController.text,
        allJobs: jobProvider.jobs,
      );

      setState(() {
        _currentInsight = insight;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading salary insights: $e')));
      }
    }
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Salary Insights'),
        content: const Text(
          'Salary insights are calculated based on current job postings in our database. '
          'Data includes base salary ranges and may not reflect total compensation including '
          'bonuses, equity, or benefits. Results are estimates and actual salaries may vary.',
        ),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Got it'))],
      ),
    );
  }
}
