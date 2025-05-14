part of 'reels_home_bloc.dart';


abstract class ReelsHomeEvent extends Equatable {
  const ReelsHomeEvent();

  @override
  List<Object> get props => [];
}

class LoadInitialVideos extends ReelsHomeEvent {}

class LoadMoreVideos extends ReelsHomeEvent {}

class RefreshVideos extends ReelsHomeEvent {}
