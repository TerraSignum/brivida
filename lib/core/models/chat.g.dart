// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Chat _$ChatFromJson(Map<String, dynamic> json) => _Chat(
  id: json['id'] as String?,
  jobId: json['jobId'] as String,
  customerUid: json['customerUid'] as String,
  proUid: json['proUid'] as String,
  memberUids: (json['memberUids'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  lastMessage: json['lastMessage'] as String?,
  lastMessageAt: json['lastMessageAt'] == null
      ? null
      : DateTime.parse(json['lastMessageAt'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ChatToJson(_Chat instance) => <String, dynamic>{
  'id': instance.id,
  'jobId': instance.jobId,
  'customerUid': instance.customerUid,
  'proUid': instance.proUid,
  'memberUids': instance.memberUids,
  'lastMessage': instance.lastMessage,
  'lastMessageAt': instance.lastMessageAt?.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

_Message _$MessageFromJson(Map<String, dynamic> json) => _Message(
  id: json['id'] as String?,
  senderUid: json['senderUid'] as String,
  type: $enumDecode(_$MessageTypeEnumMap, json['type']),
  content: json['content'] as String?,
  imageUrl: json['imageUrl'] as String?,
  delivered: json['delivered'] as bool? ?? false,
  read: json['read'] as bool? ?? false,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$MessageToJson(_Message instance) => <String, dynamic>{
  'id': instance.id,
  'senderUid': instance.senderUid,
  'type': _$MessageTypeEnumMap[instance.type]!,
  'content': instance.content,
  'imageUrl': instance.imageUrl,
  'delivered': instance.delivered,
  'read': instance.read,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

const _$MessageTypeEnumMap = {
  MessageType.text: 'text',
  MessageType.image: 'image',
};
