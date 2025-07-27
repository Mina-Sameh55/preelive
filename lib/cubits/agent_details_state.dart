// agent_details_state.dart
part of 'agent_details_cubit.dart';

abstract class AgentDetailsState {}

class AgentDetailsInitial extends AgentDetailsState {}

class AgentDetailsLoading extends AgentDetailsState {}

class AgentDetailsLoaded extends AgentDetailsState {
  final AgencyMemberModel agent;
  AgentDetailsLoaded(this.agent);
}

class AgentDetailsError extends AgentDetailsState {
  final String message;
  AgentDetailsError(this.message);
}