// ignore_for_file: constant_identifier_names

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

enum DuctType { Duct, Detail, Reply, ParentDuct, Product, Listing, Ads }

enum ProfileType { Profile, Store }

enum SortUser {
  ByVerified,
  ByAlphabetically,
  ByNewest,
  ByOldest,
  ByMaxFollower
}

enum VendorCategory { Children, Electronics, Farm, Grocery, Fashion, Housing }

enum NotificationType {
  NOT_DETERMINED,
  Order,
  Message,
  Tweet,
  Reply,
  Retweet,
  Follow,
  Mention,
  Like
}

enum MessagesType {
  Text,
  Image,
  Products,
  MyOrders,
  ChatUserProducts,
  Video,
  VoiceMessage,
  Audio,
  Document,
  Contact
}

enum ReactionType { Love, Like, Delicious, Smile, Sad, Empty }

enum StoryType { text, image, video }

enum DuctPostType { text, image, video }

enum RegistrationType { Personal, Vendor, Upgrade, BossMem, BabyVen, BossVen }

enum UserState {
  Offline,
  Online,
  Waiting,
}

enum ViewState {
  IDLE,
  LOADING,
}

List<String> keysOfRating = [
  "Very bad",
  "Poor",
  "Average",
  "Good",
  "Excellent"
];
