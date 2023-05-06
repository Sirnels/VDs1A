import 'dart:convert';

import 'package:flutter/foundation.dart';

class ViewductsUser {
  String? key;
  bool? secret;
  String? email;
  String? userId;
  String? session;
  String? state;
  String? firstName;
  String? lastName;
  String? countryCode;
  int? authenticationType;
  dynamic lastSeen;
  bool? newDevice;
  String? publicKey;
  List<String>? viewers;
  List<String>? viewing;
  String? displayName;
  String? userName;

  String? profilePic;
  String? userProfilePic;
  int? contact;
  String? bio;
  String? location;
  String? dob;
  String? createdAt;
  bool? isVerified;

  bool? admin;

  String? fcmToken;

  ViewductsUser({
    this.key,
    this.secret,
    this.email,
    this.userId,
    this.session,
    this.state,
    this.firstName,
    this.lastName,
    this.countryCode,
    this.authenticationType,
    this.lastSeen,
    this.newDevice,
    this.publicKey,
    this.viewers,
    this.viewing,
    this.displayName,
    this.userName,
    this.profilePic,
    this.userProfilePic,
    this.contact,
    this.bio,
    this.location,
    this.dob,
    this.createdAt,
    this.isVerified,
    this.admin,
    this.fcmToken,
  });

  ViewductsUser.fromJson(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return;
    }
    secret = map['secret'];
    countryCode = map['countryCode'];
    newDevice = map["newDevice"];
    email = map['email'];
    session = map['session'];
    state = map['state'];
    firstName = map['firstName'];
    userId = map['userId'];
    displayName = map['displayName'];
    userProfilePic = map['userProfilePic'];
    lastName = map['lastName'];
    publicKey = map['publicKey'];
    profilePic = map['profilePic'];
    authenticationType = map['authenticationType'];

    key = map['key'];
    dob = map['dob'];
    bio = map['bio'] ?? 'My Bio';

    location = map['location'];
    contact = map['contact'];
    createdAt = map['createdAt'];

    userName = map['userName'];

    lastSeen = map['lastSeen'];
    fcmToken = map['fcmToken'];

    isVerified = map['isVerified'] ?? false;

    admin = map['admin'] ?? false;
  }
  toJson() {
    return {
      'key': key,
      "userId": userId,
      "countryCode": countryCode,
      "email": email,
      'state': state,
      "newDevice": newDevice,
      'session': session,
      'firstName': firstName,
      'displayName': displayName,
      'profilePic': profilePic,
      'userProfilePic': userProfilePic,
      'contact': contact,
      'lastSeen': lastSeen,
      'lastName': lastName,
      'publicKey': publicKey,
      'secret': secret,
      'dob': dob,
      'bio': bio,
      'location': location,
      'createdAt': createdAt,
      'userName': userName,
      'isVerified': isVerified ?? false,
      'admin': admin ?? false,
      'fcmToken': fcmToken,
    };
  }

  ViewductsUser copyWith({
    String? key,
    bool? secret,
    String? email,
    String? userId,
    String? session,
    String? state,
    String? firstName,
    String? lastName,
    String? countryCode,
    int? authenticationType,
    dynamic? lastSeen,
    bool? newDevice,
    String? publicKey,
    List<String>? viewers,
    List<String>? viewing,
    String? displayName,
    String? userName,
    String? profilePic,
    String? userProfilePic,
    int? contact,
    String? bio,
    String? location,
    String? dob,
    String? createdAt,
    bool? isVerified,
    bool? admin,
    String? fcmToken,
  }) {
    return ViewductsUser(
      key: key ?? this.key,
      secret: secret ?? this.secret,
      email: email ?? this.email,
      userId: userId ?? this.userId,
      session: session ?? this.session,
      state: state ?? this.state,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      countryCode: countryCode ?? this.countryCode,
      authenticationType: authenticationType ?? this.authenticationType,
      lastSeen: lastSeen ?? this.lastSeen,
      newDevice: newDevice ?? this.newDevice,
      publicKey: publicKey ?? this.publicKey,
      viewers: viewers ?? this.viewers,
      viewing: viewing ?? this.viewing,
      displayName: displayName ?? this.displayName,
      userName: userName ?? this.userName,
      profilePic: profilePic ?? this.profilePic,
      userProfilePic: userProfilePic ?? this.userProfilePic,
      contact: contact ?? this.contact,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      dob: dob ?? this.dob,
      createdAt: createdAt ?? this.createdAt,
      isVerified: isVerified ?? this.isVerified,
      admin: admin ?? this.admin,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (key != null) {
      result.addAll({'key': key});
    }
    if (secret != null) {
      result.addAll({'secret': secret});
    }
    if (email != null) {
      result.addAll({'email': email});
    }
    if (userId != null) {
      result.addAll({'userId': userId});
    }
    if (session != null) {
      result.addAll({'session': session});
    }
    if (state != null) {
      result.addAll({'state': state});
    }
    if (firstName != null) {
      result.addAll({'firstName': firstName});
    }
    if (lastName != null) {
      result.addAll({'lastName': lastName});
    }
    if (countryCode != null) {
      result.addAll({'countryCode': countryCode});
    }
    if (authenticationType != null) {
      result.addAll({'authenticationType': authenticationType});
    }
    result.addAll({'lastSeen': lastSeen});
    if (newDevice != null) {
      result.addAll({'newDevice': newDevice});
    }
    if (publicKey != null) {
      result.addAll({'publicKey': publicKey});
    }
    if (viewers != null) {
      result.addAll({'viewers': viewers!.map((x) => x).toList()});
    }
    if (viewing != null) {
      result.addAll({'viewing': viewing});
    }
    if (displayName != null) {
      result.addAll({'displayName': displayName});
    }
    if (userName != null) {
      result.addAll({'userName': userName});
    }
    if (profilePic != null) {
      result.addAll({'profilePic': profilePic});
    }
    if (userProfilePic != null) {
      result.addAll({'userProfilePic': userProfilePic});
    }
    if (contact != null) {
      result.addAll({'contact': contact});
    }
    if (bio != null) {
      result.addAll({'bio': bio});
    }
    if (location != null) {
      result.addAll({'location': location});
    }
    if (dob != null) {
      result.addAll({'dob': dob});
    }
    if (createdAt != null) {
      result.addAll({'createdAt': createdAt});
    }
    if (isVerified != null) {
      result.addAll({'isVerified': isVerified});
    }
    if (admin != null) {
      result.addAll({'admin': admin});
    }
    if (fcmToken != null) {
      result.addAll({'fcmToken': fcmToken});
    }

    return result;
  }

  factory ViewductsUser.fromMap(Map<String, dynamic> map) {
    return ViewductsUser(
      key: map['key'],
      secret: map['secret'],
      email: map['email'],
      userId: map['userId'],
      session: map['session'],
      state: map['state'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      countryCode: map['countryCode'],
      authenticationType: map['authenticationType']?.toInt(),
      lastSeen: map['lastSeen'] ?? null,
      newDevice: map['newDevice'],
      publicKey: map['publicKey'],
      viewers: List<String>.from(map['viewers']),
      viewing: List<String>.from(map['viewing']),
      displayName: map['displayName'],
      userName: map['userName'],
      profilePic: map['profilePic'],
      userProfilePic: map['userProfilePic'],
      contact: map['contact']?.toInt(),
      bio: map['bio'],
      location: map['location'],
      dob: map['dob'],
      createdAt: map['createdAt'],
      isVerified: map['isVerified'],
      admin: map['admin'],
      fcmToken: map['fcmToken'],
    );
  }

  @override
  String toString() {
    return 'ViewductsUser(key: $key, secret: $secret, email: $email, userId: $userId, session: $session, state: $state, firstName: $firstName, lastName: $lastName, countryCode: $countryCode, authenticationType: $authenticationType, lastSeen: $lastSeen, newDevice: $newDevice, publicKey: $publicKey, viewers: $viewers, viewing: $viewing, displayName: $displayName, userName: $userName, profilePic: $profilePic, userProfilePic: $userProfilePic, contact: $contact, bio: $bio, location: $location, dob: $dob, createdAt: $createdAt, isVerified: $isVerified, admin: $admin, fcmToken: $fcmToken)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ViewductsUser &&
        other.key == key &&
        other.secret == secret &&
        other.email == email &&
        other.userId == userId &&
        other.session == session &&
        other.state == state &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.countryCode == countryCode &&
        other.authenticationType == authenticationType &&
        other.lastSeen == lastSeen &&
        other.newDevice == newDevice &&
        other.publicKey == publicKey &&
        listEquals(other.viewers, viewers) &&
        listEquals(other.viewing, viewing) &&
        other.displayName == displayName &&
        other.userName == userName &&
        other.profilePic == profilePic &&
        other.userProfilePic == userProfilePic &&
        other.contact == contact &&
        other.bio == bio &&
        other.location == location &&
        other.dob == dob &&
        other.createdAt == createdAt &&
        other.isVerified == isVerified &&
        other.admin == admin &&
        other.fcmToken == fcmToken;
  }

  @override
  int get hashCode {
    return key.hashCode ^
        secret.hashCode ^
        email.hashCode ^
        userId.hashCode ^
        session.hashCode ^
        state.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        countryCode.hashCode ^
        authenticationType.hashCode ^
        lastSeen.hashCode ^
        newDevice.hashCode ^
        publicKey.hashCode ^
        viewers.hashCode ^
        viewing.hashCode ^
        displayName.hashCode ^
        userName.hashCode ^
        profilePic.hashCode ^
        userProfilePic.hashCode ^
        contact.hashCode ^
        bio.hashCode ^
        location.hashCode ^
        dob.hashCode ^
        createdAt.hashCode ^
        isVerified.hashCode ^
        admin.hashCode ^
        fcmToken.hashCode;
  }

  // String toJson() => json.encode(toMap());

  // factory ViewductsUser.fromJson(String source) => ViewductsUser.fromMap(json.decode(source));
}

class Vendors {
  String? key;
  String? name;
  String? profilePic;
  String? subscription;
  String? location;
  String? vendorCategory;

  Vendors(
      {this.key,
      this.name,
      this.profilePic,
      this.subscription,
      this.location,
      this.vendorCategory});

  Vendors.fromJson(Map<dynamic, dynamic> map) {
    // ignore: unnecessary_null_comparison
    if (map == null) {
      return;
    }
    key = map['key'];
    name = map['name'];
    profilePic = map['profilePic'];
    subscription = map['subscription'];
    location = map['location'];
    vendorCategory = map['vendorCategory'];
  }
  toJson() {
    return {
      'key': key,
      "email": name,
      "profilePic": profilePic,
      "subscription": subscription,
      "location": location,
      "vendorCategory": vendorCategory,
    };
  }

  Vendors copyWith(
      {String? key,
      String? name,
      String? profilePic,
      String? subscription,
      String? location,
      String? vendorCategory}) {
    return Vendors(
      key: key ?? this.key,
      name: name ?? this.key,
      profilePic: profilePic ?? this.profilePic,
      subscription: subscription ?? this.subscription,
      location: location ?? this.location,
      vendorCategory: vendorCategory ?? this.vendorCategory,
    );
  }
}
