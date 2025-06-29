import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../providers/favorites_provider.dart';
import '../widgets/animated_widgets.dart';

class JobCard extends StatelessWidget {
  const JobCard({required this.job, super.key, this.showRemoveFromFavorites = false, this.onRemoveFromFavorites});
  final Job job;
  final bool showRemoveFromFavorites;
  final VoidCallback? onRemoveFromFavorites;

  @override
  Widget build(BuildContext context) {
    // Using LayoutBuilder to make decisions based on the card's own constraints
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isNarrow = constraints.maxWidth < 360; // Example breakpoint for very narrow cards
        final double paddingValue = isNarrow ? 12.0 : 20.0;
        final titleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: isNarrow ? 15 : null, // Slightly smaller title for narrow cards
            );
        final companyStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontSize: isNarrow ? 13 : null,
            );
        final bodySmallStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: isNarrow ? 11 : null,
            );
        final chipTextStyle = Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: isNarrow ? 10 : null);


        return FadeInSlideUp(
          child: Card(
            elevation: 4,
            shadowColor: Colors.black12,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: InkWell(
              onTap: () {
                context.go('/job/${job.id}');
              },
              borderRadius: BorderRadius.circular(16),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.surface,
                      Theme.of(context).colorScheme.surface.withOpacity(0.8)
                    ],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(paddingValue),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min, // Important for GridView compatibility
                    children: [
                      // Header row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (job.company.logo != null)
                            CircleAvatar(radius: isNarrow ? 20 : 24, backgroundImage: NetworkImage(job.company.logo!))
                          else
                            CircleAvatar(
                              radius: isNarrow ? 20 : 24,
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              child: Text(
                                job.company.name[0].toUpperCase(),
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: isNarrow ? 16 : null,
                                ),
                              ),
                            ),
                          SizedBox(width: isNarrow ? 8 : 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  job.title,
                                  style: titleStyle,
                                  maxLines: isNarrow ? 3 : 2, // Allow more lines for title if narrow
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(job.company.name, style: companyStyle),
                              ],
                            ),
                          ),
                          if (showRemoveFromFavorites)
                            IconButton(
                              icon: const Icon(Icons.close),
                              iconSize: isNarrow ? 20 : 24,
                              onPressed: onRemoveFromFavorites,
                              tooltip: 'Remove from favorites',
                            )
                          else
                            Consumer<FavoritesProvider>(
                              builder: (context, favoritesProvider, child) {
                                final isFavorite = favoritesProvider.isFavorite(job.id);
                                return IconButton(
                                  icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_outline,
                                      color: isFavorite ? Colors.red : null),
                                  iconSize: isNarrow ? 20 : 24,
                                  onPressed: () async {
                                    await favoritesProvider.toggleFavorite(job);
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(isFavorite ? 'Removed from favorites' : 'Added to favorites'),
                                          duration: const Duration(seconds: 1),
                                        ),
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                        ],
                      ),
                      SizedBox(height: isNarrow ? 8 : 12),

                      // Location and work type
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined,
                              size: isNarrow ? 14 : 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
                          SizedBox(width: isNarrow ? 2 : 4),
                          Expanded(
                            child: Text(
                              job.location,
                              style: bodySmallStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: isNarrow ? 4 : 8), // Add some space before the chip
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: isNarrow ? 6 : 8, vertical: isNarrow ? 3 : 4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(isNarrow ? 8 : 12),
                            ),
                            child: Text(
                              job.workLocationDisplayName,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer, fontSize: isNarrow ? 10: null),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isNarrow ? 8 : 12),

                      // Job description preview - more flexible with Expanded and Spacer
                      Expanded(
                        flex: isNarrow ? 2 : 1, // Give more relative space to description if narrow
                        child: Text(
                          job.description,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: isNarrow ? 13: null),
                          maxLines: 3, // Increased max lines
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                       SizedBox(height: isNarrow ? 8 : 12),


                      // Skills chips
                      if (job.skills.isNotEmpty) ...[
                        Wrap(
                          spacing: isNarrow ? 4 : 6,
                          runSpacing: isNarrow ? 4 : 6,
                          children: job.skills
                              .take(isNarrow ? 2 : 3) // Show fewer skills if narrow
                              .map(
                                (skill) => Container(
                                  padding: EdgeInsets.symmetric(horizontal: isNarrow ? 6: 8, vertical: isNarrow ? 3 : 4),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.surfaceVariant,
                                    borderRadius: BorderRadius.circular(isNarrow ? 6 : 8),
                                  ),
                                  child: Text(skill, style: chipTextStyle),
                                ),
                              )
                              .toList(),
                        ),
                        SizedBox(height: isNarrow ? 8 : 12),
                      ],

                      // Spacer to push bottom content down, useful in GridView
                      if (constraints.maxHeight > 250 && !isNarrow) // Only add extra spacer if there's enough height
                        const Spacer(flex:1),


                      // Bottom row with salary, job type, and posted date
                      // Conditional layout for bottom row
                      if (isNarrow)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              job.salaryRange,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: isNarrow ? 13 : null,
                                  ),
                            ),
                            SizedBox(height: isNarrow ? 4: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildJobTypeChip(context, job.jobTypeDisplayName, isNarrow),
                                Text(
                                  DateFormat('MMM d').format(job.postedDate),
                                  style: bodySmallStyle,
                                ),
                              ],
                            ),
                          ],
                        )
                      else
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end, // Align items to bottom
                          children: [
                            Flexible( // Added Flexible to prevent overflow if salary is too long
                              child: Text(
                                job.salaryRange,
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8), // Add some spacing
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildJobTypeChip(context, job.jobTypeDisplayName, isNarrow),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat('MMM d').format(job.postedDate),
                                  style: bodySmallStyle,
                                ),
                              ],
                            ),
                          ],
                        ),

                      if (job.isFeatured) ...[
                        SizedBox(height: isNarrow ? 6 : 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: isNarrow ? 6 : 8, vertical: isNarrow ? 3 : 4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.tertiaryContainer,
                            borderRadius: BorderRadius.circular(isNarrow ? 6 : 8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star,
                                  size: isNarrow ? 12 : 16,
                                  color: Theme.of(context).colorScheme.onTertiaryContainer),
                              const SizedBox(width: 4),
                              Text(
                                'Featured',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                                      fontWeight: FontWeight.bold,
                                      fontSize: isNarrow ? 10 : null,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildJobTypeChip(BuildContext context, String jobTypeDisplayName, bool isNarrow) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isNarrow ? 6 : 8, vertical: isNarrow ? 3 : 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(isNarrow ? 6 : 8),
      ),
      child: Text(
        jobTypeDisplayName,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              fontSize: isNarrow ? 10 : null,
            ),
      ),
    );
  }
}
