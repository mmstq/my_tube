import 'package:my_tube/core/util/cache_util.dart';
import 'package:my_tube/data/models/video_model.dart';
import 'package:my_tube/data/sources/video_remote_data_source.dart';
import 'package:my_tube/domain/entities/video.dart';
import 'package:my_tube/domain/repositories/video_repository.dart';

class VideoRepositoryImpl implements VideoRepository {
  final VideoRemoteDataSource remoteDataSource;
  final CacheUtil cacheUtil;

  VideoRepositoryImpl({
    required this.remoteDataSource,
    required this.cacheUtil,
  });

  @override
  Future<List<Video>> getVideos(int page, int limit) async {
      // Try to get videos from cache first
      final cachedVideos = cacheUtil.getVideosFromCache(page);

      if (cachedVideos != null && cachedVideos.isNotEmpty) {
        // Convert VideoModel to Video entity
        return cachedVideos.map((model) => _convertToEntity(model)).toList();
      } else {
        // Fetch from API if cache is empty
        final remoteVideos = await remoteDataSource.getVideos(page, limit);

        // Cache the fetched videos
        await cacheUtil.cacheVideos(remoteVideos, page);

        // Convert VideoModel to Video entity
        return remoteVideos.map((model) => _convertToEntity(model)).toList();
      }
  }

  @override
  Future<bool> clearCache() async {
    return await cacheUtil.clearCache();
  }

  // Helper method to convert VideoModel to Video entity
    Video _convertToEntity(VideoModel model) {
    return Video(
      id: model.id,
      title: model.title,
      description: model.description,
      url: model.url,
      cdnUrl: model.cdnUrl,
      thumbCdnUrl: model.thumbCdnUrl,
      userId: model.userId,
      status: model.status,
      slug: model.slug,
      encodeStatus: model.encodeStatus,
      priority: model.priority,
      totalViews: model.totalViews,
      totalLikes: model.totalLikes,
      totalComments: model.totalComments,
      totalShare: model.totalShare,
      totalWishlist: model.totalWishlist,
      duration: model.duration,
      language: model.language,
      orientation: model.orientation,
      videoHeight: model.videoHeight,
      videoWidth: model.videoWidth,
      isPrivate: model.isPrivate,
      isHideComment: model.isHideComment,
      user: model.user,
      category: model.category!,
      isLiked: model.isLiked,
      isWished: model.isWished,
      isFollow: model.isFollow,
    );
  }
}
