
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
  String _id;
  String get id => _id;

  Comment();

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  static Map<String, dynamic> toJson(Comment instance) =>
      _$CommentToJson(instance);
}