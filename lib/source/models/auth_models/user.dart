import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:project_temp/source/models/models.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable {
  const User({
    required this.id,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    this.middleName,
    this.email,
    this.pin,
    this.personId,
    this.verificationStatus,
    this.rejectReasonDescription,
    this.payoutPhone,
  });

  @JsonKey(fromJson: stringIdFromJson, defaultValue: '')
  final String id;

  @JsonKey(defaultValue: '')
  final String phoneNumber;

  @JsonKey(defaultValue: '')
  final String firstName;

  @JsonKey(defaultValue: '')
  final String lastName;

  final String? middleName;
  final String? email;
  final String? pin;

  @JsonKey(fromJson: personIdFromJson)
  final int? personId;

  final String? verificationStatus;
  final String? rejectReasonDescription;
  final String? payoutPhone;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  String get displayName {
    final parts = <String>[
      firstName,
      if (middleName != null && middleName!.isNotEmpty) middleName!,
      lastName,
    ].where((s) => s.isNotEmpty).toList();
    if (parts.isEmpty) return phoneNumber;
    return parts.join(' ');
  }

  @override
  List<Object?> get props => [
        id,
        phoneNumber,
        firstName,
        lastName,
        middleName,
        email,
        pin,
        personId,
        verificationStatus,
        rejectReasonDescription,
        payoutPhone,
      ];
}
