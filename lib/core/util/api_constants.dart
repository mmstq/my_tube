class ApiConstants {
  static const String baseUrl = 'https://backend-cj4o057m.fctl.app';
  static const String videosEndpoint = '/bytes/scroll';

  static String getVideosUrl(int page, int limit) {
    return '$baseUrl$videosEndpoint?page=$page&limit=$limit';
  }
}
