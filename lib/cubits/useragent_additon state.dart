import '../model/user model.dart';

abstract class AgentState {}

class AgentInitial extends AgentState {}

class AgentLoading extends AgentState {}

class AgentLoaded extends AgentState {
  final List<UserModel> users;

  AgentLoaded(this.users);
}

class AgentError extends AgentState {
  final String message;

  AgentError(this.message);
}

class AgentRoleAssigned extends AgentState {}