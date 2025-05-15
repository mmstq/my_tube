part of 'reels_bloc.dart';

abstract class ReelsEvent extends Equatable {
  const ReelsEvent();

  @override
  List<Object> get props => [];
}

class FetchVideos extends ReelsEvent {
  final int page;
  final int limit;

  const FetchVideos({required this.page, required this.limit});

  @override
  List<Object> get props => [page, limit];
}

class LoadMoreVideos extends ReelsEvent {
  final int page;
  final int limit;

  const LoadMoreVideos({required this.page, required this.limit});

  @override
  List<Object> get props => [page, limit];
}

class SelectVideo extends ReelsEvent {
  final Video video;
  final int initialIndex;

  const SelectVideo({required this.video, this.initialIndex = 0});

  @override
  List<Object> get props => [video, initialIndex];
}

class InitializeReels extends ReelsEvent {
  final Video? initialVideo;
  final int? initialIndex;

  const InitializeReels({this.initialVideo, this.initialIndex});

  @override
  List<Object> get props => [initialVideo ?? 0, initialIndex ?? 0];
}

class PageChanged extends ReelsEvent {
  final int index;

  const PageChanged(this.index);

  @override
  List<Object> get props => [index];
}

class LoadNextPage extends ReelsEvent {
  const LoadNextPage();

  @override
  List<Object> get props => [];
}
