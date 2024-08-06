import 'package:json_annotation/json_annotation.dart';

part 'youtube_response_object.g.dart';

@JsonSerializable(explicitToJson: true)
class YoutubeResponse {
  final List<YoutubeItem> items;

  YoutubeResponse({
    required this.items,
  });

  factory YoutubeResponse.fromJson(Map<String, dynamic> json) =>
      _$YoutubeResponseFromJson(json);
  Map<String, dynamic> toJson() => _$YoutubeResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class YoutubeItem {
  final VideoId id;
  final Snippet snippet;

  YoutubeItem({
    required this.id,
    required this.snippet,
  });

  factory YoutubeItem.fromJson(Map<String, dynamic> json) =>
      _$YoutubeItemFromJson(json);
  Map<String, dynamic> toJson() => _$YoutubeItemToJson(this);
}

@JsonSerializable(explicitToJson: true)
class VideoId {
  final String videoId;

  VideoId({
    required this.videoId,
  });

  factory VideoId.fromJson(Map<String, dynamic> json) =>
      _$VideoIdFromJson(json);
  Map<String, dynamic> toJson() => _$VideoIdToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Snippet {
  final String title;
  final Thumbnails thumbnails;
  final String channelTitle;

  Snippet({
    required this.title,
    required this.thumbnails,
    required this.channelTitle,
  });

  factory Snippet.fromJson(Map<String, dynamic> json) =>
      _$SnippetFromJson(json);
  Map<String, dynamic> toJson() => _$SnippetToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Thumbnails {
  final Thumbnail medium;
  final Thumbnail high;

  Thumbnails({
    required this.medium,
    required this.high,
  });

  factory Thumbnails.fromJson(Map<String, dynamic> json) =>
      _$ThumbnailsFromJson(json);
  Map<String, dynamic> toJson() => _$ThumbnailsToJson(this);
}

@JsonSerializable()
class Thumbnail {
  final String url;
  final int width;
  final int height;

  Thumbnail({
    required this.url,
    required this.width,
    required this.height,
  });

  factory Thumbnail.fromJson(Map<String, dynamic> json) =>
      _$ThumbnailFromJson(json);
  Map<String, dynamic> toJson() => _$ThumbnailToJson(this);
}
