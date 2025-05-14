part of 'reels_home_bloc.dart';


abstract class ReelsHomeState extends Equatable {
  const ReelsHomeState();

  @override
  List<Object> get props => [];
}

class ReelsHomeInitial extends ReelsHomeState {}

class ReelsHomeLoading extends ReelsHomeState {}

class ReelsHomeLoaded extends ReelsHomeState {
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

class ReelsHomeError extends ReelsHomeState {
  final String message;

  const ReelsHomeError({required this.message});

  @override
  List<Object> get props => [message];
}
