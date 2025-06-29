import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Last updated: ${DateTime.now().year}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),

            _buildSection(
              context,
              'Information We Collect',
              'We collect information you provide directly to us, such as when you create an account, update your profile, or contact us for support. This may include your name, email address, phone number, location, and professional information.',
            ),

            _buildSection(
              context,
              'How We Use Your Information',
              'We use the information we collect to:\n\n• Provide and maintain our services\n• Send you job alerts and notifications\n• Improve our app and user experience\n• Communicate with you about updates and support\n• Ensure the security of our platform',
            ),

            _buildSection(
              context,
              'Information Sharing',
              'We do not sell, trade, or otherwise transfer your personal information to third parties without your consent, except as described in this policy. We may share your information with:\n\n• Employers when you apply for jobs\n• Service providers who assist us in operating our platform\n• Legal authorities when required by law',
            ),

            _buildSection(
              context,
              'Data Security',
              'We implement appropriate security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction. However, no method of transmission over the internet is 100% secure.',
            ),

            _buildSection(
              context,
              'Your Rights',
              'You have the right to:\n\n• Access your personal information\n• Update or correct your information\n• Delete your account and data\n• Opt out of marketing communications\n• Request a copy of your data',
            ),

            _buildSection(
              context,
              'Cookies and Tracking',
              'We use cookies and similar technologies to enhance your experience, analyze usage patterns, and provide personalized content. You can control cookie settings through your device preferences.',
            ),

            _buildSection(
              context,
              'Children\'s Privacy',
              'Our service is not intended for children under 13 years of age. We do not knowingly collect personal information from children under 13.',
            ),

            _buildSection(
              context,
              'Changes to This Policy',
              'We may update this privacy policy from time to time. We will notify you of any changes by posting the new policy on this page and updating the "Last updated" date.',
            ),

            _buildSection(
              context,
              'Contact Us',
              'If you have any questions about this privacy policy, please contact us at:\n\nEmail: privacy@jobboard.com\nPhone: +1 (555) 123-4567\nAddress: 123 Privacy St, San Francisco, CA 94102',
            ),

            const SizedBox(height: 32),
            Center(
              child: Text(
                '© ${DateTime.now().year} Job Board App. All rights reserved.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );

  Widget _buildSection(BuildContext context, String title, String content) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
      ],
    );
}
