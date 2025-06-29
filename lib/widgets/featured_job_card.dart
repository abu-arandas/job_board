import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../providers/favorites_provider.dart';

class FeaturedJobCard extends StatelessWidget {
  const FeaturedJobCard({required this.job, super.key});
  final Job job;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final bool isNarrow = constraints.maxWidth < 280; // Breakpoint for very narrow featured cards
      final double padding = isNarrow ? 12.0 : 16.0;
      final double avatarRadius = isNarrow ? 18.0 : 20.0;

      final titleStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
            fontSize: isNarrow ? 18 : null,
          );
      final companyNameStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.w500,
            fontSize: isNarrow ? 13 : null,
          );
      final locationStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.8),
            fontSize: isNarrow ? 11 : null,
          );
      final chipTextStyle = Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: isNarrow ? 10 : null);
      final salaryStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
            fontSize: isNarrow ? 15 : null,
          );
      final dateStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.8),
            fontSize: isNarrow ? 11 : null,
          );

      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias, // Ensures gradient respects border radius
        child: InkWell(
          onTap: () {
            context.go('/job/${job.id}');
          },
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context).colorScheme.primaryContainer.withOpacity(0.8),
                ],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Good for GridView
                children: [
                  // Header with featured badge and favorite button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: isNarrow ? 6 : 8, vertical: isNarrow ? 3 : 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(isNarrow ? 8 : 12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, size: isNarrow ? 12 : 16, color: Theme.of(context).colorScheme.onPrimary),
                            SizedBox(width: isNarrow ? 2 : 4),
                            Text(
                              'Featured',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.onPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: isNarrow ? 10 : null,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Consumer<FavoritesProvider>(
                        builder: (context, favoritesProvider, child) {
                          final isFavorite = favoritesProvider.isFavorite(job.id);
                          return IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(), // Remove default padding
                            iconSize: isNarrow ? 20 : 24,
                            icon: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_outline,
                              color: isFavorite ? Colors.red : Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
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

                  // Company logo and info
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (job.company.logo != null)
                        CircleAvatar(radius: avatarRadius, backgroundImage: NetworkImage(job.company.logo!))
                      else
                        CircleAvatar(
                          radius: avatarRadius,
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          child: Text(
                            job.company.name[0].toUpperCase(),
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: isNarrow ? 14 : null),
                          ),
                        ),
                      SizedBox(width: isNarrow ? 8 : 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(job.company.name, style: companyNameStyle, overflow: TextOverflow.ellipsis),
                            Text(job.location, style: locationStyle, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isNarrow ? 8 : 12),

                  // Job title
                  Text(
                    job.title,
                    style: titleStyle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isNarrow ? 6 : 8),

                  // Job type and work location chips (using Wrap for narrow screens)
                  Wrap(
                    spacing: isNarrow ? 4 : 8,
                    runSpacing: 4,
                    children: [
                      _buildChip(context, job.jobTypeDisplayName, chipTextStyle, isNarrow),
                      _buildChip(context, job.workLocationDisplayName, chipTextStyle, isNarrow),
                    ],
                  ),
                  SizedBox(height: isNarrow ? 6 : 8),

                  // Spacer to push bottom content down if there's extra space
                  if (constraints.maxHeight > 180 && !isNarrow) // Adjust threshold as needed
                     const Spacer(),


                  // Bottom row with salary and posted date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          job.salaryRange,
                          style: salaryStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: isNarrow ? 4 : 8),
                      Text(
                        DateFormat('MMM d').format(job.postedDate),
                        style: dateStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildChip(BuildContext context, String label, TextStyle? textStyle, bool isNarrow) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isNarrow ? 6 : 8, vertical: isNarrow ? 3 : 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(isNarrow ? 6 : 8),
      ),
      child: Text(label, style: textStyle),
    );
  }
}
