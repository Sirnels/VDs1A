import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viewducts/admin/screens/add_product.dart';
import 'package:viewducts/helper/enum.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/page/Auth/signup.dart';
import 'package:viewducts/page/feed/composeTweet/composeDuct.dart';
import 'package:viewducts/page/feed/feedPage.dart';
import 'package:viewducts/page/message/chatListPage.dart';
import 'package:viewducts/page/message/chatScreenPage.dart';
import 'package:viewducts/page/message/newMessagePage.dart';
import 'package:viewducts/page/mobil_login_Page/edit_number.dart';
import 'package:viewducts/page/mobil_login_Page/verify_number.dart';
import 'package:viewducts/page/product/itemPage.dart';
import 'package:viewducts/page/product/market.dart';
import 'package:viewducts/page/product/sellers_signup.dart';
import 'package:viewducts/page/product/shopingCart.dart';
import 'package:viewducts/page/profile/profilePage.dart';
import 'package:viewducts/page/profile/shippingAdress.dart';

import 'package:viewducts/page/responsive.dart';
import 'package:viewducts/page/settings/accountSettings/about/aboutTwitter.dart';
import 'package:viewducts/page/settings/settingsAndPrivacyPage.dart';
import 'package:viewducts/state/appState.dart';
import 'package:viewducts/widgets/duct/ductStoryPage.dart';

import 'settings/accountSettings/accountSettingsPage.dart';
import 'settings/accountSettings/privacyAndSafety/privacyAndSafetyPage.dart';

class ChatResponsive extends StatelessWidget {
  const ChatResponsive(
      {Key? key,
      this.userProfileId,
      this.productId,
      this.dependency = false,
      this.isVductProduct = false,
      this.isDesktop = false,
      this.isTablet = false,
      this.chatIdUsers,
      this.keyId})
      : super(key: key);
  final bool isVductProduct;
  final String? userProfileId;
  final bool isDesktop;
  final bool? dependency;
  final bool isTablet;
  final String? productId;
  final String? chatIdUsers;
  final String? keyId;

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Stack(
        children: [
          ChatScreenPage(
              keyId: keyId,
              userProfileId: userProfileId,
              chatIdUsers: chatIdUsers,
              productId: productId,
              dependency: dependency,
              isVductProduct: isVductProduct,
              isDesktop: isDesktop,
              isTablet: isTablet),
        ],
      ),
      tablet: Stack(
        children: [
          Row(
            children: [
              Expanded(
                flex: 6,
                child: ChatListPage(
                  isTablet: true,
                ),
              ),
              Expanded(
                flex: 9,
                child: ChatScreenPage(
                  keyId: keyId,
                  chatIdUsers: chatIdUsers,
                  isTablet: true,
                  userProfileId: userProfileId,
                  productId: productId,
                  isVductProduct: isVductProduct,
                ),
              ),
            ],
          ),
        ],
      ),
      desktop: Row(
        children: [
          // Once our width is less then 1300 then it start showing errors
          // Now there is no error if our width is less then 1340

          Expanded(flex: Get.width > 1340 ? 3 : 5, child: PlainScaffold()),
          Expanded(
            flex: Get.width > 1340 ? 8 : 10,
            child: ChatScreenPage(
              keyId: keyId,
              chatIdUsers: chatIdUsers,
              isDesktop: true,
              userProfileId: userProfileId,
              productId: productId,
              isVductProduct: isVductProduct,
            ),
          ),
          Expanded(flex: Get.width > 1340 ? 2 : 4, child: PlainScaffold()),
        ],
      ),
    );
  }
}

class ProfileResponsiveView extends StatelessWidget {
  final bool isVductProduct;
  final String? profileId;
  final bool isDesktop;
  final bool isTablet;
  final ProfileType? profileType;
  final String? productId;
  const ProfileResponsiveView({
    Key? key,
    this.profileId,
    this.productId,
    this.isVductProduct = false,
    this.isDesktop = false,
    this.isTablet = false,
    this.profileType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Stack(
        children: [
          ProfilePage(
            profileId: profileId,
            profileType: profileType,
          )
        ],
      ),
      tablet: Stack(
        children: [
          Row(
            children: [
              Expanded(
                flex: 6,
                child: ChatListPage(
                  isTablet: true,
                ),
              ),
              Expanded(
                  flex: 9,
                  child: ProfilePage(
                    profileId: profileId,
                    profileType: profileType,
                  )),
            ],
          ),
        ],
      ),
      desktop: Row(
        children: [
          // Once our width is less then 1300 then it start showing errors
          // Now there is no error if our width is less then 1340

          Expanded(
            flex: Get.width > 1340 ? 3 : 5,
            child: ChatListPage(
              isDesktop: true,
            ),
          ),
          Expanded(
              flex: Get.width > 1340 ? 6 : 8,
              child: ProfilePage(
                profileId: profileId,
                profileType: profileType,
              )),
          Expanded(
            flex: Get.width > 1340 ? 4 : 6,
            child: FeedPage(isDesktop: true, shop: true),
          ),
        ],
      ),
    );
  }
}

class ShopItemPageResponsive extends StatelessWidget {
  final String? product;
  final String? section;
  final String? state;
  final String? category;
  final String? location;
  final bool isWelcomePage;
  const ShopItemPageResponsive(
      {Key? key,
      this.state,
      this.product,
      this.section,
      this.category,
      this.location,
      required this.isWelcomePage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Stack(
        children: [
          ItemPage(
              isWelcomePage: isWelcomePage,
              product: product,
              section: section,
              category: category,
              location: location,
              state: state)
        ],
      ),
      tablet: Stack(
        children: [
          Row(
            children: [
              Expanded(
                flex: 6,
                child: Home(
                  isTablet: true,
                ),
              ),
              Expanded(
                  flex: 9,
                  child: ItemPage(
                      isWelcomePage: isWelcomePage,
                      product: product,
                      section: section,
                      category: category,
                      location: location,
                      state: state)),
            ],
          ),
        ],
      ),
      desktop: Row(
        children: [
          // Once our width is less then 1300 then it start showing errors
          // Now there is no error if our width is less then 1340

          Expanded(flex: Get.width > 1340 ? 3 : 5, child: PlainScaffold()),
          Expanded(
              flex: Get.width > 1340 ? 8 : 10,
              child: ItemPage(
                  isWelcomePage: isWelcomePage,
                  product: product,
                  section: section,
                  category: category,
                  location: location,
                  state: state)),
          Expanded(
            flex: Get.width > 1340 ? 2 : 4,
            child: PlainScaffold(),
          ),
        ],
      ),
    );
  }
}

class UserSearchResponsive extends StatelessWidget {
  const UserSearchResponsive({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Stack(
        children: [NewMessagePage()],
      ),
      tablet: Stack(
        children: [
          Row(
            children: [
              Expanded(
                flex: 6,
                child: Home(
                  isTablet: true,
                ),
              ),
              Expanded(flex: 9, child: NewMessagePage()),
            ],
          ),
        ],
      ),
      desktop: Row(
        children: [
          // Once our width is less then 1300 then it start showing errors
          // Now there is no error if our width is less then 1340

          Expanded(
            flex: Get.width > 1340 ? 3 : 5,
            child: Home(
              isDesktop: true,
            ),
          ),
          Expanded(flex: Get.width > 1340 ? 6 : 8, child: NewMessagePage()),
          Expanded(
            flex: Get.width > 1340 ? 4 : 6,
            child: FeedPage(isDesktop: true, shop: true),
          ),
        ],
      ),
    );
  }
}

class CompoaseDuctsPageResponsive extends StatelessWidget {
  final bool visibleSwitch;
  final bool? isRetweet;
  final bool isTweet;
  final bool isVendor;
  final String? ductIds;

  const CompoaseDuctsPageResponsive(
      {Key? key,
      this.isRetweet,
      this.isTweet = true,
      this.visibleSwitch = true,
      this.ductIds,
      this.isVendor = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Stack(
        children: [
          ComposeDuctsPage(
            isTweet: isTweet,
            isRetweet: isRetweet,
            ductIds: ductIds,
            isVendor: isVendor,
          )
        ],
      ),
      tablet: Stack(
        children: [
          Row(
            children: [
              Expanded(
                flex: 6,
                child: FeedPage(
                  isTablet: true,
                ),
              ),
              Expanded(
                  flex: 9,
                  child: ComposeDuctsPage(
                    isTweet: isTweet,
                    isRetweet: isRetweet,
                    ductIds: ductIds,
                    isVendor: isVendor,
                  )),
            ],
          ),
        ],
      ),
      desktop: Row(
        children: [
          // Once our width is less then 1300 then it start showing errors
          // Now there is no error if our width is less then 1340

          Expanded(
            flex: Get.width > 1340 ? 5 : 7,
            child: FeedPage(
              isDesktop: true,
            ),
          ),
          Expanded(
              flex: Get.width > 1340 ? 9 : 11,
              child: ComposeDuctsPage(
                isTweet: isTweet,
                isRetweet: isRetweet,
                ductIds: ductIds,
                isVendor: isVendor,
              )),
          Expanded(
            flex: Get.width > 1340 ? 2 : 2,
            child: PlainScaffold(),
          ),
        ],
      ),
    );
  }
}

class ProductResponsiveView extends StatelessWidget {
  final FeedModel? model;
  final String? commissionUser;
  final bool isVduct;
  final int? rating;
  final ViewductsUser? currentUser;
  final ViewductsUser? vendor;
  const ProductResponsiveView(
      {Key? key,
      this.model,
      this.commissionUser,
      this.isVduct = false,
      this.rating,
      this.currentUser,
      this.vendor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Stack(
        children: [
          ProductStoryView(
              model: model,
              commissionUser: commissionUser,
              isVduct: isVduct,
              rating: rating,
              currentUser: currentUser,
              vendor: vendor)
        ],
      ),
      tablet: Stack(
        children: [
          Row(
            children: [
              Expanded(
                flex: 6,
                child: Home(
                  isTablet: true,
                ),
              ),
              Expanded(
                  flex: 9,
                  child: ProductStoryView(
                      model: model,
                      commissionUser: commissionUser,
                      rating: rating,
                      isVduct: isVduct,
                      currentUser: currentUser,
                      vendor: vendor)),
            ],
          ),
        ],
      ),
      desktop: Row(
        children: [
          // Once our width is less then 1300 then it start showing errors
          // Now there is no error if our width is less then 1340

          Expanded(
            flex: Get.width > 1340 ? 4 : 6,
            child: Home(
              isDesktop: true,
            ),
          ),
          Expanded(
              flex: Get.width > 1340 ? 8 : 10,
              child: ProductStoryView(
                  model: model,
                  commissionUser: commissionUser,
                  rating: rating,
                  isVduct: isVduct,
                  currentUser: currentUser,
                  vendor: vendor)),
          Expanded(
            flex: Get.width > 1340 ? 2 : 4,
            child: PlainScaffold(),
          ),
        ],
      ),
    );
  }
}

class PlainScaffold extends StatelessWidget {
  const PlainScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

class MainStoryResponsiveView extends StatelessWidget {
  final FeedModel? model;
  final FeedModel? product;
  final String? commissionUser;
  final List<DuctStoryModel>? storylist;
  final bool isVduct;
  final ViewductsUser? currentUser;
  final ViewductsUser? secondUser;
  final String vendorId;
  const MainStoryResponsiveView(
      {Key? key,
      this.model,
      this.storylist,
      this.commissionUser,
      required this.vendorId,
      this.isVduct = false,
      this.currentUser,
      this.secondUser,
      this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Stack(
        children: [
          MainStoryPage(
              vendorId: vendorId,
              model: model,
              product: product,
              storylist: storylist,
              currentUser: currentUser,
              secondUser: secondUser)
        ],
      ),
      tablet: Stack(
        children: [
          Row(
            children: [
              Expanded(
                flex: 6,
                child: Home(
                  isTablet: true,
                ),
              ),
              Expanded(
                  flex: 9,
                  child: MainStoryPage(
                      product: product,
                      vendorId: vendorId,
                      model: model,
                      storylist: storylist,
                      currentUser: currentUser,
                      secondUser: secondUser)),
            ],
          ),
        ],
      ),
      desktop: Row(
        children: [
          // Once our width is less then 1300 then it start showing errors
          // Now there is no error if our width is less then 1340

          Expanded(
            flex: Get.width > 1340 ? 3 : 5,
            child: Home(
              isDesktop: true,
            ),
          ),
          Expanded(
              flex: Get.width > 1340 ? 8 : 10,
              child: MainStoryPage(
                  product: product,
                  vendorId: vendorId,
                  storylist: storylist,
                  model: model,
                  currentUser: currentUser,
                  secondUser: secondUser)),
          Expanded(
            flex: Get.width > 1340 ? 2 : 4,
            child: PlainScaffold(),
          ),
        ],
      ),
    );
  }
}

class SettingsAndPrivacyPageResponsiveView extends StatelessWidget {
  const SettingsAndPrivacyPageResponsiveView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Stack(
        children: [SettingsAndPrivacyPage()],
      ),
      tablet: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: SettingsAndPrivacyPage(),
              ),
            ],
          ),
        ],
      ),
      desktop: Row(
        children: [
          // Once our width is less then 1300 then it start showing errors
          // Now there is no error if our width is less then 1340

          Expanded(
            flex: Get.width > 1340 ? 3 : 5,
            child: PlainScaffold(),
          ),
          Expanded(
              flex: Get.width > 1340 ? 8 : 10, child: SettingsAndPrivacyPage()),
          Expanded(
            flex: Get.width > 1340 ? 2 : 4,
            child: PlainScaffold(),
          ),
        ],
      ),
    );
  }
}

class AboutPageResponsiveView extends StatelessWidget {
  const AboutPageResponsiveView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Stack(
        children: [AboutPage()],
      ),
      tablet: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: AboutPage(),
              ),
            ],
          ),
        ],
      ),
      desktop: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
              color: (Colors.white12).withOpacity(0.1),
            ),
          ),
          Row(
            children: [
              // Once our width is less then 1300 then it start showing errors
              // Now there is no error if our width is less then 1340

              Expanded(
                flex: Get.width > 1340 ? 3 : 5,
                child: PlainScaffold(),
              ),
              Expanded(flex: Get.width > 1340 ? 8 : 10, child: AboutPage()),
              Expanded(
                flex: Get.width > 1340 ? 2 : 4,
                child: PlainScaffold(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SignUpPageResponsiveView extends StatelessWidget {
  final VoidCallback? loginCallback;
  const SignUpPageResponsiveView({
    Key? key,
    this.loginCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Stack(
        children: [Signup()],
      ),
      tablet: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: Signup(),
              ),
            ],
          ),
        ],
      ),
      desktop: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
              color: (Colors.white12).withOpacity(0.1),
            ),
          ),
          Row(
            children: [
              // Once our width is less then 1300 then it start showing errors
              // Now there is no error if our width is less then 1340

              Expanded(
                flex: Get.width > 1340 ? 3 : 5,
                child: PlainScaffold(),
              ),
              Expanded(
                flex: Get.width > 1340 ? 8 : 10,
                child: Signup(),
              ),
              Expanded(
                flex: Get.width > 1340 ? 2 : 4,
                child: PlainScaffold(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AddProductPageResponsiveView extends StatelessWidget {
  final bool isTweet;
  const AddProductPageResponsiveView({
    Key? key,
    this.isTweet = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Stack(
        children: [
          AddProduct(
            isTweet: true,
          )
        ],
      ),
      tablet: Stack(
        children: [
          Row(
            children: [
              Expanded(
                  child: AddProduct(
                isTweet: true,
              )),
            ],
          ),
        ],
      ),
      desktop: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
              color: (Colors.white12).withOpacity(0.1),
            ),
          ),
          Row(
            children: [
              // Once our width is less then 1300 then it start showing errors
              // Now there is no error if our width is less then 1340

              Expanded(
                flex: Get.width > 1340 ? 3 : 5,
                child: PlainScaffold(),
              ),
              Expanded(
                flex: Get.width > 1340 ? 8 : 10,
                child: AddProduct(
                  isTweet: true,
                ),
              ),
              Expanded(
                flex: Get.width > 1340 ? 2 : 4,
                child: PlainScaffold(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SellersSignUpPageResponsiveView extends StatelessWidget {
  final VoidCallback? loginCallback;
  const SellersSignUpPageResponsiveView({
    Key? key,
    this.loginCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Stack(
        children: [SellersSignup(loginCallback: loginCallback)],
      ),
      tablet: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: SellersSignup(loginCallback: loginCallback),
              ),
            ],
          ),
        ],
      ),
      desktop: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
              color: (Colors.white12).withOpacity(0.1),
            ),
          ),
          Row(
            children: [
              // Once our width is less then 1300 then it start showing errors
              // Now there is no error if our width is less then 1340

              Expanded(
                flex: Get.width > 1340 ? 3 : 5,
                child: PlainScaffold(),
              ),
              Expanded(
                flex: Get.width > 1340 ? 8 : 10,
                child: SellersSignup(loginCallback: loginCallback),
              ),
              Expanded(
                flex: Get.width > 1340 ? 2 : 4,
                child: PlainScaffold(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PrivacyAndSaftyPagePageResponsiveView extends StatelessWidget {
  const PrivacyAndSaftyPagePageResponsiveView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Stack(
        children: [PrivacyAndSaftyPage()],
      ),
      tablet: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: PrivacyAndSaftyPage(),
              ),
            ],
          ),
        ],
      ),
      desktop: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
              color: (Colors.white12).withOpacity(0.1),
            ),
          ),
          Row(
            children: [
              // Once our width is less then 1300 then it start showing errors
              // Now there is no error if our width is less then 1340

              Expanded(
                flex: Get.width > 1340 ? 3 : 5,
                child: PlainScaffold(),
              ),
              Expanded(
                  flex: Get.width > 1340 ? 8 : 10,
                  child: PrivacyAndSaftyPage()),
              Expanded(
                flex: Get.width > 1340 ? 2 : 4,
                child: PlainScaffold(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AccountSettingsPageResponsiveView extends StatelessWidget {
  const AccountSettingsPageResponsiveView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Stack(
        children: [AccountSettingsPage()],
      ),
      tablet: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: AccountSettingsPage(),
              ),
            ],
          ),
        ],
      ),
      desktop: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
              color: (Colors.white12).withOpacity(0.1),
            ),
          ),
          Row(
            children: [
              // Once our width is less then 1300 then it start showing errors
              // Now there is no error if our width is less then 1340

              Expanded(
                flex: Get.width > 1340 ? 3 : 5,
                child: PlainScaffold(),
              ),
              Expanded(
                  flex: Get.width > 1340 ? 8 : 10,
                  child: AccountSettingsPage()),
              Expanded(
                flex: Get.width > 1340 ? 2 : 4,
                child: PlainScaffold(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EditPhonePageResponsiveView extends StatelessWidget {
  const EditPhonePageResponsiveView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Stack(
        children: [EditNumber()],
      ),
      tablet: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: EditNumber(),
              ),
            ],
          ),
        ],
      ),
      desktop: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
              color: (Colors.white12).withOpacity(0.1),
            ),
          ),
          Row(
            children: [
              // Once our width is less then 1300 then it start showing errors
              // Now there is no error if our width is less then 1340

              Expanded(
                flex: Get.width > 1340 ? 3 : 5,
                child: PlainScaffold(),
              ),
              Expanded(flex: Get.width > 1340 ? 8 : 10, child: EditNumber()),
              Expanded(
                flex: Get.width > 1340 ? 2 : 4,
                child: PlainScaffold(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class VerifyPhonePageResponsiveView extends StatelessWidget {
  const VerifyPhonePageResponsiveView(
      {Key? key, this.number, this.country, this.code, this.phoneNoCode})
      : super(key: key);
  final number;
  final phoneNoCode;
  final String? country;
  final String? code;

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Stack(
        children: [
          VerifyNumber(
              country: country,
              number: number,
              code: code,
              phoneNoCode: phoneNoCode)
        ],
      ),
      tablet: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: VerifyNumber(
                    country: country,
                    number: number,
                    code: code,
                    phoneNoCode: phoneNoCode),
              ),
            ],
          ),
        ],
      ),
      desktop: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
              color: (Colors.white12).withOpacity(0.1),
            ),
          ),
          Row(
            children: [
              // Once our width is less then 1300 then it start showing errors
              // Now there is no error if our width is less then 1340

              Expanded(
                flex: Get.width > 1340 ? 3 : 5,
                child: PlainScaffold(),
              ),
              Expanded(
                  flex: Get.width > 1340 ? 8 : 10,
                  child: VerifyNumber(
                      country: country,
                      number: number,
                      code: code,
                      phoneNoCode: phoneNoCode)),
              Expanded(
                flex: Get.width > 1340 ? 2 : 4,
                child: PlainScaffold(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WebMarketPlace extends StatelessWidget {
  const WebMarketPlace(
      {Key? key, this.number, this.country, this.code, this.phoneNoCode})
      : super(key: key);
  final number;
  final phoneNoCode;
  final String? country;
  final String? code;

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Stack(
        children: [
          Home(),
        ],
      ),
      tablet: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: Home(
                  isTablet: true,
                ),
              ),
            ],
          ),
        ],
      ),
      desktop: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
              color: (Colors.white12).withOpacity(0.1),
            ),
          ),
          Row(
            children: [
              // Once our width is less then 1300 then it start showing errors
              // Now there is no error if our width is less then 1340

              Expanded(
                flex: Get.width > 1340 ? 3 : 5,
                child: PlainScaffold(),
              ),
              Expanded(
                flex: Get.width > 1340 ? 8 : 10,
                child: Home(
                  isDesktop: true,
                ),
              ),
              Expanded(
                flex: Get.width > 1340 ? 2 : 4,
                child: PlainScaffold(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ShoppingCartResponsive extends StatelessWidget {
  const ShoppingCartResponsive(
      {Key? key,
      this.number,
      this.country,
      this.code,
      this.phoneNoCode,
      this.model,
      this.cart,
      this.sellerId,
      this.buyerId,
      this.sellersName})
      : super(key: key);
  final number;
  final phoneNoCode;
  final String? country;
  final String? sellersName;
  final String? code;
  final AppState? model;
  final Rx<ViewProduct>? cart;
  final String? sellerId;
  final String? buyerId;
  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Stack(
        children: [
          ShoppingCart(
              cart: cart,
              sellerId: sellerId,
              buyerId: buyerId,
              sellersName: sellersName),
        ],
      ),
      tablet: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: ShoppingCart(
                    cart: cart,
                    sellerId: sellerId,
                    buyerId: buyerId,
                    sellersName: sellersName),
              ),
            ],
          ),
        ],
      ),
      desktop: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
              color: (Colors.white12).withOpacity(0.1),
            ),
          ),
          Row(
            children: [
              // Once our width is less then 1300 then it start showing errors
              // Now there is no error if our width is less then 1340

              Expanded(
                flex: Get.width > 1340 ? 3 : 5,
                child: PlainScaffold(),
              ),
              Expanded(
                flex: Get.width > 1340 ? 8 : 10,
                child: ShoppingCart(
                    cart: cart,
                    sellerId: sellerId,
                    buyerId: buyerId,
                    sellersName: sellersName),
              ),
              Expanded(
                flex: Get.width > 1340 ? 2 : 4,
                child: PlainScaffold(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CheckoutResponsive extends StatelessWidget {
  const CheckoutResponsive(
      {Key? key,
      this.number,
      this.country,
      this.code,
      this.phoneNoCode,
      this.model,
      this.cart,
      this.sellerId,
      this.buyerId,
      this.currentUser,
      required this.product})
      : super(key: key);
  final number;
  final phoneNoCode;
  final String? country;
  final String? code;
  final AppState? model;
  final Rx<ViewProduct>? cart;
  final String? sellerId;
  final String? buyerId;
  final List<CartItemModel> product;
  final ViewductsUser? currentUser;
  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Stack(
        children: [
          ShippingAddress(
              cart: cart!,
              sellerId: sellerId,
              currentUser: currentUser,
              product: product),
        ],
      ),
      tablet: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: ShippingAddress(
                    cart: cart!,
                    sellerId: sellerId,
                    currentUser: currentUser,
                    product: product),
              ),
            ],
          ),
        ],
      ),
      desktop: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
              color: (Colors.white12).withOpacity(0.1),
            ),
          ),
          Row(
            children: [
              // Once our width is less then 1300 then it start showing errors
              // Now there is no error if our width is less then 1340

              Expanded(
                flex: Get.width > 1340 ? 3 : 5,
                child: PlainScaffold(),
              ),
              Expanded(
                flex: Get.width > 1340 ? 8 : 10,
                child: ShippingAddress(
                  cart: cart!,
                  sellerId: sellerId,
                  currentUser: currentUser,
                  product: product,
                ),
              ),
              Expanded(
                flex: Get.width > 1340 ? 2 : 4,
                child: PlainScaffold(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChatlistPageResponsive extends StatelessWidget {
  const ChatlistPageResponsive({
    Key? key,
    this.isCart,
  }) : super(key: key);
  final isCart;

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Stack(
        children: [
          ChatListPage(
            isCart: isCart,
          )
        ],
      ),
      tablet: Stack(
        children: [
          Row(
            children: [
              Expanded(
                  child: ChatListPage(
                isCart: isCart,
              )),
            ],
          ),
        ],
      ),
      desktop: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
              color: (Colors.white12).withOpacity(0.1),
            ),
          ),
          Row(
            children: [
              // Once our width is less then 1300 then it start showing errors
              // Now there is no error if our width is less then 1340

              Expanded(
                flex: Get.width > 1340 ? 3 : 5,
                child: PlainScaffold(),
              ),
              Expanded(
                  flex: Get.width > 1340 ? 8 : 10,
                  child: ChatListPage(
                    isCart: isCart,
                  )),
              Expanded(
                flex: Get.width > 1340 ? 2 : 4,
                child: PlainScaffold(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
