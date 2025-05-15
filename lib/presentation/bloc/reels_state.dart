part of 'reels_bloc.dart';

abstract class ReelsState extends Equatable {
  const ReelsState();

  @override
  List<Object> get props => [];
}

class ReelsInitial extends ReelsState {}

class ReelsLoading extends ReelsState {}

class ReelsLoaded extends ReelsState {
  final List<Video> videos;
  final bool isLastPage;
  final int page;
  final int currentPage;
  final int? selectedVideoIndex;

  const ReelsLoaded({
    required this.videos,
    required this.isLastPage,
    required this.page,
    required this.currentPage,
    this.selectedVideoIndex,
  });

  ReelsLoaded copyWith({
    List<Video>? videos,
    bool? isLastPage,
    int? page,
    int? currentPage,
    int? selectedVideoIndex,
  }) {
    return ReelsLoaded(
      videos: videos ?? this.videos,
      isLastPage: isLastPage ?? this.isLastPage,
      page: page ?? this.page,
      currentPage: currentPage ?? this.currentPage,
      selectedVideoIndex: selectedVideoIndex ?? this.selectedVideoIndex,
    );
  }

  @override
  List<Object> get props => [
    videos,
    isLastPage,
    page,
    selectedVideoIndex ?? -1,
    currentPage,
  ];
}



class ReelsError extends ReelsState {
  final String message;

  const ReelsError(this.message);

  @override
  List<Object> get props => [message];
}
