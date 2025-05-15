part of 'reels_feed_bloc.dart';


abstract class ReelsFeedState extends Equatable {
  const ReelsFeedState();

  @override
  List<Object> get props => [];
}

class ReelsHomeInitial extends ReelsFeedState {}

class ReelsHomeLoading extends ReelsFeedState {}

class ReelsHomeLoaded extends ReelsFeedState {
  final List<Video> videos;
  final int page;
  final bool hasReachedMax;
  final bool isLoadingMore;

  const ReelsHomeLoaded({
    required this.videos,
    required this.page,
    required this.hasReachedMax,
    required this.isLoadingMore,
  });

  ReelsHomeLoaded copyWith({
    List<Video>? videos,
    int? page,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return ReelsHomeLoaded(
      videos: videos ?? this.videos,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object> get props => [videos, page, hasReachedMax, isLoadingMore];
}

class ReelsHomeError extends ReelsFeedState {
  final String message;

  const ReelsHomeError({required this.message});

  @override
  List<Object> get props => [message];
}
