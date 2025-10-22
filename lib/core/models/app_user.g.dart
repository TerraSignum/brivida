// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
  uid: json['uid'] as String,
  email: json['email'] as String,
  displayName: json['displayName'] as String?,
  username: json['username'] as String?,
  usernameLower: json['usernameLower'] as String?,
  photoUrl: json['photoUrl'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
  locale: json['locale'] as String?,
  marketingOptIn: json['marketingOptIn'] as bool? ?? false,
  isVerified: json['isVerified'] as bool? ?? false,
  role: json['role'] as String?,
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  deleted: json['deleted'] as bool? ?? false,
);

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
  'uid': instance.uid,
  'email': instance.email,
  'displayName': instance.displayName,
  'username': instance.username,
  'usernameLower': instance.usernameLower,
  'photoUrl': instance.photoUrl,
  'phoneNumber': instance.phoneNumber,
  'locale': instance.locale,
  'marketingOptIn': instance.marketingOptIn,
  'isVerified': instance.isVerified,
  'role': instance.role,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'deleted': instance.deleted,
};
