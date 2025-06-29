import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class ApiService {

  ApiService({http.Client? client}) : _client = client ?? http.Client();
  static const String _baseUrl = 'https://api.jobboard.com/v1';
  static const Duration _cacheTimeout = Duration(minutes: 15);

  final http.Client _client;
  late SharedPreferences _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Jobs API
  Future<List<Job>> getJobs({
    int page = 1,
    int limit = 20,
    String? search,
    String? location,
    String? jobType,
    String? experienceLevel,
    int? minSalary,
    int? maxSalary,
    bool forceRefresh = false,
  }) async {
    final cacheKey =
        'jobs_${page}_${limit}_${search ?? ''}_${location ?? ''}_${jobType ?? ''}_${experienceLevel ?? ''}_${minSalary ?? ''}_${maxSalary ?? ''}';

    // Try cache first
    if (!forceRefresh) {
      final cachedJobs = await _getCachedJobs(cacheKey);
      if (cachedJobs != null) {
        return cachedJobs;
      }
    }

    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
        if (search != null && search.isNotEmpty) 'search': search,
        if (location != null && location.isNotEmpty) 'location': location,
        if (jobType != null && jobType.isNotEmpty) 'job_type': jobType,
        if (experienceLevel != null && experienceLevel.isNotEmpty) 'experience_level': experienceLevel,
        if (minSalary != null) 'min_salary': minSalary.toString(),
        if (maxSalary != null) 'max_salary': maxSalary.toString(),
      };

      final uri = Uri.parse('$_baseUrl/jobs').replace(queryParameters: queryParams);
      final response = await _client.get(uri, headers: _getHeaders()).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final jobs = (data['jobs'] as List).map((jobJson) => Job.fromJson(jobJson)).toList();

        // Cache the results
        await _cacheJobs(cacheKey, jobs);

        return jobs;
      } else {
        throw ApiException('Failed to fetch jobs: ${response.statusCode}');
      }
    } on SocketException {
      // Network error - try to return cached data
      final cachedJobs = await _getCachedJobs(cacheKey, ignoreTimeout: true);
      if (cachedJobs != null) {
        return cachedJobs;
      }
      throw ApiException('No internet connection and no cached data available');
    } catch (e) {
      throw ApiException('Failed to fetch jobs: $e');
    }
  }

  Future<Job> getJobById(String jobId, {bool forceRefresh = false}) async {
    final cacheKey = 'job_$jobId';

    // Try cache first
    if (!forceRefresh) {
      final cachedJob = await _getCachedJob(cacheKey);
      if (cachedJob != null) {
        return cachedJob;
      }
    }

    try {
      final response = await _client
          .get(Uri.parse('$_baseUrl/jobs/$jobId'), headers: _getHeaders())
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final job = Job.fromJson(data['job']);

        // Cache the result
        await _cacheJob(cacheKey, job);

        return job;
      } else if (response.statusCode == 404) {
        throw ApiException('Job not found');
      } else {
        throw ApiException('Failed to fetch job: ${response.statusCode}');
      }
    } on SocketException {
      // Network error - try to return cached data
      final cachedJob = await _getCachedJob(cacheKey, ignoreTimeout: true);
      if (cachedJob != null) {
        return cachedJob;
      }
      throw ApiException('No internet connection and no cached data available');
    } catch (e) {
      throw ApiException('Failed to fetch job: $e');
    }
  }

  Future<List<Company>> getCompanies({int page = 1, int limit = 20, String? search, bool forceRefresh = false}) async {
    final cacheKey = 'companies_${page}_${limit}_${search ?? ''}';

    // Try cache first
    if (!forceRefresh) {
      final cachedCompanies = await _getCachedCompanies(cacheKey);
      if (cachedCompanies != null) {
        return cachedCompanies;
      }
    }

    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
        if (search != null && search.isNotEmpty) 'search': search,
      };

      final uri = Uri.parse('$_baseUrl/companies').replace(queryParameters: queryParams);
      final response = await _client.get(uri, headers: _getHeaders()).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final companies = (data['companies'] as List).map((companyJson) => Company.fromJson(companyJson)).toList();

        // Cache the results
        await _cacheCompanies(cacheKey, companies);

        return companies;
      } else {
        throw ApiException('Failed to fetch companies: ${response.statusCode}');
      }
    } on SocketException {
      // Network error - try to return cached data
      final cachedCompanies = await _getCachedCompanies(cacheKey, ignoreTimeout: true);
      if (cachedCompanies != null) {
        return cachedCompanies;
      }
      throw ApiException('No internet connection and no cached data available');
    } catch (e) {
      throw ApiException('Failed to fetch companies: $e');
    }
  }

  // User API
  Future<User> getCurrentUser() async {
    const cacheKey = 'current_user';

    // Try cache first
    final cachedUser = await _getCachedUser(cacheKey);
    if (cachedUser != null) {
      return cachedUser;
    }

    try {
      final response = await _client
          .get(Uri.parse('$_baseUrl/user/me'), headers: _getHeaders())
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final user = User.fromJson(data['user']);

        // Cache the result
        await _cacheUser(cacheKey, user);

        return user;
      } else if (response.statusCode == 401) {
        throw ApiException('Unauthorized - please log in again');
      } else {
        throw ApiException('Failed to fetch user: ${response.statusCode}');
      }
    } on SocketException {
      // Network error - try to return cached data
      final cachedUser = await _getCachedUser(cacheKey, ignoreTimeout: true);
      if (cachedUser != null) {
        return cachedUser;
      }
      throw ApiException('No internet connection and no cached data available');
    } catch (e) {
      throw ApiException('Failed to fetch user: $e');
    }
  }

  Future<User> updateUser(User user) async {
    try {
      final response = await _client
          .put(Uri.parse('$_baseUrl/user/me'), headers: _getHeaders(), body: json.encode(user.toJson()))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final updatedUser = User.fromJson(data['user']);

        // Update cache
        await _cacheUser('current_user', updatedUser);

        return updatedUser;
      } else {
        throw ApiException('Failed to update user: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException('Failed to update user: $e');
    }
  }

  // Application API
  Future<void> applyToJob(String jobId, {String? coverLetter}) async {
    try {
      final body = <String, dynamic>{'job_id': jobId, if (coverLetter != null) 'cover_letter': coverLetter};

      final response = await _client
          .post(Uri.parse('$_baseUrl/applications'), headers: _getHeaders(), body: json.encode(body))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 201) {
        throw ApiException('Failed to apply to job: ${response.statusCode}');
      }

      // Clear relevant caches
      await _clearApplicationCaches();
    } catch (e) {
      throw ApiException('Failed to apply to job: $e');
    }
  }

  // Authentication
  Future<AuthResult> signIn(String email, String password) async {
    try {
      final response = await _client
          .post(
            Uri.parse('$_baseUrl/auth/signin'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final authResult = AuthResult.fromJson(data);

        // Store auth token
        await _prefs.setString('auth_token', authResult.token);

        return authResult;
      } else if (response.statusCode == 401) {
        throw ApiException('Invalid email or password');
      } else {
        throw ApiException('Failed to sign in: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException('Failed to sign in: $e');
    }
  }

  Future<void> signOut() async {
    await _prefs.remove('auth_token');
    await _clearAllCaches();
  }

  // Cache management
  Future<List<Job>?> _getCachedJobs(String key, {bool ignoreTimeout = false}) async {
    final cachedData = _prefs.getString('cache_$key');
    final cacheTime = _prefs.getInt('cache_time_$key');

    if (cachedData != null && cacheTime != null) {
      final age = DateTime.now().millisecondsSinceEpoch - cacheTime;
      if (ignoreTimeout || age < _cacheTimeout.inMilliseconds) {
        try {
          final List<dynamic> jsonList = json.decode(cachedData);
          return jsonList.map((json) => Job.fromJson(json)).toList();
        } catch (e) {
          // Invalid cache data
          await _prefs.remove('cache_$key');
          await _prefs.remove('cache_time_$key');
        }
      }
    }
    return null;
  }

  Future<void> _cacheJobs(String key, List<Job> jobs) async {
    final jsonString = json.encode(jobs.map((job) => job.toJson()).toList());
    await _prefs.setString('cache_$key', jsonString);
    await _prefs.setInt('cache_time_$key', DateTime.now().millisecondsSinceEpoch);
  }

  Future<Job?> _getCachedJob(String key, {bool ignoreTimeout = false}) async {
    final cachedData = _prefs.getString('cache_$key');
    final cacheTime = _prefs.getInt('cache_time_$key');

    if (cachedData != null && cacheTime != null) {
      final age = DateTime.now().millisecondsSinceEpoch - cacheTime;
      if (ignoreTimeout || age < _cacheTimeout.inMilliseconds) {
        try {
          return Job.fromJson(json.decode(cachedData));
        } catch (e) {
          // Invalid cache data
          await _prefs.remove('cache_$key');
          await _prefs.remove('cache_time_$key');
        }
      }
    }
    return null;
  }

  Future<void> _cacheJob(String key, Job job) async {
    await _prefs.setString('cache_$key', json.encode(job.toJson()));
    await _prefs.setInt('cache_time_$key', DateTime.now().millisecondsSinceEpoch);
  }

  Future<List<Company>?> _getCachedCompanies(String key, {bool ignoreTimeout = false}) async {
    final cachedData = _prefs.getString('cache_$key');
    final cacheTime = _prefs.getInt('cache_time_$key');

    if (cachedData != null && cacheTime != null) {
      final age = DateTime.now().millisecondsSinceEpoch - cacheTime;
      if (ignoreTimeout || age < _cacheTimeout.inMilliseconds) {
        try {
          final List<dynamic> jsonList = json.decode(cachedData);
          return jsonList.map((json) => Company.fromJson(json)).toList();
        } catch (e) {
          // Invalid cache data
          await _prefs.remove('cache_$key');
          await _prefs.remove('cache_time_$key');
        }
      }
    }
    return null;
  }

  Future<void> _cacheCompanies(String key, List<Company> companies) async {
    final jsonString = json.encode(companies.map((company) => company.toJson()).toList());
    await _prefs.setString('cache_$key', jsonString);
    await _prefs.setInt('cache_time_$key', DateTime.now().millisecondsSinceEpoch);
  }

  Future<User?> _getCachedUser(String key, {bool ignoreTimeout = false}) async {
    final cachedData = _prefs.getString('cache_$key');
    final cacheTime = _prefs.getInt('cache_time_$key');

    if (cachedData != null && cacheTime != null) {
      final age = DateTime.now().millisecondsSinceEpoch - cacheTime;
      if (ignoreTimeout || age < _cacheTimeout.inMilliseconds) {
        try {
          return User.fromJson(json.decode(cachedData));
        } catch (e) {
          // Invalid cache data
          await _prefs.remove('cache_$key');
          await _prefs.remove('cache_time_$key');
        }
      }
    }
    return null;
  }

  Future<void> _cacheUser(String key, User user) async {
    await _prefs.setString('cache_$key', json.encode(user.toJson()));
    await _prefs.setInt('cache_time_$key', DateTime.now().millisecondsSinceEpoch);
  }

  Future<void> _clearApplicationCaches() async {
    final keys = _prefs.getKeys();
    for (final key in keys) {
      if (key.startsWith('cache_applications_') || key.startsWith('cache_time_applications_')) {
        await _prefs.remove(key);
      }
    }
  }

  Future<void> _clearAllCaches() async {
    final keys = _prefs.getKeys();
    for (final key in keys) {
      if (key.startsWith('cache_') || key.startsWith('cache_time_')) {
        await _prefs.remove(key);
      }
    }
  }

  Map<String, String> _getHeaders() {
    final headers = <String, String>{'Content-Type': 'application/json', 'Accept': 'application/json'};

    final token = _prefs.getString('auth_token');
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  // Sync management
  Future<bool> isOnline() async {
    try {
      final response = await _client
          .get(Uri.parse('$_baseUrl/health'), headers: _getHeaders())
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<void> syncPendingChanges() async {
    if (!await isOnline()) return;

    // Sync pending applications
    await _syncPendingApplications();

    // Sync pending profile updates
    await _syncPendingProfileUpdates();

    // Sync pending favorites
    await _syncPendingFavorites();
  }

  Future<void> _syncPendingApplications() async {
    final pendingApplications = _prefs.getStringList('pending_applications') ?? [];

    for (final applicationJson in pendingApplications) {
      try {
        final application = json.decode(applicationJson);
        await applyToJob(application['job_id'], coverLetter: application['cover_letter']);
      } catch (e) {
        // Keep in pending list if sync fails
        continue;
      }
    }

    // Clear successfully synced applications
    await _prefs.remove('pending_applications');
  }

  Future<void> _syncPendingProfileUpdates() async {
    final pendingUpdate = _prefs.getString('pending_profile_update');
    if (pendingUpdate != null) {
      try {
        final userJson = json.decode(pendingUpdate);
        final user = User.fromJson(userJson);
        await updateUser(user);
        await _prefs.remove('pending_profile_update');
      } catch (e) {
        // Keep pending if sync fails
      }
    }
  }

  Future<void> _syncPendingFavorites() async {
    final pendingFavorites = _prefs.getStringList('pending_favorites') ?? [];

    for (final favoriteAction in pendingFavorites) {
      try {
        final action = json.decode(favoriteAction);
        if (action['type'] == 'add') {
          await _addFavoriteJob(action['job_id']);
        } else if (action['type'] == 'remove') {
          await _removeFavoriteJob(action['job_id']);
        }
      } catch (e) {
        // Keep in pending list if sync fails
        continue;
      }
    }

    // Clear successfully synced favorites
    await _prefs.remove('pending_favorites');
  }

  Future<void> _addFavoriteJob(String jobId) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/favorites'),
      headers: _getHeaders(),
      body: json.encode({'job_id': jobId}),
    );

    if (response.statusCode != 201) {
      throw ApiException('Failed to add favorite');
    }
  }

  Future<void> _removeFavoriteJob(String jobId) async {
    final response = await _client.delete(Uri.parse('$_baseUrl/favorites/$jobId'), headers: _getHeaders());

    if (response.statusCode != 200) {
      throw ApiException('Failed to remove favorite');
    }
  }

  void dispose() {
    _client.close();
  }
}

class AuthResult {

  AuthResult({required this.token, required this.user});

  factory AuthResult.fromJson(Map<String, dynamic> json) => AuthResult(token: json['token'], user: User.fromJson(json['user']));
  final String token;
  final User user;
}

class ApiException implements Exception {

  ApiException(this.message);
  final String message;

  @override
  String toString() => 'ApiException: $message';
}
