import '../model/life streaming model.dart';
abstract class StreamState {}

class StreamInitial extends StreamState {}

class StreamLoading extends StreamState {}

class StreamLoaded extends StreamState {
  final List<LiveStream> streams;
  final bool hasMore;
  final bool isLoading;
  final String? filter;

  StreamLoaded(
      this.streams, {
        this.hasMore = true,
        this.isLoading = false,
        this.filter,
      });

  StreamLoaded copyWith({
    List<LiveStream>? streams,
    bool? hasMore,
    bool? isLoading,
    String? filter,
  }) {
    return StreamLoaded(
      streams ?? this.streams,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      filter: filter ?? this.filter,
    );
  }
}

class StreamError extends StreamState {
  final String message;

  StreamError(this.message);
}

class StreamTerminated extends StreamState {
  final String streamId;

  StreamTerminated(this.streamId);
}

class StreamUpdated extends StreamState {
  final LiveStream stream;

  StreamUpdated(this.stream);
}