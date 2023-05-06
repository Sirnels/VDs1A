import 'package:appwrite/models.dart' as model;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viewducts/apis/auth_api.dart';
import 'package:viewducts/apis/user_api.dart';
import 'package:viewducts/core/utils.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/page/Auth/signup.dart';
import 'package:viewducts/page/homePage.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    authAPI: ref.watch(authAPIProvider),
    userAPI: ref.watch(userAPIProvider),
  );
});

final currentUserDetailsProvider = FutureProvider((ref) {
  final currentUserId = ref.watch(currentUserAccountProvider).value!.$id;
  final userDetails = ref.watch(userDetailsProvider(currentUserId));
  return userDetails.value;
});

final userDetailsProvider = FutureProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

final currentUserAccountProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUser();
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final UserAPI _userAPI;
  AuthController({
    required AuthAPI authAPI,
    required UserAPI userAPI,
  })  : _authAPI = authAPI,
        _userAPI = userAPI,
        super(false);
  // state = isLoading

  Future<model.Account?> currentUser() => _authAPI.currentUserAccount();

  void signUp(
      {required String email,
      required String password,
      required BuildContext context,
      required ViewductsUser userModel}) async {
    state = true;
    final res = await _authAPI.signUp(
      email: email,
      password: password,
    );

    res.fold(
      (l) {
        state = false;
        return showSnackBar(context, l.message);
      },
      (r) async {
        await _authAPI.login(
          email: email,
          password: password,
        );
        ViewductsUser model = ViewductsUser(
            key: r.$id,
            admin: userModel.admin,
            authenticationType: userModel.authenticationType,
            contact: userModel.contact,
            bio: userModel.bio,
            countryCode: userModel.countryCode,
            createdAt: userModel.createdAt,
            displayName: userModel.displayName,
            email: userModel.email,
            fcmToken: userModel.fcmToken,
            isVerified: userModel.isVerified,
            newDevice: userModel.newDevice,
            dob: userModel.dob,
            firstName: userModel.firstName,
            lastName: userModel.lastName,
            lastSeen: userModel.lastSeen,
            location: userModel.location,
            profilePic: userModel.profilePic,
            publicKey: userModel.profilePic,
            secret: userModel.secret,
            session: userModel.session,
            state: userModel.state,
            userName: userModel.userName,
            userProfilePic: userModel.userProfilePic,
            userId: r.$id);
        final res2 = await _userAPI.saveUserData(model);
        res2.fold((l) => showSnackBar(context, l.message), (r) {
          state = false;
          showSnackBar(context, 'Accounted created! You\'re Welcome.');
          Navigator.push(context, HomePage.route());
        });
      },
    );
  }

  void login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.login(
      email: email,
      password: password,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      },
    );
  }

  Future<ViewductsUser> getUserData(String uid) async {
    final document = await _userAPI.getUserData(uid);
    final updatedUser = ViewductsUser.fromJson(document.data);
    return updatedUser;
  }

  void logout(BuildContext context) async {
    final res = await _authAPI.logout();
    res.fold((l) => null, (r) {
      // Navigator.pushAndRemoveUntil(
      //   context,
      //   SignUpView.route(),
      //   (route) => false,
      // );
    });
  }
}
