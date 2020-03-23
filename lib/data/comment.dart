
import 'package:flutter_flowermusic/data/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment {
  User user;
  String content;
  String creatDateStr;
  int niceCount;
  String songId;
  @JsonKey(name: '_id', nullable: true)
  String id;

  Comment({this.user, this.content, this.creatDateStr, this.niceCount, this.songId});

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CommentToJson(this);
}