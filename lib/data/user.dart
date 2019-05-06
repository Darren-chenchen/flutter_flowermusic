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
  String userPic = '';
  User();

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);

  static Map<String, dynamic> toJson(User instance) =>
      _$UserToJson(instance);
}
