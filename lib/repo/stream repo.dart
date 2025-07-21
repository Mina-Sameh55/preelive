import '../model/life streaming model.dart';
abstract class StreamRepository {
  Future<List<LiveStream>> getActiveStreams({int page = 0, int limit = 20});
  Future<List<LiveStream>> getFilteredStreams({
    required String filter,
    int page = 0,
    int limit = 20,
  });
  Future<void> deleteStream(String streamId);
  Future<void> terminateStream(String streamId);
  Future<LiveStream> updateStreamStats(
      String streamId,
      int newViewers,
      int newDiamonds,
      );
  Future<LiveStream> createStream(LiveStream newStream);
  Future<void> updateBattleStatus(
      String streamId,
      String status,
      int myPoints,
      int hisPoints,
      );
  Future<List<LiveStream>> searchStreams(String query, {int page = 0, int limit = 20});
}