// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Song _$SongFromJson(Map<String, dynamic> json) {
  return Song()
    ..imgUrl = json['imgUrl'] as String
    ..lrcUrl = json['lrcUrl'] as String
    ..size = json['size'] as String
    ..singer = json['singer'] as String
    ..songUrl = json['songUrl'] as String
    ..title = json['title'] as String
    ..duration = json['duration'] as String
    ..imgUrl_s = json['imgUrl_s'] as String
    ..desc = json['desc'] as String
    ..isFav = json['isFav'] as bool
    ..id = json['_id'] as String
    ..isExpaned = json['isExpaned'] as bool;
}

Map<String, dynamic> _$SongToJson(Song instance) => <String, dynamic>{
      'imgUrl': instance.imgUrl,
      'lrcUrl': instance.lrcUrl,
      'size': instance.size,
      'singer': instance.singer,
      'songUrl': instance.songUrl,
      'title': instance.title,
      'duration': instance.duration,
      'imgUrl_s': instance.imgUrl_s,
      'desc': instance.desc,
      'isFav': instance.isFav,
      '_id': instance.id,
      'isExpaned': instance.isExpaned
    };
