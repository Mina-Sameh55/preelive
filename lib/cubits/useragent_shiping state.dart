import '../model/user model.dart';

abstract class ShippingAgentState {}

class ShippingAgentInitial extends ShippingAgentState {}

class ShippingAgentLoading extends ShippingAgentState {}

class ShippingAgentLoaded extends ShippingAgentState {
  final List<UserModel> users;
  ShippingAgentLoaded(this.users);
}

class PointsUpdated extends ShippingAgentState {}

class ShippingAgentError extends ShippingAgentState {
  final String message;
  ShippingAgentError(this.message);
}