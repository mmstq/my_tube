import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_tube/domain/entities/video.dart';
import 'package:my_tube/domain/usecases/get_videos.dart';

part 'reels_event.dart';
part 'reels_state.dart';

// BLoC
class ReelsBloc extends Bloc<ReelsEvent, ReelsState> {
  final GetVideos getVideos;

  ReelsBloc({required this.getVideos}) : super(ReelsInitial()) {
    on<FetchVideos>(_onFetchVideos);
    on<LoadMoreVideos>(_onLoadMoreVideos);
    on<SelectVideo>(_onSelectVideo);
  }

  Future<void> _onFetchVideos(
    FetchVideos event,
    Emitter<ReelsState> emit,
  ) async {
    emit(ReelsLoading());
    await _fetchVideosAndEmitState(event.page, event.limit, emit);
  }

  Future<void> _onLoadMoreVideos(
    LoadMoreVideos event,
    Emitter<ReelsState> emit,
  ) async {
    // The UI will show a loading indicator, no need for a separate loading state
    await _fetchVideosAndEmitState(event.page, event.limit, emit);
  }

  Future<void> _onSelectVideo(
    SelectVideo event,
    Emitter<ReelsState> emit,
  ) async {
    final currentState = state;
    if (currentState is ReelsLoaded) {
      emit(
        ReelsLoaded(
          videos: currentState.videos,
          isLastPage: currentState.isLastPage,
          page: currentState.page,
          selectedVideoIndex: event.initialIndex,
          currentPage: currentState.currentPage,
        ),
      );
    }
  }

  // Helper method to avoid code duplication
  Future<void> _fetchVideosAndEmitState(
    int page,
    int limit,
    Emitter<ReelsState> emit,
  ) async {
    try {
      final videos = await getVideos(Params(page: page, limit: limit));
      final isLastPage = videos.length < limit;
      emit(
        ReelsLoaded(
          videos: videos,
          isLastPage: isLastPage,
          page: page,
          currentPage: 0,
        ),
      );
    } catch (e) {
      emit(ReelsError(e.toString()));
    }
  }
}
