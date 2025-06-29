import 'package:flutter/material.dart' hide ThemeMode;
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SettingsProvider>().loadSettings();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'reset') {
                _showResetDialog();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'reset',
                child: Row(children: [Icon(Icons.restore), SizedBox(width: 8), Text('Reset to defaults')]),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          if (settingsProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (settingsProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
                  const SizedBox(height: 16),
                  Text('Something went wrong', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(
                    settingsProvider.error!,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      settingsProvider.loadSettings();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final settings = settingsProvider.settings;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Appearance section
                _buildSectionHeader('Appearance'),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.palette_outlined),
                        title: const Text('Theme'),
                        subtitle: Text(settings.themeModeDisplayName),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _showThemeDialog(settingsProvider),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Notifications section
                _buildSectionHeader('Notifications'),
                Card(
                  child: Column(
                    children: [
                      SwitchListTile(
                        secondary: const Icon(Icons.notifications_outlined),
                        title: const Text('Enable Notifications'),
                        subtitle: const Text('Receive push notifications'),
                        value: settings.notificationsEnabled,
                        onChanged: (value) {
                          settingsProvider.updateNotificationSetting('notificationsEnabled', value);
                        },
                      ),
                      const Divider(height: 1),
                      SwitchListTile(
                        secondary: const Icon(Icons.work_outline),
                        title: const Text('Job Alerts'),
                        subtitle: const Text('Get notified about new job matches'),
                        value: settings.jobAlertsEnabled,
                        onChanged: settings.notificationsEnabled
                            ? (value) {
                                settingsProvider.updateNotificationSetting('jobAlertsEnabled', value);
                              }
                            : null,
                      ),
                      const Divider(height: 1),
                      SwitchListTile(
                        secondary: const Icon(Icons.update),
                        title: const Text('Application Updates'),
                        subtitle: const Text('Get updates on your job applications'),
                        value: settings.applicationUpdatesEnabled,
                        onChanged: settings.notificationsEnabled
                            ? (value) {
                                settingsProvider.updateNotificationSetting('applicationUpdatesEnabled', value);
                              }
                            : null,
                      ),
                      const Divider(height: 1),
                      SwitchListTile(
                        secondary: const Icon(Icons.email_outlined),
                        title: const Text('Marketing Emails'),
                        subtitle: const Text('Receive promotional emails'),
                        value: settings.marketingEmailsEnabled,
                        onChanged: (value) {
                          settingsProvider.updateNotificationSetting('marketingEmailsEnabled', value);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Job Search section
                _buildSectionHeader('Job Search'),
                Card(
                  child: Column(
                    children: [
                      SwitchListTile(
                        secondary: const Icon(Icons.auto_awesome),
                        title: const Text('Auto-apply Filters'),
                        subtitle: const Text('Remember and apply your last search filters'),
                        value: settings.autoApplyFilters,
                        onChanged: (value) {
                          settingsProvider.updateSetting('autoApplyFilters', value);
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.attach_money),
                        title: const Text('Max Salary Alerts'),
                        subtitle: Text('Alert for jobs up to \$${settings.maxSalaryAlerts}k'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _showSalaryDialog(settingsProvider),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // About section
                _buildSectionHeader('About'),
                const Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.info_outline),
                        title: Text('App Version'),
                        subtitle: Text('1.0.0'),
                      ),
                      Divider(height: 1),
                      ListTile(
                        leading: Icon(Icons.code),
                        title: Text('Built with Flutter'),
                        subtitle: Text('Cross-platform job board app'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

  Widget _buildSectionHeader(String title) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
      ),
    );

  void _showThemeDialog(SettingsProvider settingsProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ThemeMode.values.map((mode) => RadioListTile<ThemeMode>(
              title: Text(mode.name),
              value: mode,
              groupValue: settingsProvider.settings.themeMode,
              onChanged: (value) {
                if (value != null) {
                  settingsProvider.updateThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
            )).toList(),
        ),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel'))],
      ),
    );
  }

  void _showSalaryDialog(SettingsProvider settingsProvider) {
    var currentValue = settingsProvider.settings.maxSalaryAlerts;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Max Salary Alerts'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Alert for jobs up to \$${currentValue}k'),
              const SizedBox(height: 16),
              Slider(
                value: currentValue.toDouble(),
                min: 30,
                max: 300,
                divisions: 27,
                label: '\$${currentValue}k',
                onChanged: (value) {
                  setState(() {
                    currentValue = value.round();
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                settingsProvider.updateSetting('maxSalaryAlerts', currentValue);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text(
          'Are you sure you want to reset all settings to their default values? This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final success = await context.read<SettingsProvider>().resetSettings();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(success ? 'Settings reset to defaults' : 'Failed to reset settings')),
                );
              }
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
