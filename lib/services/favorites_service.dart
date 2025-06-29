import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import 'job_service.dart';

class FavoritesService {
  static const String _favoritesKey = 'favorite_jobs';
  final JobService _jobService = JobService();

  /// Adds a job to favorites
  Future<bool> addToFavorites(String jobId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoriteIds = await getFavoriteJobIds();

      if (!favoriteIds.contains(jobId)) {
        favoriteIds.add(jobId);
        await prefs.setStringList(_favoritesKey, favoriteIds);
        return true;
      }
      return false; // Already in favorites
    } catch (e) {
      return false;
    }
  }

  /// Removes a job from favorites
  Future<bool> removeFromFavorites(String jobId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoriteIds = await getFavoriteJobIds();

      if (favoriteIds.contains(jobId)) {
        favoriteIds.remove(jobId);
        await prefs.setStringList(_favoritesKey, favoriteIds);
        return true;
      }
      return false; // Not in favorites
    } catch (e) {
      return false;
    }
  }

  /// Checks if a job is in favorites
  Future<bool> isFavorite(String jobId) async {
    try {
      final favoriteIds = await getFavoriteJobIds();
      return favoriteIds.contains(jobId);
    } catch (e) {
      return false;
    }
  }

  /// Gets all favorite job IDs
  Future<List<String>> getFavoriteJobIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_favoritesKey) ?? [];
    } catch (e) {
      return [];
    }
  }

  /// Gets all favorite jobs with full job details
  Future<List<Job>> getFavoriteJobs() async {
    try {
      final favoriteIds = await getFavoriteJobIds();
      final favoriteJobs = <Job>[];

      for (final jobId in favoriteIds) {
        final job = await _jobService.getJobById(jobId);
        if (job != null) {
          favoriteJobs.add(job);
        }
      }

      return favoriteJobs;
    } catch (e) {
      return [];
    }
  }

  /// Toggles favorite status of a job
  Future<bool> toggleFavorite(String jobId) async {
    final isFav = await isFavorite(jobId);
    if (isFav) {
      return removeFromFavorites(jobId);
    } else {
      return addToFavorites(jobId);
    }
  }

  /// Clears all favorites
  Future<bool> clearAllFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_favoritesKey);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Gets the count of favorite jobs
  Future<int> getFavoritesCount() async {
    final favoriteIds = await getFavoriteJobIds();
    return favoriteIds.length;
  }
}
