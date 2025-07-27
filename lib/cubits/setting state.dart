import'package:untitled1/model/setting_cubit.dart';

abstract class SettingsState {}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final AppSettings settings;

  SettingsLoaded(this.settings);
}

class SettingsError extends SettingsState {
  final String message;

  SettingsError(this.message);
}