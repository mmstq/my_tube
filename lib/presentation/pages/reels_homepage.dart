import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:my_tube/domain/entities/video.dart';
import 'package:my_tube/presentation/bloc/reels_home_bloc.dart';
import 'package:my_tube/presentation/widgets/app_bar.dart';
import 'package:my_tube/presentation/widgets/bottom_bar.dart';
import 'package:my_tube/presentation/widgets/video_player_item.dart';
import 'package:my_tube/presentation/widgets/video_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ReelsHomePage extends StatefulWidget {
  const ReelsHomePage({super.key});

  @override
  State<ReelsHomePage> createState() => _ReelsHomePageState();
}

class _ReelsHomePageState extends State<ReelsHomePage> {
  final ScrollController _scrollController = ScrollController();
  late final ReelsHomeBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = context.read<ReelsHomeBloc>();
    bloc.add(LoadInitialVideos());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.7) {
      bloc.add(LoadMoreVideos());
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context),
      bottomNavigationBar: BottomBar(selectedIndex: 0),
      body: BlocBuilder<ReelsHomeBloc, ReelsHomeState>(
        builder: (context, state) {
          if (state is ReelsHomeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ReelsHomeError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => bloc.add(LoadInitialVideos()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is ReelsHomeLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                bloc.add(RefreshVideos());
              },
              child: MasonryGridView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.only(bottom: 60),
                itemCount: state.videos.length + (state.hasReachedMax ? 0 : 1),
                gridDelegate:
                const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                itemBuilder: (context, index) {
                  if (index >= state.videos.length) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final video = state.videos[index];
                  // Calculate aspect ratio using video dimensions
                  double aspectRatio = 9 / 16; // default vertical aspect ratio

                  if (video.videoWidth != null &&
                      video.videoHeight != null &&
                      video.videoHeight! > 0 &&
                      video.videoWidth! > 0) {
                    aspectRatio = video.videoWidth! / video.videoHeight!;
                  }

                  // Calculate item height based on screen width and aspect ratio
                  final screenWidth = MediaQuery.of(context).size.width;
                  final itemWidth =
                      (screenWidth / 2) - 4; // 2 columns with 4px spacing
                  final itemHeight = itemWidth / aspectRatio;

                  return Container(
                  height: itemHeight,
                  margin: const EdgeInsets.all(2),
                  child: buildVideoItem(video, context, height: itemHeight),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class ReelsPage extends StatelessWidget {
  final Video initialVideo;
  const ReelsPage({super.key, required this.initialVideo});

  @override
  Widget build(BuildContext context) {
    Logger().d(initialVideo.cdnUrl);
    Logger().d(initialVideo.url);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: VideoPlayerItem(
          video: initialVideo,
          heroTag: 'video-${initialVideo.id}',
        ),
      ),
    );
  }
}



