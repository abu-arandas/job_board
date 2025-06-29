import '../models/models.dart';

class MockDataService {
  static final List<Company> _companies = [
    Company(
      id: '1',
      name: 'TechCorp',
      description: 'Leading technology company specializing in innovative software solutions.',
      website: 'https://techcorp.com',
      location: 'San Francisco, CA',
      industry: 'Technology',
      employeeCount: 5000,
      foundedYear: DateTime(2010),
    ),
    Company(
      id: '2',
      name: 'StartupXYZ',
      description: 'Fast-growing startup revolutionizing the fintech industry.',
      website: 'https://startupxyz.com',
      location: 'New York, NY',
      industry: 'Fintech',
      employeeCount: 150,
      foundedYear: DateTime(2020),
    ),
    Company(
      id: '3',
      name: 'Global Solutions',
      description: 'International consulting firm providing enterprise solutions.',
      website: 'https://globalsolutions.com',
      location: 'London, UK',
      industry: 'Consulting',
      employeeCount: 10000,
      foundedYear: DateTime(1995),
    ),
    Company(
      id: '4',
      name: 'InnovateLab',
      description: 'Research and development company focused on AI and machine learning.',
      website: 'https://innovatelab.com',
      location: 'Austin, TX',
      industry: 'AI/ML',
      employeeCount: 300,
      foundedYear: DateTime(2018),
    ),
    Company(
      id: '5',
      name: 'DesignStudio',
      description: 'Creative agency specializing in digital design and user experience.',
      website: 'https://designstudio.com',
      location: 'Los Angeles, CA',
      industry: 'Design',
      employeeCount: 75,
      foundedYear: DateTime(2015),
    ),
  ];

  static final List<Job> _jobs = [
    Job(
      id: '1',
      title: 'Senior Flutter Developer',
      description:
          'We are looking for an experienced Flutter developer to join our mobile team. You will be responsible for developing high-quality mobile applications for both iOS and Android platforms.',
      company: _companies[0],
      location: 'San Francisco, CA',
      jobType: JobType.fullTime,
      experienceLevel: ExperienceLevel.senior,
      workLocation: WorkLocation.hybrid,
      salaryMin: 120,
      salaryMax: 160,
      requirements: [
        '5+ years of Flutter development experience',
        'Strong knowledge of Dart programming language',
        'Experience with state management (Provider, Bloc, Riverpod)',
        'Knowledge of RESTful APIs and JSON',
        'Experience with Git version control',
      ],
      benefits: [
        'Health, dental, and vision insurance',
        'Flexible working hours',
        'Remote work options',
        '401(k) with company matching',
        'Professional development budget',
      ],
      skills: ['Flutter', 'Dart', 'Mobile Development', 'iOS', 'Android'],
      applicationEmail: 'careers@techcorp.com',
      postedDate: DateTime.now().subtract(const Duration(days: 2)),
      applicationDeadline: DateTime.now().add(const Duration(days: 28)),
      isFeatured: true,
    ),
    Job(
      id: '2',
      title: 'Frontend React Developer',
      description:
          'Join our frontend team to build amazing user interfaces using React and modern web technologies. You will work closely with designers and backend developers.',
      company: _companies[1],
      location: 'New York, NY',
      jobType: JobType.fullTime,
      experienceLevel: ExperienceLevel.mid,
      workLocation: WorkLocation.remote,
      salaryMin: 90,
      salaryMax: 130,
      requirements: [
        '3+ years of React development experience',
        'Strong JavaScript and TypeScript skills',
        'Experience with modern CSS frameworks',
        'Knowledge of state management libraries',
        'Familiarity with testing frameworks',
      ],
      benefits: [
        'Competitive salary',
        'Stock options',
        'Unlimited PTO',
        'Home office setup budget',
        'Learning and development opportunities',
      ],
      skills: ['React', 'JavaScript', 'TypeScript', 'CSS', 'HTML'],
      applicationUrl: 'https://startupxyz.com/careers/frontend-react',
      postedDate: DateTime.now().subtract(const Duration(days: 1)),
      applicationDeadline: DateTime.now().add(const Duration(days: 21)),
    ),
    Job(
      id: '3',
      title: 'DevOps Engineer',
      description:
          'We need a skilled DevOps engineer to help us scale our infrastructure and improve our deployment processes. Experience with cloud platforms is essential.',
      company: _companies[2],
      location: 'London, UK',
      jobType: JobType.fullTime,
      experienceLevel: ExperienceLevel.senior,
      workLocation: WorkLocation.onsite,
      salaryMin: 80,
      salaryMax: 120,
      requirements: [
        '4+ years of DevOps experience',
        'Strong knowledge of AWS or Azure',
        'Experience with Docker and Kubernetes',
        'Proficiency in scripting languages',
        'Knowledge of CI/CD pipelines',
      ],
      benefits: [
        'Competitive salary package',
        'Private healthcare',
        'Pension scheme',
        'Flexible working arrangements',
        'Career progression opportunities',
      ],
      skills: ['AWS', 'Docker', 'Kubernetes', 'CI/CD', 'Linux'],
      applicationEmail: 'hr@globalsolutions.com',
      postedDate: DateTime.now().subtract(const Duration(days: 3)),
      applicationDeadline: DateTime.now().add(const Duration(days: 14)),
    ),
    Job(
      id: '4',
      title: 'UX/UI Designer',
      description:
          'We are seeking a creative UX/UI designer to join our design team. You will be responsible for creating intuitive and beautiful user interfaces for our digital products.',
      company: _companies[4],
      location: 'Los Angeles, CA',
      jobType: JobType.fullTime,
      experienceLevel: ExperienceLevel.mid,
      workLocation: WorkLocation.hybrid,
      salaryMin: 80,
      salaryMax: 110,
      requirements: [
        '3+ years of UX/UI design experience',
        'Proficiency in Figma, Sketch, or Adobe XD',
        'Strong portfolio showcasing design process',
        'Understanding of user-centered design principles',
        'Experience with design systems',
      ],
      benefits: [
        'Creative work environment',
        'Design conference budget',
        'Latest design tools and software',
        'Flexible working hours',
        'Health and wellness benefits',
      ],
      skills: ['Figma', 'Sketch', 'Adobe XD', 'Prototyping', 'User Research'],
      applicationEmail: 'design@designstudio.com',
      postedDate: DateTime.now().subtract(const Duration(days: 5)),
      applicationDeadline: DateTime.now().add(const Duration(days: 25)),
    ),
    Job(
      id: '5',
      title: 'Machine Learning Engineer',
      description:
          'Join our AI team to develop cutting-edge machine learning models and deploy them at scale. You will work on exciting projects involving computer vision, NLP, and predictive analytics.',
      company: _companies[3],
      location: 'Austin, TX',
      jobType: JobType.fullTime,
      experienceLevel: ExperienceLevel.senior,
      workLocation: WorkLocation.remote,
      salaryMin: 140,
      salaryMax: 180,
      requirements: [
        '5+ years of ML engineering experience',
        'Strong Python and TensorFlow/PyTorch skills',
        'Experience with cloud platforms (AWS, GCP, Azure)',
        'Knowledge of MLOps and model deployment',
        'PhD or Masters in Computer Science or related field',
      ],
      benefits: [
        'Cutting-edge research opportunities',
        'Conference and publication support',
        'Top-tier hardware and cloud credits',
        'Flexible remote work',
        'Equity participation',
      ],
      skills: ['Python', 'TensorFlow', 'PyTorch', 'AWS', 'MLOps'],
      applicationUrl: 'https://innovatelab.com/careers/ml-engineer',
      postedDate: DateTime.now().subtract(const Duration(days: 1)),
      applicationDeadline: DateTime.now().add(const Duration(days: 30)),
      isFeatured: true,
    ),
    Job(
      id: '6',
      title: 'Backend Developer (Node.js)',
      description:
          'We need a skilled backend developer to help us build scalable APIs and microservices. You will work with modern technologies and contribute to our growing platform.',
      company: _companies[1],
      location: 'New York, NY',
      jobType: JobType.fullTime,
      experienceLevel: ExperienceLevel.junior,
      workLocation: WorkLocation.onsite,
      salaryMin: 70,
      salaryMax: 95,
      requirements: [
        '2+ years of Node.js development experience',
        'Experience with Express.js and REST APIs',
        'Knowledge of databases (MongoDB, PostgreSQL)',
        'Understanding of microservices architecture',
        'Familiarity with Docker and Kubernetes',
      ],
      benefits: [
        'Mentorship from senior developers',
        'Learning and development budget',
        'Modern office in Manhattan',
        'Team building events',
        'Health insurance',
      ],
      skills: ['Node.js', 'Express.js', 'MongoDB', 'PostgreSQL', 'Docker'],
      applicationEmail: 'backend@startupxyz.com',
      postedDate: DateTime.now().subtract(const Duration(days: 4)),
      applicationDeadline: DateTime.now().add(const Duration(days: 20)),
    ),
  ];

  static List<Job> getAllJobs() => List.from(_jobs);

  static List<Job> searchJobs({
    String? query,
    String? location,
    JobType? jobType,
    ExperienceLevel? experienceLevel,
    WorkLocation? workLocation,
    double? minSalary,
    double? maxSalary,
  }) {
    final filteredJobs = _jobs.where((job) {
      // Text search
      if (query != null && query.isNotEmpty) {
        final searchQuery = query.toLowerCase();
        if (!job.title.toLowerCase().contains(searchQuery) &&
            !job.company.name.toLowerCase().contains(searchQuery) &&
            !job.description.toLowerCase().contains(searchQuery) &&
            !job.skills.any((skill) => skill.toLowerCase().contains(searchQuery))) {
          return false;
        }
      }

      // Location filter
      if (location != null && location.isNotEmpty) {
        if (!job.location.toLowerCase().contains(location.toLowerCase())) {
          return false;
        }
      }

      // Job type filter
      if (jobType != null && job.jobType != jobType) {
        return false;
      }

      // Experience level filter
      if (experienceLevel != null && job.experienceLevel != experienceLevel) {
        return false;
      }

      // Work location filter
      if (workLocation != null && job.workLocation != workLocation) {
        return false;
      }

      // Salary filter
      if (minSalary != null && (job.salaryMax == null || job.salaryMax! < minSalary)) {
        return false;
      }

      if (maxSalary != null && (job.salaryMin == null || job.salaryMin! > maxSalary)) {
        return false;
      }

      return true;
    }).toList();

    return filteredJobs;
  }

  static Job? getJobById(String id) {
    try {
      return _jobs.firstWhere((job) => job.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<Job> getFeaturedJobs() => _jobs.where((job) => job.isFeatured).toList();

  static List<Job> getRecentJobs({int limit = 10}) {
    final sortedJobs = List<Job>.from(_jobs);
    sortedJobs.sort((a, b) => b.postedDate.compareTo(a.postedDate));
    return sortedJobs.take(limit).toList();
  }

  static List<Company> getAllCompanies() => List.from(_companies);

  static Company? getCompanyById(String id) {
    try {
      return _companies.firstWhere((company) => company.id == id);
    } catch (e) {
      return null;
    }
  }
}
