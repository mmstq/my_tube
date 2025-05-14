import 'package:flutter/material.dart';
import 'package:my_tube/domain/entities/video.dart';
import 'package:my_tube/presentation/widgets/video_player_item.dart';

class ReelsPage extends StatelessWidget {
  final Video initialVideo;

  const ReelsPage({super.key, required this.initialVideo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: VideoPlayerItem(video: initialVideo, heroTag: 'video-${initialVideo.id}'),
    );
  }
}
