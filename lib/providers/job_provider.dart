import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/services.dart';

class JobProvider with ChangeNotifier {
  final JobService _jobService = JobService();
  
  List<Job> _jobs = [];
  List<Job> _featuredJobs = [];
  List<Job> _searchResults = [];
  bool _isLoading = false;
  String? _error;
  
  // Getters
  List<Job> get jobs => _jobs;
  List<Job> get featuredJobs => _featuredJobs;
  List<Job> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  /// Loads all jobs
  Future<void> loadJobs() async {
    _setLoading(true);
    _clearError();
    
    try {
      _jobs = await _jobService.getAllJobs();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load jobs: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  /// Loads featured jobs
  Future<void> loadFeaturedJobs() async {
    _setLoading(true);
    _clearError();
    
    try {
      _featuredJobs = await _jobService.getFeaturedJobs();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load featured jobs: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  /// Searches for jobs
  Future<void> searchJobs({
    String? query,
    String? location,
    JobType? jobType,
    ExperienceLevel? experienceLevel,
    WorkLocation? workLocation,
    double? minSalary,
    double? maxSalary,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      _searchResults = await _jobService.searchJobs(
        query: query,
        location: location,
        jobType: jobType,
        experienceLevel: experienceLevel,
        workLocation: workLocation,
        minSalary: minSalary,
        maxSalary: maxSalary,
      );
      notifyListeners();
    } catch (e) {
      _setError('Failed to search jobs: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  /// Gets a job by ID
  Future<Job?> getJobById(String id) async {
    try {
      return await _jobService.getJobById(id);
    } catch (e) {
      _setError('Failed to load job: $e');
      return null;
    }
  }
  
  /// Clears search results
  void clearSearchResults() {
    _searchResults = [];
    notifyListeners();
  }
  
  /// Refreshes all data
  Future<void> refresh() async {
    await Future.wait([
      loadJobs(),
      loadFeaturedJobs(),
    ]);
  }
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }
  
  void _clearError() {
    _error = null;
  }
}
