import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:untitled1/model/user%20model.dart';

class AgencyMemberModel {
  final String objectId;
  final String agentId;
  final String hostId;
  final num liveDuration;
  final num matchEarnings;
  final num partyEarnings;
  final num gameGratuities;
  final num platformReward;
  final num pCoinEarnings;
  final num partyCrownDuration;
  final num matchingDuration;
  final num totalPointsEarnings;
  final num liveEarnings;
  final num partyHostDuration;

  final UserModel? agent;
  final UserModel? host;

  AgencyMemberModel({
    required this.objectId,
    required this.agentId,
    required this.hostId,
    required this.liveDuration,
    required this.matchEarnings,
    required this.partyEarnings,
    required this.gameGratuities,
    required this.platformReward,
    required this.pCoinEarnings,
    required this.partyCrownDuration,
    required this.matchingDuration,
    required this.totalPointsEarnings,
    required this.liveEarnings,
    required this.partyHostDuration,
    this.agent,
    this.host,
  });
  factory AgencyMemberModel.fromParse(
      ParseObject object, {
        ParseObject? agentUser,
        ParseObject? hostUser,
      }) {
    return AgencyMemberModel(
      objectId: object.objectId ?? '',
      agentId: object.get<String>('agent_id') ?? '',
      hostId: object.get<String>('host_id') ?? '',
      liveDuration: object.get<num>('live_duration')?.toInt() ?? 0,
      matchEarnings: object.get<num>('match_earnings')?.toDouble() ?? 0.0,
      partyEarnings: object.get<num>('party_earnings')?.toDouble() ?? 0.0,
      gameGratuities: object.get<num>('game_gratuities')?.toDouble() ?? 0.0,
      platformReward: object.get<num>('platform_reward')?.toDouble() ?? 0.0,
      pCoinEarnings: object.get<num>('p_coin_earnings')?.toDouble() ?? 0.0,
      partyCrownDuration: object.get<num>('party_crown_duration')?.toDouble() ??
          0.0,
      matchingDuration: object.get<num>('matching_duration')?.toDouble() ?? 0.0,
      totalPointsEarnings: object.get<num>('total_points_earnings')
          ?.toDouble() ?? 0.0,
      liveEarnings: object.get<num>('live_earnings')?.toDouble() ?? 0.0,
      partyHostDuration: object.get<num>('party_host_duration')?.toDouble() ??
          0.0,
      agent: agentUser != null ? UserModel.fromParse(agentUser) : null,
      host: hostUser != null ? UserModel.fromParse(hostUser) : null,
    );
  }}