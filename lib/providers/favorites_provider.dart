import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/services.dart';

class FavoritesProvider with ChangeNotifier {
  final FavoritesService _favoritesService = FavoritesService();
  
  List<Job> _favoriteJobs = [];
  Set<String> _favoriteJobIds = {};
  bool _isLoading = false;
  String? _error;
  
  // Getters
  List<Job> get favoriteJobs => _favoriteJobs;
  Set<String> get favoriteJobIds => _favoriteJobIds;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get favoritesCount => _favoriteJobs.length;
  
  /// Loads all favorite jobs
  Future<void> loadFavorites() async {
    _setLoading(true);
    _clearError();
    
    try {
      _favoriteJobs = await _favoritesService.getFavoriteJobs();
      _favoriteJobIds = (await _favoritesService.getFavoriteJobIds()).toSet();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load favorites: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  /// Adds a job to favorites
  Future<bool> addToFavorites(Job job) async {
    try {
      final success = await _favoritesService.addToFavorites(job.id);
      if (success) {
        _favoriteJobs.add(job);
        _favoriteJobIds.add(job.id);
        notifyListeners();
      }
      return success;
    } catch (e) {
      _setError('Failed to add to favorites: $e');
      return false;
    }
  }
  
  /// Removes a job from favorites
  Future<bool> removeFromFavorites(String jobId) async {
    try {
      final success = await _favoritesService.removeFromFavorites(jobId);
      if (success) {
        _favoriteJobs.removeWhere((job) => job.id == jobId);
        _favoriteJobIds.remove(jobId);
        notifyListeners();
      }
      return success;
    } catch (e) {
      _setError('Failed to remove from favorites: $e');
      return false;
    }
  }
  
  /// Toggles favorite status of a job
  Future<bool> toggleFavorite(Job job) async {
    if (isFavorite(job.id)) {
      return removeFromFavorites(job.id);
    } else {
      return addToFavorites(job);
    }
  }
  
  /// Checks if a job is in favorites
  bool isFavorite(String jobId) => _favoriteJobIds.contains(jobId);
  
  /// Clears all favorites
  Future<bool> clearAllFavorites() async {
    try {
      final success = await _favoritesService.clearAllFavorites();
      if (success) {
        _favoriteJobs.clear();
        _favoriteJobIds.clear();
        notifyListeners();
      }
      return success;
    } catch (e) {
      _setError('Failed to clear favorites: $e');
      return false;
    }
  }
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }
  
  void _clearError() {
    _error = null;
  }
}
