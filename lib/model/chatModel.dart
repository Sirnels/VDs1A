// ignore_for_file: file_names

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:viewducts/helper/enum.dart';

@immutable
class UnreadMessageModel {
  final String chatListkey;
  final String senderUserId;
  UnreadMessageModel({
    required this.chatListkey,
    required this.senderUserId,
  });

  UnreadMessageModel copyWith({
    String? chatListkey,
    String? senderUserId,
  }) {
    return UnreadMessageModel(
      chatListkey: chatListkey ?? this.chatListkey,
      senderUserId: senderUserId ?? this.senderUserId,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'chatListkey': chatListkey});
    result.addAll({'senderUserId': senderUserId});

    return result;
  }

  factory UnreadMessageModel.fromMap(Map<String, dynamic> map) {
    return UnreadMessageModel(
      chatListkey: map['chatListkey'] ?? '',
      senderUserId: map['senderUserId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UnreadMessageModel.fromJson(String source) =>
      UnreadMessageModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'UnreadMessageModel(chatListkey: $chatListkey, senderUserId: $senderUserId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UnreadMessageModel &&
        other.chatListkey == chatListkey &&
        other.senderUserId == senderUserId;
  }

  @override
  int get hashCode => chatListkey.hashCode ^ senderUserId.hashCode;
}

@immutable
class SendMessageModel {
  final ChatMessage onlineMessage;
  final ChatMessage localMessage;
  final MessagesType messageType;
  final int timeStamp;
  final BuildContext context;
  final String imagePath;
  final String videoPath;
  final String localMediaPath;
  SendMessageModel({
    required this.onlineMessage,
    required this.localMessage,
    required this.messageType,
    required this.timeStamp,
    required this.context,
    required this.imagePath,
    required this.videoPath,
    required this.localMediaPath,
  });

  SendMessageModel copyWith({
    ChatMessage? onlineMessage,
    ChatMessage? localMessage,
    MessagesType? messageType,
    int? timeStamp,
    BuildContext? context,
    String? imagePath,
    String? videoPath,
    String? localMediaPath,
  }) {
    return SendMessageModel(
      onlineMessage: onlineMessage ?? this.onlineMessage,
      localMessage: localMessage ?? this.localMessage,
      messageType: messageType ?? this.messageType,
      timeStamp: timeStamp ?? this.timeStamp,
      context: context ?? this.context,
      imagePath: imagePath ?? this.imagePath,
      videoPath: videoPath ?? this.videoPath,
      localMediaPath: localMediaPath ?? this.localMediaPath,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'onlineMessage': onlineMessage});
    result.addAll({'localMessage': localMessage});
    result.addAll({'messageType': messageType});
    result.addAll({'timeStamp': timeStamp});
    result.addAll({'context': context});
    result.addAll({'imagePath': imagePath});
    result.addAll({'videoPath': videoPath});
    result.addAll({'localMediaPath': localMediaPath});

    return result;
  }

  factory SendMessageModel.fromMap(Map<String, dynamic> map) {
    return SendMessageModel(
      onlineMessage: ChatMessage.fromJson(map['onlineMessage']),
      localMessage: ChatMessage.fromJson(map['localMessage']),
      messageType: (map['messageType']),
      timeStamp: map['timeStamp']?.toInt() ?? 0,
      context: (map['context']),
      imagePath: map['imagePath'] ?? '',
      videoPath: map['videoPath'] ?? '',
      localMediaPath: map['localMediaPath'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SendMessageModel.fromJson(String source) =>
      SendMessageModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SendMessageModel(onlineMessage: $onlineMessage, localMessage: $localMessage, messageType: $messageType, timeStamp: $timeStamp, context: $context, imagePath: $imagePath, videoPath: $videoPath, localMediaPath: $localMediaPath)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SendMessageModel &&
        other.onlineMessage == onlineMessage &&
        other.localMessage == localMessage &&
        other.messageType == messageType &&
        other.timeStamp == timeStamp &&
        other.context == context &&
        other.imagePath == imagePath &&
        other.videoPath == videoPath &&
        other.localMediaPath == localMediaPath;
  }

  @override
  int get hashCode {
    return onlineMessage.hashCode ^
        localMessage.hashCode ^
        messageType.hashCode ^
        timeStamp.hashCode ^
        context.hashCode ^
        imagePath.hashCode ^
        videoPath.hashCode ^
        localMediaPath.hashCode;
  }
}

@immutable
class ChatCridentialsModel {
  final String currentSecondUserChatkey;
  final String isDowmloaded;
  final String currentUser;
  final String secondUser;
  final WidgetRef ref;
  ChatCridentialsModel({
    required this.currentSecondUserChatkey,
    required this.isDowmloaded,
    required this.currentUser,
    required this.secondUser,
    required this.ref,
  });

  ChatCridentialsModel copyWith({
    String? currentSecondUserChatkey,
    String? isDowmloaded,
    String? currentUser,
    String? secondUser,
    WidgetRef? ref,
  }) {
    return ChatCridentialsModel(
      currentSecondUserChatkey:
          currentSecondUserChatkey ?? this.currentSecondUserChatkey,
      isDowmloaded: isDowmloaded ?? this.isDowmloaded,
      currentUser: currentUser ?? this.currentUser,
      secondUser: secondUser ?? this.secondUser,
      ref: ref ?? this.ref,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'currentSecondUserChatkey': currentSecondUserChatkey});
    result.addAll({'isDowmloaded': isDowmloaded});
    result.addAll({'currentUser': currentUser});
    result.addAll({'secondUser': secondUser});
    result.addAll({'ref': ref});

    return result;
  }

  factory ChatCridentialsModel.fromMap(Map<String, dynamic> map) {
    return ChatCridentialsModel(
      currentSecondUserChatkey: map['currentSecondUserChatkey'] ?? '',
      isDowmloaded: map['isDowmloaded'] ?? '',
      currentUser: map['currentUser'] ?? '',
      secondUser: map['secondUser'] ?? '',
      ref: (map['ref']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatCridentialsModel.fromJson(String source) =>
      ChatCridentialsModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ChatCridentialsModel(currentSecondUserChatkey: $currentSecondUserChatkey, isDowmloaded: $isDowmloaded, currentUser: $currentUser, secondUser: $secondUser, ref: $ref)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatCridentialsModel &&
        other.currentSecondUserChatkey == currentSecondUserChatkey &&
        other.isDowmloaded == isDowmloaded &&
        other.currentUser == currentUser &&
        other.secondUser == secondUser &&
        other.ref == ref;
  }

  @override
  int get hashCode {
    return currentSecondUserChatkey.hashCode ^
        isDowmloaded.hashCode ^
        currentUser.hashCode ^
        secondUser.hashCode ^
        ref.hashCode;
  }
}

class ChatMessage {
  String? key;
  String? senderId;
  String? clicked;
  dynamic message;
  int? reactions;
  String? chatType;
  int? senderReactions;
  int? receiverReactions;
  String? replyedMessage;
  String? fileDownloaded;
  String? seen;
  String? imagePath;
  int? type;
  dynamic createdAt;
  int? orderState;
  String? newChats;
  String? videoKey;
  String? videoThumbnail;
  String? audioFile;
  String? voiceMessage;
  //String? msgTimeStamp;
  int? timeStamp;
//dynamic deleteUpto;
  String? productName;
  String? imageKey;
  String? senderName;
  String? receiverId;
  String? userId;
  String? sellerId;
  String? chatlistKey;
  String? searchKey;

  ChatMessage(
      {this.senderId,
      this.newChats,
      this.audioFile,
      this.fileDownloaded,
      this.userId,
      this.videoThumbnail,
      this.clicked,
      this.message,
      this.orderState,
      this.reactions,
      this.senderReactions,
      this.voiceMessage,
      this.receiverReactions,
      this.replyedMessage,
      this.key,
      this.sellerId,
      this.productName,
      this.chatlistKey,
      this.searchKey,
      this.chatType,
      //this.deleteUpto,
      this.seen,
      this.createdAt,
      this.receiverId,
      this.senderName,
      this.type,
      this.imageKey,
      this.videoKey,
      this.imagePath,
      // this.msgTimeStamp,
      this.timeStamp});

  factory ChatMessage.fromJson(Map<dynamic, dynamic>? json) => ChatMessage(
      senderId: json?["senderId"],
      voiceMessage: json?["voiceMessage"],
      chatType: json?["chatType"],
      videoThumbnail: json?["videoThumbnail"],
      clicked: json?["clicked"],
      audioFile: json?["audioFile"],
      fileDownloaded: json?["fileDownloaded"],
      searchKey: json?['searchKey'],
      chatlistKey: json?['chatlistKey'],
      productName: json?["productName"],
      sellerId: json?["sellerId"],
      newChats: json?["newChats"],
      userId: json?['userId'],
      orderState: json?["orderState"],
      senderReactions: json?["senderReactions"],
      receiverReactions: json?["receiverReactions"],
      reactions: json?["reactions"],
      replyedMessage: json?["replyedMessage"],
      message: json?["message"],
      seen: json?["seen"],
      type: json?['type'],
      key: json?['key'],
      imageKey: json?["imageKey"],
      imagePath: json?["imagePath"],
//msgTimeStamp: json['msgTimeStamp'],
//deleteUpto: json['deleteUpto'],
      createdAt: json?["createdAt"],
      timeStamp: json?['timeStamp'],
      videoKey: json?["videoKey"],
      senderName: json?["senderName"],
      receiverId: json?["receiverId"]);

  Map<String, dynamic> toJson() => {
        "senderId": senderId,
        "voiceMessage": voiceMessage,
        "chatType": chatType,
        "chatlistKey": chatlistKey,
        "videoThumbnail": videoThumbnail,
        "sellerId": sellerId,
        "productName": productName,
        "audioFile": audioFile,
        "searchKey": searchKey,
        "clicked": clicked,
        "message": message,
        "newChats": newChats,
        "userId": userId,
        "fileDownloaded": fileDownloaded,
        "key": key,
        "receiverId": receiverId,
        "seen": seen,
        "reactions": reactions,
        "videoKey": videoKey,
        "senderReactions": senderReactions,
        "receiverReactions": receiverReactions,
        "replyedMessage": replyedMessage,
        "orderState": orderState,
//"deleteUpto": deleteUpto,
        "type": type,
        "imagePath": imagePath,
        "imageKey": imageKey,
//"msgTimeStamp": msgTimeStamp,
        "createdAt": createdAt,
        "senderName": senderName,
        "timeStamp": timeStamp
      };
}

class ChatOnlineStatus {
  String? uid;
  String? chatOnlineChatStatus;
  String? userSeen;
  String? chatStatus;
  String? ids;
  String? lastSeen;
  String? seenChat;
  String? notofication;

  // dynamic receiverOnlineStatus;
  ChatOnlineStatus(
      {this.uid,
      this.chatOnlineChatStatus,
      this.userSeen,
      this.chatStatus,
      this.ids,
      this.notofication,
      this.seenChat,
      this.lastSeen});

  factory ChatOnlineStatus.fromJson(Map<dynamic, dynamic>? json) =>
      ChatOnlineStatus(
        chatStatus: json?['chatStatus'],
        uid: json?["uid"],
        userSeen: json?["userSeen"],
        seenChat: json?["seenChat"],
        notofication: json?['notofication'],
        ids: json?['ids'],
        lastSeen: json?["lastSeen"],
        chatOnlineChatStatus: json?["chatOnlineChatStatus"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "seenChat": seenChat,
        "userSeen": userSeen,
        "notofication": notofication,
        "chatOnlineChatStatus": chatOnlineChatStatus ?? '',
        "chatStatus": chatStatus,
        "lastSeen": lastSeen,
        "ids": ids,
      };
}

class MessageData {
  int? lastSeen;
  QuerySnapshot snapshot;
  MessageData({required this.snapshot, required this.lastSeen});
}

class ChatStoryModel {
  String? key;
  String? senderId;
  dynamic message;
  String? storyId;
  String? chatId;
  int? reactions;
  int? type;
  String? replyedMessage;
  dynamic createdAt;
  String? senderName;
  String? receiverId;
  String? senderImage;
  List<dynamic>? likeList;
  List<dynamic>? seenList;
  int? likeCount;
  int? seenCount;
  ChatStoryModel({
    this.key,
    this.senderId,
    this.message,
    this.chatId,
    this.storyId,
    this.reactions,
    this.replyedMessage,
    this.createdAt,
    this.type,
    this.senderName,
    this.receiverId,
    this.senderImage,
    this.likeList,
    this.seenList,
    this.likeCount,
    this.seenCount,
  });

  factory ChatStoryModel.fromJson(Map<dynamic, dynamic> json) => ChatStoryModel(
      key: json["key"],
      senderId: json["senderId"],
      chatId: json["chatId"],
      message: json["message"],
      storyId: json["storyId"],
      reactions: json["reactions"],
      replyedMessage: json["replyedMessage"],
      type: json["type"],
      createdAt: json["createdAt"],
      senderName: json["senderName"],
      receiverId: json["receiverId"],
      senderImage: json["senderImage"],
      likeList: json["likeList"],
      seenList: json["seenList"],
      likeCount: json["likeCount"],
      seenCount: json["seenCount"]);

  Map<String, dynamic> toJson() => {
        "key": key,
        "senderId": senderId,
        "message": message,
        "storyId": storyId,
        "chatId": chatId,
        "reactions": reactions,
        "replyedMessage": replyedMessage,
        "type": type,
        "createdAt": createdAt,
        "senderName": senderName,
        "receiverId": receiverId,
        "senderImage": senderImage,
        "likeList": likeList,
        "seenList": seenList,
        "likeCount": likeCount,
        "seenCount": seenCount
      };
}

class ViewsModel {
  String? senderId;
  String? userId;
  String? senderName;
  String? storyId;
  String? senderImage;
  ViewsModel(
      {this.senderId,
      this.senderName,
      this.senderImage,
      this.userId,
      this.storyId});

  factory ViewsModel.fromJson(Map<dynamic, dynamic> json) => ViewsModel(
      storyId: json["storyId"],
      userId: json["userId"],
      senderId: json["senderId"],
      senderName: json["senderName"],
      senderImage: json["senderImage"]);

  Map<String, dynamic> toJson() => {
        "storyId": storyId,
        "userId": userId,
        "senderId": senderId,
        "senderName": senderName,
        "senderImage": senderImage
      };
}

class MainUserViewsModel {
  String? viewerId;
  String? viewductUser;
  String? key;

  MainUserViewsModel({this.viewerId, this.viewductUser, this.key});

  factory MainUserViewsModel.fromJson(Map<dynamic, dynamic> json) =>
      MainUserViewsModel(
        viewerId: json["viewerId"],
        key: json["key"],
        viewductUser: json["viewductUser"],
      );

  Map<String, dynamic> toJson() => {
        "viewerId": viewerId,
        "key": key,
        "viewductUser": viewductUser,
      };
}

class AppPlayStoreModel {
  String? downloadApp;
  String? downloadUrl;
  String? operatingSystem;
  String? storeUrl;
  String? buckedId;
  bool? active;

  AppPlayStoreModel(
      {this.downloadApp,
      this.buckedId,
      this.downloadUrl,
      this.operatingSystem,
      this.storeUrl,
      this.active});

  factory AppPlayStoreModel.fromJson(Map<dynamic, dynamic> json) =>
      AppPlayStoreModel(
          downloadApp: json["downloadApp"],
          operatingSystem: json["operatingSystem"],
          downloadUrl: json["downloadUrl"],
          storeUrl: json["storeUrl"],
          active: json["active"],
          buckedId: json["buckedId"]);

  Map<String, dynamic> toJson() => {
        "downloadApp": downloadApp,
        "operatingSystem": operatingSystem,
        "downloadUrl": downloadUrl,
        "storeUrl": storeUrl,
        "active": active,
        "buckedId": buckedId,
      };
}

class AwsWasabiStorageModel {
  String? endPoint;
  String? accessKey;
  String? secretKey;
  String? payStackPublickey;
  String? region;
  String? buckedId;
  String? payStackBackendUrl;

  AwsWasabiStorageModel({
    this.endPoint,
    this.buckedId,
    this.accessKey,
    this.secretKey,
    this.payStackPublickey,
    this.payStackBackendUrl,
    this.region,
  });

  factory AwsWasabiStorageModel.fromJson(Map<dynamic, dynamic> json) =>
      AwsWasabiStorageModel(
          endPoint: json["endPoint"],
          payStackBackendUrl: json["payStackBackendUrl"],
          secretKey: json["secretKey"],
          payStackPublickey: json['payStackPublickey'],
          accessKey: json["accessKey"],
          buckedId: json["buckedId"],
          region: json["region"]);

  Map<String, dynamic> toJson() => {
        "endPoint": endPoint,
        "payStackPublickey": payStackPublickey,
        "payStackBackendUrl": payStackBackendUrl,
        "secretKey": secretKey,
        "accessKey": accessKey,
        "buckedId": buckedId,
        "region": region,
      };
}

class ChatActivenesseModel {
  String? chatActive;

  ChatActivenesseModel({
    this.chatActive,
  });

  factory ChatActivenesseModel.fromJson(Map<dynamic, dynamic> json) =>
      ChatActivenesseModel(
        chatActive: json["chatActive"],
      );

  Map<String, dynamic> toJson() => {
        "chatActive": chatActive,
      };
}

class VendorModel {
  String? storeType;
  String? vendorId;
  bool? active;
  double? commission;
  String? firstName;
  String? lastName;
  String? businessName;
  String? businessAddress;
  String? businessAccount;
  String? country;
  String? bank;
  String? state;
  String? storeActiveState;
  String? date;
  String? reference;
  VendorModel({
    this.storeType,
    this.vendorId,
    this.active,
    this.commission,
    this.firstName,
    this.lastName,
    this.businessName,
    this.businessAddress,
    this.businessAccount,
    this.country,
    this.state,
    this.bank,
    this.storeActiveState,
    this.date,
    this.reference,
  });

  factory VendorModel.fromJson(Map<dynamic, dynamic> json) => VendorModel(
      storeType: json["storeType"],
      vendorId: json["vendorId"],
      active: json["active"],
      commission: json["commission"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      businessName: json["businessName"],
      businessAddress: json["businessAddress"],
      businessAccount: json["businessAccount"],
      country: json["country"],
      bank: json["bank"],
      state: json["state"],
      storeActiveState: json["storeActiveState"],
      date: json["date"],
      reference: json["reference"]);

  Map<String, dynamic> toJson() => {
        "storeType": storeType,
        "vendorId": vendorId,
        "active": active,
        "commission": commission,
        "firstName": firstName,
        "lastName": lastName,
        "businessName": businessName,
        "businessAddress": businessAddress,
        "businessAccount": businessAccount,
        "country": country,
        "bank": bank,
        "state": state,
        "storeActiveState": storeActiveState,
        "date": date,
        "reference": reference,
      };
}

class CategoryModel {
  String? key;
  String? section;

  double? categoryCommission;

  CategoryModel({
    this.key,
    this.section,
    this.categoryCommission,
  });

  factory CategoryModel.fromJson(Map<dynamic, dynamic> json) => CategoryModel(
      key: json["key"],
      section: json["section"],
      categoryCommission: json["categoryCommission"]);

  Map<String, dynamic> toJson() => {
        "key": key,
        "section": section,
        "categoryCommission": categoryCommission,
      };
}

class AuthModel {
  String? authType;

  bool? active;

  AuthModel({
    this.authType,
    this.active,
  });

  factory AuthModel.fromJson(Map<dynamic, dynamic> json) => AuthModel(
        authType: json["authType"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "authType": authType,
        "active": active,
      };
}

class PolicyModel {
  String? topic;

  String? body;

  PolicyModel({
    this.topic,
    this.body,
  });

  factory PolicyModel.fromJson(Map<dynamic, dynamic> json) => PolicyModel(
        topic: json["topic"],
        body: json["body"],
      );

  Map<String, dynamic> toJson() => {
        "topic": topic,
        "body": body,
      };
}

class SectionModel {
  String? section;
  dynamic categoryCommission;
  String? key;

  SectionModel({
    this.section,
    this.categoryCommission,
    this.key,
  });

  factory SectionModel.fromJson(Map<dynamic, dynamic> json) => SectionModel(
        section: json["section"],
        categoryCommission: json["categoryCommission"],
        key: json["key"],
      );

  Map<String, dynamic> toJson() => {
        "section": section,
        "categoryCommission": categoryCommission,
        "key": key,
      };
}

class ExchangeRateModel {
  String? currency;

  double? rate;

  ExchangeRateModel({
    this.currency,
    this.rate,
  });

  factory ExchangeRateModel.fromJson(Map<dynamic, dynamic> json) =>
      ExchangeRateModel(
        currency: json["currency"],
        rate: json["rate"],
      );

  Map<String, dynamic> toJson() => {
        "currency": currency,
        "rate": rate,
      };
}

class SubscriptionViewDuctsModel {
  String? subType;

  double? price;

  SubscriptionViewDuctsModel({
    this.subType,
    this.price,
  });

  factory SubscriptionViewDuctsModel.fromJson(Map<dynamic, dynamic> json) =>
      SubscriptionViewDuctsModel(
        subType: json["subType"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "subType": subType,
        "price": price,
      };
}

class LocalChatMessageModel {
  String? key;
  String? senderId;
  int? clicked;
  dynamic message;
  int? reactions;
  int? senderReactions;
  int? receiverReactions;
  String? replyedMessage;
  int? seen;
  String? imagePath;
  int? type;
  dynamic createdAt;
  int? orderState;
  int? newChats;

  //String? msgTimeStamp;
  int? timeStamp;
//dynamic deleteUpto;
  String? productName;
  String? imageKey;
  String? senderName;
  String? receiverId;
  String? userId;
  String? sellerId;
  String? chatlistKey;

  LocalChatMessageModel(
      {this.senderId,
      this.newChats,
      this.userId,
      this.clicked,
      this.message,
      this.orderState,
      this.reactions,
      this.senderReactions,
      this.receiverReactions,
      this.replyedMessage,
      this.key,
      this.sellerId,
      this.productName,
      this.chatlistKey,
      //this.deleteUpto,
      this.seen,
      this.createdAt,
      this.receiverId,
      this.senderName,
      this.type,
      this.imageKey,
      this.imagePath,
      // this.msgTimeStamp,
      this.timeStamp});

  factory LocalChatMessageModel.fromJson(Map<dynamic, dynamic>? json) =>
      LocalChatMessageModel(
          senderId: json?["senderId"],
          clicked: json?["clicked"],
          chatlistKey: json?['chatlistKey'],
          productName: json?["productName"],
          sellerId: json?["sellerId"],
          newChats: json?["newChats"],
          userId: json?['userId'],
          orderState: json?["orderState"],
          senderReactions: json?["senderReactions"],
          receiverReactions: json?["receiverReactions"],
          reactions: json?["reactions"],
          replyedMessage: json?["replyedMessage"],
          message: json?["message"],
          seen: json?["seen"],
          type: json?['type'],
          key: json?['key'],
          imageKey: json?["imageKey"],
          imagePath: json?["imagePath"],
//msgTimeStamp: json['msgTimeStamp'],
//deleteUpto: json['deleteUpto'],
          createdAt: json?["createdAt"],
          timeStamp: json?['timeStamp'],
          senderName: json?["senderName"],
          receiverId: json?["receiverId"]);

  Map<String, dynamic> toJson() => {
        "senderId": senderId,
        "chatlistKey": chatlistKey,
        "sellerId": sellerId,
        "productName": productName,
        "clicked": clicked,
        "message": message,
        "newChats": newChats,
        "userId": userId,
        "key": key,
        "receiverId": receiverId,
        "seen": seen,
        "reactions": reactions,
        "senderReactions": senderReactions,
        "receiverReactions": receiverReactions,
        "replyedMessage": replyedMessage,
        "orderState": orderState,
//"deleteUpto": deleteUpto,
        "type": type,
        "imagePath": imagePath,
        "imageKey": imageKey,
//"msgTimeStamp": msgTimeStamp,
        "createdAt": createdAt,
        "senderName": senderName,
        "timeStamp": timeStamp
      };
}
