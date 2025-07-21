import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/repo/user%20repo.dart';

import '../model/user model.dart';
import 'user _state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/repo/user%20repo.dart';

import '../model/user model.dart';
import 'user _state.dart';
class UserCubit extends Cubit<UserState> {
  final UserRepository repository;
  List<UserModel> _cachedUsers = [];

  UserCubit({required this.repository}) : super(UserInitial());

  Future<void> loadUsers() async {
    if (isClosed) return;
    emit(UserLoading());
    try {
      final users = await repository.getUsers();
      _cachedUsers = users; // تحديث الكاش
      if (!isClosed) emit(UserLoaded(users));
    } catch (e) {
      if (!isClosed) emit(UserError('Failed to load users: $e'));
    }
  }

  Future<void> _refreshUsers() async {
    if (isClosed) return;

    try {
      final users = await repository.getUsers();
      _cachedUsers = users;
      if (!isClosed) emit(UserLoaded(users));
    } catch (e) {
      if (!isClosed) emit(UserError('Failed to refresh users: $e'));
    }
  }

  Future<void> blockUser(String userId, Duration duration) async {
    if (isClosed) return;

    try {
      emit(UserActionInProgress());
      await repository.blockUser(userId, duration);
      await _refreshUsers();
    } catch (e) {
      if (!isClosed) emit(UserError('Failed to block user: $e'));
      await _refreshUsers(); // تحديث البيانات حتى في حالة الخطأ
    }
  }

  Future<void> banUser(String userId,Duration duration) async {
    if (isClosed) return;

    try {
      emit(UserActionInProgress());
      await repository.banUser(userId,duration);
      await _refreshUsers();
    } catch (e) {
      if (!isClosed) emit(UserError('Failed to ban user: $e'));
      await _refreshUsers();
    }
  }

  Future<void> createUser(Map<String, dynamic> userData) async {
    if (isClosed) return;

    try {
      emit(UserActionInProgress());
      await repository.createUser(userData);
      await _refreshUsers();
    } catch (e) {
      if (!isClosed) emit(UserError('Failed to create user: $e'));
    }
  }

  Future<void> deleteUser(String userId) async {
    if (isClosed) return;

    try {
      emit(UserActionInProgress());
      await repository.deleteUser(userId);
      await _refreshUsers();
    } catch (e) {
      if (!isClosed) emit(UserError('Failed to delete user: $e'));
      await _refreshUsers();
    }
  }

  Future<void> updateUser(String userId, Map<String, dynamic> updates) async {
    if (isClosed) return;

    try {
      emit(UserActionInProgress());
      await repository.updateUser(userId, updates);
      await _refreshUsers();
    } catch (e) {
      if (!isClosed) emit(UserError('Failed to update user: $e'));
    }
  }

  Future<void> blockDevice(String userId, String deviceId, Duration duration) async {
    if (isClosed) return;

    try {
      emit(UserActionInProgress());
      await repository.blockDevice(userId, deviceId, duration);
      await _refreshUsers();
    } catch (e) {
      if (!isClosed) emit(UserError('Failed to block device: $e'));
    }
  }

  Future<void> unblockUser(String userId) async {
    if (isClosed) return;

    try {
      emit(UserActionInProgress());
      await repository.unblockUser(userId);
      await _refreshUsers();
    } catch (e) {
      if (!isClosed) emit(UserError('Failed to unblock user: $e'));
    }
  }

  Future<void> unbanUser(String userId) async {
    if (isClosed) return;

    try {
      emit(UserActionInProgress());
      await repository.unbanUser(userId);
      await _refreshUsers();
    } catch (e) {
      if (!isClosed) emit(UserError('Failed to unban user: $e'));
    }
  }

  Future<void> unblockDevice(String userId, String deviceId) async {
    if (isClosed) return;

    try {
      emit(UserActionInProgress());
      await repository.unblockDevice(userId, deviceId);
      await _refreshUsers();
    } catch (e) {
      if (!isClosed) emit(UserError('Failed to unblock device: $e'));
    }
  }

  // دالة مساعدة للبحث بدون إعادة تحميل كامل
  void searchUsers(String query) {
    if (state is! UserLoaded) return;

    final lowerQuery = query.toLowerCase();

    final filteredUsers = _cachedUsers.where((user) {
      final status = user.isBanned
          ? 'banned'
          : user.isBlocked
          ? 'blocked'
          : user.isDeviceBlocked
          ? 'device blocked'
          : 'active';

      return user.name.toLowerCase().contains(lowerQuery) ||
          user.email.toLowerCase().contains(lowerQuery) ||
          user.id.contains(query) ||
          user.uid.toString().contains(query) ||
          user.username.toLowerCase().contains(lowerQuery) ||
          user.country.toLowerCase().contains(lowerQuery) ||
          user.role.toLowerCase().contains(lowerQuery) ||
          status.contains(lowerQuery);
    }).toList();

    if (!isClosed) emit(UserLoaded(filteredUsers));
  }}