import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_tube/presentation/bloc/video_bloc.dart';
import 'package:my_tube/presentation/widgets/video_player_item.dart';

class ReelsPage extends StatefulWidget {
  const ReelsPage({super.key});

  @override
  State<ReelsPage> createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage> {
  static const int _pageLimit = 10;
  final PageController _pageController;

  _ReelsPageState() : _pageController = _initPageController();

  static PageController _initPageController() {
    // Can't access context here, so initialize in initState instead
    return PageController();
  }

  @override
  void initState() {
    super.initState();

    // Get the current state to determine if there's a selected video
    final currentState = context.read<VideoBloc>().state;
    if (currentState is VideoPageLoaded &&
        currentState.selectedVideoIndex != null) {
      _pageController.jumpToPage(currentState.selectedVideoIndex!);
    } else {
      // If no video is selected, load the first page
      context.read<VideoBloc>().add(
        const FetchVideos(page: 1, limit: _pageLimit),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<VideoBloc, VideoState>(
        listener: (context, state) {
          if (state is VideoError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is VideoInitial || state is VideoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is VideoPageLoaded) {
            return Stack(
              children: [
                // Videos PageView
                PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  itemCount: state.videos.length + (state.isLastPage ? 0 : 1),
                  onPageChanged: (index) {
                    // Load more videos when reaching the end
                    if (index >= state.videos.length - 4 && !state.isLastPage) {
                      context.read<VideoBloc>().add(
                        LoadMoreVideos(page: state.page + 1, limit: _pageLimit),
                      );
                    }
                  },
                  itemBuilder: (context, index) {
                    if (index >= state.videos.length) {
                      // Show loading indicator at the end
                      return const Center(child: CircularProgressIndicator());
                    }

                    final video = state.videos[index];
                    return VideoPlayerItem(
                      video: video,
                      heroTag: 'video-${video.id}',
                    );
                  },
                ),

                // App bar with title
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'MyTube',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Refresh button
                Positioned(
                  top: 8,
                  right: 16,
                  child: IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: () {
                      context.read<VideoBloc>().add(ClearCache());
                    },
                  ),
                ),
              ],
            );
          } else if (state is LoadingMoreVideos) {
            return Stack(
              children: [
                // Existing videos
                PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  itemCount: state.currentVideos.length + 1,
                  itemBuilder: (context, index) {
                    if (index >= state.currentVideos.length) {
                      // Show loading indicator at the end
                      return const Center(child: CircularProgressIndicator());
                    }

                    final video = state.currentVideos[index];
                    return VideoPlayerItem(
                      video: video,
                      heroTag: 'video-${video.id}',
                    );
                  },
                ),

                // App bar with title
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'MyTube',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Failed to load videos',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<VideoBloc>().add(
                        const FetchVideos(page: 1, limit: _pageLimit),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
