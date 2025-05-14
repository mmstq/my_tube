import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_tube/data/models/video_model.dart';

class CacheUtil {
  final SharedPreferences sharedPreferences;

  CacheUtil({required this.sharedPreferences});

  Future<bool> cacheVideos(List<VideoModel> videos, int page) async {
    final String jsonVideos = json.encode(
      videos.map((video) => video.toJson()).toList(),
    );
    return await sharedPreferences.setString(
      'CACHED_VIDEOS_PAGE_$page',
      jsonVideos,
    );
  }

  List<VideoModel>? getVideosFromCache(int page) {
    final String? jsonVideos = sharedPreferences.getString(
      'CACHED_VIDEOS_PAGE_$page',
    );
    if (jsonVideos != null) {
      final List<dynamic> decodedData = json.decode(jsonVideos);
      return decodedData
          .map<VideoModel>((json) => VideoModel.fromJson(json))
          .toList();
    }
    return null;
  }

  Future<bool> clearCache() async {
    final keys = sharedPreferences.getKeys();
    final videoCacheKeys = keys.where(
      (key) => key.startsWith('CACHED_VIDEOS_PAGE_'),
    );

    for (final key in videoCacheKeys) {
      await sharedPreferences.remove(key);
    }

    return true;
  }
}
