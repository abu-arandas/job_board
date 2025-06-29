import 'package:flutter/material.dart';
import '../models/models.dart';

class FilterBottomSheet extends StatefulWidget {

  const FilterBottomSheet({
    required this.onApplyFilters, super.key,
    this.selectedJobType,
    this.selectedExperienceLevel,
    this.selectedWorkLocation,
    this.minSalary,
    this.maxSalary,
  });
  final JobType? selectedJobType;
  final ExperienceLevel? selectedExperienceLevel;
  final WorkLocation? selectedWorkLocation;
  final double? minSalary;
  final double? maxSalary;
  final Function(
    JobType?,
    ExperienceLevel?,
    WorkLocation?,
    double?,
    double?,
  ) onApplyFilters;

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  JobType? _selectedJobType;
  ExperienceLevel? _selectedExperienceLevel;
  WorkLocation? _selectedWorkLocation;
  RangeValues _salaryRange = const RangeValues(30, 200);

  @override
  void initState() {
    super.initState();
    _selectedJobType = widget.selectedJobType;
    _selectedExperienceLevel = widget.selectedExperienceLevel;
    _selectedWorkLocation = widget.selectedWorkLocation;
    
    final minSalary = widget.minSalary ?? 30;
    final maxSalary = widget.maxSalary ?? 200;
    _salaryRange = RangeValues(minSalary, maxSalary);
  }

  @override
  Widget build(BuildContext context) => Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Handle
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                
                // Header
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filters',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      TextButton(
                        onPressed: _clearAllFilters,
                        child: const Text('Clear All'),
                      ),
                    ],
                  ),
                ),
                
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Job Type
                        _buildSectionTitle('Job Type'),
                        _buildJobTypeFilter(),
                        const SizedBox(height: 24),
                        
                        // Experience Level
                        _buildSectionTitle('Experience Level'),
                        _buildExperienceLevelFilter(),
                        const SizedBox(height: 24),
                        
                        // Work Location
                        _buildSectionTitle('Work Location'),
                        _buildWorkLocationFilter(),
                        const SizedBox(height: 24),
                        
                        // Salary Range
                        _buildSectionTitle('Salary Range (K USD)'),
                        _buildSalaryRangeFilter(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                
                // Bottom buttons
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: FilledButton(
                          onPressed: _applyFilters,
                          child: const Text('Apply Filters'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ),
    );

  Widget _buildSectionTitle(String title) => Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );

  Widget _buildJobTypeFilter() => Wrap(
      spacing: 8,
      runSpacing: 8,
      children: JobType.values.map((jobType) {
        final isSelected = _selectedJobType == jobType;
        return FilterChip(
          label: Text(_getJobTypeDisplayName(jobType)),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _selectedJobType = selected ? jobType : null;
            });
          },
        );
      }).toList(),
    );

  Widget _buildExperienceLevelFilter() => Wrap(
      spacing: 8,
      runSpacing: 8,
      children: ExperienceLevel.values.map((level) {
        final isSelected = _selectedExperienceLevel == level;
        return FilterChip(
          label: Text(_getExperienceLevelDisplayName(level)),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _selectedExperienceLevel = selected ? level : null;
            });
          },
        );
      }).toList(),
    );

  Widget _buildWorkLocationFilter() => Wrap(
      spacing: 8,
      runSpacing: 8,
      children: WorkLocation.values.map((location) {
        final isSelected = _selectedWorkLocation == location;
        return FilterChip(
          label: Text(_getWorkLocationDisplayName(location)),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _selectedWorkLocation = selected ? location : null;
            });
          },
        );
      }).toList(),
    );

  Widget _buildSalaryRangeFilter() => Column(
      children: [
        RangeSlider(
          values: _salaryRange,
          min: 20,
          max: 300,
          divisions: 28,
          labels: RangeLabels(
            '\$${_salaryRange.start.round()}K',
            '\$${_salaryRange.end.round()}K',
          ),
          onChanged: (values) {
            setState(() {
              _salaryRange = values;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '\$${_salaryRange.start.round()}K',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              '\$${_salaryRange.end.round()}K',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ],
    );

  String _getJobTypeDisplayName(JobType jobType) {
    switch (jobType) {
      case JobType.fullTime:
        return 'Full-time';
      case JobType.partTime:
        return 'Part-time';
      case JobType.contract:
        return 'Contract';
      case JobType.internship:
        return 'Internship';
      case JobType.freelance:
        return 'Freelance';
    }
  }

  String _getExperienceLevelDisplayName(ExperienceLevel level) {
    switch (level) {
      case ExperienceLevel.entry:
        return 'Entry Level';
      case ExperienceLevel.junior:
        return 'Junior';
      case ExperienceLevel.mid:
        return 'Mid Level';
      case ExperienceLevel.senior:
        return 'Senior';
      case ExperienceLevel.lead:
        return 'Lead';
      case ExperienceLevel.executive:
        return 'Executive';
    }
  }

  String _getWorkLocationDisplayName(WorkLocation location) {
    switch (location) {
      case WorkLocation.remote:
        return 'Remote';
      case WorkLocation.onsite:
        return 'On-site';
      case WorkLocation.hybrid:
        return 'Hybrid';
    }
  }

  void _clearAllFilters() {
    setState(() {
      _selectedJobType = null;
      _selectedExperienceLevel = null;
      _selectedWorkLocation = null;
      _salaryRange = const RangeValues(30, 200);
    });
  }

  void _applyFilters() {
    widget.onApplyFilters(
      _selectedJobType,
      _selectedExperienceLevel,
      _selectedWorkLocation,
      _salaryRange.start,
      _salaryRange.end,
    );
    Navigator.of(context).pop();
  }
}
