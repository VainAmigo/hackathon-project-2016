// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: json['id'] == null ? '' : stringIdFromJson(json['id']),
  phoneNumber: json['phoneNumber'] as String? ?? '',
  firstName: json['firstName'] as String? ?? '',
  lastName: json['lastName'] as String? ?? '',
  middleName: json['middleName'] as String?,
  email: json['email'] as String?,
  pin: json['pin'] as String?,
  personId: personIdFromJson(json['personId']),
  verificationStatus: json['verificationStatus'] as String?,
  rejectReasonDescription: json['rejectReasonDescription'] as String?,
  payoutPhone: json['payoutPhone'] as String?,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'phoneNumber': instance.phoneNumber,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'middleName': instance.middleName,
  'email': instance.email,
  'pin': instance.pin,
  'personId': instance.personId,
  'verificationStatus': instance.verificationStatus,
  'rejectReasonDescription': instance.rejectReasonDescription,
  'payoutPhone': instance.payoutPhone,
};
