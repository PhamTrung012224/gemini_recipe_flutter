// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'youtube_response_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YoutubeResponse _$YoutubeResponseFromJson(Map<String, dynamic> json) =>
    YoutubeResponse(
      items: (json['items'] as List<dynamic>)
          .map((e) => YoutubeItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$YoutubeResponseToJson(YoutubeResponse instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
    };

YoutubeItem _$YoutubeItemFromJson(Map<String, dynamic> json) => YoutubeItem(
      id: VideoId.fromJson(json['id'] as Map<String, dynamic>),
      snippet: Snippet.fromJson(json['snippet'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$YoutubeItemToJson(YoutubeItem instance) =>
    <String, dynamic>{
      'id': instance.id.toJson(),
      'snippet': instance.snippet.toJson(),
    };

VideoId _$VideoIdFromJson(Map<String, dynamic> json) => VideoId(
      videoId: json['videoId'] as String,
    );

Map<String, dynamic> _$VideoIdToJson(VideoId instance) => <String, dynamic>{
      'videoId': instance.videoId,
    };

Snippet _$SnippetFromJson(Map<String, dynamic> json) => Snippet(
      title: json['title'] as String,
      thumbnails:
          Thumbnails.fromJson(json['thumbnails'] as Map<String, dynamic>),
      channelTitle: json['channelTitle'] as String,
    );

Map<String, dynamic> _$SnippetToJson(Snippet instance) => <String, dynamic>{
      'title': instance.title,
      'thumbnails': instance.thumbnails.toJson(),
      'channelTitle': instance.channelTitle,
    };

Thumbnails _$ThumbnailsFromJson(Map<String, dynamic> json) => Thumbnails(
      medium: Thumbnail.fromJson(json['medium'] as Map<String, dynamic>),
      high: Thumbnail.fromJson(json['high'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ThumbnailsToJson(Thumbnails instance) =>
    <String, dynamic>{
      'medium': instance.medium.toJson(),
      'high': instance.high.toJson(),
    };

Thumbnail _$ThumbnailFromJson(Map<String, dynamic> json) => Thumbnail(
      url: json['url'] as String,
      width: (json['width'] as num).toInt(),
      height: (json['height'] as num).toInt(),
    );

Map<String, dynamic> _$ThumbnailToJson(Thumbnail instance) => <String, dynamic>{
      'url': instance.url,
      'width': instance.width,
      'height': instance.height,
    };
