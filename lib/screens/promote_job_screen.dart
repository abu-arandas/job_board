import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';
import '../widgets/animated_widgets.dart';
import '../widgets/premium_components.dart';

class PromoteJobScreen extends StatefulWidget {

  const PromoteJobScreen({
    required this.jobId, super.key,
  });
  final String jobId;

  @override
  State<PromoteJobScreen> createState() => _PromoteJobScreenState();
}

class _PromoteJobScreenState extends State<PromoteJobScreen> {
  int _selectedPromotionIndex = 0;
  int _selectedDuration = 7; // days

  final List<JobPromotion> _promotions = [
    JobPromotion(
      name: 'Featured Listing',
      price: 49.99,
      description: 'Highlight your job at the top of search results',
      features: [
        'Top placement in search results',
        'Featured badge on job listing',
        '3x more visibility',
        'Priority in recommendations',
      ],
      color: Colors.orange,
      icon: Icons.star,
    ),
    JobPromotion(
      name: 'Premium Boost',
      price: 99.99,
      description: 'Maximum exposure with premium placement',
      features: [
        'Everything in Featured Listing',
        'Homepage banner placement',
        'Email newsletter inclusion',
        'Social media promotion',
        '5x more visibility',
      ],
      color: Colors.purple,
      icon: Icons.rocket_launch,
      isPopular: true,
    ),
    JobPromotion(
      name: 'Urgent Hiring',
      price: 29.99,
      description: 'Mark as urgent to attract immediate attention',
      features: [
        'Urgent hiring badge',
        'Red highlight in listings',
        'Push notifications to relevant users',
        '2x more applications',
      ],
      color: Colors.red,
      icon: Icons.priority_high,
    ),
  ];

  final List<int> _durations = [3, 7, 14, 30];

  @override
  Widget build(BuildContext context) {
    final selectedPromotion = _promotions[_selectedPromotionIndex];
    final totalPrice = selectedPromotion.price * (_selectedDuration / 7);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Promote Your Job'),
      ),
      body: SingleChildScrollView(
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
                      Icons.trending_up,
                      size: 64,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Boost Your Job Visibility',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Get more qualified candidates faster',
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

            // Promotion options
            FadeInSlideUp(
              delay: const Duration(milliseconds: 200),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose Promotion Type',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...List.generate(_promotions.length, (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildPromotionCard(_promotions[index], index),
                      )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Duration selection
            FadeInSlideUp(
              delay: const Duration(milliseconds: 400),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Duration',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: _durations.map((duration) {
                        final isSelected = duration == _selectedDuration;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedDuration = duration;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  color: isSelected 
                                      ? selectedPromotion.color
                                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(12),
                                  border: isSelected 
                                      ? null 
                                      : Border.all(color: Theme.of(context).colorScheme.outline),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      '$duration',
                                      style: TextStyle(
                                        color: isSelected ? Colors.white : null,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      duration == 1 ? 'day' : 'days',
                                      style: TextStyle(
                                        color: isSelected 
                                            ? Colors.white.withOpacity(0.8) 
                                            : Theme.of(context).colorScheme.onSurfaceVariant,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Price summary
            FadeInSlideUp(
              delay: const Duration(milliseconds: 600),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Price Summary',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${selectedPromotion.name} ($_selectedDuration days)'),
                            Text('\$${totalPrice.toStringAsFixed(2)}'),
                          ],
                        ),
                        if (_selectedDuration > 7) ...[
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Discount (${((_selectedDuration - 7) * 5).round()}% off)',
                                style: const TextStyle(color: Colors.green),
                              ),
                              Text(
                                '-\$${(selectedPromotion.price * 0.05 * (_selectedDuration - 7) / 7).toStringAsFixed(2)}',
                                style: const TextStyle(color: Colors.green),
                              ),
                            ],
                          ),
                        ],
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\$${totalPrice.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: selectedPromotion.color,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Expected results
            FadeInSlideUp(
              delay: const Duration(milliseconds: 800),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  color: selectedPromotion.color.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.insights,
                              color: selectedPromotion.color,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Expected Results',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: selectedPromotion.color,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildResultItem('Views', '${_getExpectedViews()}+'),
                        _buildResultItem('Applications', '${_getExpectedApplications()}+'),
                        _buildResultItem('Quality Score', '${_getQualityScore()}%'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Promote button
            FadeInSlideUp(
              delay: const Duration(milliseconds: 1000),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: PremiumButton(
                        text: 'Promote Job - \$${totalPrice.toStringAsFixed(2)}',
                        icon: selectedPromotion.icon,
                        onPressed: _promoteJob,
                        gradient: LinearGradient(
                          colors: [selectedPromotion.color, selectedPromotion.color.withOpacity(0.7)],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Promotion starts immediately after payment',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildPromotionCard(JobPromotion promotion, int index) {
    final isSelected = index == _selectedPromotionIndex;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPromotionIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected 
              ? promotion.color.withOpacity(0.1)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? promotion.color : Theme.of(context).colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: promotion.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    promotion.icon,
                    color: promotion.color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            promotion.name,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: promotion.color,
                            ),
                          ),
                          if (promotion.isPopular) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: promotion.color,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'POPULAR',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text(
                        promotion.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                Text(
                  '\$${promotion.price.toStringAsFixed(0)}/week',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: promotion.color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...promotion.features.map((feature) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: promotion.color,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        feature,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              )),
          ],
        ),
      ),
    );
  }

  Widget _buildResultItem(String label, String value) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );

  int _getExpectedViews() {
    const baseViews = 100;
    final multiplier = _selectedPromotionIndex == 0 ? 3 : _selectedPromotionIndex == 1 ? 5 : 2;
    return (baseViews * multiplier * (_selectedDuration / 7)).round();
  }

  int _getExpectedApplications() => (_getExpectedViews() * 0.15).round();

  int _getQualityScore() => 75 + (_selectedPromotionIndex * 10);

  void _promoteJob() {
    final promotion = _promotions[_selectedPromotionIndex];
    final totalPrice = promotion.price * (_selectedDuration / 7);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Promote Job'),
        content: Text(
          'You\'re about to promote your job with ${promotion.name} '
          'for $_selectedDuration days at \$${totalPrice.toStringAsFixed(2)}.\n\n'
          'The promotion will start immediately after payment.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _processPromotion(promotion, totalPrice);
            },
            child: const Text('Promote'),
          ),
        ],
      ),
    );
  }

  void _processPromotion(JobPromotion promotion, double price) {
    // In a real app, this would integrate with payment processing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Job promoted with ${promotion.name} for $_selectedDuration days!'),
        backgroundColor: Colors.green,
      ),
    );
    context.pop();
  }
}

class JobPromotion {

  JobPromotion({
    required this.name,
    required this.price,
    required this.description,
    required this.features,
    required this.color,
    required this.icon,
    this.isPopular = false,
  });
  final String name;
  final double price;
  final String description;
  final List<String> features;
  final Color color;
  final IconData icon;
  final bool isPopular;
}
