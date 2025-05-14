import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_tube/domain/entities/video.dart';
import 'package:my_tube/domain/usecases/get_videos.dart';

// Events
abstract class VideoEvent extends Equatable {
  const VideoEvent();

  @override
  List<Object> get props => [];
}

class FetchVideos extends VideoEvent {
  final int page;
  final int limit;

  const FetchVideos({required this.page, required this.limit});

  @override
  List<Object> get props => [page, limit];
}

class LoadMoreVideos extends VideoEvent {
  final int page;
  final int limit;

  const LoadMoreVideos({required this.page, required this.limit});

  @override
  List<Object> get props => [page, limit];
}

class SelectVideo extends VideoEvent {
  final Video video;
  final int initialIndex;

  const SelectVideo({required this.video, this.initialIndex = 0});

  @override
  List<Object> get props => [video, initialIndex];
}

class ClearCache extends VideoEvent {}

// States
abstract class VideoState extends Equatable {
  const VideoState();

  @override
  List<Object> get props => [];
}

class VideoInitial extends VideoState {}

class VideoLoading extends VideoState {}

class VideoPageLoaded extends VideoState {
  final List<Video> videos;
  final bool isLastPage;
  final int page;
  final int? selectedVideoIndex;

  const VideoPageLoaded({
    required this.videos,
    required this.isLastPage,
    required this.page,
    this.selectedVideoIndex,
  });

  @override
  List<Object> get props => [
    videos,
    isLastPage,
    page,
    selectedVideoIndex ?? -1,
  ];
}

class VideoError extends VideoState {
  final String message;

  const VideoError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class VideoBloc extends Bloc<VideoEvent, VideoState> {
  final GetVideos getVideos;

  VideoBloc({required this.getVideos}) : super(VideoInitial()) {
    on<FetchVideos>(_onFetchVideos);
    on<LoadMoreVideos>(_onLoadMoreVideos);
    on<SelectVideo>(_onSelectVideo);
    on<ClearCache>(_onClearCache);
  }

  Future<void> _onFetchVideos(
    FetchVideos event,
    Emitter<VideoState> emit,
  ) async {
    emit(VideoLoading());
    await _fetchVideosAndEmitState(event.page, event.limit, emit);
  }

  Future<void> _onLoadMoreVideos(
    LoadMoreVideos event,
    Emitter<VideoState> emit,
  ) async {
    // The UI will show a loading indicator, no need for a separate loading state
    await _fetchVideosAndEmitState(event.page, event.limit, emit);
  }

  Future<void> _onSelectVideo(
    SelectVideo event,
    Emitter<VideoState> emit,
  ) async {
    final currentState = state;
    if (currentState is VideoPageLoaded) {
      emit(
        VideoPageLoaded(
          videos: currentState.videos,
          isLastPage: currentState.isLastPage,
          page: currentState.page,
          selectedVideoIndex: event.initialIndex,
        ),
      );
    }
  }

  Future<void> _onClearCache(ClearCache event, Emitter<VideoState> emit) async {
    add(const FetchVideos(page: 1, limit: 10));
  }

  // Helper method to avoid code duplication
  Future<void> _fetchVideosAndEmitState(
    int page,
    int limit,
    Emitter<VideoState> emit,
  ) async {
    try {
      final videos = await getVideos(Params(page: page, limit: limit));
      final isLastPage = videos.length < limit;
      emit(VideoPageLoaded(videos: videos, isLastPage: isLastPage, page: page));
    } catch (e) {
      emit(VideoError(e.toString()));
    }
  }
}
