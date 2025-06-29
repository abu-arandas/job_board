import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/models.dart';
import '../services/profile_completion_service.dart';
import '../widgets/animated_widgets.dart';
import '../widgets/premium_components.dart';

class ProfileCompletionScreen extends StatefulWidget {
  const ProfileCompletionScreen({super.key});

  @override
  State<ProfileCompletionScreen> createState() => _ProfileCompletionScreenState();
}

class _ProfileCompletionScreenState extends State<ProfileCompletionScreen> {
  final _profileService = ProfileCompletionService();
  late ProfileCompletionResult _completionResult;

  // Mock user data - in real app, get from provider/service
  final User _mockUser = User(
    id: '1',
    name: 'John Doe',
    email: 'john.doe@email.com',
    phone: '+1 (555) 123-4567',
    location: 'San Francisco, CA',
    title: 'Software Developer',
    bio: 'Passionate software developer with 5+ years of experience.',
    skills: ['Flutter', 'Dart', 'React'],
    jobTitle: 'Senior Flutter Developer',
    experienceLevel: 'Senior',
    preferredJobTypes: ['Full-time', 'Remote'],
    createdAt: DateTime.now(),
  );

  @override
  void initState() {
    super.initState();
    _completionResult = _profileService.calculateCompletion(_mockUser);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Profile Completion'),
        actions: [IconButton(icon: const Icon(Icons.help_outline), onPressed: _showHelpDialog)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Completion Overview
            FadeInSlideUp(child: _buildCompletionOverview()),
            const SizedBox(height: 24),

            // Recommendations
            if (_completionResult.recommendations.isNotEmpty) ...[
              FadeInSlideUp(delay: const Duration(milliseconds: 200), child: _buildRecommendations()),
              const SizedBox(height: 24),
            ],

            // Completion Checklist
            FadeInSlideUp(delay: const Duration(milliseconds: 400), child: _buildCompletionChecklist()),
          ],
        ),
      ),
    );

  Widget _buildCompletionOverview() => GradientCard(
      gradient: _getGradientForLevel(_completionResult.level),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_getIconForLevel(_completionResult.level), color: Colors.white, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_completionResult.percentage}% Complete',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _completionResult.levelDisplayName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white.withOpacity(0.9)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Progress bar
          Container(
            height: 8,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), borderRadius: BorderRadius.circular(4)),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: _completionResult.percentage / 100,
              child: Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            _completionResult.levelDescription,
            style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 16),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(child: _buildStatItem('Completed', '${_completionResult.completedItems}', Icons.check_circle)),
              Expanded(
                child: _buildStatItem(
                  'Remaining',
                  '${_completionResult.totalItems - _completionResult.completedItems}',
                  Icons.pending,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'High Priority',
                  '${_completionResult.highPriorityIncomplete.length}',
                  Icons.priority_high,
                ),
              ),
            ],
          ),
        ],
      ),
    );

  Widget _buildStatItem(String label, String value, IconData icon) => Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(label, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
        ],
      ),
    );

  Widget _buildRecommendations() => Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Recommendations',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._completionResult.recommendations.map((recommendation) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      recommendation.startsWith('•') ? Icons.arrow_right : Icons.info_outline,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        recommendation.startsWith('•') ? recommendation.substring(2) : recommendation,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              )),
          ],
        ),
      ),
    );

  Widget _buildCompletionChecklist() {
    final groupedChecks = <String, List<ProfileCheck>>{};
    for (final check in _completionResult.checks) {
      groupedChecks.putIfAbsent(check.category, () => []).add(check);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Completion Checklist',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...groupedChecks.entries.map((entry) => _buildChecklistCategory(entry.key, entry.value)),
      ],
    );
  }

  Widget _buildChecklistCategory(String category, List<ProfileCheck> checks) => Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            ...checks.map(_buildChecklistItem),
          ],
        ),
      ),
    );

  Widget _buildChecklistItem(ProfileCheck check) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: check.isCompleted ? Colors.green : _getPriorityColor(check.priority).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: check.isCompleted ? null : Border.all(color: _getPriorityColor(check.priority)),
            ),
            child: Icon(
              check.isCompleted ? Icons.check : _getPriorityIcon(check.priority),
              size: 16,
              color: check.isCompleted ? Colors.white : _getPriorityColor(check.priority),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  check.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    decoration: check.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                Text(
                  check.description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          if (!check.isCompleted)
            IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: () => _editProfileSection(check)),
        ],
      ),
    );

  Gradient _getGradientForLevel(ProfileCompletionLevel level) {
    switch (level) {
      case ProfileCompletionLevel.starter:
        return const LinearGradient(colors: [Colors.red, Colors.orange]);
      case ProfileCompletionLevel.beginner:
        return const LinearGradient(colors: [Colors.orange, Colors.amber]);
      case ProfileCompletionLevel.intermediate:
        return const LinearGradient(colors: [Colors.amber, Colors.blue]);
      case ProfileCompletionLevel.advanced:
        return const LinearGradient(colors: [Colors.blue, Colors.green]);
      case ProfileCompletionLevel.expert:
        return const LinearGradient(colors: [Colors.green, Colors.teal]);
    }
  }

  IconData _getIconForLevel(ProfileCompletionLevel level) {
    switch (level) {
      case ProfileCompletionLevel.starter:
        return Icons.play_arrow;
      case ProfileCompletionLevel.beginner:
        return Icons.trending_up;
      case ProfileCompletionLevel.intermediate:
        return Icons.star_half;
      case ProfileCompletionLevel.advanced:
        return Icons.star;
      case ProfileCompletionLevel.expert:
        return Icons.emoji_events;
    }
  }

  Color _getPriorityColor(ProfilePriority priority) {
    switch (priority) {
      case ProfilePriority.high:
        return Colors.red;
      case ProfilePriority.medium:
        return Colors.orange;
      case ProfilePriority.low:
        return Colors.blue;
    }
  }

  IconData _getPriorityIcon(ProfilePriority priority) {
    switch (priority) {
      case ProfilePriority.high:
        return Icons.priority_high;
      case ProfilePriority.medium:
        return Icons.remove;
      case ProfilePriority.low:
        return Icons.keyboard_arrow_down;
    }
  }

  void _editProfileSection(ProfileCheck check) {
    // Navigate to appropriate edit screen based on check
    if (check.title.contains('Photo')) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Photo upload feature coming soon')));
    } else {
      context.go('/edit-profile');
    }
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Profile Completion Help'),
        content: const Text(
          'Complete your profile to increase your visibility to employers. '
          'Higher completion rates lead to more job opportunities and better matches.',
        ),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Got it'))],
      ),
    );
  }
}
