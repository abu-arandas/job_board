import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';
import '../widgets/animated_widgets.dart';
import '../widgets/premium_components.dart';

class PremiumSubscriptionScreen extends StatefulWidget {
  const PremiumSubscriptionScreen({super.key});

  @override
  State<PremiumSubscriptionScreen> createState() => _PremiumSubscriptionScreenState();
}

class _PremiumSubscriptionScreenState extends State<PremiumSubscriptionScreen> {
  int _selectedPlanIndex = 1; // Default to Pro plan
  bool _isAnnual = true;

  final List<SubscriptionPlan> _plans = [
    SubscriptionPlan(
      name: 'Basic',
      monthlyPrice: 9.99,
      annualPrice: 99.99,
      color: Colors.grey,
      features: [
        'Apply to unlimited jobs',
        'Basic profile customization',
        'Email notifications',
        'Standard support',
      ],
      limitations: [
        'Limited to 5 job alerts',
        'No priority support',
        'Basic analytics only',
      ],
    ),
    SubscriptionPlan(
      name: 'Pro',
      monthlyPrice: 19.99,
      annualPrice: 199.99,
      color: AppTheme.primaryBlue,
      isPopular: true,
      features: [
        'Everything in Basic',
        'Priority job recommendations',
        'Advanced profile features',
        'Unlimited job alerts',
        'Resume optimization tips',
        'Interview preparation guides',
        'Priority customer support',
        'Advanced analytics',
      ],
      limitations: [],
    ),
    SubscriptionPlan(
      name: 'Enterprise',
      monthlyPrice: 49.99,
      annualPrice: 499.99,
      color: Colors.purple,
      features: [
        'Everything in Pro',
        'Personal career coach',
        'Salary negotiation assistance',
        'Direct recruiter connections',
        'Custom job matching',
        'White-glove onboarding',
        'Dedicated account manager',
        'API access',
      ],
      limitations: [],
    ),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Premium Plans'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Maybe Later'),
          ),
        ],
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
                      Icons.workspace_premium,
                      size: 64,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Unlock Your Career Potential',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Get premium features to accelerate your job search',
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

            // Billing toggle
            FadeInSlideUp(
              delay: const Duration(milliseconds: 200),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isAnnual = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !_isAnnual ? Theme.of(context).colorScheme.primary : null,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Monthly',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: !_isAnnual 
                                  ? Colors.white 
                                  : Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isAnnual = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _isAnnual ? Theme.of(context).colorScheme.primary : null,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Annual',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _isAnnual 
                                      ? Colors.white 
                                      : Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (_isAnnual)
                                Text(
                                  'Save 17%',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 10,
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
            ),
            const SizedBox(height: 24),

            // Plans
            FadeInSlideUp(
              delay: const Duration(milliseconds: 400),
              child: SizedBox(
                height: 600,
                child: PageView.builder(
                  controller: PageController(viewportFraction: 0.85),
                  onPageChanged: (index) {
                    setState(() {
                      _selectedPlanIndex = index;
                    });
                  },
                  itemCount: _plans.length,
                  itemBuilder: (context, index) => _buildPlanCard(_plans[index], index == _selectedPlanIndex),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Subscribe button
            FadeInSlideUp(
              delay: const Duration(milliseconds: 600),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: PremiumButton(
                        text: 'Start ${_plans[_selectedPlanIndex].name} Plan',
                        icon: Icons.credit_card,
                        onPressed: _subscribeToPlan,
                        gradient: LinearGradient(
                          colors: [_plans[_selectedPlanIndex].color, _plans[_selectedPlanIndex].color.withOpacity(0.7)],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '7-day free trial • Cancel anytime',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Features comparison
            FadeInSlideUp(
              delay: const Duration(milliseconds: 800),
              child: _buildFeaturesComparison(),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );

  Widget _buildPlanCard(SubscriptionPlan plan, bool isSelected) {
    final price = _isAnnual ? plan.annualPrice : plan.monthlyPrice;
    final period = _isAnnual ? 'year' : 'month';
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        elevation: isSelected ? 8 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: isSelected 
              ? BorderSide(color: plan.color, width: 2)
              : BorderSide.none,
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: isSelected 
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      plan.color.withOpacity(0.1),
                      plan.color.withOpacity(0.05),
                    ],
                  )
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    plan.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: plan.color,
                    ),
                  ),
                  if (plan.isPopular)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: plan.color,
                        borderRadius: BorderRadius.circular(12),
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
              ),
              const SizedBox(height: 16),

              // Price
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${price.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: plan.color,
                    ),
                  ),
                  Text(
                    '/$period',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              if (_isAnnual && plan.monthlyPrice > 0) ...[
                const SizedBox(height: 4),
                Text(
                  'Billed annually (\$${(plan.annualPrice / 12).toStringAsFixed(2)}/month)',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              const SizedBox(height: 24),

              // Features
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...plan.features.map((feature) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: plan.color,
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
                    if (plan.limitations.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      ...plan.limitations.map((limitation) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.remove_circle_outline,
                                color: Colors.grey,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  limitation,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturesComparison() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Why Choose Premium?',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildComparisonRow('Job Applications', 'Limited', 'Unlimited', 'Unlimited'),
                  _buildComparisonRow('Job Alerts', '5', 'Unlimited', 'Unlimited'),
                  _buildComparisonRow('Profile Views', 'Basic', 'Enhanced', 'Premium'),
                  _buildComparisonRow('Support', 'Email', 'Priority', 'Dedicated'),
                  _buildComparisonRow('Analytics', 'Basic', 'Advanced', 'Enterprise'),
                ],
              ),
            ),
          ),
        ],
      ),
    );

  Widget _buildComparisonRow(String feature, String basic, String pro, String enterprise) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              feature,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(basic, textAlign: TextAlign.center)),
          Expanded(child: Text(pro, textAlign: TextAlign.center)),
          Expanded(child: Text(enterprise, textAlign: TextAlign.center)),
        ],
      ),
    );

  void _subscribeToPlan() {
    final plan = _plans[_selectedPlanIndex];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Subscribe to ${plan.name}'),
        content: Text(
          'You\'re about to subscribe to the ${plan.name} plan for '
          '\$${(_isAnnual ? plan.annualPrice : plan.monthlyPrice).toStringAsFixed(2)} '
          'per ${_isAnnual ? 'year' : 'month'}.\n\n'
          'You\'ll get a 7-day free trial and can cancel anytime.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _processSubscription(plan);
            },
            child: const Text('Subscribe'),
          ),
        ],
      ),
    );
  }

  void _processSubscription(SubscriptionPlan plan) {
    // In a real app, this would integrate with payment processing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Successfully subscribed to ${plan.name} plan!'),
        backgroundColor: Colors.green,
      ),
    );
    context.pop();
  }
}

class SubscriptionPlan {

  SubscriptionPlan({
    required this.name,
    required this.monthlyPrice,
    required this.annualPrice,
    required this.color,
    required this.features, this.isPopular = false,
    this.limitations = const [],
  });
  final String name;
  final double monthlyPrice;
  final double annualPrice;
  final Color color;
  final bool isPopular;
  final List<String> features;
  final List<String> limitations;
}
