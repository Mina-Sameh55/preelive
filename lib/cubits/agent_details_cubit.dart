import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/agency memeber model.dart';
import '../repo/agency nember repo.dart';


part 'agent_details_state.dart';

class AgentDetailsCubit extends Cubit<AgentDetailsState> {
  final IAgencyMemberRepository repository;

  AgentDetailsCubit({required this.repository}) : super(AgentDetailsInitial());

  Future<void> loadAgentDetails(String agentId) async {
    emit(AgentDetailsLoading());
    try {
      final details = await repository.getAgentDetailsWithUsers(agentId);
      if (details != null) {
        emit(AgentDetailsLoaded(details));
      } else {
        emit(AgentDetailsError('No data found'));
      }
    } catch (e) {
      emit(AgentDetailsError(e.toString()));
    }
  }
}