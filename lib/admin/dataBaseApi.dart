import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:dart_appwrite/models.dart';
import 'package:get/get.dart';
import 'package:viewducts/helper/utility.dart';

class DataBaseApi extends GetxController {
  static DataBaseApi instance = Get.find<DataBaseApi>();
  final endPoint = 'https://6357.viewducts.com/v1';
  final apiKey =
      'f8a0d6c992e50aa90c452b19a8759100e308ac86e5552c3efbc9c2fd6ff46070b661385ab77543eeab59e6ca4ead29b3c81891c3d69bf63dfdab1e5212dbde0314b7e01b33bd521f366683f9734f22ecb64b0fbcd5fd5bf3492a8548103ac2da3656d343d770aa5b5f274d41582557d79267d08b2e5071f856d86aa4e7aa69fa';

  createDuctsDataBase() async {
    Collection? collection;
    final client = Client();
    client
        .setEndpoint(endPoint) // Your Appwrite Endpoint
        .setProject(projectId)
        .setKey(apiKey);
    final database = Databases(
      client,
    );
    collection = await database.createCollection(
      databaseId: databaseId,
      collectionId: "unique()",
      name: 'Ducts',
      permissions: [
        Permission.read(Role.users()),
        Permission.write(Role.users()),
      ],
    );
    if (collection.attributes.isEmpty) {
      try {
        // You are free to choose your own key name.
        // But make to sure to replace those things in the model too.
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "key",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "ductId",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "shoeSize",
            array: true,
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "productName",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "keyword",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "caption",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "type",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "cProduct",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "videoPath",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "productDescription",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "productCategory",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "price",
            size: 255,
            xrequired: false);
        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "salePrice",
            xrequired: false);
        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "commissionPrice",
            xrequired: false);

        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "section",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "store",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "commissionUser",
            size: 255,
            xrequired: false);
        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "weight",
            xrequired: false);
        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "stockQuantity",
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "colors",
            array: true,
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "productimagePath",
            array: true,
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "sizes",
            array: true,
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "culture",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "productLocation",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "productState",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "brand",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "parentkey",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "childVductkey",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "ductComment",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "userId",
            size: 255,
            xrequired: false);
        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "likeCount",
            xrequired: false);

        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "likeList",
            array: true,
            size: 255,
            xrequired: false);

        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "commentCount",
            xrequired: false);
        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "vductCount",
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "createdAt",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "imagePath",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "tags",
            array: true,
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "replyDuctKeyList",
            array: true,
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "ads",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "thumbPath",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "duration",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "user",
            size: 255,
            xrequired: false);
        // await database.createEnumAttribute(
        //     collectionId: collectionId,
        //     key: "message_type",
        //     elements: ["IMAGE", "VIDEO", "TEXT"],
        //     xdefault: "TEXT",
        //     xrequired: false);
      } on AppwriteException {
        rethrow;
      }
    }
  }

  createProductCollectionDataBase() async {
    Collection? collection;
    final client = Client();
    client
        .setEndpoint(endPoint) // Your Appwrite Endpoint
        .setProject(projectId)
        .setKey(apiKey);
    final database = Databases(
      client,
    );
    collection = await database.createCollection(
      databaseId: databaseId,
      collectionId: "unique()",
      name: 'Products',
      permissions: [
        Permission.read(Role.users()),
        Permission.write(Role.users()),
      ],
    );
    if (collection.attributes.isEmpty) {
      try {
        // You are free to choose your own key name.
        // But make to sure to replace those things in the model too.
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "key",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "ductId",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "shoeSize",
            array: true,
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "productName",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "keyword",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "caption",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "type",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "cProduct",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "videoPath",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "productDescription",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "productCategory",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "price",
            size: 255,
            xrequired: false);
        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "salePrice",
            xrequired: false);
        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "commissionPrice",
            xrequired: false);

        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "section",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "store",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "commissionUser",
            size: 255,
            xrequired: false);
        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "weight",
            xrequired: false);
        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "stockQuantity",
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "colors",
            array: true,
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "productimagePath",
            array: true,
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "sizes",
            array: true,
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "culture",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "productLocation",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "productState",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "brand",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "parentkey",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "childVductkey",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "ductComment",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "userId",
            size: 255,
            xrequired: false);
        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "likeCount",
            xrequired: false);

        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "likeList",
            array: true,
            size: 255,
            xrequired: false);

        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "commentCount",
            xrequired: false);
        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "vductCount",
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "createdAt",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "imagePath",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "tags",
            array: true,
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "replyDuctKeyList",
            array: true,
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "ads",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "thumbPath",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "duration",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "user",
            size: 255,
            xrequired: false);
        // await database.createEnumAttribute(
        //     collectionId: collectionId,
        //     key: "message_type",
        //     elements: ["IMAGE", "VIDEO", "TEXT"],
        //     xdefault: "TEXT",
        //     xrequired: false);
      } on AppwriteException {
        rethrow;
      }
    }
  }

  createStoryCollectionDataBase() async {
    Collection? collection;
    final client = Client();
    client
        .setEndpoint(endPoint) // Your Appwrite Endpoint
        .setProject(projectId)
        .setKey(apiKey);
    final database = Databases(
      client,
    );
    collection = await database.createCollection(
      databaseId: databaseId,
      collectionId: "unique()",
      name: 'Story',
      permissions: [
        Permission.read(Role.users()),
        Permission.write(Role.users()),
      ],
    );
    if (collection.attributes.isEmpty) {
      try {
        // You are free to choose your own key name.
        // But make to sure to replace those things in the model too.
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "key",
            size: 255,
            xrequired: true);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "userId",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "cProduct",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "videoPath",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "duration",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "commissionUser",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "profilePic",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "ductComment",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "displayName",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "createdAt",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "imagePath",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "date",
            size: 255,
            xrequired: false);
        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "storyType",
            xrequired: false);

        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "userViwed",
            array: true,
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "hearts",
            array: true,
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "chats",
            array: true,
            size: 255,
            xrequired: false);
      } on AppwriteException {
        rethrow;
      }
    }
  }

  createStoryChatsDataBase() async {
    Collection? collection;
    final client = Client();
    client
        .setEndpoint(endPoint) // Your Appwrite Endpoint
        .setProject(projectId)
        .setKey(apiKey);
    final database = Databases(
      client,
    );
    collection = await database.createCollection(
      databaseId: databaseId,
      collectionId: "unique()",
      name: 'StoryChats',
      permissions: [
        Permission.read(Role.users()),
        Permission.write(Role.users()),
      ],
    );
    if (collection.attributes.isEmpty) {
      try {
        // You are free to choose your own key name.
        // But make to sure to replace those things in the model too.
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "key",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "senderId",
            size: 255,
            xrequired: false);

        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "message",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "storyId",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "chatId",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "replyedMessage",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "createdAt",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "senderName",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "receiverId",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "senderImage",
            size: 255,
            xrequired: false);
        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "reactions",
            xrequired: false);
        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "type",
            xrequired: false);
      } on AppwriteException {
        rethrow;
      }
    }
  }

  createStoryUserViewsDataBase() async {
    Collection? collection;
    final client = Client();

    client
        .setEndpoint(endPoint) // Your Appwrite Endpoint
        .setProject(projectId)
        .setKey(apiKey);
    final database = Databases(
      client,
    );
    collection = await database.createCollection(
      databaseId: databaseId,
      collectionId: "unique()",
      name: 'StoryViews',
      permissions: [
        Permission.read(Role.users()),
        Permission.write(Role.users()),
      ],
    );
    if (collection.attributes.isEmpty) {
      try {
        // You are free to choose your own key name.
        // But make to sure to replace those things in the model too.
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "storyId",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "userId",
            size: 255,
            xrequired: false);

        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "senderId",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "senderName",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "senderImage",
            size: 255,
            xrequired: false);
      } on AppwriteException {
        rethrow;
      }
    }
  }

  createHeartLikesCollectionDataBase() async {
    Collection? collection;
    final client = Client();
    client
        .setEndpoint(endPoint) // Your Appwrite Endpoint
        .setProject(projectId)
        .setKey(apiKey);
    final database = Databases(
      client,
    );
    collection = await database.createCollection(
      databaseId: databaseId,
      collectionId: "unique()",
      name: 'UserLikes',
      permissions: [
        Permission.read(Role.users()),
        Permission.write(Role.users()),
      ],
    );
    if (collection.attributes.isEmpty) {
      try {
        // You are free to choose your own key name.
        // But make to sure to replace those things in the model too.
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "viewerId",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "storyId",
            size: 255,
            xrequired: false);

        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "userId",
            size: 255,
            xrequired: false);
      } on AppwriteException {
        rethrow;
      }
    }
  }

  creatProfileUserCollectionDataBase() async {
    Collection? collection;
    final client = Client();
    client
        .setEndpoint(endPoint) // Your Appwrite Endpoint
        .setProject(projectId)
        .setKey(apiKey);
    final database = Databases(
      client,
    );
    collection = await database.createCollection(
      databaseId: databaseId,
      collectionId: "unique()",
      name: 'profile',
      permissions: [
        Permission.read(Role.users()),
        Permission.write(Role.users()),
      ],
    );
    if (collection.attributes.isEmpty) {
      try {
        // You are free to choose your own key name.
        // But make to sure to replace those things in the model too.
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "key",
            size: 255,
            xrequired: true);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "email",
            size: 255,
            xrequired: false);

        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "userId",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "session",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "state",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "firstName",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "lastName",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "lastSeen",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "publicKey",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "displayName",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "userName",
            size: 255,
            xrequired: false);
        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "authenticationType",
            xrequired: false);
        await database.createBooleanAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "isVerified",
            xrequired: false);
        await database.createBooleanAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "admin",
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "userProfilePic",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "bio",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "location",
            size: 255,
            xrequired: false);
        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "contact",
            xrequired: false);

        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "dob",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "createdAt",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "fcmToken",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "profilePic",
            size: 255,
            xrequired: false);
      } on AppwriteException {
        rethrow;
      }
    }
  }

  createMainUserProfileViewsCollectionDataBase() async {
    Collection? collection;
    final client = Client();
    client
        .setEndpoint(endPoint) // Your Appwrite Endpoint
        .setProject(projectId)
        .setKey(apiKey);
    final database = Databases(
      client,
    );
    collection = await database.createCollection(
      databaseId: databaseId,
      collectionId: "unique()",
      name: 'ProfileViews',
      permissions: [
        Permission.read(Role.users()),
        Permission.write(Role.users()),
      ],
    );
    if (collection.attributes.isEmpty) {
      try {
        // You are free to choose your own key name.
        // But make to sure to replace those things in the model too.
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "viewerId",
            size: 255,
            xrequired: false);
      } on AppwriteException {
        rethrow;
      }
    }
  }

  createProductBukectDataBase() async {
    Collection? collection;
    final client = Client();
    client
        .setEndpoint(endPoint) // Your Appwrite Endpoint
        .setProject(projectId)
        .setKey(apiKey);
    final database = Databases(
      client,
    );
    collection = await database.createCollection(
      databaseId: databaseId,
      collectionId: "unique()",
      name: 'Ducts',
      permissions: [
        Permission.read(Role.users()),
        Permission.write(Role.users()),
      ],
    );
    if (collection.attributes.isEmpty) {
      try {
        // You are free to choose your own key name.
        // But make to sure to replace those things in the model too.
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "key",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "ductId",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "shoeSize",
            array: true,
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "productName",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "keyword",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "caption",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "type",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "cProduct",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "videoPath",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "productDescription",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "productCategory",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "price",
            size: 255,
            xrequired: false);
        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "salePrice",
            xrequired: false);
        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "commissionPrice",
            xrequired: false);

        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "section",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "store",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "commissionUser",
            size: 255,
            xrequired: false);
        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "weight",
            xrequired: false);
        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "stockQuantity",
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "colors",
            array: true,
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "productimagePath",
            array: true,
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "sizes",
            array: true,
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "culture",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "productLocation",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "productState",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "brand",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "parentkey",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "childVductkey",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "ductComment",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "userId",
            size: 255,
            xrequired: false);
        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "likeCount",
            xrequired: false);

        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "likeList",
            array: true,
            size: 255,
            xrequired: false);

        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "commentCount",
            xrequired: false);
        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "vductCount",
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "createdAt",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "imagePath",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "tags",
            array: true,
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "replyDuctKeyList",
            array: true,
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "ads",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "thumbPath",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "duration",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "user",
            size: 255,
            xrequired: false);
        // await database.createEnumAttribute(
        //     collectionId: collectionId,
        //     key: "message_type",
        //     elements: ["IMAGE", "VIDEO", "TEXT"],
        //     xdefault: "TEXT",
        //     xrequired: false);
      } on AppwriteException {
        rethrow;
      }
    }
  }

  createProfileImageBucketDataBase() async {
    Collection? collection;
    final client = Client();
    client
        .setEndpoint(endPoint) // Your Appwrite Endpoint
        .setProject(projectId)
        .setKey(apiKey);
    final database = Databases(
      client,
    );
    collection = await database.createCollection(
      databaseId: databaseId,
      collectionId: "unique()",
      name: 'Ducts',
      permissions: [
        Permission.read(Role.users()),
        Permission.write(Role.users()),
      ],
    );
    if (collection.attributes.isEmpty) {
      try {
        // You are free to choose your own key name.
        // But make to sure to replace those things in the model too.
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "key",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "ductId",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "shoeSize",
            array: true,
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "productName",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "keyword",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "caption",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "type",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "cProduct",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "videoPath",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "productDescription",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "productCategory",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "price",
            size: 255,
            xrequired: false);
        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "salePrice",
            xrequired: false);
        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "commissionPrice",
            xrequired: false);

        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "section",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "store",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "commissionUser",
            size: 255,
            xrequired: false);
        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "weight",
            xrequired: false);
        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "stockQuantity",
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "colors",
            array: true,
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "productimagePath",
            array: true,
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "sizes",
            array: true,
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "culture",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "productLocation",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "productState",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "brand",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "parentkey",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "childVductkey",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "ductComment",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "userId",
            size: 255,
            xrequired: false);
        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "likeCount",
            xrequired: false);

        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "likeList",
            array: true,
            size: 255,
            xrequired: false);

        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "commentCount",
            xrequired: false);
        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "vductCount",
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "createdAt",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "imagePath",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "tags",
            array: true,
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "replyDuctKeyList",
            array: true,
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "ads",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "thumbPath",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "duration",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "user",
            size: 255,
            xrequired: false);
        // await database.createEnumAttribute(
        //     collectionId: collectionId,
        //     key: "message_type",
        //     elements: ["IMAGE", "VIDEO", "TEXT"],
        //     xdefault: "TEXT",
        //     xrequired: false);
      } on AppwriteException {
        rethrow;
      }
    }
  }

  createDuctsImageBucketDataBase() async {
    Collection? collection;
    final client = Client();
    client
        .setEndpoint(endPoint) // Your Appwrite Endpoint
        .setProject(projectId)
        .setKey(apiKey);
    final database = Databases(
      client,
    );
    collection = await database.createCollection(
      databaseId: databaseId,
      collectionId: "unique()",
      name: 'Ducts',
      permissions: [
        Permission.read(Role.users()),
        Permission.write(Role.users()),
      ],
    );
    if (collection.attributes.isEmpty) {
      try {
        // You are free to choose your own key name.
        // But make to sure to replace those things in the model too.
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "key",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "ductId",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "shoeSize",
            array: true,
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "productName",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "keyword",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "caption",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "type",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "cProduct",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "videoPath",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "productDescription",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "productCategory",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "price",
            size: 255,
            xrequired: false);
        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "salePrice",
            xrequired: false);
        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "commissionPrice",
            xrequired: false);

        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "section",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "store",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "commissionUser",
            size: 255,
            xrequired: false);
        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "weight",
            xrequired: false);
        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "stockQuantity",
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "colors",
            array: true,
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "productimagePath",
            array: true,
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "sizes",
            array: true,
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "culture",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "productLocation",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "productState",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "brand",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "parentkey",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "childVductkey",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "ductComment",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "userId",
            size: 255,
            xrequired: false);
        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "likeCount",
            xrequired: false);

        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "likeList",
            array: true,
            size: 255,
            xrequired: false);

        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "commentCount",
            xrequired: false);
        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "vductCount",
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "createdAt",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "imagePath",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "tags",
            array: true,
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "replyDuctKeyList",
            array: true,
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "ads",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "thumbPath",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "duration",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "user",
            size: 255,
            xrequired: false);
        // await database.createEnumAttribute(
        //     collectionId: collectionId,
        //     key: "message_type",
        //     elements: ["IMAGE", "VIDEO", "TEXT"],
        //     xdefault: "TEXT",
        //     xrequired: false);
      } on AppwriteException {
        rethrow;
      }
    }
  }

  createChildrenCategoryCollectionDataBase() async {
    Collection? collection;
    final client = Client();
    client
        .setEndpoint(endPoint) // Your Appwrite Endpoint
        .setProject(projectId)
        .setKey(apiKey);
    final database = Databases(
      client,
    );
    collection = await database.createCollection(
      databaseId: databaseId,
      collectionId: "unique()",
      name: 'childrenCategories',
      permissions: [
        Permission.read(Role.users()),
        Permission.write(Role.users()),
      ],
    );
    if (collection.attributes.isEmpty) {
      try {
        // You are free to choose your own key name.
        // But make to sure to replace those things in the model too.
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "key",
            size: 255,
            xrequired: true);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "image",
            size: 255,
            xrequired: false);

        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "childrenCategory",
            size: 255,
            xrequired: false);
      } on AppwriteException {
        rethrow;
      }
    }
  }

  createFashionCategoryCollectionDataBase() async {
    Collection? collection;
    final client = Client();
    client
        .setEndpoint(endPoint) // Your Appwrite Endpoint
        .setProject(projectId)
        .setKey(apiKey);
    final database = Databases(
      client,
    );
    collection = await database.createCollection(
      databaseId: databaseId,
      collectionId: "unique()",
      name: 'fashionCategories',
      permissions: [
        Permission.read(Role.users()),
        Permission.write(Role.users()),
      ],
    );
    if (collection.attributes.isEmpty) {
      try {
        // You are free to choose your own key name.
        // But make to sure to replace those things in the model too.
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "image",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "fashionCategory",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "key",
            size: 255,
            xrequired: false);
      } on AppwriteException {
        rethrow;
      }
    }
  }

  createElectronicsCategoryCollectionDataBase() async {
    Collection? collection;
    final client = Client();
    client
        .setEndpoint(endPoint) // Your Appwrite Endpoint
        .setProject(projectId)
        .setKey(apiKey);
    final database = Databases(
      client,
    );
    collection = await database.createCollection(
      databaseId: databaseId,
      collectionId: "unique()",
      name: 'electronicsCategories',
      permissions: [
        Permission.read(Role.users()),
        Permission.write(Role.users()),
      ],
    );
    if (collection.attributes.isEmpty) {
      try {
        // You are free to choose your own key name.
        // But make to sure to replace those things in the model too.
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "key",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "image",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "electronicsCategory",
            size: 255,
            xrequired: false);
      } on AppwriteException {
        rethrow;
      }
    }
  }

  createGroceriesCollectionDataBase() async {
    Collection? collection;
    final client = Client();
    client
        .setEndpoint(endPoint) // Your Appwrite Endpoint
        .setProject(projectId)
        .setKey(apiKey);
    final database = Databases(
      client,
    );
    collection = await database.createCollection(
      databaseId: databaseId,
      collectionId: "unique()",
      name: 'groceryCategories',
      permissions: [
        Permission.read(Role.users()),
        Permission.write(Role.users()),
      ],
    );
    if (collection.attributes.isEmpty) {
      try {
        // You are free to choose your own key name.
        // But make to sure to replace those things in the model too.
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "key",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "image",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "groceryCategory",
            size: 255,
            xrequired: false);
      } on AppwriteException {
        rethrow;
      }
    }
  }

  createBooksCollectionDataBase() async {
    Collection? collection;
    final client = Client();
    client
        .setEndpoint(endPoint) // Your Appwrite Endpoint
        .setProject(projectId)
        .setKey(apiKey);
    final database = Databases(
      client,
    );
    collection = await database.createCollection(
      databaseId: databaseId,
      collectionId: "unique()",
      name: 'booksCategories',
      permissions: [
        Permission.read(Role.users()),
        Permission.write(Role.users()),
      ],
    );
    if (collection.attributes.isEmpty) {
      try {
        // You are free to choose your own key name.
        // But make to sure to replace those things in the model too.
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "key",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "image",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "booksCategory",
            size: 255,
            xrequired: false);
      } on AppwriteException {
        rethrow;
      }
    }
  }

  createHousingCollectionDataBase() async {
    Collection? collection;
    final client = Client();
    client
        .setEndpoint(endPoint) // Your Appwrite Endpoint
        .setProject(projectId)
        .setKey(apiKey);
    final database = Databases(
      client,
    );
    collection = await database.createCollection(
      databaseId: databaseId,
      collectionId: "unique()",
      name: 'housingCategories',
      permissions: [
        Permission.read(Role.users()),
        Permission.write(Role.users()),
      ],
    );
    if (collection.attributes.isEmpty) {
      try {
        // You are free to choose your own key name.
        // But make to sure to replace those things in the model too.
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "key",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "image",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "housingCategory",
            size: 255,
            xrequired: false);
      } on AppwriteException {
        rethrow;
      }
    }
  }

  createFarmCollectionDataBase() async {
    Collection? collection;
    final client = Client();
    client
        .setEndpoint(endPoint) // Your Appwrite Endpoint
        .setProject(projectId)
        .setKey(apiKey);
    final database = Databases(
      client,
    );
    collection = await database.createCollection(
      databaseId: databaseId,
      collectionId: "unique()",
      name: 'farmCategories',
      permissions: [
        Permission.read(Role.users()),
        Permission.write(Role.users()),
      ],
    );
    if (collection.attributes.isEmpty) {
      try {
        // You are free to choose your own key name.
        // But make to sure to replace those things in the model too.
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "key",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "image",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "farmCategory",
            size: 255,
            xrequired: false);
      } on AppwriteException {
        rethrow;
      }
    }
  }

  createCarsCollectionDataBase() async {
    Collection? collection;
    final client = Client();
    client
        .setEndpoint(endPoint) // Your Appwrite Endpoint
        .setProject(projectId)
        .setKey(apiKey);
    final database = Databases(
      client,
    );
    collection = await database.createCollection(
      databaseId: databaseId,
      collectionId: "unique()",
      name: 'carsCategories',
      permissions: [
        Permission.read(Role.users()),
        Permission.write(Role.users()),
      ],
    );
    if (collection.attributes.isEmpty) {
      try {
        // You are free to choose your own key name.
        // But make to sure to replace those things in the model too.
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "key",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "image",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "carsCategory",
            size: 255,
            xrequired: false);
      } on AppwriteException {
        rethrow;
      }
    }
  }

  createSectionCollectionDataBase() async {
    Collection? collection;
    final client = Client();
    client
        .setEndpoint(endPoint) // Your Appwrite Endpoint
        .setProject(projectId)
        .setKey(apiKey);
    final database = Databases(
      client,
    );
    collection = await database.createCollection(
      databaseId: databaseId,
      collectionId: "unique()",
      name: 'section',
      permissions: [
        Permission.read(Role.users()),
        Permission.write(Role.users()),
      ],
    );
    if (collection.attributes.isEmpty) {
      try {
        // You are free to choose your own key name.
        // But make to sure to replace those things in the model too.
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "key",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "section",
            size: 255,
            xrequired: false);
      } on AppwriteException {
        rethrow;
      }
    }
  }

  createTypeCollectionDataBase() async {
    Collection? collection;
    final client = Client();
    client
        .setEndpoint(endPoint) // Your Appwrite Endpoint
        .setProject(projectId)
        .setKey(apiKey);
    final database = Databases(
      client,
    );
    collection = await database.createCollection(
      databaseId: databaseId,
      collectionId: "unique()",
      name: 'type',
      permissions: [
        Permission.read(Role.users()),
        Permission.write(Role.users()),
      ],
    );
    if (collection.attributes.isEmpty) {
      try {
        // You are free to choose your own key name.
        // But make to sure to replace those things in the model too.
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "key",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "type",
            size: 255,
            xrequired: false);
      } on AppwriteException {
        rethrow;
      }
    }
  }

  createChatListCollection() async {
    Collection? collection;
    final client = Client();
    client
        .setEndpoint(endPoint) // Your Appwrite Endpoint
        .setProject(projectId)
        .setKey(apiKey);
    final database = Databases(
      client,
    );
    collection = await database.createCollection(
      databaseId: databaseId,
      collectionId: "unique()",
      name: 'ChatList',
      permissions: [
        Permission.read(Role.users()),
        Permission.write(Role.users()),
      ],
    );
    if (collection.attributes.isEmpty) {
      try {
        // You are free to choose your own key name.
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "key",
            size: 255,
            xrequired: true);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "senderId",
            size: 255,
            xrequired: true);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "message",
            size: 255,
            xrequired: true);
        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "reactions",
            xrequired: false);
        await database.createBooleanAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "seen",
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "imagePath",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "createdAt",
            size: 255,
            xrequired: false);
        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "type",
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "replyedMessage",
            size: 255,
            xrequired: false);
        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "orderState",
            xrequired: false);
        await database.createBooleanAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "newChats",
            xrequired: false);
        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "timeStamp",
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "imageKey",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "senderName",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "receiverId",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "userId",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "sellerId",
            size: 255,
            xrequired: false);
        // await database.createEnumAttribute(
        //     collectionId: collectionId,
        //     key: "message_type",
        //     elements: ["IMAGE", "VIDEO", "TEXT"],
        //     xdefault: "TEXT",
        //     xrequired: false);
      } on AppwriteException {
        rethrow;
      }
    }
  }

  createShoppingCart() async {
    Collection? collection;
    final client = Client();
    client
        .setEndpoint(endPoint) // Your Appwrite Endpoint
        .setProject(projectId)
        .setKey(apiKey);
    final database = Databases(
      client,
    );
    collection = await database.createCollection(
        databaseId: databaseId,
        collectionId: "unique()",
        name: 'ShoppingCart',
        documentSecurity: true);
    if (collection.attributes.isEmpty) {
      try {
        // You are free to choose your own key name.
        // But make to sure to replace those things in the model too.
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "id",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "vendorId",
            size: 255,
            xrequired: false);

        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "color",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "commissionId",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "size",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "commissionUser",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "price",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "store",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "name",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "commissionPrice",
            size: 255,
            xrequired: false);

        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "quantity",
            xrequired: false);
      } on AppwriteException {
        rethrow;
      }
    }
  }

  createProfileViews() async {
    Collection? collection;
    final client = Client();
    client
        .setEndpoint(endPoint) // Your Appwrite Endpoint
        .setProject(projectId)
        .setKey(apiKey);
    final database = Databases(
      client,
    );
    collection = await database.createCollection(
      databaseId: databaseId,
      collectionId: "unique()",
      name: 'ProfileViews',
      permissions: [
        Permission.read(Role.users()),
        Permission.write(Role.users()),
      ],
    );
    if (collection.attributes.isEmpty) {
      try {
        // You are free to choose your own key name.
        // But make to sure to replace those things in the model too.
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "viewerId",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "viewductsUser",
            size: 255,
            xrequired: false);
      } on AppwriteException {
        rethrow;
      }
    }
  }

  createCountryCollection() async {
    Collection? collection;
    final client = Client();
    client
        .setEndpoint(endPoint) // Your Appwrite Endpoint
        .setProject(projectId)
        .setKey(apiKey);
    final database = Databases(
      client,
    );
    collection = await database.createCollection(
      databaseId: databaseId,
      collectionId: "unique()",
      name: 'CountryCollection',
      permissions: [
        Permission.read(Role.users()),
        Permission.write(Role.users()),
      ],
    );
    if (collection.attributes.isEmpty) {
      try {
        // You are free to choose your own key name.
        // But make to sure to replace those things in the model too.
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "country",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "states",
            size: 255,
            array: true,
            xrequired: false);
      } on AppwriteException {
        rethrow;
      }
    }
  }

  createKeywordCollection() async {
    Collection? collection;
    final client = Client();
    client
        .setEndpoint(endPoint) // Your Appwrite Endpoint
        .setProject(projectId)
        .setKey(apiKey);
    final database = Databases(
      client,
    );
    collection = await database.createCollection(
      databaseId: databaseId,
      collectionId: "unique()",
      name: 'KeywordCollection',
      permissions: [
        Permission.read(Role.users()),
        Permission.write(Role.users()),
      ],
    );
    if (collection.attributes.isEmpty) {
      try {
        // You are free to choose your own key name.
        // But make to sure to replace those things in the model too.
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "keyword",
            size: 255,
            xrequired: false);
      } on AppwriteException {
        rethrow;
      }
    }
  }

  createShippingAdress() async {
    Collection? collection;
    final client = Client();
    client
        .setEndpoint(endPoint) // Your Appwrite Endpoint
        .setProject(projectId)
        .setKey(apiKey);
    final database = Databases(
      client,
    );
    collection = await database.createCollection(
      databaseId: databaseId,
      collectionId: "unique()",
      name: 'ShippingAddress',
      permissions: [
        Permission.read(Role.users()),
        Permission.write(Role.users()),
      ],
    );
    if (collection.attributes.isEmpty) {
      try {
        // You are free to choose your own key name.
        // But make to sure to replace those things in the model too.
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "contact",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "city",
            size: 255,
            xrequired: false);

        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "area",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "name",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "country",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "state",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "address",
            size: 255,
            xrequired: false);
      } on AppwriteException {
        rethrow;
      }
    }
  }

  createUsersOrdersCollection() async {
    Collection? collection;
    final client = Client();
    client
        .setEndpoint(endPoint) // Your Appwrite Endpoint
        .setProject(projectId)
        .setKey(apiKey);
    final database = Databases(
      client,
    );
    collection = await database.createCollection(
      databaseId: databaseId,
      collectionId: "unique()",
      name: 'UserOrdersCollection',
      permissions: [
        Permission.read(Role.users()),
        Permission.write(Role.users()),
      ],
    );
    if (collection.attributes.isEmpty) {
      try {
        // You are free to choose your own key name.
        // But make to sure to replace those things in the model too.
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "userId",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "state",
            size: 255,
            xrequired: false);

        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "country",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "shippingMethod",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "orderState",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "sellerId",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "key",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "placedDate",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "accessCode",
            size: 255,
            xrequired: false);
        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "totalPrice",
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "shippingAddress",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "items",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "productId",
            size: 255,
            xrequired: false);
      } on AppwriteException {
        rethrow;
      }
    }
  }

  createOdersStateCollection() async {
    Collection? collection;
    final client = Client();
    client
        .setEndpoint(endPoint) // Your Appwrite Endpoint
        .setProject(projectId)
        .setKey(apiKey);
    final database = Databases(
      client,
    );
    collection = await database.createCollection(
      databaseId: databaseId,
      collectionId: "unique()",
      name: 'OrderStateCollection',
      permissions: [
        Permission.read(Role.users()),
        Permission.write(Role.users()),
      ],
    );
    if (collection.attributes.isEmpty) {
      try {
        // You are free to choose your own key name.
        // But make to sure to replace those things in the model too.
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "orderState",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "userId",
            size: 255,
            xrequired: false);

        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "placedDate",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "state",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "country",
            size: 255,
            xrequired: false);
      } on AppwriteException {
        rethrow;
      }
    }
  }

  createInitPaymentCollection() async {
    Collection? collection;
    final client = Client();
    client
        .setEndpoint(endPoint) // Your Appwrite Endpoint
        .setProject(projectId)
        .setKey(apiKey);
    final database = Databases(
      client,
    );
    collection = await database.createCollection(
      databaseId: databaseId,
      collectionId: "unique()",
      name: 'InitPayment',
      permissions: [
        Permission.read(Role.users()),
        Permission.write(Role.users()),
      ],
    );
    if (collection.attributes.isEmpty) {
      try {
        // You are free to choose your own key name.
        // But make to sure to replace those things in the model too.
        await database.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "totalPrice",
            xrequired: false);
        await database.createBooleanAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "initialize",
            xrequired: false);

        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "userId",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "custId",
            size: 255,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "initData",
            size: 255,
            xrequired: false);
      } on AppwriteException {
        rethrow;
      }
    }
  }

  createViewBankstCollection() async {
    Collection? collection;
    final client = Client();
    client
        .setEndpoint(endPoint) // Your Appwrite Endpoint
        .setProject(projectId)
        .setKey(apiKey);
    final database = Databases(
      client,
    );
    collection = await database.createCollection(
      databaseId: databaseId,
      collectionId: "banks",
      name: 'Banks',
      permissions: [
        Permission.read(Role.users()),
        Permission.write(Role.users()),
      ],
    );
    if (collection.attributes.isEmpty) {
      try {
        // You are free to choose your own key name.
        // But make to sure to replace those things in the model too.

        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "allBanks",
            size: 1000000,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "banks",
            size: 255,
            xrequired: false);
      } on AppwriteException {
        rethrow;
      }
    }
  }

  createChipperCash() async {
    Collection? collection;
    final client = Client();
    client
        .setEndpoint(endPoint) // Your Appwrite Endpoint
        .setProject(projectId)
        .setKey(apiKey);
    final database = Databases(
      client,
    );
    collection = await database.createCollection(
      databaseId: databaseId,
      collectionId: "unique()",
      name: 'Chipper Cash',
      permissions: [
        Permission.read(Role.users()),
        Permission.write(Role.users()),
      ],
    );
    if (collection.attributes.isEmpty) {
      try {
        // You are free to choose your own key name.
        // But make to sure to replace those things in the model too.

        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "fullName",
            size: 225,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "chipperCashTag",
            size: 255,
            xrequired: false);
      } on AppwriteException {
        rethrow;
      }
    }
  }

  createUnPaidCommision() async {
    Collection? collection;
    final client = Client();
    client
        .setEndpoint(endPoint) // Your Appwrite Endpoint
        .setProject(projectId)
        .setKey(apiKey);
    final database = Databases(
      client,
    );
    collection = await database.createCollection(
      databaseId: databaseId,
      collectionId: "unique()",
      name: 'unPaidcommision',
      permissions: [
        Permission.read(Role.users()),
        Permission.write(Role.users()),
      ],
    );
    if (collection.attributes.isEmpty) {
      try {
        // You are free to choose your own key name.
        // But make to sure to replace those things in the model too.

        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "month",
            size: 225,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "amount",
            size: 225,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "productId",
            size: 225,
            xrequired: false);
        await database.createStringAttribute(
            databaseId: databaseId,
            collectionId: collection.$id,
            key: "commissionId",
            size: 255,
            xrequired: false);
      } on AppwriteException {
        rethrow;
      }
    }
  }
}
