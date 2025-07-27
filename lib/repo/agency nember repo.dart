
import '../model/agency memeber model.dart';


abstract class IAgencyMemberRepository {
  Future<AgencyMemberModel?> getAgentDetailsWithUsers(String agentId);
}