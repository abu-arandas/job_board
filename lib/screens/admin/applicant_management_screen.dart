import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../widgets/animated_widgets.dart';
import '../../widgets/premium_components.dart';

class ApplicantManagementScreen extends StatefulWidget {
  const ApplicantManagementScreen({super.key});

  @override
  State<ApplicantManagementScreen> createState() => _ApplicantManagementScreenState();
}

class _ApplicantManagementScreenState extends State<ApplicantManagementScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'New', 'Reviewed', 'Shortlisted', 'Rejected'];

  final List<JobApplication> _applications = [
    JobApplication(
      id: '1',
      applicantName: 'John Doe',
      jobTitle: 'Senior Flutter Developer',
      appliedDate: DateTime.now().subtract(const Duration(days: 1)),
      status: ApplicationStatus.new_,
      email: 'john.doe@email.com',
      experience: '5 years',
      skills: ['Flutter', 'Dart', 'Firebase'],
      resumeUrl: 'resume1.pdf',
    ),
    JobApplication(
      id: '2',
      applicantName: 'Jane Smith',
      jobTitle: 'Product Manager',
      appliedDate: DateTime.now().subtract(const Duration(days: 2)),
      status: ApplicationStatus.reviewed,
      email: 'jane.smith@email.com',
      experience: '7 years',
      skills: ['Product Management', 'Analytics', 'Agile'],
      resumeUrl: 'resume2.pdf',
    ),
    JobApplication(
      id: '3',
      applicantName: 'Mike Johnson',
      jobTitle: 'UX Designer',
      appliedDate: DateTime.now().subtract(const Duration(days: 3)),
      status: ApplicationStatus.shortlisted,
      email: 'mike.johnson@email.com',
      experience: '4 years',
      skills: ['Figma', 'Sketch', 'User Research'],
      resumeUrl: 'resume3.pdf',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredApplications = _selectedFilter == 'All'
        ? _applications
        : _applications.where((app) => app.status.name.toLowerCase() == _selectedFilter.toLowerCase()).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Applicant Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog,
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          FadeInSlideUp(
            child: Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = filter == _selectedFilter;
                  
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ),

          // Applications list
          Expanded(
            child: filteredApplications.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredApplications.length,
                    itemBuilder: (context, index) => FadeInSlideUp(
                        delay: Duration(milliseconds: index * 100),
                        child: _buildApplicationCard(filteredApplications[index]),
                      ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationCard(JobApplication application) => Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    application.applicantName.split(' ').map((n) => n[0]).join(),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        application.applicantName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        application.jobTitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                StatusBadge(
                  text: application.status.displayName,
                  color: _getStatusColor(application.status),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Details
            Row(
              children: [
                Expanded(
                  child: _buildDetailItem(
                    Icons.email_outlined,
                    'Email',
                    application.email,
                  ),
                ),
                Expanded(
                  child: _buildDetailItem(
                    Icons.work_outline,
                    'Experience',
                    application.experience,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildDetailItem(
                    Icons.calendar_today,
                    'Applied',
                    DateFormat('MMM d, y').format(application.appliedDate),
                  ),
                ),
                Expanded(
                  child: _buildDetailItem(
                    Icons.description,
                    'Resume',
                    application.resumeUrl,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Skills
            if (application.skills.isNotEmpty) ...[
              Text(
                'Skills:',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: application.skills.map((skill) => StatusBadge(
                    text: skill,
                    color: Theme.of(context).colorScheme.secondary,
                    isOutlined: true,
                  )).toList(),
              ),
              const SizedBox(height: 16),
            ],

            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _viewProfile(application),
                    icon: const Icon(Icons.person, size: 16),
                    label: const Text('View Profile'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _downloadResume(application),
                    icon: const Icon(Icons.download, size: 16),
                    label: const Text('Resume'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _showStatusDialog(application),
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Update'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

  Widget _buildDetailItem(IconData icon, String label, String value) => Row(
      children: [
        Icon(icon, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );

  Widget _buildEmptyState() => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No Applications Found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'No applications match the selected filter',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );

  Color _getStatusColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.new_:
        return Colors.blue;
      case ApplicationStatus.reviewed:
        return Colors.orange;
      case ApplicationStatus.shortlisted:
        return Colors.green;
      case ApplicationStatus.rejected:
        return Colors.red;
    }
  }

  void _viewProfile(JobApplication application) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
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
                        application.applicantName,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        application.email,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Applied for: ${application.jobTitle}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Experience: ${application.experience}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Skills:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: application.skills.map((skill) => StatusBadge(
                            text: skill,
                            color: Theme.of(context).colorScheme.primary,
                            isOutlined: true,
                          )).toList(),
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

  void _downloadResume(JobApplication application) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloading ${application.resumeUrl}')),
    );
  }

  void _showStatusDialog(JobApplication application) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Application Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ApplicationStatus.values.map((status) => RadioListTile<ApplicationStatus>(
              title: Text(status.displayName),
              value: status,
              groupValue: application.status,
              onChanged: (value) {
                Navigator.of(context).pop();
                _updateApplicationStatus(application, value!);
              },
            )).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _updateApplicationStatus(JobApplication application, ApplicationStatus newStatus) {
    setState(() {
      application.status = newStatus;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Application status updated to ${newStatus.displayName}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showSearchDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Search functionality coming soon')),
    );
  }

  void _showFilterDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Advanced filters coming soon')),
    );
  }
}

class JobApplication {

  JobApplication({
    required this.id,
    required this.applicantName,
    required this.jobTitle,
    required this.appliedDate,
    required this.status,
    required this.email,
    required this.experience,
    required this.skills,
    required this.resumeUrl,
  });
  final String id;
  final String applicantName;
  final String jobTitle;
  final DateTime appliedDate;
  ApplicationStatus status;
  final String email;
  final String experience;
  final List<String> skills;
  final String resumeUrl;
}

enum ApplicationStatus {
  new_,
  reviewed,
  shortlisted,
  rejected,
}

extension ApplicationStatusExtension on ApplicationStatus {
  String get displayName {
    switch (this) {
      case ApplicationStatus.new_:
        return 'New';
      case ApplicationStatus.reviewed:
        return 'Reviewed';
      case ApplicationStatus.shortlisted:
        return 'Shortlisted';
      case ApplicationStatus.rejected:
        return 'Rejected';
    }
  }
}
