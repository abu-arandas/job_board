import 'package:flutter/material.dart';

class ResumeScreen extends StatefulWidget {
  const ResumeScreen({super.key});

  @override
  State<ResumeScreen> createState() => _ResumeScreenState();
}

class _ResumeScreenState extends State<ResumeScreen> {
  bool _hasResume = false;
  String? _resumeFileName;
  DateTime? _uploadDate;

  @override
  void initState() {
    super.initState();
    // Simulate checking for existing resume
    _checkForExistingResume();
  }

  void _checkForExistingResume() {
    // Simulate having a resume
    setState(() {
      _hasResume = true;
      _resumeFileName = 'John_Doe_Resume.pdf';
      _uploadDate = DateTime.now().subtract(const Duration(days: 15));
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('My Resume'),
        actions: [
          if (_hasResume)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'delete') {
                  _showDeleteDialog();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete Resume'),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _hasResume ? _buildResumeView() : _buildNoResumeView(),
      ),
    );

  Widget _buildNoResumeView() => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.description_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 24),
          Text(
            'No Resume Uploaded',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Upload your resume to make it easier for employers to find you',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: _uploadResume,
            icon: const Icon(Icons.upload_file),
            label: const Text('Upload Resume'),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _createResume,
            icon: const Icon(Icons.edit_document),
            label: const Text('Create Resume'),
          ),
        ],
      ),
    );

  Widget _buildResumeView() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Resume card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.picture_as_pdf,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _resumeFileName!,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Uploaded ${_formatDate(_uploadDate!)}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: _showResumeOptions,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _viewResume,
                        icon: const Icon(Icons.visibility),
                        label: const Text('View'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _downloadResume,
                        icon: const Icon(Icons.download),
                        label: const Text('Download'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Actions section
        Text(
          'Resume Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.upload_file),
                title: const Text('Upload New Resume'),
                subtitle: const Text('Replace your current resume'),
                trailing: const Icon(Icons.chevron_right),
                onTap: _uploadResume,
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit Resume'),
                subtitle: const Text('Make changes to your resume'),
                trailing: const Icon(Icons.chevron_right),
                onTap: _editResume,
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share Resume'),
                subtitle: const Text('Share with employers or contacts'),
                trailing: const Icon(Icons.chevron_right),
                onTap: _shareResume,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Tips section
        Card(
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Resume Tips',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '• Keep your resume updated with recent experience\n'
                  '• Use PDF format for best compatibility\n'
                  '• Include relevant keywords for your industry\n'
                  '• Keep it concise (1-2 pages maximum)\n'
                  '• Proofread for spelling and grammar errors',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) {
      return 'today';
    } else if (difference == 1) {
      return 'yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else if (difference < 30) {
      final weeks = (difference / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else {
      final months = (difference / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    }
  }

  void _uploadResume() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('File picker not implemented yet')),
    );
  }

  void _createResume() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Resume builder coming soon')),
    );
  }

  void _viewResume() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Resume viewer not implemented yet')),
    );
  }

  void _downloadResume() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Resume downloaded successfully')),
    );
  }

  void _editResume() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Resume editor coming soon')),
    );
  }

  void _shareResume() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share functionality not implemented yet')),
    );
  }

  void _showResumeOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.visibility),
            title: const Text('View Resume'),
            onTap: () {
              Navigator.pop(context);
              _viewResume();
            },
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Download'),
            onTap: () {
              Navigator.pop(context);
              _downloadResume();
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share'),
            onTap: () {
              Navigator.pop(context);
              _shareResume();
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Delete', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              _showDeleteDialog();
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Resume'),
        content: const Text('Are you sure you want to delete your resume? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _hasResume = false;
                _resumeFileName = null;
                _uploadDate = null;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Resume deleted')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
