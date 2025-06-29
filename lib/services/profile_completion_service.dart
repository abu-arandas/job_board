import '../models/models.dart';

class ProfileCompletionService {
  /// Calculates profile completion percentage and provides recommendations
  ProfileCompletionResult calculateCompletion(User user) {
    final checks = <ProfileCheck>[];
    var completedItems = 0;
    var totalItems = 0;

    // Basic Information (30% weight)
    checks.addAll(_checkBasicInfo(user));
    
    // Professional Information (25% weight)
    checks.addAll(_checkProfessionalInfo(user));
    
    // Skills and Experience (20% weight)
    checks.addAll(_checkSkillsAndExperience(user));
    
    // Contact and Social (15% weight)
    checks.addAll(_checkContactAndSocial(user));
    
    // Additional Information (10% weight)
    checks.addAll(_checkAdditionalInfo(user));

    // Calculate totals
    for (final check in checks) {
      totalItems++;
      if (check.isCompleted) {
        completedItems++;
      }
    }

    final percentage = totalItems > 0 ? (completedItems / totalItems * 100).round() : 0;
    final level = _getCompletionLevel(percentage);
    final recommendations = _getRecommendations(checks);

    return ProfileCompletionResult(
      percentage: percentage,
      level: level,
      checks: checks,
      recommendations: recommendations,
      completedItems: completedItems,
      totalItems: totalItems,
    );
  }

  List<ProfileCheck> _checkBasicInfo(User user) => [
      ProfileCheck(
        category: 'Basic Information',
        title: 'Profile Photo',
        description: 'Add a professional profile photo',
        isCompleted: user.portfolioUrl != null && user.portfolioUrl!.isNotEmpty,
        weight: 3,
        priority: ProfilePriority.high,
      ),
      ProfileCheck(
        category: 'Basic Information',
        title: 'Full Name',
        description: 'Complete your full name',
        isCompleted: user.name.isNotEmpty,
        weight: 2,
        priority: ProfilePriority.high,
      ),
      ProfileCheck(
        category: 'Basic Information',
        title: 'Email Address',
        description: 'Verify your email address',
        isCompleted: user.email.isNotEmpty,
        weight: 2,
        priority: ProfilePriority.high,
      ),
      ProfileCheck(
        category: 'Basic Information',
        title: 'Phone Number',
        description: 'Add your contact phone number',
        isCompleted: user.phone != null && user.phone!.isNotEmpty,
        weight: 1,
        priority: ProfilePriority.medium,
      ),
      ProfileCheck(
        category: 'Basic Information',
        title: 'Location',
        description: 'Specify your current location',
        isCompleted: user.location != null && user.location!.isNotEmpty,
        weight: 2,
        priority: ProfilePriority.high,
      ),
    ];

  List<ProfileCheck> _checkProfessionalInfo(User user) => [
      ProfileCheck(
        category: 'Professional Information',
        title: 'Job Title',
        description: 'Add your current or desired job title',
        isCompleted: user.jobTitle != null && user.jobTitle!.isNotEmpty,
        weight: 3,
        priority: ProfilePriority.high,
      ),
      ProfileCheck(
        category: 'Professional Information',
        title: 'Professional Bio',
        description: 'Write a compelling professional summary',
        isCompleted: user.bio != null && user.bio!.length >= 50,
        weight: 2,
        priority: ProfilePriority.medium,
      ),
      ProfileCheck(
        category: 'Professional Information',
        title: 'Experience Level',
        description: 'Specify your experience level',
        isCompleted: user.experienceLevel != null && user.experienceLevel!.isNotEmpty,
        weight: 2,
        priority: ProfilePriority.medium,
      ),
      ProfileCheck(
        category: 'Professional Information',
        title: 'Salary Expectations',
        description: 'Set your salary expectations',
        isCompleted: user.expectedSalaryMin != null || user.expectedSalaryMax != null,
        weight: 1,
        priority: ProfilePriority.low,
      ),
    ];

  List<ProfileCheck> _checkSkillsAndExperience(User user) => [
      ProfileCheck(
        category: 'Skills & Experience',
        title: 'Skills',
        description: 'Add at least 5 relevant skills',
        isCompleted: user.skills.length >= 5,
        weight: 3,
        priority: ProfilePriority.high,
      ),
      ProfileCheck(
        category: 'Skills & Experience',
        title: 'Resume',
        description: 'Upload your resume',
        isCompleted: user.resumeUrl != null && user.resumeUrl!.isNotEmpty,
        weight: 3,
        priority: ProfilePriority.high,
      ),
      ProfileCheck(
        category: 'Skills & Experience',
        title: 'Work Preferences',
        description: 'Set your job type preferences',
        isCompleted: user.preferredJobTypes.isNotEmpty,
        weight: 1,
        priority: ProfilePriority.medium,
      ),
    ];

  List<ProfileCheck> _checkContactAndSocial(User user) => [
      ProfileCheck(
        category: 'Contact & Social',
        title: 'LinkedIn Profile',
        description: 'Connect your LinkedIn profile',
        isCompleted: user.linkedinUrl != null && user.linkedinUrl!.isNotEmpty,
        weight: 2,
        priority: ProfilePriority.medium,
      ),
      ProfileCheck(
        category: 'Contact & Social',
        title: 'Portfolio/Website',
        description: 'Add your portfolio or personal website',
        isCompleted: user.portfolioUrl != null && user.portfolioUrl!.isNotEmpty,
        weight: 1,
        priority: ProfilePriority.low,
      ),
      ProfileCheck(
        category: 'Contact & Social',
        title: 'GitHub Profile',
        description: 'Connect your GitHub profile (for tech roles)',
        isCompleted: user.githubUrl != null && user.githubUrl!.isNotEmpty,
        weight: 1,
        priority: ProfilePriority.low,
      ),
    ];

  List<ProfileCheck> _checkAdditionalInfo(User user) => [
      ProfileCheck(
        category: 'Additional Information',
        title: 'Availability',
        description: 'Specify when you can start working',
        isCompleted: user.availability != null && user.availability!.isNotEmpty,
        weight: 1,
        priority: ProfilePriority.low,
      ),
      ProfileCheck(
        category: 'Additional Information',
        title: 'Remote Work Preference',
        description: 'Set your remote work preferences',
        isCompleted: user.isOpenToRemote != null,
        weight: 1,
        priority: ProfilePriority.low,
      ),
    ];

  ProfileCompletionLevel _getCompletionLevel(int percentage) {
    if (percentage >= 90) return ProfileCompletionLevel.expert;
    if (percentage >= 70) return ProfileCompletionLevel.advanced;
    if (percentage >= 50) return ProfileCompletionLevel.intermediate;
    if (percentage >= 25) return ProfileCompletionLevel.beginner;
    return ProfileCompletionLevel.starter;
  }

  List<String> _getRecommendations(List<ProfileCheck> checks) {
    final recommendations = <String>[];
    final incompleteHighPriority = checks
        .where((check) => !check.isCompleted && check.priority == ProfilePriority.high)
        .toList();

    if (incompleteHighPriority.isNotEmpty) {
      recommendations.add('Complete high-priority items first for better job matches');
      for (final check in incompleteHighPriority.take(3)) {
        recommendations.add('• ${check.title}: ${check.description}');
      }
    }

    final skillsCheck = checks.firstWhere(
      (check) => check.title == 'Skills',
      orElse: () => ProfileCheck(
        category: '',
        title: '',
        description: '',
        isCompleted: true,
        weight: 0,
        priority: ProfilePriority.low,
      ),
    );

    if (!skillsCheck.isCompleted) {
      recommendations.add('Adding more skills increases your visibility to employers by 40%');
    }

    final resumeCheck = checks.firstWhere(
      (check) => check.title == 'Resume',
      orElse: () => ProfileCheck(
        category: '',
        title: '',
        description: '',
        isCompleted: true,
        weight: 0,
        priority: ProfilePriority.low,
      ),
    );

    if (!resumeCheck.isCompleted) {
      recommendations.add('Profiles with resumes get 3x more views from recruiters');
    }

    return recommendations;
  }
}

class ProfileCompletionResult {

  ProfileCompletionResult({
    required this.percentage,
    required this.level,
    required this.checks,
    required this.recommendations,
    required this.completedItems,
    required this.totalItems,
  });
  final int percentage;
  final ProfileCompletionLevel level;
  final List<ProfileCheck> checks;
  final List<String> recommendations;
  final int completedItems;
  final int totalItems;

  String get levelDisplayName {
    switch (level) {
      case ProfileCompletionLevel.starter:
        return 'Starter';
      case ProfileCompletionLevel.beginner:
        return 'Beginner';
      case ProfileCompletionLevel.intermediate:
        return 'Intermediate';
      case ProfileCompletionLevel.advanced:
        return 'Advanced';
      case ProfileCompletionLevel.expert:
        return 'Expert';
    }
  }

  String get levelDescription {
    switch (level) {
      case ProfileCompletionLevel.starter:
        return 'Just getting started - complete basic info to improve visibility';
      case ProfileCompletionLevel.beginner:
        return 'Good start - add more details to attract employers';
      case ProfileCompletionLevel.intermediate:
        return 'Well on your way - focus on professional details';
      case ProfileCompletionLevel.advanced:
        return 'Great profile - fine-tune remaining details';
      case ProfileCompletionLevel.expert:
        return 'Excellent profile - you\'re ready to find your dream job!';
    }
  }

  List<ProfileCheck> get incompleteChecks => checks.where((check) => !check.isCompleted).toList();

  List<ProfileCheck> get highPriorityIncomplete => incompleteChecks.where((check) => check.priority == ProfilePriority.high).toList();
}

class ProfileCheck {

  ProfileCheck({
    required this.category,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.weight,
    required this.priority,
  });
  final String category;
  final String title;
  final String description;
  final bool isCompleted;
  final int weight;
  final ProfilePriority priority;
}

enum ProfileCompletionLevel {
  starter,
  beginner,
  intermediate,
  advanced,
  expert,
}

enum ProfilePriority {
  low,
  medium,
  high,
}
