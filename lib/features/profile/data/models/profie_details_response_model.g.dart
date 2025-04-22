// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profie_details_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileDetailsResponseModel _$ProfileDetailsResponseModelFromJson(
        Map<String, dynamic> json) =>
    ProfileDetailsResponseModel(
      success: json['success'] as bool,
      data: ProfileDetailsData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProfileDetailsResponseModelToJson(
        ProfileDetailsResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };

ProfileDetailsData _$ProfileDetailsDataFromJson(Map<String, dynamic> json) =>
    ProfileDetailsData(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String? ?? 'N/A',
      phone: json['phone'] as String? ?? 'N/A',
      email: json['email'] as String? ?? 'N/A',
      address: json['address'] as String? ?? 'N/A',
      designation: json['designation'] as String? ?? 'N/A',
      dob: json['dob'] as String? ?? 'N/A',
      maritalStatus: json['marital_status'] as String? ?? 'N/A',
      photo: json['photo'] as String? ?? 'N/A',
      gender: json['gender'] as String? ?? 'N/A',
      bloodGroup: json['blood_group'] as String? ?? 'N/A',
    );

Map<String, dynamic> _$ProfileDetailsDataToJson(ProfileDetailsData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
      'address': instance.address,
      'dob': instance.dob,
      'gender': instance.gender,
      'marital_status': instance.maritalStatus,
      'blood_group': instance.bloodGroup,
      'designation': instance.designation,
      'photo': instance.photo,
    };
