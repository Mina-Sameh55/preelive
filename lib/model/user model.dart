class UserModel {
  final String id;
  final String name;
  final String email;
  final bool isBlocked;
  final bool isBanned;
  final String username;
  final String firstName;
  final String lastName;
  final String role;
  final String country;
  final String bio;
  final String gender;
  final String avatarUrl;
  final int diamonds;
  final int userPoints;
  final String deviceId;
  final bool isDeviceBlocked;
  final String agencyRole;

  // الحقول الجديدة من Parse
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool emailVerified;
  final DateTime? lastOnline;
  final String userStateInApp;
  final DateTime? birthday;
  final String countryCode;
  final String countryDialCode;
  final List<dynamic> countryLanguages;
  final int uid;
  final int credit;
  final List<dynamic> postIdsList;
  final String secondaryPassword;
  final bool photoVerified;
  final String phoneNumberFull;
  final int prefMinAge;
  final int prefMaxAge;
  final bool prefLocationType;
  final String phoneNumber;
  final bool hasPassword;
  final List<dynamic> chatWithUsers;
  final String liveCoverUrl;
  final int creditSent;
  final int diamondsTotal;
  final String profileLanguage;
  final bool isFirstLive;
  final List<dynamic> following;
  final List<dynamic> followers;
  final int battlePoints;
  final bool vibrate;
  final bool acceptCalls;
  final bool messageNotificationSwitch;
  final bool sound;
  final bool liveOpeningAlert;
  final bool isViewer;
  final int battleLost;
  final bool mysteriousMan;
  final bool mysteryMan;
  final bool invisibleVisitor;
  final bool hideProfileCoverFrame;
  final DateTime? mvpMember;
  final String fanClubName;
  final List<dynamic> myObtainedItems;
  final String usingPartyThemeUrl;
  final String usingPartyThemeId;
  final bool canUseUsingPartyTheme;
  final List<dynamic> listOfImages;
  final List<dynamic> appLanguage;
  final String myAgentId;
  final List<dynamic> tradingCoinsReceivers;
  final String usdtContactAddress;
  final String selectPaymentMethod;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.isBlocked,
    required this.isBanned,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.country,
    required this.bio,
    required this.gender,
    required this.avatarUrl,
    required this.diamonds,
    required this.userPoints,
    required this.deviceId,
    required this.isDeviceBlocked,
    required this.agencyRole,
    // الحقول المضافة
    this.createdAt,
    this.updatedAt,
    this.emailVerified = false,
    this.lastOnline,
    this.userStateInApp = '',
    this.birthday,
    this.countryCode = '',
    this.countryDialCode = '',
    this.countryLanguages = const [],
    this.uid = 0,
    this.credit = 0,
    this.postIdsList = const [],
    this.secondaryPassword = '',
    this.photoVerified = false,
    this.phoneNumberFull = '',
    this.prefMinAge = 18,
    this.prefMaxAge = 99,
    this.prefLocationType = false,
    this.phoneNumber = '',
    this.hasPassword = false,
    this.chatWithUsers = const [],
    this.liveCoverUrl = '',
    this.creditSent = 0,
    this.diamondsTotal = 0,
    this.profileLanguage = '',
    this.isFirstLive = false,
    this.following = const [],
    this.followers = const [],
    this.battlePoints = 0,
    this.vibrate = true,
    this.acceptCalls = true,
    this.messageNotificationSwitch = true,
    this.sound = true,
    this.liveOpeningAlert = true,
    this.isViewer = false,
    this.battleLost = 0,
    this.mysteriousMan = false,
    this.mysteryMan = false,
    this.invisibleVisitor = false,
    this.hideProfileCoverFrame = false,
    this.mvpMember,
    this.fanClubName = '',
    this.myObtainedItems = const [],
    this.usingPartyThemeUrl = '',
    this.usingPartyThemeId = '',
    this.canUseUsingPartyTheme = false,
    this.listOfImages = const [],
    this.appLanguage = const [],
    this.myAgentId = '',
    this.tradingCoinsReceivers = const [],
    this.usdtContactAddress = '',
    this.selectPaymentMethod = '',
  });


  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    bool? isBlocked,
    bool? isBanned,
    String? username,
    String? firstName,
    String? lastName,
    String? role,
    String? country,
    String? bio,
    String? gender,
    String? avatarUrl,
    int? diamonds,
    int? userPoints,
    String? deviceId,
    bool? isDeviceBlocked,
    String? agencyRole,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      isBlocked: isBlocked ?? this.isBlocked,
      isBanned: isBanned ?? this.isBanned,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      role: role ?? this.role,
      country: country ?? this.country,
      bio: bio ?? this.bio,
      gender: gender ?? this.gender,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      diamonds: diamonds ?? this.diamonds,
      userPoints: userPoints ?? this.userPoints,
      deviceId: deviceId ?? this.deviceId,
      isDeviceBlocked: isDeviceBlocked ?? this.isDeviceBlocked,
      agencyRole: agencyRole ?? this.agencyRole,
    );
  }
  factory UserModel.fromJson(Map<String, dynamic> json) {
    DateTime? _parseDate(dynamic date) {
      if (date == null) return null;

      if (date is String) {
        return DateTime.tryParse(date);
      } else if (date is Map && date['iso'] != null) {
        return DateTime.tryParse(date['iso']);
      }
      return null;
    }

    String _parseUrl(dynamic obj) {
      if (obj == null) return '';
      if (obj is Map && obj['url'] != null && obj['url'] is String) {
        return obj['url']!;
      }
      return '';
    }

    List<String> _parseStringList(dynamic list) {
      if (list == null) return [];
      if (list is List) return list.whereType<String>().toList();
      return [];
    }

    List<dynamic> _parseDynamicList(dynamic list) {
      if (list == null) return [];
      if (list is List) return list;
      return [];
    }

    // 2. معالجة حالة الحظر
    final blockUntil = _parseDate(json['blockUntil']);
    final isDeviceBlocked = blockUntil != null && blockUntil.isAfter(DateTime.now());

    // 3. إنشاء النموذج
    return UserModel(
      id: json['objectId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      isBlocked: json['isBlocked'] == true,
      isBanned: json['isBanned']?.toString().toLowerCase() == 'true',
      username: json['username']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      role: json['role']?.toString() ?? 'user',
      country: json['country']?.toString() ?? '',
      bio: json['bio']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      avatarUrl: _parseUrl(json['avatar']),
      diamonds: (json['diamonds'] is int) ? json['diamonds'] : 0,
      userPoints: (json['userPoints'] is int) ? json['userPoints'] : 0,
      deviceId: json['deviceId']?.toString() ?? '',
      isDeviceBlocked: isDeviceBlocked,
      agencyRole: json['agency_role']?.toString() ?? '',

      // الحقول الجديدة
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
      emailVerified: json['emailVerified'] == true,
      lastOnline: _parseDate(json['lastOnline']),
      userStateInApp: json['user_state_in_app']?.toString() ?? '',
      birthday: _parseDate(json['birthday']),
      countryCode: json['country_code']?.toString() ?? '',
      countryDialCode: json['country_dial_code']?.toString() ?? '',
      countryLanguages: _parseStringList(json['country_languages']),
      uid: (json['uid'] is int) ? json['uid'] : 0,
      credit: (json['credit'] is int) ? json['credit'] : 0,
      postIdsList: _parseStringList(json['post_ids_list']),
      secondaryPassword: json['secondary_password']?.toString() ?? '',
      photoVerified: json['photo_verified'] == true,
      phoneNumberFull: json['phone_number_full']?.toString() ?? '',
      prefMinAge: (json['prefMinAge'] is int) ? json['prefMinAge'] : 18,
      prefMaxAge: (json['prefMaxAge'] is int) ? json['prefMaxAge'] : 99,
      prefLocationType: json['prefLocationType'] == true,
      phoneNumber: json['phone_number']?.toString() ?? '',
      hasPassword: json['has_password'] == true,
      chatWithUsers: _parseStringList(json['chat_with_users']),
      liveCoverUrl: _parseUrl(json['live_cover']),
      creditSent: (json['creditSent'] is int) ? json['creditSent'] : 0,
      diamondsTotal: (json['diamondsTotal'] is int) ? json['diamondsTotal'] : 0,
      profileLanguage: json['profile_language']?.toString() ?? '',
      isFirstLive: json['is_first_live'] == true,
      following: _parseStringList(json['following']),
      followers: _parseStringList(json['followers']),
      battlePoints: (json['battle_points'] is int) ? json['battle_points'] : 0,
      vibrate: json['vibrate'] != false, // true if missing or true
      acceptCalls: json['accept_calls'] != false,
      messageNotificationSwitch: json['message_notification_switch'] != false,
      sound: json['sound'] != false,
      liveOpeningAlert: json['live_opening_alert'] != false,
      isViewer: json['isViewer'] == true,
      battleLost: (json['battle_lost'] is int) ? json['battle_lost'] : 0,
      mysteriousMan: json['mysterious_man'] == true,
      mysteryMan: json['mystery_man'] == true,
      invisibleVisitor: json['invisible_visitor'] == true,
      hideProfileCoverFrame: json['hide_profile_cover_frame'] == true,
      mvpMember: _parseDate(json['mvp_member']),
      fanClubName: json['fan_club_name']?.toString() ?? '',
      myObtainedItems: _parseDynamicList(json['my_obtained_items']),
      usingPartyThemeUrl: _parseUrl(json['using_party_theme']),
      usingPartyThemeId: json['using_party_theme_id']?.toString() ?? '',
      canUseUsingPartyTheme: json['can_use_using_party_theme'] == true,
      listOfImages: _parseDynamicList(json['list_of_images']),
      appLanguage: _parseStringList(json['app_language']),
      myAgentId: json['my_agent_id']?.toString() ?? '',
      tradingCoinsReceivers: _parseDynamicList(json['trading_coins_receivers']),
      usdtContactAddress: json['usdt_contact_address']?.toString() ?? '',
      selectPaymentMethod: json['select_payment_method']?.toString() ?? '',
    );
  }

  static UserModel empty() {
    return UserModel(
      id: '',
      name: '',
      email: '',
      isBlocked: false,
      isBanned: false,
      username: '',
      firstName: '',
      lastName: '',
      role: 'user',
      country: '',
      bio: '',
      gender: '',
      avatarUrl: '',
      diamonds: 0,
      userPoints: 0,
      deviceId: '',
      isDeviceBlocked: false,
      agencyRole: '',
      createdAt: null,
      updatedAt: null,
      emailVerified: false,
      lastOnline: null,
      userStateInApp: '',
      birthday: null,
      countryCode: '',
      countryDialCode: '',
      countryLanguages: [],
      uid: 0,
      credit: 0,
      postIdsList: [],
      secondaryPassword: '',
      photoVerified: false,
      phoneNumberFull: '',
      prefMinAge: 18,
      prefMaxAge: 99,
      prefLocationType: false,
      phoneNumber: '',
      hasPassword: false,
      chatWithUsers: [],
      liveCoverUrl: '',
      creditSent: 0,
      diamondsTotal: 0,
      profileLanguage: '',
      isFirstLive: false,
      following: [],
      followers: [],
      battlePoints: 0,
      vibrate: true,
      acceptCalls: true,
      messageNotificationSwitch: true,
      sound: true,
      liveOpeningAlert: true,
      isViewer: false,
      battleLost: 0,
      mysteriousMan: false,
      mysteryMan: false,
      invisibleVisitor: false,
      hideProfileCoverFrame: false,
      mvpMember: null,
      fanClubName: '',
      myObtainedItems: [],
      usingPartyThemeUrl: '',
      usingPartyThemeId: '',
      canUseUsingPartyTheme: false,
      listOfImages: [],
      appLanguage: [],
      myAgentId: '',
      tradingCoinsReceivers: [],
      usdtContactAddress: '',
      selectPaymentMethod: '',
    );
  }

  bool get isEmpty => id.isEmpty;
}