import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/chatModel.dart';
import 'package:viewducts/model/feedModel.dart';

class SQLHelper {
  static Future<void> createLocalTables(sql.Database database) async {
    try {
      await database.execute(
          """CREATE TABLE messages(
            key TEXT PRIMARY KEY NOT NULL,
            senderId TEXT,
            clicked TEXT,
            chatType TEXT,
            message TEXT ,
            reactions INTEGER,
            senderReactions INTEGER,
            receiverReactions INTEGER,
            replyedMessage TEXT,
            seen TEXT,
            imagePath TEXT,
            type INTEGER,
            createdAt TIMESTAMP
            ,orderState INTEGER,
            newChats TEXT,
            timeStamp TIMESTAMP,
            productName TEXT,
            imageKey TEXT,
            senderName TEXT,
            receiverId TEXT,
            userId TEXT,
            sellerId TEXT,
            chatlistKey TEXT,
            searchKey TEXT,
            fileDownloaded TEXT,
            videoThumbnail TEXT,
            videoKey TEXT,
            audioFile TEXT,
            voiceMessage TEXT
            )
          
          
          """);
      await database.execute(
          """CREATE TABLE ducts(
            key TEXT PRIMARY KEY NOT NULL,
            ductId TEXT,
            reservedFee TEXT,
            timeDifference TEXT,
            audioTag TEXT,
            shoeSize TEXT ,
            productName TEXT,
            keyword TEXT,
            caption TEXT,
            type TEXT,
            cProduct TEXT,
            videoPath TEXT,
            productDescription TEXT,
            productCategory TEXT
            ,section TEXT,
            price TEXT,
            salePrice INTEGER,
            commissionPrice INTEGER,
            weight INTEGER,
            stockQuantity INTEGER,
            colors TEXT,
            productimagePath TEXT,
            sizes TEXT,
            culture TEXT,
            productLocation TEXT,
            productState TEXT,
            brand TEXT,
            parentkey TEXT,
            childVductkey TEXT,
            ductComment TEXT,
            userId TEXT,
            likeCount INTEGER,
            commissionUser TEXT
            likeList TEXT,
            commentCount INTEGER,
            vductCount INTEGER,
            createdAt TEXT,
            imagePath TEXT,
            tags TEXT,
            replyDuctKeyList TEXT,
            ads TEXT,
            thumbPath TEXT,
            duration TEXT,
            store TEXT, 
            user TEXT,
            likeList TEXT,
            erroMessage TEXT,
            paymentDate TEXT,
            sellersSalesPrice INTEGER,
            selllingPrice TEXT,
            reference TEXT,
            activeState TEXT,
            shippingFee TEXT,
            productImage TEXT
            
            )
          
          
          """);
      await database.execute(
          """CREATE TABLE chatList(
            key TEXT PRIMARY KEY NOT NULL,
            senderId TEXT,
            clicked TEXT,
            message TEXT,
            chatType TEXT,
            reactions INTEGER,
            senderReactions INTEGER,
            receiverReactions INTEGER,
            replyedMessage TEXT,
            seen TEXT,
            imagePath TEXT,
            type INTEGER,
            createdAt TIMESTAMP,
            orderState INTEGER,
            newChats TEXT,
            timeStamp TIMESTAMP,
            productName TEXT,
            imageKey TEXT,
            senderName TEXT,
            receiverId TEXT,
            userId TEXT,
            sellerId TEXT,
            chatlistKey TEXT,
            searchKey TEXT,
            fileDownloaded TEXT,
            videoThumbnail TEXT,
            videoKey TEXT,
            audioFile TEXT,
            voiceMessage TEXT
            )
          
          
          """);
      await database
          .execute("CREATE TABLE chats(chatId TEXT PRIMARY KEY NOT NULL )");
      if (kDebugMode) {
        cprint('created');
      }
    } catch (e) {
      if (kDebugMode) {
        cprint(e.toString());
      }
    }
  }
// id: the id of a item
// title, description: name and description of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'viewducts.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createLocalTables(database);
      },
    );
  }

  ///create chats
  static Future<void> createLocalChats(
    LocalChatMessages chats,
  ) async {
    final db = await SQLHelper.db();

    await db.insert('chats', chats.toMap(),
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  ///create local messages
  static Future<void> createLocalMessages(
    ChatMessage chats,
  ) async {
    try {
      final db = await SQLHelper.db();

      await db.insert('messages', chats.toJson(),
          conflictAlgorithm: sql.ConflictAlgorithm.replace);
      if (kDebugMode) {
        cprint('local message created');
      }
    } catch (e) {
      if (kDebugMode) {
        cprint(e.toString());
      }
    }
  }

  ///create local ducts
  static Future<void> createLocalDucts(
    FeedModel ducts,
  ) async {
    try {
      final db = await SQLHelper.db();

      await db.insert('ducts', ducts.toJson(),
          conflictAlgorithm: sql.ConflictAlgorithm.replace);
      if (kDebugMode) {
        cprint('local ducts created');
      }
    } catch (e) {
      if (kDebugMode) {
        cprint(e.toString());
      }
    }
  }

  ///create local chatList
  static Future<void> createLocalchatList(
    ChatMessage chatList,
  ) async {
    try {
      final db = await SQLHelper.db();

      await db.insert('chatList', chatList.toJson(),
          conflictAlgorithm: sql.ConflictAlgorithm.replace);
      if (kDebugMode) {
        cprint('local chatList created');
      }
    } catch (e) {
      if (kDebugMode) {
        cprint(e.toString());
      }
    }
  }

  ///delete chats
  static Future<void> deletChat(
    String chatId,
  ) async {
    final db = await SQLHelper.db();
    final batch = db.batch();
    batch.delete('meesages', where: 'chatlistKey=?', whereArgs: [chatId]);
    batch.delete('chats', where: 'chatId=?', whereArgs: [chatId]);
    await batch.commit(noResult: true);
  }

  ///find all chats
  static findAllLocalChats() async {
    final db = await SQLHelper.db();
    return db.transaction((txn) async {
      final chatsWithLatesMessages = await txn.rawQuery(
          ''' SELECT messages.* FROM
        ( SELECT
            chatlistKey, MAX(createdAt) AS createdAt
            FROM messages
            GROUP BY chatlistKey
        ) AS latest_messages
        INNER JOIN messages
        ON  messages.chatlistKey = latest_messages.chatlistKey
        AND messages.createdAt = latest_messages.createdAt
        ''');

      final chatWithUnreadMessages = await txn.rawQuery(
          ''' SELECT chatId count(*) as unread
      FROM messages
      WHERE seen =?
      GROUP BY chatId
''',
          [true]);
      return chatsWithLatesMessages.map<LocalChatMessages>((row) {
        final int? unread = int.tryParse(chatWithUnreadMessages
            .firstWhere((element) => row['chatId'] == element['chatId'],
                orElse: () => {'unread': 0})['unread']
            .toString());
        final chat = LocalChatMessages.fromMap(row);
        chat.unread = unread!;
        chat.recentMessages = ChatMessage.fromJson(row);
        return chat;
      }).toList();
    });
  }

  ///find chats
  static findLocalChats(String chatId) async {
    final db = await SQLHelper.db();
    return db.transaction((txn) async {
      final listOfChatsMap =
          await txn.query('chats', where: 'chatId=?', whereArgs: [chatId]);
      final unread = sql.Sqflite.firstIntValue(await txn.rawQuery(
          'SELECT COUNT(*) FROM MESSAGES WHERE chatlistKey =? AND seen=?',
          [chatId, 'false']));
      final mostRecentMessage = await txn.query('messages',
          where: 'chatlistKey',
          whereArgs: [chatId],
          orderBy: 'createdAt DESC',
          limit: 1);
      final chat =
          LocalChatMessages.fromMap(listOfChatsMap as Map<dynamic, dynamic>);
      chat.unread = unread!;
      chat.recentMessages = ChatMessage.fromJson(mostRecentMessage.first);
      return chat;
    });
  }

  ///find local messages
  static findLocalMessages(String chatId) async {
    final db = await SQLHelper.db();
    return db.transaction((txn) async {
      final listOfChatsMap = await txn.query(
        'messages',
        where: 'chatlistKey=?',
        whereArgs: [chatId],
        orderBy: 'createdAt DESC',
      );

      return listOfChatsMap
          .map<ChatMessage>((map) => ChatMessage.fromJson(map))
          .toList();
    });
  }

  ///find local chatList messages
  static findLocalChatliistMessages() async {
    final db = await SQLHelper.db();
    return db.transaction((txn) async {
      final listOfChatsMap = await txn.query(
        'chatList',
        // where: 'chatlistKey=?',
        // whereArgs: [chatId],
        orderBy: 'createdAt DESC',
      );

      return listOfChatsMap
          .map<ChatMessage>((map) => ChatMessage.fromJson(map))
          .toList();
    });
  }

  ///find local ducts
  static findLocalDucts(String userId) async {
    final db = await SQLHelper.db();
    return db.transaction((txn) async {
      final listOfChatsMap = await txn.query(
        'ducts',
        where: 'userId=?',
        whereArgs: [userId],
        orderBy: 'createdAt DESC',
      );

      return listOfChatsMap
          .map<FeedModel>((map) => FeedModel.fromJson(map))
          .toList();
    });
  }

  ///update message
  static updateLocalMessage(ChatMessage message, {String? seen}) async {
    final db = await SQLHelper.db();
    return db.update('messages', message.toJson(),
        where: 'key=?',
        whereArgs: [message.key],
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static updateLocalMessageSeen(ChatMessage message, {String? seen}) async {
    final db = await SQLHelper.db();
    return db.update('messages', {"seen": 'true'},
        where: 'key=?',
        whereArgs: [message.key],
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static deletLocalMessage(ChatMessage message) async {
    final db = await SQLHelper.db();
    return db.delete(
      'messages',
      where: 'key=?',
      whereArgs: [message.key],
    );
  }

  ///add reaction message
  static addReaction(ChatMessage? message, int reaction, String userId) async {
    final db = await SQLHelper.db();
    db.transaction((txn) async {
      final listOfChatsMap = await txn.query(
        'messages',
        where: 'key=? ',
        whereArgs: [message?.key],
      );
      final id = listOfChatsMap
          .map<ChatMessage>((map) => ChatMessage.fromJson(map))
          .first;
      if (id.senderId == userId) {
        db.update('messages', {'senderReactions': reaction},
            where: 'key=? ',
            whereArgs: [message?.key],
            conflictAlgorithm: sql.ConflictAlgorithm.replace);
      } else {
        db.update('messages', {'receiverReactions': reaction},
            where: 'key=? ',
            whereArgs: [message?.key],
            conflictAlgorithm: sql.ConflictAlgorithm.replace);
      }
    });
  }

  // Create new item (journal)
  static Future<int> createItem(String title, String? descrption) async {
    final db = await SQLHelper.db();

    final data = {'title': title, 'description': descrption};
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (journals)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('items', orderBy: "id");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(
      int id, String title, String? descrption) async {
    final db = await SQLHelper.db();

    final data = {
      'title': title,
      'description': descrption,
      'createdAt': DateTime.now().toString()
    };

    final result =
        await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}

class LocalChatMessages {
  String? chatId;
  int unread = 0;
  List<ChatMessage>? messages = [];
  ChatMessage? recentMessages;
  LocalChatMessages(this.chatId, {this.messages, this.recentMessages});
  toMap() => {'chatId': chatId};
  factory LocalChatMessages.fromMap(Map<dynamic, dynamic>? json) =>
      LocalChatMessages(
        json?["chatId"],
      );
}
