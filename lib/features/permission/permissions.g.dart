// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permissions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PermissionApiResponse _$PermissionApiResponseFromJson(
        Map<String, dynamic> json) =>
    PermissionApiResponse(
      success: json['success'] as bool,
      data: (json['data'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, Map<String, String>.from(e as Map)),
      ),
    );


PermissionApiResponse _$PermissionApiResponseFromJsonForGroupData(
        Map<String, dynamic> json,) =>
    PermissionApiResponse(
      success: json['success'] as bool,
      data: (json['groupedData'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, Map<String, String>.from(e as Map)),
      ),
    );

Map<String, dynamic> _$PermissionApiResponseToJson(
        PermissionApiResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };
