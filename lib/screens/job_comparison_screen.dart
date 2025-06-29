import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../widgets/animated_widgets.dart';
import '../widgets/premium_components.dart';

class JobComparisonScreen extends StatefulWidget {
  const JobComparisonScreen({required this.jobs, super.key});
  final List<Job> jobs;

  @override
  State<JobComparisonScreen> createState() => _JobComparisonScreenState();
}

class _JobComparisonScreenState extends State<JobComparisonScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.jobs.length < 2) {
      return Scaffold(
        appBar: AppBar(title: const Text('Job Comparison')),
        body: const Center(child: Text('At least 2 jobs are required for comparison')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Compare Jobs'),
        actions: [IconButton(icon: const Icon(Icons.share), onPressed: _shareComparison)],
      ),
      body: Column(
        children: [
          // Job selector tabs
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.jobs.length,
              itemBuilder: (context, index) {
                final job = widget.jobs[index];
                final isSelected = index == _currentPage;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          job.title,
                          style: TextStyle(
                            color: isSelected
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Comparison content
          Expanded(child: widget.jobs.length == 2 ? _buildSideBySideComparison() : _buildPageViewComparison()),
        ],
      ),
    );
  }

  Widget _buildSideBySideComparison() => FadeInSlideUp(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header comparison
          Row(
            children: widget.jobs
                .map(
                  (job) => Expanded(
                    child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: _buildJobHeader(job)),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),

          // Comparison categories
          ..._buildComparisonCategories(),
        ],
      ),
    ),
  );

  Widget _buildPageViewComparison() => PageView.builder(
    controller: _pageController,
    onPageChanged: (index) {
      setState(() {
        _currentPage = index;
      });
    },
    itemCount: widget.jobs.length,
    itemBuilder: (context, index) => FadeInSlideUp(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildJobHeader(widget.jobs[index]),
            const SizedBox(height: 24),
            _buildJobDetails(widget.jobs[index]),
          ],
        ),
      ),
    ),
  );

  Widget _buildJobHeader(Job job) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            job.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            job.company.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  job.location,
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  List<Widget> _buildComparisonCategories() => [
    _buildComparisonRow('Salary Range', widget.jobs.map(_formatSalary).toList(), Icons.attach_money),
    _buildComparisonRow('Job Type', widget.jobs.map((job) => job.type).toList(), Icons.work_outline),
    _buildComparisonRow(
      'Experience Level',
      widget.jobs.map((job) => job.experienceLevel.name).toList(),
      Icons.trending_up,
    ),
    _buildComparisonRow('Remote Work', widget.jobs.map((job) => job.isRemote ? 'Yes' : 'No').toList(), Icons.home_work),
    _buildComparisonRow(
      'Posted Date',
      widget.jobs.map((job) => DateFormat('MMM d, y').format(job.postedDate)).toList(),
      Icons.calendar_today,
    ),
    _buildSkillsComparison(),
    _buildBenefitsComparison(),
  ];

  Widget _buildComparisonRow(String title, List<String> values, IconData icon) => Card(
    margin: const EdgeInsets.only(bottom: 16),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: values
                .asMap()
                .entries
                .map(
                  (entry) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          entry.value,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    ),
  );

  Widget _buildSkillsComparison() => Card(
    margin: const EdgeInsets.only(bottom: 16),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.psychology, size: 20, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Required Skills',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.jobs
                .map(
                  (job) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: job.requirements
                            .take(5)
                            .map(
                              (skill) => StatusBadge(
                                text: skill,
                                color: Theme.of(context).colorScheme.primary,
                                isOutlined: true,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    ),
  );

  Widget _buildBenefitsComparison() => Card(
    margin: const EdgeInsets.only(bottom: 16),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.card_giftcard, size: 20, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text('Benefits', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.jobs
                .map(
                  (job) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: job.benefits
                            .take(5)
                            .map(
                              (benefit) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  children: [
                                    Icon(Icons.check_circle, size: 16, color: Theme.of(context).colorScheme.primary),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(benefit, style: Theme.of(context).textTheme.bodySmall)),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    ),
  );

  Widget _buildJobDetails(Job job) => Column(
    children: [
      InfoCard(title: 'Salary Range', subtitle: _formatSalary(job), icon: Icons.attach_money),
      const SizedBox(height: 12),
      InfoCard(title: 'Job Type', subtitle: job.type, icon: Icons.work_outline),
      const SizedBox(height: 12),
      InfoCard(title: 'Experience Level', subtitle: job.experienceLevel.name, icon: Icons.trending_up),
      const SizedBox(height: 12),
      InfoCard(title: 'Remote Work', subtitle: job.isRemote ? 'Yes' : 'No', icon: Icons.home_work),
    ],
  );

  String _formatSalary(Job job) {
    if (job.salaryMin == null && job.salaryMax == null) {
      return 'Not specified';
    }

    final formatter = NumberFormat.currency(symbol: r'$', decimalDigits: 0);

    if (job.salaryMin != null && job.salaryMax != null) {
      return '${formatter.format(job.salaryMin)} - ${formatter.format(job.salaryMax)}';
    } else if (job.salaryMin != null) {
      return 'From ${formatter.format(job.salaryMin)}';
    } else {
      return 'Up to ${formatter.format(job.salaryMax)}';
    }
  }

  void _shareComparison() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Comparison sharing feature coming soon')));
  }
}
