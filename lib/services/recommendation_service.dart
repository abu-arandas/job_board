import '../models/models.dart';

class RecommendationService {
  /// Generates job recommendations based on user profile and preferences
  Future<List<Job>> getRecommendedJobs({
    required List<String> userSkills,
    required String? preferredLocation,
    required double? minSalary,
    required double? maxSalary,
    required List<String> preferredJobTypes,
    required List<Job> allJobs,
    int limit = 10,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    final scoredJobs = <JobRecommendation>[];

    for (final job in allJobs) {
      final score = _calculateJobScore(
        job: job,
        userSkills: userSkills,
        preferredLocation: preferredLocation,
        minSalary: minSalary,
        maxSalary: maxSalary,
        preferredJobTypes: preferredJobTypes,
      );

      if (score > 0.2) {
        // Only include jobs with decent match
        scoredJobs.add(JobRecommendation(job: job, score: score));
      }
    }

    // Sort by score descending
    scoredJobs.sort((a, b) => b.score.compareTo(a.score));

    return scoredJobs.take(limit).map((jr) => jr.job).toList();
  }

  /// Calculates a recommendation score for a job based on user preferences
  double _calculateJobScore({
    required Job job,
    required List<String> userSkills,
    required String? preferredLocation,
    required double? minSalary,
    required double? maxSalary,
    required List<String> preferredJobTypes,
  }) {
    var score = 0.0;
    var maxScore = 0.0;

    // Skills matching (40% weight)
    const skillsWeight = 0.4;
    maxScore += skillsWeight;
    if (userSkills.isNotEmpty && job.requirements.isNotEmpty) {
      var matchingSkills = 0;
      for (final skill in userSkills) {
        if (job.requirements.any((req) => req.toLowerCase().contains(skill.toLowerCase()))) {
          matchingSkills++;
        }
      }
      score += (matchingSkills / userSkills.length) * skillsWeight;
    }

    // Location matching (20% weight)
    const locationWeight = 0.2;
    maxScore += locationWeight;
    if (preferredLocation != null && preferredLocation.isNotEmpty) {
      if (job.location.toLowerCase().contains(preferredLocation.toLowerCase())) {
        score += locationWeight;
      } else if (job.isRemote) {
        score += locationWeight * 0.8; // Remote jobs get 80% of location score
      }
    } else {
      score += locationWeight; // No preference means all locations are good
    }

    // Salary matching (25% weight)
    const salaryWeight = 0.25;
    maxScore += salaryWeight;
    if (minSalary != null || maxSalary != null) {
      final jobMinSalary = job.salaryMin ?? 0;
      final jobMaxSalary = job.salaryMax ?? jobMinSalary;

      var salaryMatches = true;
      if (minSalary != null && jobMaxSalary < minSalary) {
        salaryMatches = false;
      }
      if (maxSalary != null && jobMinSalary > maxSalary) {
        salaryMatches = false;
      }

      if (salaryMatches) {
        score += salaryWeight;
      }
    } else {
      score += salaryWeight; // No preference means all salaries are good
    }

    // Job type matching (15% weight)
    const jobTypeWeight = 0.15;
    maxScore += jobTypeWeight;
    if (preferredJobTypes.isNotEmpty) {
      if (preferredJobTypes.contains(job.type)) {
        score += jobTypeWeight;
      }
    } else {
      score += jobTypeWeight; // No preference means all types are good
    }

    // Normalize score to 0-1 range
    return maxScore > 0 ? score / maxScore : 0.0;
  }

  /// Gets similar jobs based on a given job
  Future<List<Job>> getSimilarJobs({required Job referenceJob, required List<Job> allJobs, int limit = 5}) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final scoredJobs = <JobRecommendation>[];

    for (final job in allJobs) {
      if (job.id == referenceJob.id) {
        continue; // Skip the reference job itself
      }

      final score = _calculateSimilarityScore(referenceJob, job);
      if (score > 0.2) {
        scoredJobs.add(JobRecommendation(job: job, score: score));
      }
    }

    scoredJobs.sort((a, b) => b.score.compareTo(a.score));
    return scoredJobs.take(limit).map((jr) => jr.job).toList();
  }

  /// Calculates similarity score between two jobs
  double _calculateSimilarityScore(Job job1, Job job2) {
    var score = 0.0;
    var maxScore = 0.0;

    // Company similarity (30% weight)
    const companyWeight = 0.3;
    maxScore += companyWeight;
    if (job1.company.id == job2.company.id) {
      score += companyWeight;
    }

    // Job type similarity (25% weight)
    const typeWeight = 0.25;
    maxScore += typeWeight;
    if (job1.type == job2.type) {
      score += typeWeight;
    }

    // Location similarity (20% weight)
    const locationWeight = 0.2;
    maxScore += locationWeight;
    if (job1.location == job2.location || (job1.isRemote && job2.isRemote)) {
      score += locationWeight;
    }

    // Salary range similarity (25% weight)
    const salaryWeight = 0.25;
    maxScore += salaryWeight;
    final job1Min = job1.salaryMin ?? 0;
    final job1Max = job1.salaryMax ?? job1Min;
    final job2Min = job2.salaryMin ?? 0;
    final job2Max = job2.salaryMax ?? job2Min;

    if (job1Min > 0 && job2Min > 0) {
      final salaryOverlap = _calculateRangeOverlap(job1Min, job1Max, job2Min, job2Max);
      score += salaryOverlap * salaryWeight;
    }

    return maxScore > 0 ? score / maxScore : 0.0;
  }

  /// Calculates overlap between two salary ranges
  double _calculateRangeOverlap(double min1, double max1, double min2, double max2) {
    final overlapStart = min1 > min2 ? min1 : min2;
    final overlapEnd = max1 < max2 ? max1 : max2;

    if (overlapStart >= overlapEnd) {
      return 0;
    }

    final overlapSize = overlapEnd - overlapStart;
    final totalRange = (max1 - min1) + (max2 - min2);

    return totalRange > 0 ? (2.0 * overlapSize) / totalRange : 0.0;
  }

  /// Gets trending jobs based on application activity
  Future<List<Job>> getTrendingJobs({required List<Job> allJobs, int limit = 10}) async {
    await Future.delayed(const Duration(milliseconds: 200));

    // Simulate trending algorithm based on recent posting date and company popularity
    final trendingJobs = List<Job>.from(allJobs)
      ..sort((a, b) {
        // Prioritize recent jobs
        final dateComparison = b.postedDate.compareTo(a.postedDate);
        if (dateComparison != 0) {
          return dateComparison;
        }

        // Then by company name (simulating popularity)
        return a.company.name.compareTo(b.company.name);
      });

    return trendingJobs.take(limit).toList();
  }

  /// Gets salary insights for a specific role/location
  Future<SalaryInsight> getSalaryInsights({
    required String jobTitle,
    required String location,
    required List<Job> allJobs,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final relevantJobs = allJobs
        .where(
          (job) =>
              job.title.toLowerCase().contains(jobTitle.toLowerCase()) &&
              (job.location.toLowerCase().contains(location.toLowerCase()) || job.isRemote),
        )
        .toList();

    if (relevantJobs.isEmpty) {
      return SalaryInsight(
        jobTitle: jobTitle,
        location: location,
        averageSalary: 0,
        minSalary: 0,
        maxSalary: 0,
        sampleSize: 0,
      );
    }

    final salaries = <double>[];
    for (final job in relevantJobs) {
      if (job.salaryMin != null) {
        salaries.add(job.salaryMin!);
      }
      if (job.salaryMax != null) {
        salaries.add(job.salaryMax!);
      }
    }

    if (salaries.isEmpty) {
      return SalaryInsight(
        jobTitle: jobTitle,
        location: location,
        averageSalary: 0,
        minSalary: 0,
        maxSalary: 0,
        sampleSize: relevantJobs.length,
      );
    }

    salaries.sort();
    final minSalary = salaries.first;
    final maxSalary = salaries.last;
    final averageSalary = salaries.reduce((a, b) => a + b) / salaries.length;

    return SalaryInsight(
      jobTitle: jobTitle,
      location: location,
      averageSalary: averageSalary,
      minSalary: minSalary,
      maxSalary: maxSalary,
      sampleSize: relevantJobs.length,
    );
  }
}

class JobRecommendation {
  JobRecommendation({required this.job, required this.score});
  final Job job;
  final double score;
}

class SalaryInsight {
  SalaryInsight({
    required this.jobTitle,
    required this.location,
    required this.averageSalary,
    required this.minSalary,
    required this.maxSalary,
    required this.sampleSize,
  });
  final String jobTitle;
  final String location;
  final double averageSalary;
  final double minSalary;
  final double maxSalary;
  final int sampleSize;
}
