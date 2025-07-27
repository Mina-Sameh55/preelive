import'package:untitled1/model/setting_cubit.dart';
abstract class SettingsRepository {
  Future<AppSettings> getSettings();
  Future<void> updateSettings(AppSettings settings);
}