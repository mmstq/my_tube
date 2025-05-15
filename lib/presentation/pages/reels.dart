import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_tube/domain/entities/video.dart';
import 'package:my_tube/presentation/bloc/reels_bloc.dart';
import 'package:my_tube/presentation/widgets/video_player_item.dart';

class Reels extends StatefulWidget {
  final List<Video>? initialVideos;
  final int initialIndex;

  const Reels({super.key, this.initialVideos, this.initialIndex = 0});

  @override
  State<Reels> createState() => _ReelsState();
}

class _ReelsState extends State<Reels> {
  late final PageController _pageController;
  late final ReelsBloc bloc;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    bloc = context.read<ReelsBloc>();

    if (widget.initialVideos != null && widget.initialVideos!.isNotEmpty) {
      // Use provided videos if navigating from homepage
      bloc.initializeWithVideos(widget.initialVideos!, widget.initialIndex);
    } else {
      bloc.add(FetchVideos(page: 1, limit: ReelsBloc.pageLimit));
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
                    itemCount: state.videos.length,
                    onPageChanged: (index) {
                      bloc.add(PageChanged(index));
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

                  // Back button
                  Positioned(
                    top: 10,
                    left: 10,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
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
                        bloc.add(
                          FetchVideos(page: 1, limit: ReelsBloc.pageLimit),
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
      ),
    );
  }
}
