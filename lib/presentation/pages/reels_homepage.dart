import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:my_tube/domain/entities/video.dart';
import 'package:my_tube/presentation/bloc/video_bloc.dart';
import 'package:my_tube/presentation/pages/reels_page.dart';

class ReelsHomePage extends StatefulWidget {
  const ReelsHomePage({super.key});

  @override
  State<ReelsHomePage> createState() => _ReelsHomePageState();
}

class _ReelsHomePageState extends State<ReelsHomePage> {
  static const int _pageLimit = 20;
  final ScrollController _scrollController = ScrollController();
  StreamSubscription? _blocSubscription;
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasReachedMax = false;
  List<Video> _videos = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _listenToBlocState();

    // Fetch initial data
    _fetchPage(_currentPage);
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    // Load more when user scrolls to 70% of the way to the bottom
    if (currentScroll >= maxScroll * 0.7) {
      _loadMore();
    }
  }

  void _loadMore() {
    if (!_isLoading && !_hasReachedMax) {
      _fetchPage(_currentPage + 1);
    }
  }

  void _fetchPage(int page) {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    if (page == 1) {
      // First page
      context.read<VideoBloc>().add(FetchVideos(page: page, limit: _pageLimit));
    } else {
      // Subsequent pages
      context.read<VideoBloc>().add(
        LoadMoreVideos(page: page, limit: _pageLimit),
      );
    }
  }

  void _listenToBlocState() {
    _blocSubscription = context.read<VideoBloc>().stream.listen((state) {
      if (state is VideoPageLoaded) {
        setState(() {
          _isLoading = false;
          _hasReachedMax = state.page == 7;

          if (state.page == 1) {
            _videos = state.videos;
          } else {
            _videos = [..._videos, ...state.videos];
          }

          _currentPage = state.page;
        });
      } else if (state is VideoError) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${state.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_blocSubscription == null) {
      _listenToBlocState();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _blocSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MyTube')),
      body: BlocListener<VideoBloc, VideoState>(
        listener: (context, state) {
          // This is just to make sure we're listening to the bloc
          // The actual handling is done in _listenToBlocState
        },
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_videos.isEmpty && _isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_videos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No videos found'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _fetchPage(1),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _currentPage = 1;
          _hasReachedMax = false;
          _videos = [];
        });
        _fetchPage(1);
      },
      child: GridView.builder(
        controller: _scrollController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.6,
          crossAxisSpacing: 1.0,
          mainAxisSpacing: 1.0,
        ),
        itemCount: _videos.length + (_hasReachedMax ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= _videos.length) {
            context.read<VideoBloc>().add(
              LoadMoreVideos(page: _currentPage + 1, limit: _pageLimit),
            );
            return const Center(child: CircularProgressIndicator());
          }
          return _buildVideoItem(_videos[index], context);
        },
      ),
    );
  }

  Widget _buildVideoItem(Video video, BuildContext context) {
    return GestureDetector(
      onTap: () {
        final videoBloc = context.read<VideoBloc>();
        // Find the index of the selected video
        final selectedIndex = _videos.indexOf(video);
        // Dispatch SelectVideo event before navigation
        videoBloc.add(SelectVideo(video: video, initialIndex: selectedIndex));

        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => BlocProvider.value(
                  value: videoBloc,
                  child: const ReelsPage(),
                ),
          ),
        );
      },
      child: Container(
        height: 300,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(4.0),
        child: Stack(
          children: [
            // Thumbnail section
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: video.thumbCdnUrl ?? '',
                height: 400,
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder:
                    (context, url) => Container(
                      color: Colors.grey[900],
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                errorWidget:
                    (context, url, error) => Container(
                      color: Colors.grey[900],
                      child: const Center(
                        child: Icon(Icons.error_outline, color: Colors.white54),
                      ),
                    ),
              ),
            ),

            // Duration overlay
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _formatDuration(video.duration ?? 0),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 8,
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Channel avatar
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.grey.shade800,
                      backgroundImage:
                          video.user.profilePictureCdn != null &&
                                  video.user.profilePictureCdn!.startsWith(
                                    'http',
                                  )
                              ? CachedNetworkImageProvider(
                                video.user.profilePictureCdn!,
                              )
                              : null,
                      child:
                          video.user.profilePictureCdn == null ||
                                  !video.user.profilePictureCdn!.startsWith(
                                    'http',
                                  )
                              ? Text(
                                video.user.fullName?.isNotEmpty == true
                                    ? video.user.fullName![0].toUpperCase()
                                    : '?',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                              : null,
                    ),
                    const SizedBox(width: 8),

                    // Title and metadata
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            video.title ?? 'No Title',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            video.user.fullName ?? 'Unknown',
                            style: TextStyle(
                              color: Colors.grey.shade200,
                              fontSize: 11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    if (duration.inHours > 0) {
      return '${duration.inHours}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}';
    } else {
      return '${duration.inMinutes}:${twoDigits(duration.inSeconds.remainder(60))}';
    }
  }
}
