import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../providers/job_provider.dart';
import '../widgets/job_card.dart';

class AllJobsScreen extends StatefulWidget {
  const AllJobsScreen({super.key});

  @override
  State<AllJobsScreen> createState() => _AllJobsScreenState();
}

class _AllJobsScreenState extends State<AllJobsScreen> {
  String _sortBy = 'recent';
  final List<String> _sortOptions = ['recent', 'salary_high', 'salary_low', 'alphabetical'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JobProvider>().loadJobs();
    });
  }

  List<Job> _getSortedJobs(List<Job> jobs) {
    final sortedJobs = List<Job>.from(jobs);
    
    switch (_sortBy) {
      case 'recent':
        sortedJobs.sort((a, b) => b.postedDate.compareTo(a.postedDate));
        break;
      case 'salary_high':
        sortedJobs.sort((a, b) {
          final aSalary = a.salaryMax ?? a.salaryMin ?? 0;
          final bSalary = b.salaryMax ?? b.salaryMin ?? 0;
          return bSalary.compareTo(aSalary);
        });
        break;
      case 'salary_low':
        sortedJobs.sort((a, b) {
          final aSalary = a.salaryMin ?? a.salaryMax ?? 0;
          final bSalary = b.salaryMin ?? b.salaryMax ?? 0;
          return aSalary.compareTo(bSalary);
        });
        break;
      case 'alphabetical':
        sortedJobs.sort((a, b) => a.title.compareTo(b.title));
        break;
    }
    
    return sortedJobs;
  }

  String _getSortDisplayName(String sortBy) {
    switch (sortBy) {
      case 'recent':
        return 'Most Recent';
      case 'salary_high':
        return 'Salary: High to Low';
      case 'salary_low':
        return 'Salary: Low to High';
      case 'alphabetical':
        return 'Alphabetical';
      default:
        return 'Most Recent';
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('All Jobs'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) {
              setState(() {
                _sortBy = value;
              });
            },
            itemBuilder: (context) => _sortOptions.map((option) => PopupMenuItem<String>(
                value: option,
                child: Row(
                  children: [
                    if (_sortBy == option)
                      Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      )
                    else
                      const SizedBox(width: 20),
                    const SizedBox(width: 8),
                    Text(_getSortDisplayName(option)),
                  ],
                ),
              )).toList(),
          ),
        ],
      ),
      body: Consumer<JobProvider>(
        builder: (context, jobProvider, child) {
          if (jobProvider.isLoading && jobProvider.jobs.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (jobProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Something went wrong',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    jobProvider.error!,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      jobProvider.loadJobs();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final sortedJobs = _getSortedJobs(jobProvider.jobs);

          if (sortedJobs.isEmpty) {
            return Center(
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
                    'No jobs available',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Check back later for new opportunities',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await jobProvider.loadJobs();
            },
            child: Column(
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${sortedJobs.length} jobs found',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'Sorted by ${_getSortDisplayName(_sortBy)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Jobs list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: sortedJobs.length,
                    itemBuilder: (context, index) {
                      final job = sortedJobs[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: JobCard(job: job),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
}
