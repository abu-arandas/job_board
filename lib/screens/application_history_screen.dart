import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum ApplicationStatus {
  pending,
  reviewed,
  interview,
  rejected,
  accepted,
}

class JobApplication {

  JobApplication({
    required this.id,
    required this.jobTitle,
    required this.company,
    required this.appliedDate,
    required this.status,
    this.notes,
  });
  final String id;
  final String jobTitle;
  final String company;
  final DateTime appliedDate;
  final ApplicationStatus status;
  final String? notes;

  String get statusDisplayName {
    switch (status) {
      case ApplicationStatus.pending:
        return 'Pending';
      case ApplicationStatus.reviewed:
        return 'Reviewed';
      case ApplicationStatus.interview:
        return 'Interview';
      case ApplicationStatus.rejected:
        return 'Rejected';
      case ApplicationStatus.accepted:
        return 'Accepted';
    }
  }

  Color getStatusColor(BuildContext context) {
    switch (status) {
      case ApplicationStatus.pending:
        return Colors.orange;
      case ApplicationStatus.reviewed:
        return Colors.blue;
      case ApplicationStatus.interview:
        return Colors.purple;
      case ApplicationStatus.rejected:
        return Colors.red;
      case ApplicationStatus.accepted:
        return Colors.green;
    }
  }

  IconData get statusIcon {
    switch (status) {
      case ApplicationStatus.pending:
        return Icons.schedule;
      case ApplicationStatus.reviewed:
        return Icons.visibility;
      case ApplicationStatus.interview:
        return Icons.person;
      case ApplicationStatus.rejected:
        return Icons.close;
      case ApplicationStatus.accepted:
        return Icons.check_circle;
    }
  }
}

class ApplicationHistoryScreen extends StatefulWidget {
  const ApplicationHistoryScreen({super.key});

  @override
  State<ApplicationHistoryScreen> createState() => _ApplicationHistoryScreenState();
}

class _ApplicationHistoryScreenState extends State<ApplicationHistoryScreen> {
  final List<JobApplication> _applications = [
    JobApplication(
      id: '1',
      jobTitle: 'Senior Flutter Developer',
      company: 'TechCorp',
      appliedDate: DateTime.now().subtract(const Duration(days: 2)),
      status: ApplicationStatus.reviewed,
      notes: 'Application reviewed by HR team',
    ),
    JobApplication(
      id: '2',
      jobTitle: 'Frontend React Developer',
      company: 'StartupXYZ',
      appliedDate: DateTime.now().subtract(const Duration(days: 5)),
      status: ApplicationStatus.interview,
      notes: 'Phone interview scheduled for next week',
    ),
    JobApplication(
      id: '3',
      jobTitle: 'DevOps Engineer',
      company: 'Global Solutions',
      appliedDate: DateTime.now().subtract(const Duration(days: 10)),
      status: ApplicationStatus.rejected,
      notes: 'Position filled by another candidate',
    ),
    JobApplication(
      id: '4',
      jobTitle: 'UX/UI Designer',
      company: 'DesignStudio',
      appliedDate: DateTime.now().subtract(const Duration(days: 15)),
      status: ApplicationStatus.pending,
    ),
    JobApplication(
      id: '5',
      jobTitle: 'Machine Learning Engineer',
      company: 'InnovateLab',
      appliedDate: DateTime.now().subtract(const Duration(days: 20)),
      status: ApplicationStatus.accepted,
      notes: 'Offer received! Starting next month',
    ),
  ];

  ApplicationStatus? _filterStatus;

  @override
  Widget build(BuildContext context) {
    final filteredApplications = _filterStatus == null
        ? _applications
        : _applications.where((app) => app.status == _filterStatus).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Application History'),
        actions: [
          PopupMenuButton<ApplicationStatus?>(
            icon: const Icon(Icons.filter_list),
            onSelected: (status) {
              setState(() {
                _filterStatus = status;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem<ApplicationStatus?>(
                child: Text('All Applications'),
              ),
              ...ApplicationStatus.values.map((status) => PopupMenuItem<ApplicationStatus?>(
                value: status,
                child: Text(status.name.toUpperCase()),
              )),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Total',
                    _applications.length.toString(),
                    Icons.work_outline,
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Pending',
                    _applications.where((app) => app.status == ApplicationStatus.pending).length.toString(),
                    Icons.schedule,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Interviews',
                    _applications.where((app) => app.status == ApplicationStatus.interview).length.toString(),
                    Icons.person,
                    Colors.purple,
                  ),
                ),
              ],
            ),
          ),

          // Applications list
          Expanded(
            child: filteredApplications.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredApplications.length,
                    itemBuilder: (context, index) {
                      final application = filteredApplications[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _ApplicationCard(
                          application: application,
                          onTap: () => _showApplicationDetails(application),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value, IconData icon, Color color) => Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );

  Widget _buildEmptyState() => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.work_off,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            _filterStatus == null ? 'No Applications Yet' : 'No ${_filterStatus!.name.toUpperCase()} Applications',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            _filterStatus == null
                ? 'Start applying to jobs to see your application history here'
                : 'Try changing the filter to see other applications',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

  void _showApplicationDetails(JobApplication application) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (context, scrollController) => DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        application.jobTitle,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        application.company,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Icon(
                            application.statusIcon,
                            color: application.getStatusColor(context),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            application.statusDisplayName,
                            style: TextStyle(
                              color: application.getStatusColor(context),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      Text(
                        'Applied: ${DateFormat('MMM d, y').format(application.appliedDate)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      
                      if (application.notes != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          'Notes:',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          application.notes!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                      
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Job details not available')),
                            );
                          },
                          icon: const Icon(Icons.work),
                          label: const Text('View Job Details'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ApplicationCard extends StatelessWidget {

  const _ApplicationCard({
    required this.application,
    required this.onTap,
  });
  final JobApplication application;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                          application.jobTitle,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          application.company,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: application.getStatusColor(context).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          application.statusIcon,
                          size: 16,
                          color: application.getStatusColor(context),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          application.statusDisplayName,
                          style: TextStyle(
                            color: application.getStatusColor(context),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Applied ${DateFormat('MMM d, y').format(application.appliedDate)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
}
