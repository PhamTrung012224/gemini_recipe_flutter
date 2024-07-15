import 'package:gemini_cookbook/src/config/models/services/api_provider/dio_provider.dart';
import 'package:gemini_cookbook/src/config/models/services/youtube_search/constants.dart';

class YoutubeSearchRepository {
  late final DioProvider dioProvider;

  YoutubeSearchRepository()
      : dioProvider = DioProvider(baseUrl: YoutubeSearchConstants.baseUrl);

  Future<Map<String, dynamic>> search(String q, int maxResults) async {
    const path = '';
    return dioProvider.get(path, queryParameters: {
      'part': 'snippet',
      'maxResults': maxResults,
      'q': q,
      'videoDuration': 'medium',
      'type': 'video',
      'videoType': 'any',
      'key': YoutubeSearchConstants.youtubeApiKey
    });
  }
}
