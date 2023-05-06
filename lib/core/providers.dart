import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viewducts/constants/constants.dart';
import 'package:dart_appwrite/dart_appwrite.dart' as appWriteDart;

final appwriteClientProvider = Provider((ref) {
  Client client = Client();
  return client
      .addHeader("Access-Control-Allow-Origin", "*")
      .setEndpoint(AppwriteConstants.endPoint)
      .setProject(AppwriteConstants.projectId);
});
final appwriteClientChatsProvider = Provider((ref) {
  final serverKey =
      'cfda8d2ce26ec0da493f6a2347c009c4bcff9a07b2b6f17e9b9a7614eed866752f4c01ebc1b2a48f49bfa164e7f163b79e4e975dee889d0d3e453c0f5ca6e6d9d7f5f96413bf6210d651a707f4b2ef79938fbe5bd77d736f7b545547b3ca822dc99976548dc025a7a574d8275f1fac01f3b129635ee6f4e4d5e6afc9bbd39bea';
  appWriteDart.Client client = appWriteDart.Client();
  return client
      .setEndpoint(AppwriteConstants.endPoint)
      .setProject(AppwriteConstants.projectId)
      .setKey(serverKey);
});
final appwriteAccountProvider = Provider((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Account(client);
});

final appwriteDatabaseProvider = Provider((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Databases(client);
});
final appwriteChatDatabaseProvider = Provider((ref) {
  final client = ref.watch(appwriteClientChatsProvider);
  return appWriteDart.Databases(client);
});

final appwriteStorageProvider = Provider((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Storage(client);
});

final appwriteRealtimeProvider = Provider((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Realtime(client);
});
