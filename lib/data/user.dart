import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {

  String userId;
  String userName;
  String passWord;
  String creatDateStr;
  String creatDate;
  String token;
  String email;
  @JsonKey(nullable: true)
  String userPic = '';
  User();

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);

  Map<String, dynamic> toJson() =>
      _$UserToJson(this);
}
