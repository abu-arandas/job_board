import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/animated_widgets.dart';
import '../../widgets/premium_components.dart';

class PostJobScreen extends StatefulWidget {
  const PostJobScreen({super.key});

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _companyController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _requirementsController = TextEditingController();
  final _benefitsController = TextEditingController();
  final _salaryMinController = TextEditingController();
  final _salaryMaxController = TextEditingController();

  String _selectedJobType = 'Full-time';
  String _selectedExperienceLevel = 'Mid-level';
  bool _isRemote = false;
  bool _isUrgent = false;
  bool _isFeatured = false;
  bool _isLoading = false;

  final List<String> _jobTypes = ['Full-time', 'Part-time', 'Contract', 'Freelance', 'Internship'];

  final List<String> _experienceLevels = ['Entry-level', 'Mid-level', 'Senior-level', 'Executive'];

  final List<String> _skills = [];
  final _skillController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _companyController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _requirementsController.dispose();
    _benefitsController.dispose();
    _salaryMinController.dispose();
    _salaryMaxController.dispose();
    _skillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Post New Job'),
      actions: [TextButton(onPressed: _saveAsDraft, child: const Text('Save Draft'))],
    ),
    body: Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Basic Information
            FadeInSlideUp(
              child: _buildSection('Basic Information', [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Job Title *',
                    hintText: 'e.g., Senior Flutter Developer',
                    prefixIcon: Icon(Icons.work_outline),
                  ),
                  validator: (value) => value?.isEmpty == true ? 'Job title is required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _companyController,
                  decoration: const InputDecoration(
                    labelText: 'Company Name *',
                    hintText: 'e.g., TechCorp Inc.',
                    prefixIcon: Icon(Icons.business),
                  ),
                  validator: (value) => value?.isEmpty == true ? 'Company name is required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location *',
                    hintText: 'e.g., San Francisco, CA',
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                  validator: (value) => value?.isEmpty == true ? 'Location is required' : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedJobType,
                        decoration: const InputDecoration(labelText: 'Job Type *', prefixIcon: Icon(Icons.schedule)),
                        items: _jobTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedJobType = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedExperienceLevel,
                        decoration: const InputDecoration(
                          labelText: 'Experience Level *',
                          prefixIcon: Icon(Icons.trending_up),
                        ),
                        items: _experienceLevels
                            .map((level) => DropdownMenuItem(value: level, child: Text(level)))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedExperienceLevel = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ]),
            ),
            const SizedBox(height: 24),

            // Job Details
            FadeInSlideUp(
              delay: const Duration(milliseconds: 200),
              child: _buildSection('Job Details', [
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Job Description *',
                    hintText: 'Describe the role, responsibilities, and what makes this opportunity exciting...',
                    alignLabelWithHint: true,
                  ),
                  maxLines: 6,
                  validator: (value) => value?.isEmpty == true ? 'Job description is required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _requirementsController,
                  decoration: const InputDecoration(
                    labelText: 'Requirements *',
                    hintText: 'List the required skills, experience, and qualifications...',
                    alignLabelWithHint: true,
                  ),
                  maxLines: 4,
                  validator: (value) => value?.isEmpty == true ? 'Requirements are required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _benefitsController,
                  decoration: const InputDecoration(
                    labelText: 'Benefits & Perks',
                    hintText: 'Health insurance, flexible hours, remote work, etc...',
                    alignLabelWithHint: true,
                  ),
                  maxLines: 3,
                ),
              ]),
            ),
            const SizedBox(height: 24),

            // Skills
            FadeInSlideUp(
              delay: const Duration(milliseconds: 400),
              child: _buildSection('Required Skills', [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _skillController,
                        decoration: const InputDecoration(
                          labelText: 'Add Skill',
                          hintText: 'e.g., Flutter, React, Python',
                        ),
                        onFieldSubmitted: _addSkill,
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(onPressed: () => _addSkill(_skillController.text), child: const Text('Add')),
                  ],
                ),
                const SizedBox(height: 16),
                if (_skills.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _skills
                        .map((skill) => Chip(label: Text(skill), onDeleted: () => _removeSkill(skill)))
                        .toList(),
                  ),
              ]),
            ),
            const SizedBox(height: 24),

            // Compensation
            FadeInSlideUp(
              delay: const Duration(milliseconds: 600),
              child: _buildSection('Compensation', [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _salaryMinController,
                        decoration: const InputDecoration(
                          labelText: 'Minimum Salary',
                          hintText: '80000',
                          prefixText: r'$ ',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _salaryMaxController,
                        decoration: const InputDecoration(
                          labelText: 'Maximum Salary',
                          hintText: '120000',
                          prefixText: r'$ ',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ]),
            ),
            const SizedBox(height: 24),

            // Job Options
            FadeInSlideUp(
              delay: const Duration(milliseconds: 800),
              child: _buildSection('Job Options', [
                SwitchListTile(
                  title: const Text('Remote Work Available'),
                  subtitle: const Text('This position can be done remotely'),
                  value: _isRemote,
                  onChanged: (value) {
                    setState(() {
                      _isRemote = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text('Urgent Hiring'),
                  subtitle: const Text('Mark this job as urgent to attract more attention'),
                  value: _isUrgent,
                  onChanged: (value) {
                    setState(() {
                      _isUrgent = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text('Featured Job'),
                  subtitle: const Text('Promote this job for better visibility (additional cost)'),
                  value: _isFeatured,
                  onChanged: (value) {
                    setState(() {
                      _isFeatured = value;
                    });
                  },
                ),
              ]),
            ),
            const SizedBox(height: 32),

            // Action buttons
            FadeInSlideUp(
              delay: const Duration(milliseconds: 1000),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: PremiumButton(
                      text: 'Post Job',
                      icon: Icons.publish,
                      onPressed: _postJob,
                      isLoading: _isLoading,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: PremiumButton(
                      text: 'Preview Job',
                      icon: Icons.preview,
                      onPressed: _previewJob,
                      isOutlined: true,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    ),
  );

  Widget _buildSection(String title, List<Widget> children) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    ),
  );

  void _addSkill(String skill) {
    if (skill.isNotEmpty && !_skills.contains(skill)) {
      setState(() {
        _skills.add(skill);
        _skillController.clear();
      });
    }
  }

  void _removeSkill(String skill) {
    setState(() {
      _skills.remove(skill);
    });
  }

  Future<void> _postJob() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Job posted successfully!'), backgroundColor: Colors.green));
      context.pop();
    }
  }

  void _previewJob() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Job preview feature coming soon')));
  }

  void _saveAsDraft() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Job saved as draft'), backgroundColor: Colors.blue));
  }
}
