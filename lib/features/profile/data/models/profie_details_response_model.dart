import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'profie_details_response_model.g.dart';

@JsonSerializable()
class ProfileDetailsResponseModel {
  final bool success;
  final ProfileDetailsData data;

  ProfileDetailsResponseModel({required this.success, required this.data});

  factory ProfileDetailsResponseModel.fromJson(Map<String, dynamic> json) => _$ProfileDetailsResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileDetailsResponseModelToJson(this);
}

@JsonSerializable()
class ProfileDetailsData {
  final int id;
  @JsonKey(defaultValue: 'N/A')
  final String name;
  @JsonKey(defaultValue: 'N/A')
  final String phone;
  @JsonKey(defaultValue: 'N/A')
  final String email;
  @JsonKey(defaultValue: 'N/A')
  final String address;
  @JsonKey(defaultValue: 'N/A')
  final String dob;
  @JsonKey(defaultValue: 'N/A')
  final String gender;
  @JsonKey(name: 'marital_status',defaultValue: 'N/A')
  final String? maritalStatus;
  @JsonKey(name: 'blood_group',defaultValue: 'N/A')
  final String? bloodGroup;
  @JsonKey(defaultValue: 'N/A')
  final String? designation;
  @JsonKey(defaultValue: 'N/A')
  final String? photo;

  ProfileDetailsData({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.designation,
    required this.dob,
    required this.maritalStatus,
    required this.photo,
    required this.gender,
    required this.bloodGroup,
  });

  factory ProfileDetailsData.fromJson(Map<String, dynamic> json) => _$ProfileDetailsDataFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileDetailsDataToJson(this);
}