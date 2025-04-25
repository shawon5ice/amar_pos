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
      _$PermissionApiResponseFromJson(json,);

  factory PermissionApiResponse.fromJsonForGroupData(Map<String, dynamic> json) {
    return PermissionApiResponse(
      success: json['success'] ?? false,
      data: (json['groupedData'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(
          key,
          Map<String, String>.from(value),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() => _$PermissionApiResponseToJson(this);
}