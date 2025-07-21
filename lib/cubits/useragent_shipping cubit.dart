import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/cubits/useragent_shiping%20state.dart';

import '../model/user model.dart';
import '../repo/usershipping repo.dart';


class ShippingAgentCubit extends Cubit<ShippingAgentState> {
  final ShippingAgentRepository repository;
  List<UserModel> _allUsers = [];

  ShippingAgentCubit({ required this.repository}) : super(ShippingAgentInitial());

  Future<void> loadUsers() async {
    emit(ShippingAgentLoading());
    try {
      final users = await repository.getUsersWithPoints();
      _allUsers = users;
      emit(ShippingAgentLoaded(users));
    } catch (e) {
      emit(ShippingAgentError('Failed to load users'));
    }
  }

  Future<void> searchUsers(String query) async {
    emit(ShippingAgentLoading());
    try {
      // استدعاء دالة البحث من الـ repository
      final results = await repository.searchUsers(query);

      // فلترة النتائج لتعرض فقط المستخدمين الذين لديهم دور وكيل
      // final filteredResults = results.where((user) => user.agencyRole == 'agent').toList();

      emit(ShippingAgentLoaded(results));
    } catch (e) {
      emit(ShippingAgentError('Search failed: $e'));
    }
  }

  Future<void> updatePoints(String userId, int points) async {
    emit(ShippingAgentLoading());
    try {
      await repository.updateUserPoints(userId: userId, points: points);
      final users = await repository.getUsersWithPoints();
      _allUsers = users;
      emit(ShippingAgentLoaded(users));
      emit(PointsUpdated());
    } catch (e) {
      emit(ShippingAgentError('فشل في تحديث النقاط'));
    }
  }}
