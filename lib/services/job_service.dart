import 'dart:async';
import '../models/models.dart';
import 'mock_data_service.dart';

class JobService {
  static const Duration _simulatedDelay = Duration(milliseconds: 500);

  /// Fetches all available jobs
  Future<List<Job>> getAllJobs() async {
    await Future.delayed(_simulatedDelay);
    return MockDataService.getAllJobs();
  }

  /// Searches for jobs based on various criteria
  Future<List<Job>> searchJobs({
    String? query,
    String? location,
    JobType? jobType,
    ExperienceLevel? experienceLevel,
    WorkLocation? workLocation,
    double? minSalary,
    double? maxSalary,
  }) async {
    await Future.delayed(_simulatedDelay);
    return MockDataService.searchJobs(
      query: query,
      location: location,
      jobType: jobType,
      experienceLevel: experienceLevel,
      workLocation: workLocation,
      minSalary: minSalary,
      maxSalary: maxSalary,
    );
  }

  /// Fetches a specific job by ID
  Future<Job?> getJobById(String id) async {
    await Future.delayed(_simulatedDelay);
    return MockDataService.getJobById(id);
  }

  /// Fetches featured jobs
  Future<List<Job>> getFeaturedJobs() async {
    await Future.delayed(_simulatedDelay);
    return MockDataService.getFeaturedJobs();
  }

  /// Fetches recently posted jobs
  Future<List<Job>> getRecentJobs({int limit = 10}) async {
    await Future.delayed(_simulatedDelay);
    return MockDataService.getRecentJobs(limit: limit);
  }

  /// Fetches all companies
  Future<List<Company>> getAllCompanies() async {
    await Future.delayed(_simulatedDelay);
    return MockDataService.getAllCompanies();
  }

  /// Fetches a specific company by ID
  Future<Company?> getCompanyById(String id) async {
    await Future.delayed(_simulatedDelay);
    return MockDataService.getCompanyById(id);
  }

  /// Simulates applying to a job
  Future<bool> applyToJob(String jobId, {
    String? coverLetter,
    String? resumeUrl,
  }) async {
    await Future.delayed(_simulatedDelay);
    // In a real app, this would make an API call to submit the application
    return true; // Simulate successful application
  }

  /// Gets job recommendations based on user preferences
  Future<List<Job>> getRecommendedJobs({
    List<String>? skills,
    String? location,
    ExperienceLevel? experienceLevel,
  }) async {
    await Future.delayed(_simulatedDelay);
    
    // Simple recommendation logic based on skills and experience level
    var allJobs = MockDataService.getAllJobs();
    
    if (skills != null && skills.isNotEmpty) {
      allJobs = allJobs.where((job) => job.skills.any((jobSkill) => 
          skills.any((userSkill) => 
            jobSkill.toLowerCase().contains(userSkill.toLowerCase())
          )
        )).toList();
    }
    
    if (experienceLevel != null) {
      allJobs = allJobs.where((job) => job.experienceLevel == experienceLevel).toList();
    }
    
    if (location != null && location.isNotEmpty) {
      allJobs = allJobs.where((job) => 
        job.location.toLowerCase().contains(location.toLowerCase()) ||
        job.workLocation == WorkLocation.remote
      ).toList();
    }
    
    return allJobs.take(5).toList();
  }
}
