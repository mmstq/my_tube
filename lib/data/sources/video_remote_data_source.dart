import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_tube/core/util/api_constants.dart';
import 'package:my_tube/data/models/video_model.dart';

abstract class VideoRemoteDataSource {
  /// Calls the API endpoint to get videos
  ///
  /// Throws an exception if the response code is not 200
  Future<List<VideoModel>> getVideos(int page, int limit);
}

class VideoRemoteDataSourceImpl implements VideoRemoteDataSource {
  final http.Client client;

  VideoRemoteDataSourceImpl({required this.client});

  @override
  Future<List<VideoModel>> getVideos(int page, int limit) async {
    final response = await client.get(
      Uri.parse(ApiConstants.getVideosUrl(page, limit)),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> videosJson = jsonResponse['data']?['data'] ?? [];
      return videosJson
          .map<VideoModel>((json) => VideoModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load videos: ${response.statusCode}');
    }
  }
}
