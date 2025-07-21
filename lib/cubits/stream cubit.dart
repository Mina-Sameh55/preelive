import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:untitled1/cubits/stream%20state.dart';

import '../model/life streaming model.dart';
import '../repo/stream repo.dart';

class StreamCubit extends Cubit<StreamState> {
  final StreamRepository repository;
  int _currentPage = 0;
  bool _hasMore = true;
  String _currentFilter = 'all';
  final int _pageSize = 20;
  Timer? _refreshTimer;

  StreamCubit({required this.repository}) : super(StreamInitial()) {
    // تحديث تلقائي كل 30 ثانية
    _refreshTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      if (state is StreamLoaded) {
        refreshStreams();
      }
    });
  }

  @override
  Future<void> close() {
    _refreshTimer?.cancel();
    return super.close();
  }

  Future<void> loadInitialData() async {
    emit(StreamLoading());
    await _loadData();
  }

  Future<void> refreshStreams() async {
    _currentPage = 0;
    _hasMore = true;
    await _loadData(refresh: true);
  }

  Future<void> loadMore() async {
    if (_hasMore && !(state is StreamLoading)) {
      await _loadData();
    }
  }

  Future<void> _loadData({bool refresh = false}) async {
    try {
      if (refresh) {
        emit(StreamLoading());
      } else if (state is StreamLoaded) {
        final currentState = state as StreamLoaded;
        if (!currentState.hasMore || currentState.isLoading) return;
        emit(currentState.copyWith(isLoading: true));
      }

      List<LiveStream> newStreams;

      if (_currentFilter == 'all') {
        newStreams = await repository.getActiveStreams(
          page: _currentPage,
          limit: _pageSize,
        );
      } else {
        newStreams = await repository.getFilteredStreams(
          filter: _currentFilter,
          page: _currentPage,
          limit: _pageSize,
        );
      }

      _hasMore = newStreams.length == _pageSize;
      _currentPage++;

      if (state is StreamLoaded && !refresh) {
        final currentState = state as StreamLoaded;
        emit(StreamLoaded(
          [...currentState.streams, ...newStreams],
          hasMore: _hasMore,
          filter: _currentFilter,
        ));
      } else {
        emit(StreamLoaded(newStreams,
            hasMore: _hasMore, filter: _currentFilter));
      }
    } catch (e) {
      emit(StreamError('Failed to load streams: $e'));
    }
  }

  Future<void> filterStreams(String filterType) async {
    _currentFilter = filterType;
    _currentPage = 0;
    _hasMore = true;
    await _loadData(refresh: true);
  }

  Future<void> searchStreams(String query) async {
    _currentPage = 0;
    _hasMore = true;
    emit(StreamLoading());

    try {
      final results = await repository.searchStreams(
        query,
        page: _currentPage,
        limit: _pageSize,
      );

      _hasMore = results.length == _pageSize;
      _currentPage++;

      emit(StreamLoaded(results, hasMore: _hasMore, filter: 'search'));
    } catch (e) {
      emit(StreamError('Search failed: $e'));
    }
  }

  Future<void> terminateStream(String streamId) async {
    try {
      await repository.terminateStream(streamId);

      if (state is StreamLoaded) {
        final currentState = state as StreamLoaded;
        final updatedStreams = currentState.streams
            .where((stream) => stream.id != streamId)
            .toList();

        emit(StreamLoaded(updatedStreams,
            hasMore: currentState.hasMore, filter: currentState.filter));
      }
    } catch (e) {
      emit(StreamError('Failed to terminate stream: $e'));
    }
  }

  Future<void> updateStreamStats(
      String streamId, int viewers, int diamonds) async {
    try {
      final updatedStream =
          await repository.updateStreamStats(streamId, viewers, diamonds);

      if (state is StreamLoaded) {
        final currentState = state as StreamLoaded;
        final index = currentState.streams.indexWhere((s) => s.id == streamId);

        if (index != -1) {
          final updatedStreams = List<LiveStream>.from(currentState.streams);
          updatedStreams[index] = updatedStream;

          emit(StreamLoaded(updatedStreams,
              hasMore: currentState.hasMore, filter: currentState.filter));
        }
      }
    } catch (e) {
      emit(StreamError('Failed to update stats: $e'));
    }
  }

  Future<void> deleteStream(String streamId) async {
    try {
      await repository.deleteStream(streamId);

      if (state is StreamLoaded) {
        final currentState = state as StreamLoaded;
        final updatedStreams =
            currentState.streams.where((s) => s.id != streamId).toList();

        emit(StreamLoaded(
          updatedStreams,
          hasMore: currentState.hasMore,
          filter: currentState.filter,
        ));
      }
    } catch (e) {
      emit(StreamError('Failed to delete stream: $e'));
    }
  }

  Future updateBattleStatus(
    String streamId,
    String status,
    int myPoints,
    int hisPoints,
  ) async {
    try {
      await repository.updateBattleStatus(
          streamId, status, myPoints, hisPoints);
      refreshStreams();
    } catch (e) {
      emit(StreamError('Failed to update battle: $e'));
    }
  }
}
