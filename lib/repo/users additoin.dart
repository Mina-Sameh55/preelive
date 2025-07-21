import '../model/user model.dart';

abstract class AgentRepository {
  Future<List<UserModel>> getAgents();
  Future<List<UserModel>> searchUsers(String query);
  Future<void> assignAgentRole(String userId);
  Future<void> removeAgentRole(String userId);

}