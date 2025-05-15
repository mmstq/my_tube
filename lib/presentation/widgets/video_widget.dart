import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:my_tube/core/util/helper_functions.dart';
import 'package:my_tube/domain/entities/video.dart';
import 'package:my_tube/presentation/bloc/reels_bloc.dart';
import 'package:my_tube/presentation/pages/reels_homepage.dart';

import '../pages/reels.dart';

Widget buildVideoItem(
  Video video,
  BuildContext context,
  int selectedIndex,
  List<Video> currentVideos,
) {
  final isHorizontal = video.orientation == 'landscape';
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => BlocProvider.value(
                value: context.read<ReelsBloc>(),
                child: Reels(
                  initialVideos: currentVideos,
                  initialIndex: selectedIndex,
                ),
              ),
        ),
      );
    },
    child: Container(
      height: 300,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: video.thumbCdnUrl ?? '',
              fit: BoxFit.cover,
              height: isHorizontal ? 116 : 400,
              width: double.infinity,
              placeholder:
                  (_, __) => Container(
                    color: Colors.grey[900],
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
              errorWidget:
                  (_, __, ___) => Container(
                    color: Colors.grey[900],
                    child: const Center(
                      child: Icon(Icons.error_outline, color: Colors.white54),
                    ),
                  ),
            ),
          ),
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
                formatDuration(video.duration ?? 0),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          isHorizontal
              ? Positioned(
                left: isHorizontal ? 0 : 8,
                bottom: 0,
                right: isHorizontal ? 0 : 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.grey.shade800,
                        backgroundImage:
                            video.user.profilePictureCdn?.startsWith('http') ==
                                    true
                                ? CachedNetworkImageProvider(
                                  video.user.profilePictureCdn!,
                                )
                                : null,
                        child:
                            video.user.profilePictureCdn?.startsWith('http') !=
                                    true
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              video.title ?? 'No Title',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              video.user.fullName ?? 'Unknown',
                              style: TextStyle(
                                color: Colors.grey,
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
              )
              : Positioned(
                left: 8,
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.grey.shade800,
                        backgroundImage:
                            video.user.profilePictureCdn?.startsWith('http') ==
                                    true
                                ? CachedNetworkImageProvider(
                                  video.user.profilePictureCdn!,
                                )
                                : null,
                        child:
                            video.user.profilePictureCdn?.startsWith('http') !=
                                    true
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
