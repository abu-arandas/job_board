import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/animated_widgets.dart';
import '../widgets/premium_components.dart';

class SkillAssessmentScreen extends StatefulWidget {

  const SkillAssessmentScreen({
    required this.skillName, super.key,
  });
  final String skillName;

  @override
  State<SkillAssessmentScreen> createState() => _SkillAssessmentScreenState();
}

class _SkillAssessmentScreenState extends State<SkillAssessmentScreen> {
  int _currentQuestionIndex = 0;
  final Map<int, int> _answers = {};
  bool _isCompleted = false;
  int? _finalScore;

  late List<AssessmentQuestion> _questions;

  @override
  void initState() {
    super.initState();
    _questions = _generateQuestionsForSkill(widget.skillName);
  }

  @override
  Widget build(BuildContext context) {
    if (_isCompleted) {
      return _buildResultsScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.skillName} Assessment'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: _showExitDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          FadeInSlideUp(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '${((_currentQuestionIndex + 1) / _questions.length * 100).round()}%',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: (_currentQuestionIndex + 1) / _questions.length,
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Question content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: FadeInSlideUp(
                key: ValueKey(_currentQuestionIndex),
                child: _buildQuestionCard(_questions[_currentQuestionIndex]),
              ),
            ),
          ),

          // Navigation buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (_currentQuestionIndex > 0)
                  Expanded(
                    child: PremiumButton(
                      text: 'Previous',
                      onPressed: _previousQuestion,
                      isOutlined: true,
                    ),
                  ),
                if (_currentQuestionIndex > 0) const SizedBox(width: 16),
                Expanded(
                  flex: _currentQuestionIndex == 0 ? 1 : 2,
                  child: PremiumButton(
                    text: _currentQuestionIndex == _questions.length - 1 ? 'Finish' : 'Next',
                    onPressed: _canProceed() ? _nextQuestion : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(AssessmentQuestion question) => Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question type badge
            StatusBadge(
              text: question.type.displayName,
              color: _getColorForType(question.type),
              icon: _getIconForType(question.type),
            ),
            const SizedBox(height: 16),

            // Question text
            Text(
              question.question,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            if (question.description != null) ...[
              Text(
                question.description!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Answer options
            ...question.options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              final isSelected = _answers[_currentQuestionIndex] == index;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () => _selectAnswer(index),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outline,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: isSelected
                          ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1)
                          : null,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.outline,
                              width: 2,
                            ),
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : null,
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            option,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: isSelected ? FontWeight.w600 : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );

  Widget _buildResultsScreen() {
    final percentage = (_finalScore! / _questions.length * 100).round();
    final level = _getSkillLevel(percentage);
    final levelColor = _getColorForLevel(level);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assessment Results'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Results overview
            FadeInSlideUp(
              child: GradientCard(
                gradient: LinearGradient(
                  colors: [levelColor, levelColor.withOpacity(0.7)],
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      size: 64,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Assessment Complete!',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.skillName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildResultStat('Score', '$_finalScore/${_questions.length}'),
                        _buildResultStat('Percentage', '$percentage%'),
                        _buildResultStat('Level', level),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Skill level explanation
            FadeInSlideUp(
              delay: const Duration(milliseconds: 200),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Skill Level',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: levelColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              _getIconForLevel(level),
                              color: levelColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  level,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: levelColor,
                                  ),
                                ),
                                Text(
                                  _getLevelDescription(level),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Action buttons
            FadeInSlideUp(
              delay: const Duration(milliseconds: 400),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: PremiumButton(
                      text: 'Add to Profile',
                      icon: Icons.add,
                      onPressed: _addToProfile,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: PremiumButton(
                      text: 'Retake Assessment',
                      icon: Icons.refresh,
                      onPressed: _retakeAssessment,
                      isOutlined: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: PremiumButton(
                      text: 'Share Results',
                      icon: Icons.share,
                      onPressed: _shareResults,
                      isOutlined: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultStat(String label, String value) => Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );

  List<AssessmentQuestion> _generateQuestionsForSkill(String skill) {
    // This would typically come from an API or database
    // For demo purposes, generating sample questions
    return [
      AssessmentQuestion(
        question: 'How would you rate your experience with $skill?',
        options: [
          'Beginner - Just starting to learn',
          'Intermediate - Some hands-on experience',
          'Advanced - Extensive experience',
          'Expert - Can teach others',
        ],
        type: AssessmentQuestionType.selfAssessment,
      ),
      AssessmentQuestion(
        question: 'Which best describes your $skill project experience?',
        options: [
          'Personal projects only',
          'Small team projects',
          'Large-scale applications',
          'Enterprise-level systems',
        ],
        type: AssessmentQuestionType.experience,
      ),
      AssessmentQuestion(
        question: 'How comfortable are you with advanced $skill concepts?',
        options: [
          'Not comfortable at all',
          'Somewhat comfortable',
          'Very comfortable',
          'Extremely comfortable',
        ],
        type: AssessmentQuestionType.knowledge,
      ),
    ];
  }

  bool _canProceed() => _answers.containsKey(_currentQuestionIndex);

  void _selectAnswer(int answerIndex) {
    setState(() {
      _answers[_currentQuestionIndex] = answerIndex;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _completeAssessment();
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  void _completeAssessment() {
    // Calculate score based on answers
    var score = 0;
    for (var i = 0; i < _questions.length; i++) {
      final answer = _answers[i] ?? 0;
      score += answer; // Simple scoring - in real app, this would be more sophisticated
    }

    setState(() {
      _finalScore = score;
      _isCompleted = true;
    });
  }

  String _getSkillLevel(int percentage) {
    if (percentage >= 80) return 'Expert';
    if (percentage >= 60) return 'Advanced';
    if (percentage >= 40) return 'Intermediate';
    return 'Beginner';
  }

  Color _getColorForLevel(String level) {
    switch (level) {
      case 'Expert':
        return Colors.green;
      case 'Advanced':
        return Colors.blue;
      case 'Intermediate':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getIconForLevel(String level) {
    switch (level) {
      case 'Expert':
        return Icons.emoji_events;
      case 'Advanced':
        return Icons.star;
      case 'Intermediate':
        return Icons.star_half;
      default:
        return Icons.star_border;
    }
  }

  String _getLevelDescription(String level) {
    switch (level) {
      case 'Expert':
        return 'You have mastery-level knowledge and can mentor others';
      case 'Advanced':
        return 'You have strong knowledge and can work independently';
      case 'Intermediate':
        return 'You have good foundational knowledge with room to grow';
      default:
        return 'You\'re just getting started - keep learning!';
    }
  }

  Color _getColorForType(AssessmentQuestionType type) {
    switch (type) {
      case AssessmentQuestionType.selfAssessment:
        return Colors.blue;
      case AssessmentQuestionType.knowledge:
        return Colors.green;
      case AssessmentQuestionType.experience:
        return Colors.orange;
      case AssessmentQuestionType.practical:
        return Colors.purple;
    }
  }

  IconData _getIconForType(AssessmentQuestionType type) {
    switch (type) {
      case AssessmentQuestionType.selfAssessment:
        return Icons.person;
      case AssessmentQuestionType.knowledge:
        return Icons.psychology;
      case AssessmentQuestionType.experience:
        return Icons.work;
      case AssessmentQuestionType.practical:
        return Icons.code;
    }
  }

  void _addToProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.skillName} skill added to your profile!'),
        backgroundColor: Colors.green,
      ),
    );
    context.pop();
  }

  void _retakeAssessment() {
    setState(() {
      _currentQuestionIndex = 0;
      _answers.clear();
      _isCompleted = false;
      _finalScore = null;
    });
  }

  void _shareResults() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share functionality coming soon')),
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Assessment'),
        content: const Text('Are you sure you want to exit? Your progress will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Continue'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.pop();
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }
}

class AssessmentQuestion {

  AssessmentQuestion({
    required this.question,
    required this.options, required this.type, this.description,
    this.correctAnswer,
  });
  final String question;
  final String? description;
  final List<String> options;
  final int? correctAnswer;
  final AssessmentQuestionType type;
}

enum AssessmentQuestionType {
  selfAssessment,
  knowledge,
  experience,
  practical,
}

extension AssessmentQuestionTypeExtension on AssessmentQuestionType {
  String get displayName {
    switch (this) {
      case AssessmentQuestionType.selfAssessment:
        return 'Self Assessment';
      case AssessmentQuestionType.knowledge:
        return 'Knowledge';
      case AssessmentQuestionType.experience:
        return 'Experience';
      case AssessmentQuestionType.practical:
        return 'Practical';
    }
  }
}
