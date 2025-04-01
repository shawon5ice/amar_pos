import 'package:json_annotation/json_annotation.dart';

part 'permissions.g.dart';


@JsonSerializable()
class PermissionApiResponse {
  final bool success;
  final Map<String, Map<String, String>> data;

  PermissionApiResponse({
    required this.success,
    required this.data,
  });

  factory PermissionApiResponse.fromJson(Map<String, dynamic> json) =>
      _$PermissionApiResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PermissionApiResponseToJson(this);
}