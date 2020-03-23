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

  @JsonKey(name: '_id', nullable: true)
  String id;

  /// 自定义属性
  bool isExpaned = false;

  Song();

  factory Song.fromJson(Map<String, dynamic> json) =>
      _$SongFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SongToJson(this);
}
