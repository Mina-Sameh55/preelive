import '../model/user model.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserActionInProgress extends UserState {} // حالة جديدة

class UserLoaded extends UserState {
  final List<UserModel> users;

  UserLoaded(this.users);
}

class UserError extends UserState {
  final String message;

  UserError(this.message);
}