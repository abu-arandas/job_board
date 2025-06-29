import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class SocialService {
  factory SocialService() => _instance;
  SocialService._internal();
  static final SocialService _instance = SocialService._internal();

  late SharedPreferences _prefs;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }
    _prefs = await SharedPreferences.getInstance();
    _isInitialized = true;
  }

  // Job sharing
  Future<ShareResult> shareJob(Job job, SharePlatform platform) async {
    if (!_isInitialized) {
      await initialize();
    }

    final shareContent = _generateJobShareContent(job);

    try {
      // In a real app, this would integrate with platform-specific sharing APIs
      switch (platform) {
        case SharePlatform.linkedin:
          return await _shareToLinkedIn(shareContent);
        case SharePlatform.twitter:
          return await _shareToTwitter(shareContent);
        case SharePlatform.facebook:
          return await _shareToFacebook(shareContent);
        case SharePlatform.whatsapp:
          return await _shareToWhatsApp(shareContent);
        case SharePlatform.email:
          return await _shareViaEmail(shareContent);
        case SharePlatform.copyLink:
          return await _copyToClipboard(shareContent);
      }
    } on Exception catch (e) {
      return ShareResult(success: false, platform: platform, error: e.toString());
    }
  }

  // Referral system
  Future<ReferralCode> generateReferralCode(String userId) async {
    if (!_isInitialized) {
      await initialize();
    }

    final code = _generateUniqueCode();
    final referralCode = ReferralCode(
      code: code,
      userId: userId,
      createdAt: DateTime.now(),
      usageCount: 0,
      maxUsage: 10,
      reward: ReferralReward(
        referrerBonus: 50,
        refereeBonus: 25,
        description: r'Get $50 credit when someone uses your code, they get $25!',
      ),
    );

    await _saveReferralCode(referralCode);
    return referralCode;
  }

  Future<ReferralCode?> getReferralCode(String userId) async {
    if (!_isInitialized) {
      await initialize();
    }

    final codesJson = _prefs.getStringList('referral_codes') ?? [];
    for (final codeJson in codesJson) {
      final code = ReferralCode.fromJson(json.decode(codeJson));
      if (code.userId == userId) {
        return code;
      }
    }
    return null;
  }

  Future<bool> useReferralCode(String code, String newUserId) async {
    if (!_isInitialized) {
      await initialize();
    }

    final codesJson = _prefs.getStringList('referral_codes') ?? [];
    final updatedCodes = <String>[];
    var codeUsed = false;

    for (final codeJson in codesJson) {
      final referralCode = ReferralCode.fromJson(json.decode(codeJson));

      if (referralCode.code == code && referralCode.canBeUsed()) {
        // Use the code
        final updatedCode = referralCode.copyWith(
          usageCount: referralCode.usageCount + 1,
          usedBy: [...referralCode.usedBy, newUserId],
        );
        updatedCodes.add(json.encode(updatedCode.toJson()));
        codeUsed = true;

        // Track referral success
        await _trackReferralSuccess(referralCode.userId, newUserId);
      } else {
        updatedCodes.add(codeJson);
      }
    }

    if (codeUsed) {
      await _prefs.setStringList('referral_codes', updatedCodes);
    }

    return codeUsed;
  }

  Future<List<ReferralStats>> getReferralStats(String userId) async {
    if (!_isInitialized) {
      await initialize();
    }

    final referralCode = await getReferralCode(userId);
    if (referralCode == null) {
      return [];
    }

    return [
      ReferralStats(
        period: 'All Time',
        referrals: referralCode.usageCount,
        earnings: referralCode.usageCount * referralCode.reward.referrerBonus,
        conversionRate: referralCode.usageCount > 0 ? 100.0 : 0.0,
      ),
    ];
  }

  // Social login integration
  Future<SocialLoginResult> signInWithGoogle() async {
    // In a real app, this would integrate with Google Sign-In
    await Future.delayed(const Duration(seconds: 2)); // Simulate API call

    return SocialLoginResult(
      success: true,
      platform: SocialPlatform.google,
      user: User(id: 'google_user_123', name: 'John Doe', email: 'john.doe@gmail.com', createdAt: DateTime.now()),
    );
  }

  Future<SocialLoginResult> signInWithLinkedIn() async {
    // In a real app, this would integrate with LinkedIn API
    await Future.delayed(const Duration(seconds: 2)); // Simulate API call

    return SocialLoginResult(
      success: true,
      platform: SocialPlatform.linkedin,
      user: User(
        id: 'linkedin_user_123',
        name: 'Jane Smith',
        email: 'jane.smith@linkedin.com',
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<SocialLoginResult> signInWithFacebook() async {
    // In a real app, this would integrate with Facebook Login
    await Future.delayed(const Duration(seconds: 2)); // Simulate API call

    return SocialLoginResult(
      success: true,
      platform: SocialPlatform.facebook,
      user: User(
        id: 'facebook_user_123',
        name: 'Mike Johnson',
        email: 'mike.johnson@facebook.com',
        createdAt: DateTime.now(),
      ),
    );
  }

  // Networking features
  Future<List<NetworkConnection>> getNetworkConnections(String userId) async {
    if (!_isInitialized) {
      await initialize();
    }

    // In a real app, this would fetch from API
    return [
      NetworkConnection(
        id: '1',
        userId: userId,
        connectedUserId: 'user_2',
        connectedUserName: 'Sarah Wilson',
        connectedUserTitle: 'Product Manager at TechCorp',
        connectionType: ConnectionType.colleague,
        connectedAt: DateTime.now().subtract(const Duration(days: 30)),
        mutualConnections: 5,
      ),
      NetworkConnection(
        id: '2',
        userId: userId,
        connectedUserId: 'user_3',
        connectedUserName: 'David Brown',
        connectedUserTitle: 'Senior Developer at StartupXYZ',
        connectionType: ConnectionType.industry,
        connectedAt: DateTime.now().subtract(const Duration(days: 15)),
        mutualConnections: 3,
      ),
    ];
  }

  Future<bool> sendConnectionRequest(String fromUserId, String toUserId, String message) async {
    if (!_isInitialized) {
      await initialize();
    }

    // In a real app, this would send via API
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call

    // Store pending request locally for demo
    final requests = _prefs.getStringList('pending_connection_requests') ?? []
      ..add(
        json.encode({
          'from_user_id': fromUserId,
          'to_user_id': toUserId,
          'message': message,
          'sent_at': DateTime.now().toIso8601String(),
        }),
      );
    await _prefs.setStringList('pending_connection_requests', requests);

    return true;
  }

  // Private methods
  ShareContent _generateJobShareContent(Job job) => ShareContent(
    title: '${job.title} at ${job.company.name}',
    description: job.description.length > 200 ? '${job.description.substring(0, 200)}...' : job.description,
    url: 'https://jobboard.com/jobs/${job.id}',
    imageUrl: job.company.logo,
  );

  Future<ShareResult> _shareToLinkedIn(ShareContent content) async {
    // Simulate LinkedIn sharing
    await Future.delayed(const Duration(seconds: 1));
    return ShareResult(success: true, platform: SharePlatform.linkedin);
  }

  Future<ShareResult> _shareToTwitter(ShareContent content) async {
    // Simulate Twitter sharing
    await Future.delayed(const Duration(seconds: 1));
    return ShareResult(success: true, platform: SharePlatform.twitter);
  }

  Future<ShareResult> _shareToFacebook(ShareContent content) async {
    // Simulate Facebook sharing
    await Future.delayed(const Duration(seconds: 1));
    return ShareResult(success: true, platform: SharePlatform.facebook);
  }

  Future<ShareResult> _shareToWhatsApp(ShareContent content) async {
    // Simulate WhatsApp sharing
    await Future.delayed(const Duration(seconds: 1));
    return ShareResult(success: true, platform: SharePlatform.whatsapp);
  }

  Future<ShareResult> _shareViaEmail(ShareContent content) async {
    // Simulate email sharing
    await Future.delayed(const Duration(seconds: 1));
    return ShareResult(success: true, platform: SharePlatform.email);
  }

  Future<ShareResult> _copyToClipboard(ShareContent content) async {
    // In a real app, this would copy to clipboard
    await Future.delayed(const Duration(milliseconds: 500));
    return ShareResult(success: true, platform: SharePlatform.copyLink);
  }

  String _generateUniqueCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    return List.generate(8, (index) => chars[random % chars.length]).join();
  }

  Future<void> _saveReferralCode(ReferralCode code) async {
    final codes = _prefs.getStringList('referral_codes') ?? []
      ..add(json.encode(code.toJson()));
    await _prefs.setStringList('referral_codes', codes);
  }

  Future<void> _trackReferralSuccess(String referrerId, String refereeId) async {
    final successes = _prefs.getStringList('referral_successes') ?? []
      ..add(
        json.encode({
          'referrer_id': referrerId,
          'referee_id': refereeId,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );
    await _prefs.setStringList('referral_successes', successes);
  }
}

// Data classes
class ShareContent {
  ShareContent({required this.title, required this.description, required this.url, this.imageUrl});
  final String title;
  final String description;
  final String url;
  final String? imageUrl;
}

class ShareResult {
  ShareResult({required this.success, required this.platform, this.error});
  final bool success;
  final SharePlatform platform;
  final String? error;
}

class ReferralCode {
  ReferralCode({
    required this.code,
    required this.userId,
    required this.createdAt,
    required this.usageCount,
    required this.maxUsage,
    required this.reward,
    this.usedBy = const [],
  });

  factory ReferralCode.fromJson(Map<String, dynamic> json) => ReferralCode(
    code: json['code'],
    userId: json['user_id'],
    createdAt: DateTime.parse(json['created_at']),
    usageCount: json['usage_count'],
    maxUsage: json['max_usage'],
    usedBy: List<String>.from(json['used_by'] ?? []),
    reward: ReferralReward.fromJson(json['reward']),
  );
  final String code;
  final String userId;
  final DateTime createdAt;
  final int usageCount;
  final int maxUsage;
  final List<String> usedBy;
  final ReferralReward reward;

  bool canBeUsed() => usageCount < maxUsage;

  ReferralCode copyWith({
    String? code,
    String? userId,
    DateTime? createdAt,
    int? usageCount,
    int? maxUsage,
    List<String>? usedBy,
    ReferralReward? reward,
  }) => ReferralCode(
    code: code ?? this.code,
    userId: userId ?? this.userId,
    createdAt: createdAt ?? this.createdAt,
    usageCount: usageCount ?? this.usageCount,
    maxUsage: maxUsage ?? this.maxUsage,
    usedBy: usedBy ?? this.usedBy,
    reward: reward ?? this.reward,
  );

  Map<String, dynamic> toJson() => {
    'code': code,
    'user_id': userId,
    'created_at': createdAt.toIso8601String(),
    'usage_count': usageCount,
    'max_usage': maxUsage,
    'used_by': usedBy,
    'reward': reward.toJson(),
  };
}

class ReferralReward {
  ReferralReward({required this.referrerBonus, required this.refereeBonus, required this.description});

  factory ReferralReward.fromJson(Map<String, dynamic> json) => ReferralReward(
    referrerBonus: json['referrer_bonus'].toDouble(),
    refereeBonus: json['referee_bonus'].toDouble(),
    description: json['description'],
  );
  final double referrerBonus;
  final double refereeBonus;
  final String description;

  Map<String, dynamic> toJson() => {
    'referrer_bonus': referrerBonus,
    'referee_bonus': refereeBonus,
    'description': description,
  };
}

class ReferralStats {
  ReferralStats({required this.period, required this.referrals, required this.earnings, required this.conversionRate});
  final String period;
  final int referrals;
  final double earnings;
  final double conversionRate;
}

class SocialLoginResult {
  SocialLoginResult({required this.success, required this.platform, this.user, this.error});
  final bool success;
  final SocialPlatform platform;
  final User? user;
  final String? error;
}

class NetworkConnection {
  NetworkConnection({
    required this.id,
    required this.userId,
    required this.connectedUserId,
    required this.connectedUserName,
    required this.connectedUserTitle,
    required this.connectionType,
    required this.connectedAt,
    required this.mutualConnections,
    this.connectedUserAvatar,
  });
  final String id;
  final String userId;
  final String connectedUserId;
  final String connectedUserName;
  final String connectedUserTitle;
  final String? connectedUserAvatar;
  final ConnectionType connectionType;
  final DateTime connectedAt;
  final int mutualConnections;
}

enum SharePlatform { linkedin, twitter, facebook, whatsapp, email, copyLink }

enum SocialPlatform { google, linkedin, facebook, twitter }

enum ConnectionType { colleague, industry, alumni, friend }
