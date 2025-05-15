import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:like_button/like_button.dart';
import 'package:video_player/video_player.dart';
import 'package:my_tube/domain/entities/video.dart';

class VideoPlayerItem extends StatefulWidget {
  final Video video;
  final String heroTag;

  const VideoPlayerItem({super.key, required this.video, required this.heroTag});

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
    final videoUrl = widget.video.cdnUrl;
    if (videoUrl == null) {
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
        // Auto-play video after initialization
        _controller.play();
        setState(() {
          _isPlaying = true;
        });
      }
    } catch (e) {
      final endMessage = e.toString().contains('Source error')?'Source error': e.toString();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error playing video: $endMessage'), backgroundColor: Colors.red));
        Navigator.pop(context);
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
    return GestureDetector(
      onTap: _isInitialized ? _playPause : null,
      child: Stack(
        fit: StackFit.loose,
        alignment: Alignment.center,
        children: [
          Container(height: double.infinity),
          // Video or thumbnail
          _isInitialized
              ? AspectRatio(aspectRatio: _controller.value.aspectRatio, child: VideoPlayer(_controller))
              : widget.video.thumbCdnUrl != null && widget.video.thumbCdnUrl!.isNotEmpty
              ? Image.network(
                widget.video.thumbCdnUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: CircularProgressIndicator());
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value:
                          loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                    ),
                  );
                },
              )
              : const Center(child: CircularProgressIndicator()),

          // Overlay with user info and actions
          Positioned(
            bottom: 110,
            left: 16,
            child: Text(
              widget.video.title!,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
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
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    children: [
                      // Video title
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.grey.shade800,
                        backgroundImage:
                            widget.video.user.profilePictureCdn != null &&
                                    widget.video.user.profilePictureCdn!.startsWith('http')
                                ? NetworkImage(widget.video.user.profilePictureCdn!)
                                : null,
                        child:
                            widget.video.user.profilePictureCdn == null ||
                                    !widget.video.user.profilePictureCdn!.startsWith('http')
                                ? Text(
                                  widget.video.user.fullName?.isNotEmpty == true
                                      ? widget.video.user.fullName![0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                )
                                : null,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.video.user.fullName!,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  // Video description
                  Text(
                    widget.video.description ?? 'No description',
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
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      if (widget.video.language != null && widget.video.language!.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Text(
                          '•  ${widget.video.language}',
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
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
            right: 8,
            bottom: 16,
            child: Column(
              children: [
                LikeButton(
                  circleColor: CircleColor(start: Colors.red, end: Colors.redAccent),
                  bubblesColor: BubblesColor(
                    dotPrimaryColor: Color(0xFF1DA1F2),
                    dotSecondaryColor: Color(0xFF17BF63),
                    dotThirdColor: Color(0xFFFFAD1F),
                    dotLastColor: Color(0xFFE0245E),
                  ),
                  likeBuilder: (bool isLiked) {
                    return Icon(
                      isLiked ? Icons.favorite_rounded : HugeIcons.strokeRoundedFavourite,
                      color: isLiked ? Colors.redAccent : Colors.white,
                    );
                  },
                  countPostion: CountPostion.bottom,
                  likeCount: widget.video.totalLikes,
                  countBuilder: (int? count, bool isLiked, String text) {
                    return Text(text, style: TextStyle(color: Colors.white));
                  },
                ),
                const SizedBox(height: 4),
                IconButton(icon: const Icon(HugeIcons.strokeRoundedComment03, color: Colors.white), onPressed: () {}),
                Text('${widget.video.totalComments}', style: const TextStyle(color: Colors.white)),
                const SizedBox(height: 4),
                IconButton(icon: const Icon(HugeIcons.strokeRoundedBookmark02, color: Colors.white), onPressed: () {}),
                Text('${widget.video.totalWishlist}', style: const TextStyle(color: Colors.white)),
                const SizedBox(height: 4),
                IconButton(icon: const Icon(HugeIcons.strokeRoundedShare08, color: Colors.white), onPressed: () {}),
                Text('${widget.video.totalShare}', style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),

          // Play/Pause indicator
          if (!_isPlaying && _isInitialized)
            Icon(Icons.play_arrow, size: 80, color: Colors.white.withValues(alpha: 0.7)),
        ],
      ),
    );
  }
}
