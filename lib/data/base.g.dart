// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseResponse _$BaseResponseFromJson(Map<String, dynamic> json) {
  return BaseResponse(
      code: json['code'] as int,
      total: json['total'] as int,
      totalPage: json['totalPage'] as int,
      data: json['data'],
      message: json['message'] as String,
      success: json['success'] as bool);
}

Map<String, dynamic> _$BaseResponseToJson(BaseResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'total': instance.total,
      'totalPage': instance.totalPage,
      'data': instance.data,
      'message': instance.message,
      'success': instance.success
    };

CommonResponse _$CommonResponseFromJson(Map<String, dynamic> json) {
  return CommonResponse()
    ..code = json['code'] as int
    ..data = json['data']
    ..message = json['message'] as String
    ..success = json['success'] as bool;
}

Map<String, dynamic> _$CommonResponseToJson(CommonResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'data': instance.data,
      'message': instance.message,
      'success': instance.success
    };
