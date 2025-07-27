

import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../model/agency memeber model.dart';
import '../repo/agency nember repo.dart';


class ParseAgencyMemberRepository implements IAgencyMemberRepository {
  @override
  Future<AgencyMemberModel?> getAgentDetailsWithUsers(String agentId) async {
    final query = QueryBuilder<ParseObject>(ParseObject('AgencyMember'))
      ..whereEqualTo('agent_id', agentId)
      ..includeObject(['agent', 'host'])
      ..setLimit(1);

    final response = await query.query();

    print('✅ Query Success: ${response.success}');
    print('📦 Raw Results: ${response.results}');

    if (response.success && response.results != null && response.results!.isNotEmpty) {
      final agencyMember = response.results!.first;

      print('🔍 AgencyMember Data: ${agencyMember.toJson()}');

      final agentUser = agencyMember.get<ParseObject>('agent');
      final hostUser = agencyMember.get<ParseObject>('host');

      print('👤 Agent User Raw: ${agentUser?.toJson()}');
      print('🏠 Host User Raw: ${hostUser?.toJson()}');

      return AgencyMemberModel.fromParse(
        agencyMember,
        agentUser: agentUser,
        hostUser: hostUser,
      );
    } else {
      print('❌ No data found or query failed');
      if (!response.success) {
        print('🚨 Error: ${response.error?.message}');
      }
      return null;
    }
  }}