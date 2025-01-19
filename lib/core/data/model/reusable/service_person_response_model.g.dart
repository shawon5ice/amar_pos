// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_person_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServicePersonResponseModel _$ServicePersonResponseModelFromJson(
        Map<String, dynamic> json) =>
    ServicePersonResponseModel(
      success: json['success'] as bool,
      serviceStuffList: (json['data'] as List<dynamic>)
          .map((e) => ServiceStuffInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ServicePersonResponseModelToJson(
        ServicePersonResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.serviceStuffList,
    };

ServiceStuffInfo _$ServiceStuffInfoFromJson(Map<String, dynamic> json) =>
    ServiceStuffInfo(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      photoUrl: json['photo_url'] as String,
    );

Map<String, dynamic> _$ServiceStuffInfoToJson(ServiceStuffInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'photo_url': instance.photoUrl,
    };
