// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User()
    ..userId = json['userId'] as String
    ..userName = json['userName'] as String
    ..passWord = json['passWord'] as String
    ..creatDateStr = json['creatDateStr'] as String
    ..creatDate = json['creatDate'] as String
    ..token = json['token'] as String
    ..email = json['email'] as String
    ..userPic = json['userPic'] as String;
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userId': instance.userId,
      'userName': instance.userName,
      'passWord': instance.passWord,
      'creatDateStr': instance.creatDateStr,
      'creatDate': instance.creatDate,
      'token': instance.token,
      'email': instance.email,
      'userPic': instance.userPic
    };
