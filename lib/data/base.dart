//library baseresponse;

import 'package:json_annotation/json_annotation.dart';

part 'base.g.dart';

@JsonSerializable()
class BaseResponse {
  int code;
  int total;
  int totalPage;
  dynamic data;
  String message;
  bool success;

  BaseResponse({this.code, this.total, this.totalPage, this.data, this.message, this.success});

  factory BaseResponse.fromJson(Map<String, dynamic> json) =>
      _$BaseResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$BaseResponseToJson(this);
}

@JsonSerializable()
class CommonResponse {
  int code;
  dynamic data;
  String message;
  bool success;

  CommonResponse();

  factory CommonResponse.fromJson(Map<String, dynamic> json) => _$CommonResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CommonResponseToJson(this);
}
