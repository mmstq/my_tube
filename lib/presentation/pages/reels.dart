import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_tube/presentation/bloc/reels_bloc.dart';
import 'package:my_tube/presentation/widgets/video_player_item.dart';

class Reels extends StatefulWidget {
  const Reels({super.key});

  @override
  State<Reels> createState() => _ReelsState();
}

class _ReelsState extends State<Reels> {
  static const int _pageLimit = 10;
  final PageController _pageController = PageController();
  late final ReelsBloc bloc;

  @override
  void initState() {
    super.initState();
    // Initial load
    bloc = context.read<ReelsBloc>();
    bloc.add(const FetchVideos(page: 1, limit: _pageLimit));
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
      body: SafeArea(
        child: BlocConsumer<ReelsBloc, ReelsState>(
          listener: (context, state) {
            if (state is ReelsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ReelsInitial || state is ReelsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ReelsLoaded) {
              return Stack(
                children: [
                  // Videos PageView
                  PageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.vertical,
                    itemCount: state.videos.length + (state.isLastPage ? 0 : 1),
                    onPageChanged: (index) {
                      // Load more videos when reaching the end
                      if (index >= state.videos.length - 2 &&
                          !state.isLastPage) {
                        bloc.add(
                          LoadMoreVideos(
                            page: state.page + 1,
                            limit: _pageLimit,
                          ),
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
                        bloc.add(const FetchVideos(page: 1, limit: _pageLimit));
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
