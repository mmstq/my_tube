part of 'reels_feed_bloc.dart';


abstract class ReelsFeedEvent extends Equatable {
  const ReelsFeedEvent();

  @override
  List<Object> get props => [];
}

class LoadInitialVideos extends ReelsFeedEvent {}

class LoadMoreVideos extends ReelsFeedEvent {}

class RefreshVideos extends ReelsFeedEvent {}
