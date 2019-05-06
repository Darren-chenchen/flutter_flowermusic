import 'package:json_annotation/json_annotation.dart';

part 'song.g.dart';

@JsonSerializable()
class Song {

  String _id;
  String imgUrl;
  String lrcUrl;
  String size;
  String singer;
  String songUrl;
  String title;
  String duration;
  String imgUrl_s;
  String desc;
  bool isFav;

  String get id => _id;

  /// 自定义属性
  bool isExpaned = false;

  Song();

  factory Song.fromJson(Map<String, dynamic> json) =>
      _$SongFromJson(json);

  static Map<String, dynamic> toJson(Song instance) =>
      _$SongToJson(instance);
}
