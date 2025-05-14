import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:my_tube/domain/entities/video.dart';

class VideoPlayerItem extends StatefulWidget {
  final Video video;
  final String heroTag;

  const VideoPlayerItem({
    super.key,
    required this.video,
    required this.heroTag,
  });

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoController();
  }

  Future<void> _initializeVideoController() async {
    final videoUrl = widget.video.cdnUrl ?? widget.video.url;
    if (videoUrl == null) {
      debugPrint('Error: No video URL available');
      return;
    }

    _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));

    try {
      await _controller.initialize();
      // Set video to loop
      await _controller.setLooping(true);

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Error initializing video: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error playing video: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _playPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
      setState(() {
        _isPlaying = false;
      });
    } else {
      _controller.play();
      setState(() {
        _isPlaying = true;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('video-${widget.video.id}'),
      onVisibilityChanged: (visibilityInfo) {
        final visiblePercentage = visibilityInfo.visibleFraction * 100;
        if (visiblePercentage > 80) {
          if (!_isPlaying && _isInitialized) {
            _controller.play();
            setState(() {
              _isPlaying = true;
            });
          }
        } else if (visiblePercentage < 50) {
          if (_isPlaying) {
            _controller.pause();
            setState(() {
              _isPlaying = false;
            });
          }
        }
      },
      child: GestureDetector(
        onTap: _isInitialized ? _playPause : null,
        child: Container(
          color: Colors.black,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Video or thumbnail
              _isInitialized
                  ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                  : widget.video.thumbCdnUrl != null &&
                      widget.video.thumbCdnUrl!.isNotEmpty
                  ? Image.network(
                    widget.video.thumbCdnUrl!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(child: CircularProgressIndicator());
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value:
                              loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                        ),
                      );
                    },
                  )
                  : const Center(child: CircularProgressIndicator()),

              // Overlay with user info and actions
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black54],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Author info
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                widget.video.user.profilePictureCdn != null &&
                                        widget.video.user.profilePictureCdn!
                                            .startsWith('http')
                                    ? NetworkImage(
                                      widget.video.user.profilePictureCdn!,
                                    )
                                    : null,
                            backgroundColor: Colors.grey[800],
                            child:
                                widget.video.user.profilePictureCdn == null ||
                                        !widget.video.user.profilePictureCdn!
                                            .startsWith('http')
                                    ? Text(
                                      widget.video.user.fullName?.isNotEmpty ==
                                              true
                                          ? widget.video.user.fullName![0]
                                              .toUpperCase()
                                          : '?',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                    : null,
                            radius: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.video.user.fullName!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Video title
                      Text(
                        widget.video.title!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Video description
                      Text(
                        widget.video.description ?? '',
                        style: const TextStyle(color: Colors.white70),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Additional stats
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '${widget.video.totalViews} views',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          if (widget.video.language != null &&
                              widget.video.language!.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Text(
                              '• ${widget.video.language}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Right-side interaction buttons
              Positioned(
                right: 16,
                bottom: 100,
                child: Column(
                  children: [
                    // Like button
                    IconButton(
                      icon: Icon(
                        widget.video.isLiked == true
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color:
                            widget.video.isLiked == true
                                ? Colors.red
                                : Colors.white,
                      ),
                      onPressed: () {},
                    ),
                    Text(
                      '${widget.video.totalLikes}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),

                    // Comment button
                    IconButton(
                      icon: const Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                    Text(
                      '${widget.video.totalComments}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),

                    // Share button
                    IconButton(
                      icon: const Icon(Icons.share, color: Colors.white),
                      onPressed: () {},
                    ),
                    Text(
                      '${widget.video.totalShare}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),

              // Play/Pause indicator
              if (!_isPlaying && _isInitialized)
                Icon(
                  Icons.play_arrow,
                  size: 80,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
