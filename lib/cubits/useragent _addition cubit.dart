import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/cubits/useragent_additon%20state.dart';
import '../../repo/user repo.dart';
import '../model/user model.dart';
import '../repo/users additoin.dart';

class AgentCubit extends Cubit<AgentState> {
  final AgentRepository agentRepository;
  List<UserModel> _allUsers = [];

  AgentCubit({ required this.agentRepository}) : super(AgentInitial());

  Future<void> loadAgents() async {
    emit(AgentLoading());
    try {
      final users = await agentRepository.getAgents();
      final agents = users.where((u) => u.agencyRole != null).toList();
      _allUsers = users;
      emit(AgentLoaded(agents));
    } catch (e) {
      emit(AgentError('Failed to load agents'));
    }
  }

  Future<void> searchUsers(String query) async {
    emit(AgentLoading());
    try {
      // استدعاء دالة البحث من الـ repository
      final results = await agentRepository.searchUsers(query);

      // فلترة النتائج لتعرض فقط المستخدمين الذين لديهم دور وكيل
      // final filteredResults = results.where((user) => user.agencyRole == 'agent').toList();

      emit(AgentLoaded(results));
    } catch (e) {
      emit(AgentError('Search failed: $e'));
    }
  }


  Future<void> assignAgentRole(UserModel user) async {
    // if (user.agencyRole != null) {
    //   emit(AgentError('${user.username} try again'));
    //   return;
    // }

    emit(AgentLoading());

    try {
      await agentRepository.assignAgentRole(user.id!,);
      await loadAgents(); // Reload updated list
      emit(AgentRoleAssigned());
    } catch (e) {
      emit(AgentError('فشل في تعيين المستخدم كوكيل'));
    }
  }
  Future<void> removeAgentRole(UserModel user) async {
    // if (user.agencyRole != null) {
    //   emit(AgentError('${user.username} try again'));
    //   return;
    // }

    emit(AgentLoading());

    try {
      await agentRepository.removeAgentRole(user.id!,);
      await loadAgents(); // Reload updated list
      emit(AgentRoleAssigned());
    } catch (e) {
      emit(AgentError(' فشل'));
    }
  }

}