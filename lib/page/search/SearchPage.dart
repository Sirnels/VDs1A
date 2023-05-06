// ignore_for_file: invalid_use_of_protected_member, unused_element, prefer_typing_uninitialized_variables, file_names, must_be_immutable, unnecessary_null_comparison

import 'dart:io';
import 'dart:ui';

//import 'package:advanced_search/advanced_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:viewducts/apis/auth_api.dart';
import 'package:viewducts/common/user_avatar.dart';
import 'package:viewducts/features/auth/controller/auth_controller.dart';
import 'package:viewducts/helper/enum.dart';

import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/page/message/item_Search_bar.dart';

import 'package:viewducts/page/profile/profilePage.dart';

import 'package:viewducts/widgets/cartIcon.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/duct/widgets/postAsymmetricView.dart';
import 'package:viewducts/widgets/frosted.dart';
import 'package:viewducts/widgets/newWidget/title_text.dart';

class SearchPage extends ConsumerStatefulWidget {
  SearchPage(
      {Key? key,
      this.scaffoldKey,
      this.submitButtonText,
      this.textController,
      this.title,
      this.onSearchChanged,
      this.icon,
      this.isBackButton = false,
      this.isbootomLine = true,
      this.isCrossButton = false,
      this.isSubmitDisable = true,
      this.leading,
      this.onActionPressed,
      this.isDesktop = false,
      this.isTablet = false})
      : super(key: key);
  final int? icon;
  final bool isDesktop;
  final bool isTablet;
  final bool isBackButton;
  final bool isbootomLine;
  final bool isCrossButton;
  final bool isSubmitDisable;
  final Widget? leading;
  final Function? onActionPressed;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final String? submitButtonText;
  final TextEditingController? textController;
  final Widget? title;
  final ValueChanged<String>? onSearchChanged;

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final Size appBarHeight = const Size.fromHeight(56.0);

//   @override
  String? ductId;

  FeedModel? model;

  bool isDropdown = false;

  double? height, width, xPosiion, yPosition;

  late OverlayEntry floatingMenu;

  // TextEditingController? _textEditingController;
  bool typing = false;

  String? senderId;

  String? userImage;

  bool? isContinuing;

  FocusNode textFieldFocus = FocusNode();

  FocusNode imageTextFieldFocus = FocusNode();

  //ChatState state = ChatState();
  ValueNotifier<bool> isSelected = ValueNotifier(false);

  String? chatUserProductId, myOrders;

  String? peerAvatar, peerNo, currentUserNo, privateKey, sharedSecret;

  bool? locked, hidden;

  int? chatStatus, unread;

  GlobalKey? actionKey;

  dynamic lastSeen;

  String? chatId;

  bool isWriting = false;

  bool showEmojiPicker = false;

  File? imageFile;

  bool? isLoading;

  String? postId;

  String? imageUrl;

  final TextEditingController textEditingController = TextEditingController();

  final TextEditingController imageTextEditingController =
      TextEditingController();

  ViewductsUser? viewductsUser;

  final ScrollController realtime = ScrollController();

  final ScrollController saved = ScrollController();

  int quantity = 1;

  String sizeValue = "";

  String colorValue = "";

  bool? editProduct;

  String? image, name;

  String? selectedColor;

  var itemDetails;

  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ValueNotifier<bool> imageNotready = ValueNotifier(false);

  bool isToolAvailable = true;

  bool isMyProfile = false;

  final GlobalKey<State> keyLoader = GlobalKey<State>();

  List<dynamic>? size;

  //FeedState? productState;
  var playstate;

  void onSettingIconPressed() {
    Navigator.pushNamed(Get.context!, '/TrendsPage');
  }

  RxList<FeedModel> listSearch = RxList<FeedModel>();
  RxList<FeedModel> emptySearchProductSugestion = RxList<FeedModel>();
  final _textEditingController = TextEditingController();
  RxString searchingText = ''.obs;
  RxString productsSearchingText = ''.obs;
  List<KeyWordDuctModel> keyWordState = <KeyWordDuctModel>[];
  // final listSearchState = useState(listSearch);
  // final emptySearchProductSugestionState =
  //     useState(emptySearchProductSugestion);
  // final searchValue = useState(searchingText);

  //  final productsSearchingTextState = useState(productsSearchingText);
  void itemProduct(String value, {int? index}) {
    productsSearchingText = value.obs;
    //  setState(() {});
    cprint('${productsSearchingText.value}');
  }

  Widget _getRichText(String result) {
    // if (result == '') {
    //   return Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: Container(
    //       child: Text('No Products'),
    //     ),
    //   );
    // }

    String textSelected = "";
    String textBefore = "";
    String textAfter = "";
    try {
      String lowerCaseResult = result.toLowerCase();
      String lowerCaseSearchText = _textEditingController.text.toLowerCase();
      textSelected = result.substring(
          lowerCaseResult.indexOf(lowerCaseSearchText),
          lowerCaseResult.indexOf(lowerCaseSearchText) +
              lowerCaseSearchText.length);
      String loserCaseTextSelected = textSelected.toLowerCase();
      textBefore =
          result.substring(0, lowerCaseResult.indexOf(loserCaseTextSelected));
      if (lowerCaseResult.indexOf(loserCaseTextSelected) + textSelected.length <
          result.length) {
        textAfter = result.substring(
            lowerCaseResult.indexOf(loserCaseTextSelected) +
                textSelected.length,
            result.length);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }

    return result.indexOf(searchingText) == -1
        ? Container()
        : Container(
            alignment: Alignment.centerLeft,
            child: RichText(
              text: _textEditingController.text.isNotEmpty
                  ? TextSpan(
                      children: [
                        if (_textEditingController.text.isNotEmpty)
                          TextSpan(
                            text: textBefore,
                            style: TextStyle(
                              color: CupertinoColors.lightBackgroundGray,
                            ),
                          ),
                        TextSpan(
                          text: textSelected,
                          style: TextStyle(
                            color: CupertinoColors.systemYellow,
                          ),
                        ),
                        TextSpan(
                          text: textAfter,
                          style: TextStyle(
                            color: CupertinoColors.lightBackgroundGray,
                          ),
                        )
                      ],
                    )
                  : TextSpan(
                      text: result,
                      style: TextStyle(
                        color: Colors.grey[500],
                      ),
                    ),
            ),
          );
  }

  void keywordItem(String value, {int? index}) {
    searchingText = value.obs;
    //  setState(() {});
    // cprint('${searchValue.value}');
  }

  // allUser() async {
  //   try {
  //     final database = Databases(
  //       clientConnect(),
  //     );

  //     if (productsSearchingTextState.value != '') {
  //       await database.listDocuments(
  //           databaseId: databaseId,
  //           collectionId: procold,
  //           queries: [
  //             Query.search('keyword', productsSearchingTextState.value.value),
  //             Query.limit(10),
  //           ]).then((data) {
  //         var value =
  //             data.documents.map((e) => FeedModel.fromJson(e.data)).toList();

  //         listSearchState.value.value = value.obs;
  //       });

  //       await database.listDocuments(
  //           databaseId: databaseId,
  //           collectionId: procold,
  //           queries: [
  //             // Query.orderDesc('createdAt'),
  //             Query.limit(10),
  //           ]).then((data) {
  //         var value =
  //             data.documents.map((e) => FeedModel.fromJson(e.data)).toList();

  //         emptySearchProductSugestionState.value.value = value.obs;
  //       });
  //     } else {
  //       // cprint('type in your word');
  //     }

  //     if (searchValue.value != '') {
  //       await database.listDocuments(
  //           databaseId: databaseId,
  //           collectionId: keyWordsColl,
  //           queries: [
  //             Query.search('keyword', searchValue.value.value),
  //             Query.limit(5),
  //           ]).then((item) {
  //         if (item.documents.isNotEmpty) {
  //           var value = item.documents
  //               .map((e) => KeyWordDuctModel.fromSnapshot(e.data))
  //               .toList();

  //           keyWordState.value = value.obs;
  //         }
  //         // else {
  //         //   keyWordState.value = [
  //         //     KeyWordDuctModel.fromSnapshot({'keyword': "is empty"})
  //         //   ];
  //         // }
  //       });
  //     }
  //   } on AppwriteException catch (e) {
  //     cprint('$e');
  //   }
  // }

  // cprint('${searchValue.value} word');

  // useEffect(
  //   () {
  //     animationController.forward();
  //     allUser();
  //     return () {};
  //   },
  //   [
  //     productsSearchingTextState.value,
  //     searchValue.value,
  //     searchingText.value,
  //     _textEditingController.text,
  //     feedState.keywords,
  //     listSearch
  //   ],
  // );
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    var appSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: KeyboardDismisser(
          gestures: const [
            GestureType.onTap,
            GestureType.onPanUpdateUpDirection,
          ],
          child: GestureDetector(
            onHorizontalDragUpdate: (details) {
              // Note: Sensitivity is integer used when you don't want to mess up vertical drag
              int sensitivity = 8;
              if (details.delta.dx > sensitivity) {
                // Right Swipe
                if (ref.read(numberProvider.notifier).state == 3) {
                  ref.read(numberProvider.notifier).state = 2;
                }
              } else if (details.delta.dx < -sensitivity) {
                if (ref.read(numberProvider.notifier).state == 3) {
                  ref.read(numberProvider.notifier).state = 4;
                }

                //Left Swipe
              }
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                ThemeMode.system == ThemeMode.light
                    ? frostedYellow(
                        Container(
                          height: appSize.height,
                          width: appSize.width,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.yellow[100]!.withOpacity(0.3),
                                Colors.yellow[200]!.withOpacity(0.1),
                                Colors.yellowAccent[100]!.withOpacity(0.2)
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      )
                    : Container(),

                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Transform.rotate(
                    angle: 90,
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/ankkara1.jpg'))),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: -10,
                  child: Transform.rotate(
                    angle: 90,
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/ankara3.jpg'))),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Transform.rotate(
                    angle: 30,
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/ankkara1.jpg'))),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: -10,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                    child: Container(
                      width: Get.height * 0.4,
                      height: Get.height * 0.4,
                      color: (Colors.white12).withOpacity(0.1),
                    ),
                  ),
                ),

                FractionallySizedBox(
                  heightFactor: 1 - 0.3,
                  alignment: Alignment.bottomCenter,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: appSize.height * 0.8,
                          width: appSize.width,
                          // child: PostAsymmetricView(
                          //   isAllserch: true,
                          //   searchWords: productsSearchingText.value,
                          //   model: productsSearchingText.value != '' &&
                          //           listSearch.isEmpty
                          //       ? emptySearchProductSugestion
                          //       : listSearch,
                          // )
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: appSize.height * 0.15,
                  right: widget.isDesktop == true
                      ? Get.width * 0.1
                      : widget.isTablet == true
                          ? Get.width * 0.2
                          : Get.width * 0.25,
                  left: 20,
                  child: SizedBox(
                    width: Get.height * 0.52,
                    // height: appSize.height * 0.3,
                    // color: Colors.white,
                    child: Obx(
                      () => SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // GestureDetector(
                            //   onTap: () {
                            //     feedState.createSearchKeyWord('Baby Ankara');
                            //   },
                            //   child: Text('Add Keyword'),
                            // ),
                            Material(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.transparent,
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 3),
                                  child: customText(
                                    'ViewCy',
                                    style: const TextStyle(
                                        // color: Colors.black45,
                                        fontSize: 35,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ),
                            Column(
                              children: [
                                Container(
                                  width: Get.height * 0.5,
                                  child: Material(
                                    elevation: 20,
                                    borderRadius: BorderRadius.circular(100),
                                    child: SizedBox(
                                      width: context.responsiveValue(
                                          mobile: Get.height * 0.5,
                                          tablet: Get.height * 0.5,
                                          desktop: Get.height * 0.5),
                                      child: CupertinoSearchTextField(
                                        suffixIcon:
                                            Icon(CupertinoIcons.mic_fill),
                                        onSubmitted: (data) {
                                          return keywordItem(data);
                                        },
                                        onSuffixTap: () =>
                                            _textEditingController.clear(),
                                        placeholder: 'Ai Search ',
                                        onChanged: (data) {
                                          return keywordItem(data);
                                        },
                                        controller: _textEditingController,
                                      ),
                                    ),
                                  ),
                                ),
                                productsSearchingText.value != '' &&
                                        listSearch.isEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      offset:
                                                          const Offset(0, 11),
                                                      blurRadius: 11,
                                                      color: Colors.black
                                                          .withOpacity(0.06))
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: CupertinoColors
                                                    .lightBackgroundGray),
                                            padding: const EdgeInsets.all(5.0),
                                            child: TitleText(
                                              '${productsSearchingText.value} products not availiable yet',
                                              color: CupertinoColors.systemRed,
                                            )),
                                      )
                                    : Container(),
                              ],
                            ),

                            SizedBox(
                              width: Get.height * 0.5,
                              height: keyWordState.length * 45.0,
                              child: searchingText == ''
                                  ? Container()
                                  : ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      itemCount: keyWordState
                                          .map((e) => e.keyword.toString())
                                          .toList()
                                          .length,
                                      itemBuilder: (context, index) {
                                        cprint(
                                            '${keyWordState.map((e) => e.keyword.toString()).toList()[index].indexOf(searchingText)} onlinedata');
                                        return GestureDetector(
                                          onTap: () {
                                            productsSearchingText.value =
                                                keyWordState
                                                    .map((e) =>
                                                        e.keyword.toString())
                                                    .toList()[index];
                                            itemProduct(
                                                index: keyWordState
                                                    .map((e) =>
                                                        e.keyword.toString())
                                                    .toList()
                                                    .indexOf(
                                                        productsSearchingText
                                                            .value),
                                                productsSearchingText.value);

                                            _textEditingController.text =
                                                productsSearchingText.value;
                                            _textEditingController.selection =
                                                TextSelection.fromPosition(
                                              TextPosition(
                                                offset: productsSearchingText
                                                    .value.length,
                                              ),
                                            );

                                            // setState(() {
                                            // });
                                            searchingText.value = '';
                                            FocusScope.of(context).unfocus();
                                          },
                                          child:
                                              keyWordState
                                                          .map((e) => e.keyword
                                                              .toString())
                                                          .toList()[index]
                                                          .indexOf(searchingText
                                                              .value) ==
                                                      -1
                                                  ? Container()
                                                  : Container(
                                                      height: 45.0,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: _getRichText(
                                                          keyWordState
                                                              .map((e) => e
                                                                  .keyword
                                                                  .toString())
                                                              .toList()[index]),
                                                      decoration:
                                                          ShapeDecoration(
                                                        color: CupertinoColors
                                                            .darkBackgroundGray,
                                                        shape:
                                                            CustomRoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                              index ==
                                                                      (keyWordState
                                                                              .map((e) => e.keyword.toString())
                                                                              .toList()
                                                                              .length -
                                                                          1)
                                                                  ? 10.0
                                                                  : 0.0,
                                                            ),
                                                            bottomRight:
                                                                Radius.circular(
                                                              index ==
                                                                      (keyWordState
                                                                              .map((e) => e.keyword.toString())
                                                                              .toList()
                                                                              .length -
                                                                          1)
                                                                  ? 10.0
                                                                  : 0.0,
                                                            ),
                                                          ),
                                                          leftSide: BorderSide(
                                                              color: const Color(
                                                                  0xFFFAFAFA)),
                                                          bottomLeftCornerSide:
                                                              BorderSide(
                                                                  color: const Color(
                                                                      0xFFFAFAFA)),
                                                          rightSide: BorderSide(
                                                              color: const Color(
                                                                  0xFFFAFAFA)),
                                                          bottomRightCornerSide:
                                                              BorderSide(
                                                                  color: const Color(
                                                                      0xFFFAFAFA)),
                                                          bottomSide: BorderSide(
                                                              color: const Color(
                                                                  0xFFFAFAFA)),
                                                        ),
                                                      ),
                                                    ),
                                        );
                                      },
                                    ),
                            ),
                            // Obx(
                            //   () => AdvancedSearch(
                            //       data: feedState.keywords
                            //           .map((e) => e.keyword.toString())
                            //           .toList(),
                            //       maxElementsToDisplay: 10,
                            //       onItemTap: (index, value) {

                            //         return itemProduct(index, value);
                            //       },
                            //       searchResultsBgColor: Colors.transparent,
                            //       onSearchClear: () {}),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 11),
                                blurRadius: 11,
                                color: Colors.black.withOpacity(0.06))
                          ],
                          borderRadius: BorderRadius.circular(100),
                          color: CupertinoColors.lightBackgroundGray),
                      padding: const EdgeInsets.all(5.0),
                      child: UserAvater(
                        userModel: currentUser!,
                        profileType: ProfileType.Store,
                      )),
                ),
                // Positioned(
                //   right: appSize.width * 0.2,
                //   top: appSize.width * 0.15,
                //   left: appSize.width * 0.01,
                //   child: Material(
                //     elevation: 1,
                //     borderRadius: BorderRadius.circular(100),
                //     child: frostedOrange(
                //       title != null ? title : _searchField(),
                //     ),
                //   ),
                // ),
                widget.isDesktop == true || widget.isTablet == true
                    ? Container()
                    : Positioned(
                        top: 20,
                        left: 10,
                        child: frostedOrange(
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.blueGrey[50],
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.yellow.withOpacity(0.1),
                                    Colors.white60.withOpacity(0.2),
                                    Colors.grey.withOpacity(0.3)
                                  ],
                                  // begin: Alignment.topCenter,
                                  // end: Alignment.bottomCenter,
                                )),
                            child: Row(
                              children: [
                                Material(
                                  elevation: 10,
                                  borderRadius: BorderRadius.circular(100),
                                  child: CircleAvatar(
                                    radius: 14,
                                    backgroundColor: Colors.transparent,
                                    child: Image.asset('assets/delicious.png'),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 3),
                                  child: customTitleText('ViewDucts'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                Positioned(
                  top: 10,
                  // left: appSize.width * 0.7,
                  right: widget.isDesktop == true
                      ? Get.width * 0.45
                      : widget.isTablet == true
                          ? Get.width * 0.52
                          : fullWidth(context) * 0.35,
                  child: Row(
                    children: const <Widget>[
                      AdminNotificationForUsers(),
                    ],
                  ),
                ),

                // adsBottom(context)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopSellers extends StatelessWidget {
  const _TopSellers({
    Key? key,
    this.user,
  }) : super(key: key);
  final ViewductsUser? user;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(10),
      color: Colors.orange[50],
      child: frostedBlueGray(
        Column(
          children: [
            ListTile(
              onTap: () {
                // kAnalytics.logViewSearchResults(searchTerm: user.userName);
                // Navigator.of(context).pushNamed('/ProfilePage/' + user?.userId);
              },
              leading: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(100),
                  child: customImage(context, user!.profilePic, height: 40)),
            ),
            ListTile(
              onTap: () {
                kAnalytics.logViewSearchResults(searchTerm: user!.userName!);
                Navigator.of(context)
                    .pushNamed('/ProfilePage/' + user!.userId!);
              },
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    child: TitleText(user!.displayName,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        overflow: TextOverflow.ellipsis),
                  ),
                  const SizedBox(width: 3),
                  user!.isVerified!
                      ? CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.transparent,
                          child: Image.asset('assets/shopping-bag.png'),
                        )
                      : const SizedBox(width: 0),
                ],
              ),
              subtitle: Text(user!.userName!),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnSale extends StatelessWidget {
  const _OnSale({
    Key? key,
    this.user,
  }) : super(key: key);
  final ViewductsUser? user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        kAnalytics.logViewSearchResults(searchTerm: user!.userName!);
        Navigator.of(context).pushNamed('/ProfilePage/' + user!.userId!);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
              elevation: 20,
              borderRadius: BorderRadius.circular(100),
              child: customImage(context, user!.profilePic, height: 40)),
          const SizedBox(
            height: 10,
          ),
          Flexible(
            child: TitleText(user!.displayName,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}

isFollower(BuildContext context) {
  // var authState = Provider.of<AuthState>(context, listen: false);
  // if (authState.profileUserModel!.viewersList != null &&
  //     authState.profileUserModel!.viewersList!.isNotEmpty) {
  //   return (authState.profileUserModel!.viewersList!
  //       .any((x) => x == authState.userModel!.userId));
  // } else
  {
    return false;
  }
}

class UserTile extends StatelessWidget {
  const UserTile({Key? key, this.user, this.id}) : super(key: key);
  final ViewductsUser? user;
  final String? id;
  Widget _vendorChecker(ViewductsUser? model, BuildContext context) {
    // var authState = Provider.of<AuthState>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        // height: authState.userId == user!.userId
        //     ? fullWidth(context) * 0
        //     : fullWidth(context) * 0.03,
        // width: authState.userId == user!.userId
        //     ? fullWidth(context) * 0
        //     : fullWidth(context) * 0.03,
        padding: const EdgeInsets.all(7.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: user!.lastSeen == true ? Colors.green : Colors.grey,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // var authState = Provider.of<AuthState>(context, listen: false);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        //color: Colors.blueGrey[50],
        // gradient: LinearGradient(
        //   colors: [
        //     Colors.white60.withOpacity(0.1),
        //     Colors.white60.withOpacity(0.2),
        //     Colors.orange.shade200.withOpacity(0.3)
        //   ],
        //   // begin: Alignment.topCenter,
        //   // end: Alignment.bottomCenter,
        // )
      ),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.only(
      //       topLeft: Radius.circular(20),
      //       topRight: Radius.circular(20),
      //       bottomRight: Radius.circular(0),
      //       bottomLeft: Radius.circular(20)),
      //),
      child: frostedWhite(
        ListTile(
          onTap: () {
            kAnalytics.logViewSearchResults(searchTerm: user!.userName!);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProfilePage(
                      profileId: user!.userId,
                      profileType: ProfileType.Store,
                    )));
            // Navigator.of(context)
            //     .pushNamed("/Stores/", arguments: UserTile(id: user.userId));
            //Navigator.of(context).pushNamed('/ProfilePage/' + user?.userId,);
          },
          leading: Stack(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.transparent,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.yellow.shade200,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.transparent,
                        child: Material(
                          elevation: 20,
                          borderRadius: BorderRadius.circular(100),
                          child: customImage(context, user!.profilePic,
                              height: fullHeight(context) * 0.06),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child: TitleText(user!.displayName,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(width: 3),
              user!.isVerified!
                  ? CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.transparent,
                      child: Image.asset('assets/shopping-bag.png'),
                    )
                  : const SizedBox(width: 0),
            ],
          ),
          subtitle: Text(user!.userName!),
          trailing: Column(
            children: const [
              // _vendorChecker(user, context),
              // authState.userId == user!.userId
              //     ? const SizedBox(
              //         height: 0,
              //         width: 0,
              //       )
              //     : RippleButton(
              //         splashColor: Colors.orange[50],
              //         borderRadius: const BorderRadius.all(Radius.circular(60)),
              //         onPressed: () {
              //           authState.followUser(user!.userId,
              //               removeFollower: isFollower(context));
              //         },
              //         child: Container(
              //           padding: const EdgeInsets.symmetric(
              //             horizontal: 10,
              //             vertical: 5,
              //           ),
              //           decoration: BoxDecoration(
              //             // color: isFollower(context) ||
              //             //         authState.userModel!.viewingList!
              //             //             .contains(user!.userId) ||
              //             //         authState.userModel!.viewersList!
              //             //             .contains(user!.userId)
              //             //     ? TwitterColor.ceriseRed
              //             //     : TwitterColor.white,
              //             // border: Border.all(
              //             //     color: Colors.black87.withAlpha(180), width: 1),
              //             // borderRadius: BorderRadius.circular(20),
              //           ),

              //           /// If [isMyProfile] is true then Edit profile button will display
              //           // Otherwise Follow/Following button will be display
              //           child: Text(
              //             isFollower(context) ||
              //                     authState.userModel!.viewingList!
              //                         .contains(user!.userId) ||
              //                     authState.userModel!.viewersList!
              //                         .contains(user!.userId)
              //                 ? 'Viewing'
              //                 : 'View',
              //             style: TextStyle(
              //               color: isFollower(context) ||
              //                       authState.userModel!.viewingList!
              //                           .contains(user!.userId) ||
              //                       authState.userModel!.viewersList!
              //                           .contains(user!.userId)
              //                   ? TwitterColor.white
              //                   : Colors.blueGrey[500],
              //               fontSize: 17,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //         ),
              //       ),
            ],
          ),
        ),
      ),
    );
  }
}
