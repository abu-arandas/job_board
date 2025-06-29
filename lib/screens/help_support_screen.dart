import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FAQ Section
            _buildSectionHeader(context, 'Frequently Asked Questions'),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  _buildFAQItem(
                    'How do I apply for a job?',
                    'Tap on any job card to view details, then tap the "Apply Now" button. You\'ll be redirected to the company\'s application page or email.',
                  ),
                  const Divider(height: 1),
                  _buildFAQItem(
                    'How do I save jobs to favorites?',
                    'Tap the heart icon on any job card to add it to your favorites. You can view all saved jobs in the Favorites tab.',
                  ),
                  const Divider(height: 1),
                  _buildFAQItem(
                    'How do I search for specific jobs?',
                    'Use the Search tab to enter keywords, location, and apply filters like job type, experience level, and salary range.',
                  ),
                  const Divider(height: 1),
                  _buildFAQItem(
                    'How do I update my profile?',
                    'Go to the Profile tab and tap "Edit Profile" to update your information, skills, and social links.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Contact Section
            _buildSectionHeader(context, 'Contact Us'),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.email_outlined),
                    title: const Text('Email Support'),
                    subtitle: const Text('support@jobboard.com'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _launchEmail('support@jobboard.com'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.phone_outlined),
                    title: const Text('Phone Support'),
                    subtitle: const Text('+1 (555) 123-4567'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _launchPhone('+15551234567'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.chat_outlined),
                    title: const Text('Live Chat'),
                    subtitle: const Text('Available 9 AM - 5 PM PST'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Live chat not available yet')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Resources Section
            _buildSectionHeader(context, 'Resources'),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.article_outlined),
                    title: const Text('User Guide'),
                    subtitle: const Text('Learn how to use the app'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('User guide coming soon')),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.video_library_outlined),
                    title: const Text('Video Tutorials'),
                    subtitle: const Text('Watch step-by-step guides'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Video tutorials coming soon')),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.forum_outlined),
                    title: const Text('Community Forum'),
                    subtitle: const Text('Connect with other job seekers'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Community forum coming soon')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Feedback Section
            _buildSectionHeader(context, 'Feedback'),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'We value your feedback!',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Help us improve the app by sharing your thoughts and suggestions.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => _launchEmail('feedback@jobboard.com'),
                        icon: const Icon(Icons.feedback_outlined),
                        label: const Text('Send Feedback'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

  Widget _buildSectionHeader(BuildContext context, String title) => Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );

  Widget _buildFAQItem(String question, String answer) => ExpansionTile(
      title: Text(question),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(answer),
        ),
      ],
    );

  Future<void> _launchEmail(String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchPhone(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
