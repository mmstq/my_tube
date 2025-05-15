import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_tube/domain/usecases/get_videos.dart';

import '../../domain/entities/video.dart';

part 'reels_home_event.dart';
part 'reels_home_state.dart';

class ReelsFeedBloc extends Bloc<ReelsHomeEvent, ReelsHomeState> {
  final GetVideos getVideos;
  static const int pageLimit = 10;

  ReelsFeedBloc({required this.getVideos}) : super(ReelsHomeInitial()) {
    on<LoadInitialVideos>(_onLoadInitialVideos);
    on<LoadMoreVideos>(_onLoadMoreVideos);
    on<RefreshVideos>(_onRefreshVideos);
  }

  Future<void> _onLoadInitialVideos(
      LoadInitialVideos event, Emitter<ReelsHomeState> emit) async {
    emit(ReelsHomeLoading());

    try {
      final videos = await getVideos(Params(page: 1, limit: pageLimit));
      final hasReachedMax = videos.length < pageLimit;

      emit(ReelsHomeLoaded(
        videos: videos,
        page: 1,
        hasReachedMax: hasReachedMax,
        isLoadingMore: false,
      ));
    } catch (e) {
      emit(ReelsHomeError(message: e.toString()));
    }
  }

  Future<void> _onLoadMoreVideos(
      LoadMoreVideos event, Emitter<ReelsHomeState> emit) async {
    final currentState = state;

    if (currentState is ReelsHomeLoaded &&
        !currentState.hasReachedMax &&
        !currentState.isLoadingMore) {
      try {
        emit(currentState.copyWith(isLoadingMore: true));
        final nextPage = currentState.page + 1;
        final videos = await getVideos(Params(page: nextPage, limit: pageLimit));
        final hasReachedMax = videos.length < pageLimit;

        emit(currentState.copyWith(
          videos: List.of(currentState.videos)..addAll(videos),
          page: nextPage,
          hasReachedMax: hasReachedMax,
          isLoadingMore: false,
        ));
      } catch (e) {
        emit(ReelsHomeError(message: e.toString()));
      }
    }
  }

  Future<void> _onRefreshVideos(
      RefreshVideos event, Emitter<ReelsHomeState> emit) async {
    try {
      final videos = await getVideos(Params(page: 1, limit: pageLimit));
      final hasReachedMax = videos.length < pageLimit;

      emit(ReelsHomeLoaded(
        videos: videos,
        page: 1,
        hasReachedMax: hasReachedMax,
        isLoadingMore: false,
      ));
    } catch (e) {
      emit(ReelsHomeError(message: e.toString()));
    }
  }
}
