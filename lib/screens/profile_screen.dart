import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/favorites_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.go('/settings');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Icon(Icons.person, size: 50, color: Theme.of(context).colorScheme.onPrimary),
                    ),
                    const SizedBox(height: 16),
                    Text('John Doe', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 4),
                    Text(
                      'Software Developer',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'San Francisco, CA',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () {
                        context.go('/edit-profile');
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit Profile'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Stats section
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Icon(Icons.work_outline, size: 32, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(height: 8),
                          Text('12', style: Theme.of(context).textTheme.headlineMedium),
                          Text('Applications', style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Icon(Icons.favorite_outline, size: 32, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(height: 8),
                          Consumer<FavoritesProvider>(
                            builder: (context, favoritesProvider, child) => Text(
                                '${favoritesProvider.favoritesCount}',
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                          ),
                          Text('Favorites', style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Menu items
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.analytics_outlined),
                    title: const Text('Profile Completion'),
                    subtitle: const Text('Track your profile progress'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      context.go('/profile-completion');
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.description_outlined),
                    title: const Text('My Resume'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      context.go('/resume');
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.history),
                    title: const Text('Application History'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      context.go('/applications');
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.bookmark_outline),
                    title: const Text('Saved Searches'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(const SnackBar(content: Text('Saved searches feature coming soon')));
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.notifications_outlined),
                    title: const Text('Notifications'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      context.go('/settings');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Account section
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined),
                    title: const Text('Privacy Policy'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      context.go('/privacy');
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.help_outline),
                    title: const Text('Help & Support'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      context.go('/help');
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('About'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      context.go('/about');
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.logout, color: Theme.of(context).colorScheme.error),
                    title: Text('Sign Out', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                    onTap: () {
                      _showSignOutDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Clear user session and navigate to login
              // For now, just show a success message
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Signed out successfully'), backgroundColor: Colors.green));
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
