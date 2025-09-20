import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'providers/favorites_provider.dart';
import 'providers/job_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/about_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/admin/applicant_management_screen.dart';
import 'screens/admin/post_job_screen.dart';
import 'screens/all_jobs_screen.dart';
import 'screens/application_history_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/help_support_screen.dart';
import 'screens/job_details_screen.dart';
import 'screens/main_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/privacy_policy_screen.dart';
import 'screens/profile_completion_screen.dart';
import 'screens/resume_screen.dart';
import 'screens/salary_insights_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/skill_assessment_screen.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const JobBoardApp());
}

class JobBoardApp extends StatelessWidget {
  const JobBoardApp({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => JobProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          return MaterialApp.router(
            title: 'Job Board - Premium Template',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settingsProvider.settings.themeMode,
            debugShowCheckedModeBanner: false,
            routerConfig: _router,
          );
        },
      ),
    );
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const MainScreen()),
    GoRoute(
      path: '/job/:id',
      builder: (context, state) {
        final jobId = state.pathParameters['id']!;
        return JobDetailsScreen(jobId: jobId);
      },
    ),
    GoRoute(path: '/all-jobs', builder: (context, state) => const AllJobsScreen()),
    GoRoute(path: '/notifications', builder: (context, state) => const NotificationsScreen()),
    GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
    GoRoute(path: '/edit-profile', builder: (context, state) => const EditProfileScreen()),
    GoRoute(path: '/help', builder: (context, state) => const HelpSupportScreen()),
    GoRoute(path: '/privacy', builder: (context, state) => const PrivacyPolicyScreen()),
    GoRoute(path: '/about', builder: (context, state) => const AboutScreen()),
    GoRoute(path: '/resume', builder: (context, state) => const ResumeScreen()),
    GoRoute(path: '/applications', builder: (context, state) => const ApplicationHistoryScreen()),
    GoRoute(path: '/salary-insights', builder: (context, state) => const SalaryInsightsScreen()),
    GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingScreen()),
    GoRoute(path: '/auth', builder: (context, state) => const AuthScreen()),
    GoRoute(path: '/profile-completion', builder: (context, state) => const ProfileCompletionScreen()),
    GoRoute(
      path: '/skill-assessment/:skill',
      builder: (context, state) => SkillAssessmentScreen(skillName: state.pathParameters['skill'] ?? 'Unknown'),
    ),
    GoRoute(path: '/admin', builder: (context, state) => const AdminDashboardScreen()),
    GoRoute(path: '/admin/post-job', builder: (context, state) => const PostJobScreen()),
    GoRoute(path: '/admin/applications', builder: (context, state) => const ApplicantManagementScreen()),
  ],
);
