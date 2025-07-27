import 'package:flutter_bloc/flutter_bloc.dart';
import'package:untitled1/model/setting_cubit.dart';
import'package:untitled1/cubits/setting state.dart';
import'package:untitled1/repo/setting repo.dart';


class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository repository;

  SettingsCubit({required this.repository}) : super(SettingsInitial());

  Future<void> loadSettings() async {
    emit(SettingsLoading());
    try {
      final settings = await repository.getSettings();
      emit(SettingsLoaded(settings));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  Future<void> updateSettings(AppSettings newSettings) async {
    try {
      await repository.updateSettings(newSettings);
      loadSettings();
    } catch (e) {
      emit(SettingsError('Failed to update settings'));
    }
  }
}