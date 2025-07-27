class AppSettings {
  final bool darkMode;
  final bool notificationsEnabled;
  final String language;

  AppSettings({
    required this.darkMode,
    required this.notificationsEnabled,
    required this.language,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      darkMode: json['darkMode'] ?? false,
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      language: json['language'] ?? 'en',
    );
  }

  Map<String, dynamic> toJson() => {
    'darkMode': darkMode,
    'notificationsEnabled': notificationsEnabled,
    'language': language,
  };
}