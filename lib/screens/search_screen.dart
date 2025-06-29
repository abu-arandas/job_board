import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../providers/job_provider.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/job_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  JobType? _selectedJobType;
  ExperienceLevel? _selectedExperienceLevel;
  WorkLocation? _selectedWorkLocation;
  double? _minSalary;
  double? _maxSalary;

  @override
  void dispose() {
    _searchController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _performSearch() {
    context.read<JobProvider>().searchJobs(
      query: _searchController.text.trim().isEmpty ? null : _searchController.text.trim(),
      location: _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
      jobType: _selectedJobType,
      experienceLevel: _selectedExperienceLevel,
      workLocation: _selectedWorkLocation,
      minSalary: _minSalary,
      maxSalary: _maxSalary,
    );
  }

  void _clearFilters() {
    setState(() {
      _selectedJobType = null;
      _selectedExperienceLevel = null;
      _selectedWorkLocation = null;
      _minSalary = null;
      _maxSalary = null;
    });
    _performSearch();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => FilterBottomSheet(
        selectedJobType: _selectedJobType,
        selectedExperienceLevel: _selectedExperienceLevel,
        selectedWorkLocation: _selectedWorkLocation,
        minSalary: _minSalary,
        maxSalary: _maxSalary,
        onApplyFilters: (jobType, experienceLevel, workLocation, minSalary, maxSalary) {
          setState(() {
            _selectedJobType = jobType;
            _selectedExperienceLevel = experienceLevel;
            _selectedWorkLocation = workLocation;
            _minSalary = minSalary;
            _maxSalary = maxSalary;
          });
          _performSearch();
        },
      ),
    );
  }

  bool get _hasActiveFilters =>
      _selectedJobType != null ||
      _selectedExperienceLevel != null ||
      _selectedWorkLocation != null ||
      _minSalary != null ||
      _maxSalary != null;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
    appBar: AppBar(
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0D9488), Color(0xFF14B8A6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.search, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          const Text('Search Jobs'),
        ],
      ),
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
    ),
    body: Column(
      children: [
        // Enhanced Search section
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Enhanced Search bar
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Job title, company, or keywords',
                    hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _performSearch();
                            },
                          )
                        : null,
                  ),
                  onSubmitted: (_) => _performSearch(),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              const SizedBox(height: 12),

              // Enhanced Location and filter row
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          hintText: 'Location',
                          hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                          prefixIcon: Icon(Icons.location_on_outlined, color: Theme.of(context).colorScheme.primary),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          suffixIcon: _locationController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _locationController.clear();
                                    _performSearch();
                                  },
                                )
                              : null,
                        ),
                        onSubmitted: (_) => _performSearch(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      gradient: _hasActiveFilters
                          ? const LinearGradient(
                              colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: _hasActiveFilters ? null : Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: _hasActiveFilters
                          ? [
                              BoxShadow(
                                color: const Color(0xFF2563EB).withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: FilledButton.icon(
                      onPressed: _showFilterBottomSheet,
                      icon: Icon(
                        Icons.tune,
                        color: _hasActiveFilters ? Colors.white : Theme.of(context).colorScheme.primary,
                      ),
                      label: Text(
                        'Filters',
                        style: TextStyle(
                          color: _hasActiveFilters ? Colors.white : Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),

              // Active filters chips
              if (_hasActiveFilters) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 8,
                        children: [
                          if (_selectedJobType != null)
                            Chip(
                              label: Text(_selectedJobType!.name),
                              onDeleted: () {
                                setState(() {
                                  _selectedJobType = null;
                                });
                                _performSearch();
                              },
                            ),
                          if (_selectedExperienceLevel != null)
                            Chip(
                              label: Text(_selectedExperienceLevel!.name),
                              onDeleted: () {
                                setState(() {
                                  _selectedExperienceLevel = null;
                                });
                                _performSearch();
                              },
                            ),
                          if (_selectedWorkLocation != null)
                            Chip(
                              label: Text(_selectedWorkLocation!.name),
                              onDeleted: () {
                                setState(() {
                                  _selectedWorkLocation = null;
                                });
                                _performSearch();
                              },
                            ),
                        ],
                      ),
                    ),
                    TextButton(onPressed: _clearFilters, child: const Text('Clear All')),
                  ],
                ),
              ],
            ],
          ),
        ),

        // Results section
        Expanded(
          child: Consumer<JobProvider>(
            builder: (context, jobProvider, child) {
              if (jobProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (jobProvider.error != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
                      const SizedBox(height: 16),
                      Text('Search failed', style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      Text(
                        jobProvider.error!,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      FilledButton(onPressed: _performSearch, child: const Text('Retry')),
                    ],
                  ),
                );
              }

              final searchResults = jobProvider.searchResults;

              if (searchResults.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 64, color: Theme.of(context).colorScheme.onSurfaceVariant),
                      const SizedBox(height: 16),
                      Text('No jobs found', style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      Text('Try adjusting your search criteria', style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final job = searchResults[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: JobCard(job: job),
                  );
                },
              );
            },
          ),
        ),
      ],
    ),
  );
}
