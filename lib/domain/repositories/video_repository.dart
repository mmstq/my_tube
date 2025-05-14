import 'package:my_tube/domain/entities/video.dart';

abstract class VideoRepository {
  /// Gets a list of videos from the API
  ///
  /// Returns a Future with a list of [Video] entities.
  /// Throws an exception if something goes wrong.
  Future<List<Video>> getVideos(int page, int limit);

  /// Clears the video cache
  Future<bool> clearCache();
}
