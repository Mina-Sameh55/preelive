import '../model/user model.dart';

abstract class ShippingAgentRepository {
  Future<List<UserModel>> getUsersWithPoints();
  Future<List<UserModel>> searchUsers(String query);
  Future<void> updateUserPoints({
    required String userId,
    required int points,
  });
}