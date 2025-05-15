import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_tube/domain/entities/video.dart';
import 'package:my_tube/domain/usecases/get_videos.dart';

part 'reels_event.dart';
part 'reels_state.dart';

// BLoC
class ReelsBloc extends Bloc<ReelsEvent, ReelsState> {
  final GetVideos getVideos;
  static const int pageLimit = 10;
  bool _isLoading = false;

  ReelsBloc({required this.getVideos}) : super(ReelsInitial()) {
    on<FetchVideos>(_onFetchVideos);
    on<LoadMoreVideos>(_onLoadMoreVideos);
    on<SelectVideo>(_onSelectVideo);
    on<InitializeReels>(_onInitializeReels);
    on<PageChanged>(_onPageChanged);
    on<LoadNextPage>(_onLoadNextPage);
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
    final currentState = state;
    if (currentState is ReelsLoaded) {
      // Don't emit loading state to avoid UI flicker
      await _fetchVideosAndEmitState(event.page, event.limit, emit);
    }
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

  Future<void> _onInitializeReels(
    InitializeReels event,
    Emitter<ReelsState> emit,
  ) async {
    emit(ReelsLoading());
    try {
      // First fetch initial page of videos
      final videos = await getVideos(const Params(page: 1, limit: 10));
      final bool isLastPage = videos.length < 10;

      // If initialVideo is not already in the list, add it
      int selectedIndex = event.initialIndex ?? 0;
      if (event.initialVideo != null) {
        bool videoExists = false;
        for (int i = 0; i < videos.length; i++) {
          if (videos[i].id == event.initialVideo!.id) {
            videoExists = true;
            selectedIndex = i; // Update selectedIndex to the actual position
            break;
          }
        }

        if (!videoExists) {
          // If we need to insert the initial video
          if (event.initialIndex != null &&
              event.initialIndex! < videos.length) {
            // If we have an index, insert at that position
            videos.insert(event.initialIndex!, event.initialVideo!);
            selectedIndex = event.initialIndex!;
          } else {
            // Otherwise insert at the beginning
            videos.insert(0, event.initialVideo!);
            selectedIndex = 0;
          }
        }
      }

      emit(
        ReelsLoaded(
          videos: videos,
          isLastPage: isLastPage,
          page: 1,
          selectedVideoIndex: selectedIndex,
          currentPage: selectedIndex,
        ),
      );
    } catch (e) {
      emit(ReelsError(e.toString()));
    }
  }

  void _onPageChanged(PageChanged event, Emitter<ReelsState> emit) {
    final currentState = state;
    if (currentState is ReelsLoaded) {
      emit(currentState.copyWith(currentPage: event.index));

      // Load more if reaching near end (e.g., last 3 videos)
      if (event.index >= currentState.videos.length - 3 &&
          !currentState.isLastPage) {
        add(LoadNextPage());
      }
    }
  }

  Future<void> _onLoadNextPage(
    LoadNextPage event,
    Emitter<ReelsState> emit,
  ) async {
    if (_isLoading) return;

    final currentState = state;
    if (currentState is ReelsLoaded && !currentState.isLastPage) {
      _isLoading = true;
      try {
        await _fetchVideosAndEmitState(currentState.page + 1, pageLimit, emit);
      } finally {
        _isLoading = false;
      }
    }
  }

  // Helper method to avoid code duplication
  Future<void> _fetchVideosAndEmitState(
    int page,
    int limit,
    Emitter<ReelsState> emit,
  ) async {
    try {
      final currentState = state;
      final newVideos = await getVideos(Params(page: page, limit: limit));
      debugPrint('Loaded ${newVideos.length} videos for page $page');

      // Only consider it the last page if we got zero videos
      final isLastPage = newVideos.isEmpty;

      if (currentState is ReelsLoaded) {
        // Append new videos to existing ones
        final List<Video> updatedVideos = List.from(currentState.videos);

        // Filter out duplicates
        for (final video in newVideos) {
          if (!updatedVideos.any((v) => v.id == video.id)) {
            updatedVideos.add(video);
          }
        }

        emit(
          ReelsLoaded(
            videos: updatedVideos,
            isLastPage: isLastPage,
            page: page,
            selectedVideoIndex: currentState.selectedVideoIndex,
            currentPage: currentState.currentPage,
          ),
        );
      } else {
        // Initial load
        emit(
          ReelsLoaded(
            videos: newVideos,
            isLastPage: isLastPage,
            page: page,
            currentPage: 0,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error loading videos: $e');
      if (state is! ReelsLoaded) {
        // Only emit error if we don't have any videos yet
        emit(ReelsError(e.toString()));
      }
    }
  }

  // Helper method to check if there are already videos with initial data
  void initializeWithVideos(List<Video> videos, int initialIndex) {
    emit(
      ReelsLoaded(
        videos: videos,
        isLastPage: false, // Set to false to allow loading more
        page: 1,
        selectedVideoIndex: initialIndex,
        currentPage: initialIndex,
      ),
    );

    // Pre-fetch the next page of videos
    add(LoadMoreVideos(page: 2, limit: pageLimit));
  }
}
