import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/social_service.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_widgets.dart';
import '../widgets/premium_components.dart';

class ReferralScreen extends StatefulWidget {
  const ReferralScreen({super.key});

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  final _socialService = SocialService();
  ReferralCode? _referralCode;
  List<ReferralStats> _stats = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReferralData();
  }

  Future<void> _loadReferralData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Mock user ID - in real app, get from auth service
      const userId = 'current_user_123';
      
      var referralCode = await _socialService.getReferralCode(userId);
      referralCode ??= await _socialService.generateReferralCode(userId);

      final stats = await _socialService.getReferralStats(userId);

      setState(() {
        _referralCode = referralCode;
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load referral data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Refer & Earn'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showHelpDialog,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Header
                  FadeInSlideUp(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(32),
                          bottomRight: Radius.circular(32),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.card_giftcard,
                            size: 64,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Earn \$${_referralCode?.reward.referrerBonus.toStringAsFixed(0) ?? '50'} for Each Referral',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Share your code and earn rewards when friends join',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Referral code
                        FadeInSlideUp(
                          delay: const Duration(milliseconds: 200),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  Text(
                                    'Your Referral Code',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Theme.of(context).colorScheme.primary,
                                        width: 2,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          _referralCode?.code ?? 'LOADING...',
                                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).colorScheme.primary,
                                            letterSpacing: 2,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        IconButton(
                                          onPressed: _copyReferralCode,
                                          icon: Icon(
                                            Icons.copy,
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: PremiumButton(
                                          text: 'Share Code',
                                          icon: Icons.share,
                                          onPressed: _shareReferralCode,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: PremiumButton(
                                          text: 'Copy Link',
                                          icon: Icons.link,
                                          onPressed: _copyReferralLink,
                                          isOutlined: true,
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

                        // How it works
                        FadeInSlideUp(
                          delay: const Duration(milliseconds: 400),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'How It Works',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _buildHowItWorksStep(
                                    1,
                                    'Share Your Code',
                                    'Send your referral code to friends via social media, email, or messaging',
                                    Icons.share,
                                    Colors.blue,
                                  ),
                                  _buildHowItWorksStep(
                                    2,
                                    'Friend Signs Up',
                                    'Your friend creates an account using your referral code',
                                    Icons.person_add,
                                    Colors.green,
                                  ),
                                  _buildHowItWorksStep(
                                    3,
                                    'Both Earn Rewards',
                                    'You get \$${_referralCode?.reward.referrerBonus.toStringAsFixed(0) ?? '50'}, they get \$${_referralCode?.reward.refereeBonus.toStringAsFixed(0) ?? '25'}!',
                                    Icons.card_giftcard,
                                    Colors.orange,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Stats
                        if (_stats.isNotEmpty) ...[
                          FadeInSlideUp(
                            delay: const Duration(milliseconds: 600),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Your Referral Stats',
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildStatCard(
                                            'Total Referrals',
                                            _stats.first.referrals.toString(),
                                            Icons.people,
                                            Colors.blue,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: _buildStatCard(
                                            'Total Earnings',
                                            '\$${_stats.first.earnings.toStringAsFixed(0)}',
                                            Icons.attach_money,
                                            Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    _buildStatCard(
                                      'Conversion Rate',
                                      '${_stats.first.conversionRate.toStringAsFixed(1)}%',
                                      Icons.trending_up,
                                      Colors.orange,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        // Terms and conditions
                        FadeInSlideUp(
                          delay: const Duration(milliseconds: 800),
                          child: Card(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        color: Theme.of(context).colorScheme.primary,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Terms & Conditions',
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    '• Each referral code can be used up to ${_referralCode?.maxUsage ?? 10} times\n'
                                    '• Rewards are credited within 24 hours of successful referral\n'
                                    '• Referred users must complete profile setup to qualify\n'
                                    '• Self-referrals and duplicate accounts are not allowed',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );

  Widget _buildHowItWorksStep(int step, String title, String description, IconData icon, Color color) => Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                step.toString(),
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Icon(icon, color: color),
        ],
      ),
    );

  Widget _buildStatCard(String title, String value, IconData icon, Color color) => Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

  void _copyReferralCode() {
    if (_referralCode != null) {
      Clipboard.setData(ClipboardData(text: _referralCode!.code));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Referral code copied to clipboard!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _copyReferralLink() {
    if (_referralCode != null) {
      final link = 'https://jobboard.com/signup?ref=${_referralCode!.code}';
      Clipboard.setData(ClipboardData(text: link));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Referral link copied to clipboard!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _shareReferralCode() {
    if (_referralCode != null) {
      // In a real app, this would use the share plugin
      showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Share via',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildShareOption('WhatsApp', Icons.message, Colors.green),
                  _buildShareOption('Email', Icons.email, Colors.blue),
                  _buildShareOption('SMS', Icons.sms, Colors.orange),
                  _buildShareOption('More', Icons.share, Colors.grey),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildShareOption(String label, IconData icon, Color color) => GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sharing via $label...')),
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Referral Program Help'),
        content: const Text(
          'Share your unique referral code with friends and family. '
          'When they sign up using your code, you both earn rewards! '
          'The more people you refer, the more you earn.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
