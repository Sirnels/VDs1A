// ignore_for_file: file_names, sized_box_for_whitespace, use_key_in_widget_constructors, prefer_typing_uninitialized_variables, deprecated_member_use, unused_local_variable, unused_element, invalid_use_of_protected_member, must_be_immutable, division_optimization

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
//import 'package:emoji_picker/emoji_picker.dart';
import 'package:animations/animations.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_paystack_payment/flutter_paystack_payment.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
//import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
//import 'package:share/share.dart';
import 'package:status_alert/status_alert.dart';
import 'package:video_player/video_player.dart';
import 'package:viewducts/common/common.dart';
import 'package:viewducts/features/auth/controller/auth_controller.dart';
import 'package:viewducts/features/business_store/business_store_controller.dart';
import 'package:viewducts/features/products/product_controller.dart';
import 'package:viewducts/helper/constant.dart';
import 'package:viewducts/helper/enum.dart';
import 'package:viewducts/helper/theme.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/page/message/item_Search_bar.dart';
import 'package:viewducts/page/product/editproduct.dart';
import 'package:viewducts/page/product/shopingCart.dart';
import 'package:viewducts/page/responsiveView.dart';
// import 'package:viewducts/state/authState.dart';
// import 'package:viewducts/state/feedState.dart';
// import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/duct/duct.dart';
import 'package:viewducts/widgets/duct/widgets/ductBottomSheet.dart';
import 'package:viewducts/widgets/duct/widgets/ductImage.dart';
import 'package:viewducts/widgets/newWidget/customUrlText.dart';
import 'package:viewducts/widgets/newWidget/rippleButton.dart';
import 'package:viewducts/widgets/newWidget/title_text.dart';
import 'package:viewducts/widgets/rating_star.dart';
import '../../customWidgets.dart';
import '../../frosted.dart';

class PostAsymmetricView extends HookWidget {
  final Widget? trailing;
  final DuctType? type;
  final bool isSearchPage;
  final bool isWelcomePage;
  final String? product;
  final String? section;
  final String? category;
  final String? location;
  List<FeedModel>? model;
  String? state;
  bool? isAllserch;
  String? lastId;
  String? searchWords;
  PostAsymmetricView(
      {Key? key,
      this.product,
      this.section,
      this.category,
      this.location,
      this.isAllserch,
      this.state,
      this.lastId,
      this.searchWords,
      this.model,
      this.trailing,
      this.type,
      this.isWelcomePage = false,
      this.isSearchPage = false})
      : super(key: key);

  List<Container> _buildColumns(BuildContext context) {
    if (model == null || model!.isEmpty) {
      return const <Container>[];
    }

    // This will return a list of columns. It will oscillate between the two
    // kinds of columns. Even cases of the index (0, 2, 4, etc) will be
    // TwoProductCardColumn and the odd cases will be OneProductCardColumn.
    //
    // Each pair of columns will advance us 3 model forward (2 + 1). That's
    // some kinda awkward math so we use _evenCasesIndex and _oddCasesIndex as
    // helpers for creating the index of the model list that will correspond
    // to the index of the list of columns.
    return List<Container>.generate(_listItemCount(model!.length), (int index) {
      double width = context.responsiveValue(
          mobile: Get.height * 0.3,
          tablet: Get.height * 0.3,
          desktop: Get.height * 0.3);
      Widget column;
      if (index % 2 == 0) {
        /// Even cases
        final int bottom = _evenCasesIndex(index);
        column = TwoProductCardColumn(
          isWelcomePage: isWelcomePage,
          bottom: model![bottom],
          top: model!.length - 1 >= bottom + 1 ? model![bottom + 1] : null,
        );
        width += 32.0;
      } else {
        /// Odd cases
        column = OneProductCardColumn(
          isWelcomePage: isWelcomePage,
          model: model![_oddCasesIndex(index)],
        );
      }
      return Container(
        width: width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: column,
        ),
      );
    }).toList();
  }

  int _evenCasesIndex(int input) {
    // The operator ~/ is a cool one. It's the truncating division operator. It
    // divides the number and if there's a remainder / decimal, it cuts it off.
    // This is like dividing and then casting the result to int. Also, it's
    // functionally equivalent to floor() in this case.
    return input ~/ 2 * 3;
  }

  int _oddCasesIndex(int input) {
    assert(input > 0);
    return (input / 2).ceil() * 3 - 1;
  }

  int _listItemCount(int totalItems) {
    return (totalItems % 3 == 0)
        ? totalItems ~/ 3 * 2
        : (totalItems / 3).ceil() * 2 - 1;
  }

  final _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    // final sec = useState(section);
    // final cate = useState(category);
    // final loca = useState(location);
    // final stat = useState(state);
    // final productState = useState(feedState.productlist);
    // final stateSetState = useState(feedState.state);
    // final input = useState(''.obs);
    // final database = Databases(
    //   clientConnect(),
    // );
    // final realtime = Realtime(clientConnect());
    // final productStream = useStream(realtime.subscribe(
    //     ["databases.$databaseId.collections.$procold.documents"]).stream);
    // getData({String? pageIndex}) async {
    //   try {
    //     final database = Databases(
    //       clientConnect(),
    //     );

    //     if (isAllserch == true) {
    //       if (pageIndex == 'top') {
    //         await database.listDocuments(
    //             databaseId: databaseId,
    //             collectionId: procold,
    //             queries: [
    //               Query.orderDesc('createdAt'),
    //               Query.limit(10),
    //               Query.cursorAfter(lastId.toString()),
    //               Query.search('keyword', searchWords.toString())
    //             ]).then((data) {
    //           model = data.documents
    //               .map((e) => FeedModel.fromJson(e.data))
    //               .toList();
    //           lastId = data.documents.last.$id;
    //         });
    //       } else if (pageIndex == 'bottom') {
    //         await database.listDocuments(
    //             databaseId: databaseId,
    //             collectionId: procold,
    //             queries: [
    //               Query.orderDesc('createdAt'),
    //               // Query.equal('activeState', 'active'),
    //               Query.limit(10),
    //               Query.search('keyword', searchWords.toString())

    //               // Query.equal('productLocation', loca.value),
    //             ]).then((data) {
    //           model = data.documents
    //               .map((e) => FeedModel.fromJson(e.data))
    //               .toList();
    //         });
    //       } else {}
    //     } else {
    //       if (pageIndex == 'top') {
    //         await database.listDocuments(
    //             databaseId: databaseId,
    //             collectionId: procold,
    //             queries: [
    //               Query.orderDesc('createdAt'),
    //               Query.limit(10),
    //               Query.cursorAfter(lastId.toString()),
    //               // Query.equal('productLocation', loca.value),
    //               Query.equal('productState', stat.value.toString()),
    //               Query.equal('section', sec.value.toString()),
    //               Query.equal('productCategory', cate.value.toString()),
    //               // Query.equal('activeState', 'active'),
    //             ]).then((data) {
    //           model = data.documents
    //               .map((e) => FeedModel.fromJson(e.data))
    //               .toList();
    //           lastId = data.documents.last.$id;
    //         });
    //       } else if (pageIndex == 'bottom') {
    //         await database.listDocuments(
    //             databaseId: databaseId,
    //             collectionId: procold,
    //             queries: [
    //               Query.orderDesc('createdAt'),
    //               //  Query.equal('activeState', 'active'),
    //               Query.limit(10),
    //               // Query.equal('productLocation', loca.value),
    //             ]).then((data) {
    //           model = data.documents
    //               .map((e) => FeedModel.fromJson(e.data))
    //               .toList();
    //         });
    //       } else {}
    //     }
    //   } on AppwriteException catch (e) {
    //     cprint("$e");
    //   }
    // }

    // useEffect(
    //   () {
    //     getData();

    //     return () {
    //       sec.value == null;
    //       cate.value == null;
    //       loca.value == null;
    //       stat.value == null;
    //     };
    //   },
    //   [
    //     feedState.productlist,
    //     product,
    //     section,
    //     category,
    //     location,
    //     feedState.state
    //   ],
    // );

    return NotificationListener<ScrollEndNotification>(
      child: ListView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(0.0, 34.0, 16.0, 44.0),
        children: _buildColumns(context),
        physics: const AlwaysScrollableScrollPhysics(),
      ),
      onNotification: (notification) {
        // if (t is ScrollEndNotification) {
        //  cprint(_controller.position.pixels.toString());
        // cprint(_controller.position.minScrollExtent.toString());
        if (notification.metrics.atEdge) {
          if (notification.metrics.pixels == 0) {
            //  getData(pageIndex: 'top');
            cprint('At top');
            // cprint(lastId.toString());
          } else {
            //  getData(pageIndex: 'bottom');
            cprint('At bottom');
          }
        }
        // }
        //How many pixels scrolled from pervious frame
        // print(t!.scrollDelta);

        // //List scroll position
        // print(t.metrics.pixels);
        return true;
      },
    );
  }
}

class TwoProductCardColumn extends StatelessWidget {
  const TwoProductCardColumn({
    Key? key,
    required FeedModel this.bottom,
    this.top,
    this.trailing,
    this.type,
    this.isSearchPage = false,
    required this.isWelcomePage,
  });

  final FeedModel? bottom, top;
  final Widget? trailing;
  final DuctType? type;
  final bool isSearchPage;
  final bool isWelcomePage;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      const double spacerHeight = 44.0;

      final double heightOfCards =
          (constraints.biggest.height - spacerHeight) / 2.0;
      final double heightOfImages = heightOfCards - _ItemCard.kTextBoxHeight;
      final double imageAspectRatio =
          (heightOfImages >= 0.0 && constraints.biggest.width > heightOfImages)
              ? constraints.biggest.width / heightOfImages
              : 33 / 49;

      return ListView(
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 28.0),
            child: top != null
                ? _ItemCard(
                    isWelcomePage: isWelcomePage,
                    imageAspectRatio: imageAspectRatio,
                    ductProduct: top,
                  )
                : SizedBox(
                    height: heightOfCards > 0 ? heightOfCards : spacerHeight,
                  ),
          ),
          const SizedBox(height: spacerHeight),
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 28.0),
            child: _ItemCard(
              isWelcomePage: isWelcomePage,
              imageAspectRatio: imageAspectRatio,
              ductProduct: bottom,
            ),
          ),
          SizedBox(
            height: fullWidth(context) * 0.4,
          )
        ],
      );
    });
  }
}

class OneProductCardColumn extends StatelessWidget {
  const OneProductCardColumn(
      {this.model,
      this.trailing,
      this.type,
      this.isSearchPage = false,
      required this.isWelcomePage});

  final FeedModel? model;
  final Widget? trailing;
  final DuctType? type;
  final bool isSearchPage;
  final bool isWelcomePage;
  @override
  Widget build(BuildContext context) {
    return ListView(
      //reverse: true,
      children: <Widget>[
        const SizedBox(
          height: 40.0,
        ),
        _ItemCard(
          isWelcomePage: isWelcomePage,
          ductProduct: model,
          isSearchPage: isSearchPage,
        ),
      ],
    );
  }
}

class NormalView extends HookWidget {
  const NormalView({
    Key? key,
    this.model,
    this.trailing,
    this.type,
    this.isSearchPage,
    this.item,
    required this.isWelcomePage,
  }) : super(key: key);
  final List<FeedModel>? item;
  final FeedModel? model;
  final Widget? trailing;
  final DuctType? type;
  final bool? isSearchPage;
  final bool isWelcomePage;

//   @override
//   _NormalViewState createState() => _NormalViewState();
// }

// class _NormalViewState extends State<NormalView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: fullWidth(context) * 0.5,
      height: fullHeight(context) * 0.8,
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        const double spacerHeight = 44.0;

        final double heightOfCards =
            (constraints.biggest.height - spacerHeight) / 2.0;
        final double heightOfImages = heightOfCards - _ItemCard.kTextBoxHeight;
        final double imageAspectRatio = (heightOfImages >= 0.0 &&
                constraints.biggest.width > heightOfImages)
            ? constraints.biggest.width / heightOfImages
            : 33 / 49;

        return ListView(
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            // Padding(
            //   padding: const EdgeInsetsDirectional.only(start: 28.0),
            //   child: top != null
            //       ? _ItemCard(
            //           imageAspectRatio: imageAspectRatio,
            //           ductProduct: top,
            //         )
            //       : SizedBox(
            //           height: heightOfCards > 0 ? heightOfCards : spacerHeight,
            //         ),
            // ),
            // const SizedBox(height: spacerHeight),
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 55.0),
              child: _ItemCard(
                isWelcomePage: isWelcomePage,
                imageAspectRatio: imageAspectRatio,
                ductProduct: model,
              ),
            ),
          ],
        );
      }),
    );
    // Column(
    //   children: [
    //     // Container(
    //     //   width: fullWidth(context) * 0.2,
    //     //   height: fullWidth(context) * 0.2,
    //     //   child: _imageFeed(widget.model?.imagePath),
    //     // ),
    //     _ItemCard(
    //       ductProduct: widget.model,
    //       isSearchPage: widget.isSearchPage,
    //     ),
    //   ],
    // );
  }
}

class _ItemCard extends ConsumerStatefulWidget {
  _ItemCard(
      {this.imageAspectRatio = 33 / 49,
      this.ductProduct,
      this.type,
      this.profileId,
      this.isSearchPage,
      required this.isWelcomePage})
      : assert(imageAspectRatio > 0);
  final DuctType? type;
  final double imageAspectRatio;
  final String? profileId;
  final bool isWelcomePage;
  // final Products products;
  final FeedModel? ductProduct;
  final bool? isSearchPage;
  static const double kTextBoxHeight = 65.0;

  @override
  ConsumerState<_ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends ConsumerState<_ItemCard> {
  ValueNotifier<bool> imageNotready = ValueNotifier(false);

  var isDropdown = false.obs;

  double? height, width, xPosiion, yPosition;

  late OverlayEntry floatingMenu;

  Color? iconColor;

  Color? iconEnableColor;

  double? size;

  bool isDuctDetail = false;

  String? ductId;

  String? senderId;

  String? userImage;

  bool? isContinuing;

  FocusNode textFieldFocus = FocusNode();

  FocusNode imageTextFieldFocus = FocusNode();

  //ChatState state = ChatState();
  ValueNotifier<bool> isSelected = ValueNotifier(false);

  String? chatUserProductId, myOrders;

  String? peerAvatar, peerNo, currentUserNo, privateKey, sharedSecret;

  bool locked = false;

  bool hidden = false;

  int? chatStatus, unread;

  GlobalKey? actionKey;

  dynamic lastSeen;

  String? chatId;

  bool isWriting = false;

  var showEmojiPicker = false.obs;

  File? imageFile;

  bool isLoading = false;

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
  bool isToolAvailable = true;

  bool isMyProfile = false;

  final GlobalKey<State> keyLoader = GlobalKey<State>();

  // List<dynamic> size;
  // FeedState? productState;
  // var authState = Provider.of<AuthState>(context);
  // var state = Provider.of<FeedState>(context);
  // String? id = widget.profileId ?? authState.userId;
  // late List<FeedModel> list;
  InitPaymentModel? userPayment;
  //  double? _stockNumber = 0.0;
  final plugin = PaystackPayment();
  String backendUrl = 'https://api.paystack.co';
  var publicKey = '';
  //userCartController.wasabiAws.value.payStackPublickey;

  _submitButton({String? ref}) async {
    var product = widget.ductProduct;
    product!.reference = ref;
    product.activeState = 'Aproved';
    product.paymentDate = DateTime.now().toUtc().toString();
    // await feedState.updateProDuctItems(product, key: product.key);
  }

  _showMessage(String message,
      [Duration duration = const Duration(seconds: 4)]) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: duration,
      action: SnackBarAction(
          label: 'CLOSE',
          onPressed: () =>
              ScaffoldMessenger.of(context).removeCurrentSnackBar()),
    ));
  }

  _updateStatus(String reference, String message) {
    _showMessage('Reference: $reference \n Response: $message',
        const Duration(seconds: 7));
  }

  _verifyOnServer(String reference) async {
    _updateStatus(reference, 'Verifying...');
    String url = '$backendUrl/verify/$reference';
    try {
      http.Response response = await http.get(Uri.parse(url));
      var body = response.body;
      _updateStatus(reference, body);
    } catch (e) {
      _updateStatus(
          reference,
          'There was a problem verifying %s on the backend: '
          '$reference $e');
    }
    // setState(() => _inProgress = false);
  }

  _clear({String? ref}) async {
    // var auth = Provider.of<AuthState>(context, listen: false);
    //setState(() => _inProgress = true);

    await _submitButton(ref: ref.toString()).then((value) async {
      await EasyLoading.dismiss();
      //  chatState.boughtItemMessageNotification(sellersInfo.value);
      StatusAlert.show(Get.context!,
          duration: const Duration(seconds: 2),
          // backgroundColor: Colors.red,
          title: 'Payment Sucessful',
          // subtitle: "${product.productName} already added to your cart",
          configuration: const IconConfiguration(icon: Icons.done));
    }).then((value) => Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
          //   _sucessPaymentAlertBox(context);
        }));
  }

  _chargeCard(Charge charge) async {
    //  final response = await plugin.chargeCard(context, charge: charge);
    CheckoutResponse response = await plugin.checkout(
      context,
      method: CheckoutMethod.card, // Defaults to CheckoutMethod.selectable
      charge: charge,
      logo: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(10),
        child: frostedOrange(
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blueGrey[50],
                gradient: LinearGradient(
                  colors: [
                    Colors.yellow.withOpacity(0.1),
                    Colors.white60.withOpacity(0.2),
                    Colors.orange.withOpacity(0.3)
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
                  child: customTitleText('ViewDucts'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    final reference = response.reference;

    // Checking if the transaction is successful
    if (response.status) {
      //  EasyLoading.show(status: 'Viewducting');
      await _verifyOnServer(reference.toString());
      // await feedState.addNewCard(authState.userId,
      //     userPayment?.totalPrice.toString(), reference.toString(),
      //     authorizationCode: '');
      return _clear(ref: reference.toString());
    }

    // The transaction failed. Checking if we should verify the transaction
    if (response.verify) {
      //  EasyLoading.show(status: 'Viewducting');
      await _verifyOnServer(reference.toString());
      // await feedState.addNewCard(authState.userId,
      //     userPayment?.totalPrice.toString(), reference.toString(),
      //     authorizationCode: '');
      _clear(ref: reference.toString());
    } else {
      // setState(() => _inProgress = false);
      EasyLoading.dismiss();
      _updateStatus(reference.toString(), response.message);
    }
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<String?> _fetchAccessCodeFrmServer(String reference) async {
    String? access = userPayment?.initData.toString();

    cprint(access);
    String url = '$backendUrl/$access';
    String? accessCode;
    try {
      if (kDebugMode) {
        print("Access code url = $url");
      }
      // http.Response response = await http.get(url);
      accessCode = access;
      if (kDebugMode) {
        print('Response for access code = $accessCode');
      }
    } catch (e) {
      _updateStatus(
          reference,
          'There was a problem getting a new access code form'
          ' the backend: $e');
    }

    return accessCode;
  }

  _startAfreshCharge() async {
    // int amt = await int.tryParse(userPayment?.totalPrice.toString() ?? '0') ?? 0;
    // Charge charge = Charge();
    Charge charge = Charge()
      ..amount = int.tryParse(userPayment!.totalPrice!.toString())! * 100
      ..reference = _getReference()
      ..accessCode = await _fetchAccessCodeFrmServer(_getReference())
      // or ..accessCode = _getAccessCodeFrmInitialization()
      ..email = " authState.userModel?.email";

    // charge.card = _getCardFromUI();
    // charge.accessCode = await _fetchAccessCodeFrmServer(_getReference());
    _chargeCard(charge);
  }

  // if (feedState.feedlist != null && feedState.feedlist!.isNotEmpty) {
  //   list = feedState.feedlist!.where((x) => x.userId == id).toList();
  // }

  Future<bool?> _showDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Obx(
          () => Container(
            height: 10,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Color.fromARGB(255, 236, 179, 21),
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: frostedYellow(
                    Container(
                      height: Get.height * 0.3,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 11),
                                blurRadius: 11,
                                color: Colors.black.withOpacity(0.06))
                          ],
                          borderRadius: BorderRadius.circular(5),
                          color: CupertinoColors.lightBackgroundGray),
                      padding: const EdgeInsets.all(5.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              offset: const Offset(0, 11),
                                              blurRadius: 11,
                                              color: Colors.black
                                                  .withOpacity(0.06))
                                        ],
                                        borderRadius: BorderRadius.circular(18),
                                        color: CupertinoColors.systemYellow),
                                    padding: const EdgeInsets.all(5.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        // Navigator.maybePop(context);
                                      },
                                      child: Text(
                                        '',
                                        //   'USD ${userCartController.subscriptionModel.firstWhere((data) => data.subType == 'product', orElse: () => SubscriptionViewDuctsModel()).price ?? ''}/year',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w200),
                                      ),
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              offset: const Offset(0, 11),
                                              blurRadius: 11,
                                              color: Colors.black
                                                  .withOpacity(0.06))
                                        ],
                                        borderRadius: BorderRadius.circular(5),
                                        color:
                                            //  userCartController
                                            //             .venDor.value.active ==
                                            //         false
                                            //     ? CupertinoColors.systemRed
                                            //     :
                                            CupertinoColors.white),
                                    padding: const EdgeInsets.all(5.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        // Navigator.maybePop(context);
                                      },
                                      child: Text(
                                        'this Product yearly Subscription has expire',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w200),
                                      ),
                                    )),
                              ),
                              // authState.appPlayStore
                              //         .where((data) => data.operatingSystem == 'IOS')
                              //         .isNotEmpty
                              //     ?

                              //: Container(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.maybePop(context);
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                    offset: const Offset(0, 11),
                                                    blurRadius: 11,
                                                    color: Colors.black
                                                        .withOpacity(0.06))
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              color:
                                                  CupertinoColors.inactiveGray),
                                          padding: const EdgeInsets.all(5.0),
                                          child: Row(
                                            children: [
                                              Icon(CupertinoIcons.back),
                                              const Text(
                                                'Cancel',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w200),
                                              )
                                            ],
                                          )),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      try {
                                        await Navigator.maybePop(context);
                                        _startAfreshCharge();
                                        // Get.to(
                                        //     () =>
                                        //         SellersSignUpPageResponsiveView(
                                        //             loginCallback: authState
                                        //                 .getCurrentUser),
                                        //     transition: Transition.downToUp);
                                      } on AppwriteException catch (e) {
                                        cprint('$e Subscribe');
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                    offset: const Offset(0, 11),
                                                    blurRadius: 11,
                                                    color: Colors.black
                                                        .withOpacity(0.06))
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              color:
                                                  CupertinoColors.systemGreen),
                                          padding: const EdgeInsets.all(5.0),
                                          child: Row(
                                            children: [
                                              const Text(
                                                'Subscribe',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w200),
                                              ),
                                              Icon(CupertinoIcons.forward),
                                            ],
                                          )),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  var ratingValue = 0;
  var finalRatingValue = 0;
  buildDynamicLinks(String title, String image, String docId,
      String description, bool short) async {
    String url = "https://viewducts.page.link/products";
    String name = "?id=$docId";
    FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: url,
      link: Uri.parse('$url$name'),
      longDynamicLink: Uri.parse('$url$name'),
      androidParameters: AndroidParameters(
          packageName: "com.viewducts.viewducts",
          minimumVersion: 1,
          fallbackUrl: Uri.parse('$url$name')),
      // iosParameters: IOSParameters(
      //   bundleId: "Bundle-ID",
      //   minimumVersion: '0',
      // ),
      socialMetaTagParameters: SocialMetaTagParameters(
          description: '$description',
          imageUrl: Uri.parse("$image"),
          title: title),
    );
    // final ShortDynamicLink shortLink =
    //     await dynamicLinks.buildShortLink(parameters);
    Uri urls;
    // final ShortDynamicLink dynamicUrl =
    //     await dynamicLinks.buildShortLink(parameters);

    // String? desc = '${dynamicUrl.shortUrl.toString()}';

    if (short) {
      final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(
        parameters,
        shortLinkType: ShortDynamicLinkType.unguessable,
      );

      urls = dynamicLink.shortUrl;
    } else {
      urls = await dynamicLinks.buildLink(
        parameters,
      );
    }
    // await Share.share(
    //   urls.toString(),
    //   subject: title,
    // );
  }

  Widget _timeWidget(BuildContext context, ViewductsUser? currentUser) {
    final productReviewModelComment = ref
        .watch(
            getProductReviewCommentProvider(widget.ductProduct!.key.toString()))
        .value;
    // final productRating = ref.watch(getProductRatingProvider(RatingModel(
    //     productReveiwLength: productReviewModelComment?.length ?? 0,
    //     ratingValue: int.parse(productReviewModelComment!
    //         .map((data) => data.rating)
    //         .reduce((value, element) => value! + element!)
    //         .toString()))));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        // Row(
        //   children: <Widget>[
        //     SizedBox(width: 5),
        //     customText(getPostTime2(widget.ductProduct!.createdAt),
        //         style: textStyle14),
        //     SizedBox(width: 10),
        //   ],
        // ),
        const Divider(),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              customText(
                ' ${widget.ductProduct!.productName}',
                style: TextStyle(
                    color: CupertinoColors.white,
                    //Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: Get.height * 0.7,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    offset: const Offset(0, 11),
                                    blurRadius: 11,
                                    color: Colors.black.withOpacity(0.06))
                              ],
                              borderRadius: BorderRadius.circular(5),
                              color: CupertinoColors.lightBackgroundGray),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              offset: const Offset(0, 11),
                                              blurRadius: 11,
                                              color: Colors.black
                                                  .withOpacity(0.06))
                                        ],
                                        borderRadius: BorderRadius.circular(5),
                                        color:
                                            CupertinoColors.darkBackgroundGray),
                                    padding: const EdgeInsets.all(5.0),
                                    child: TitleText(
                                      '${widget.ductProduct?.productName} Reviews',
                                      color: CupertinoColors.systemYellow,
                                    )),
                              ),
                              ref
                                  .watch(getProductReviewCommentProvider(
                                      widget.ductProduct!.key.toString()))
                                  .when(
                                      data: (productReviewModelComment) {
                                        return productReviewModelComment.isEmpty
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    height: 150,
                                                  ),
                                                  Align(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                              offset:
                                                                  const Offset(
                                                                      0, 11),
                                                              blurRadius: 11,
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.06))
                                                        ],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(18),
                                                      ),
                                                      child: BubbleSpecialThree(
                                                          isSender: false,
                                                          tail: true,
                                                          color: CupertinoColors
                                                              .systemOrange,
                                                          text:
                                                              'No reviews yet for this product at the moment'),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Expanded(
                                                child: ListView(
                                                  children:
                                                      productReviewModelComment
                                                          .where((item) =>
                                                              item.productId ==
                                                              widget
                                                                  .ductProduct!
                                                                  .key)
                                                          .map((data) => Row(
                                                                crossAxisAlignment: currentUser?.userId ==
                                                                        data
                                                                            .userId
                                                                    ? CrossAxisAlignment
                                                                        .end
                                                                    : CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment: currentUser?.userId ==
                                                                        data
                                                                            .userId
                                                                    ? MainAxisAlignment
                                                                        .end
                                                                    : MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      currentUser?.userId ==
                                                                              data.userId
                                                                          ? Container()
                                                                          : Padding(
                                                                              padding: const EdgeInsets.all(5.0),
                                                                              child: TitleText(
                                                                                data.senderName,
                                                                                color: CupertinoColors.darkBackgroundGray,
                                                                              ),
                                                                            ),
                                                                      Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                                offset: const Offset(0, 11),
                                                                                blurRadius: 11,
                                                                                color: Colors.black.withOpacity(0.06))
                                                                          ],
                                                                          borderRadius:
                                                                              BorderRadius.circular(18),
                                                                        ),
                                                                        child:
                                                                            BubbleSpecialThree(
                                                                          isSender: currentUser?.userId == data.userId
                                                                              ? true
                                                                              : false,
                                                                          tail:
                                                                              true,
                                                                          color: currentUser?.userId == data.userId
                                                                              ? CupertinoColors.lightBackgroundGray
                                                                              : CupertinoColors.systemYellow,
                                                                          text: data
                                                                              .reviewComment
                                                                              .toString(),
                                                                        ),
                                                                      ),
                                                                      SingleChildScrollView(
                                                                        scrollDirection:
                                                                            Axis.horizontal,
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            RatingStatWidget(
                                                                              rating: data.rating!,
                                                                            ),
                                                                            Text(keysOfRating[data.rating! -
                                                                                1]),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ))
                                                          .toList(),
                                                ),
                                              );
                                      },
                                      error: (error, stackTrace) => ErrorText(
                                            error: error.toString(),
                                          ),
                                      loading: () => const LoaderAll()),
                            ],
                          ),
                          // child: Padding(
                          //   padding: const EdgeInsets.all(5.0),
                          //   child: Container(
                          //       decoration: BoxDecoration(
                          //           boxShadow: [
                          //             BoxShadow(
                          //                 offset:
                          //                     const Offset(0, 11),
                          //                 blurRadius: 11,
                          //                 color: Colors.black
                          //                     .withOpacity(0.06))
                          //           ],
                          //           borderRadius:
                          //               BorderRadius.circular(5),
                          //           color: CupertinoColors
                          //               .systemYellow),
                          //       padding: const EdgeInsets.all(5.0),
                          //       child: TitleText(
                          //         'This is the commission you get after buying the product and ducting it to your friends and family in ViewDucts',
                          //         color: CupertinoColors
                          //             .darkBackgroundGray,
                          //       )),
                          // ),
                        );
                      },
                    );
                  },
                  icon: Icon(CupertinoIcons.chat_bubble_fill)),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: Get.height * 0.7,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0, 11),
                                  blurRadius: 11,
                                  color: Colors.black.withOpacity(0.06))
                            ],
                            borderRadius: BorderRadius.circular(5),
                            color: CupertinoColors.lightBackgroundGray),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            offset: const Offset(0, 11),
                                            blurRadius: 11,
                                            color:
                                                Colors.black.withOpacity(0.06))
                                      ],
                                      borderRadius: BorderRadius.circular(5),
                                      color:
                                          CupertinoColors.darkBackgroundGray),
                                  padding: const EdgeInsets.all(5.0),
                                  child: TitleText(
                                    '${widget.ductProduct?.productName} Reviews',
                                    color: CupertinoColors.systemYellow,
                                  )),
                            ),
                            ref
                                .watch(getProductReviewCommentProvider(
                                    widget.ductProduct!.key.toString()))
                                .when(
                                    data: (productReviewModelComment) {
                                      return productReviewModelComment.isEmpty
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 150,
                                                ),
                                                Align(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                            offset:
                                                                const Offset(
                                                                    0, 11),
                                                            blurRadius: 11,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.06))
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18),
                                                    ),
                                                    child: BubbleSpecialThree(
                                                        isSender: false,
                                                        tail: true,
                                                        color: CupertinoColors
                                                            .systemOrange,
                                                        text:
                                                            'No reviews yet for this product at the moment'),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Expanded(
                                              child: ListView(
                                                children:
                                                    productReviewModelComment
                                                        .where((item) =>
                                                            item.productId ==
                                                            widget.ductProduct!
                                                                .key)
                                                        .map((data) => Row(
                                                              crossAxisAlignment: currentUser
                                                                          ?.userId ==
                                                                      data
                                                                          .userId
                                                                  ? CrossAxisAlignment
                                                                      .end
                                                                  : CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment: currentUser
                                                                          ?.userId ==
                                                                      data
                                                                          .userId
                                                                  ? MainAxisAlignment
                                                                      .end
                                                                  : MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    currentUser?.userId ==
                                                                            data.userId
                                                                        ? Container()
                                                                        : Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(5.0),
                                                                            child:
                                                                                TitleText(
                                                                              data.senderName,
                                                                              color: CupertinoColors.darkBackgroundGray,
                                                                            ),
                                                                          ),
                                                                    Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                              offset: const Offset(0, 11),
                                                                              blurRadius: 11,
                                                                              color: Colors.black.withOpacity(0.06))
                                                                        ],
                                                                        borderRadius:
                                                                            BorderRadius.circular(18),
                                                                      ),
                                                                      child:
                                                                          BubbleSpecialThree(
                                                                        isSender: currentUser?.userId ==
                                                                                data.userId
                                                                            ? true
                                                                            : false,
                                                                        tail:
                                                                            true,
                                                                        color: currentUser?.userId ==
                                                                                data.userId
                                                                            ? CupertinoColors.lightBackgroundGray
                                                                            : CupertinoColors.systemYellow,
                                                                        text: data
                                                                            .reviewComment
                                                                            .toString(),
                                                                      ),
                                                                    ),
                                                                    SingleChildScrollView(
                                                                      scrollDirection:
                                                                          Axis.horizontal,
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          RatingStatWidget(
                                                                            rating:
                                                                                data.rating!,
                                                                          ),
                                                                          Text(keysOfRating[data.rating! -
                                                                              1]),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ))
                                                        .toList(),
                                              ),
                                            );
                                    },
                                    error: (error, stackTrace) => ErrorText(
                                          error: error.toString(),
                                        ),
                                    loading: () => const LoaderAll()),
                          ],
                        ),
                        // child: Padding(
                        //   padding: const EdgeInsets.all(5.0),
                        //   child: Container(
                        //       decoration: BoxDecoration(
                        //           boxShadow: [
                        //             BoxShadow(
                        //                 offset:
                        //                     const Offset(0, 11),
                        //                 blurRadius: 11,
                        //                 color: Colors.black
                        //                     .withOpacity(0.06))
                        //           ],
                        //           borderRadius:
                        //               BorderRadius.circular(5),
                        //           color: CupertinoColors
                        //               .systemYellow),
                        //       padding: const EdgeInsets.all(5.0),
                        //       child: TitleText(
                        //         'This is the commission you get after buying the product and ducting it to your friends and family in ViewDucts',
                        //         color: CupertinoColors
                        //             .darkBackgroundGray,
                        //       )),
                        // ),
                      );
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 2),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 3),
                    decoration: BoxDecoration(
                        color: CupertinoColors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text('Reviews'),
                  ),
                ),
              ),
              // RatingStatWidget(
              //   rating: 3,
              // ),
              // ref
              //     .watch(getProductRatingProvider(RatingModel(
              //         productReveiwLength:
              //             productReviewModelComment?.length ?? 0,
              //         ratingValue: 0
              //         //  int.parse(productReviewModelComment
              //         //         ?.map((data) => data.rating)
              //         //         //  .reduce((value, element) => value ?? 0 + element!)
              //         //         .toString() ??
              //         //     '0')

              //         )))
              //     .when(
              //         data: (rating) {
              //           return RatingStatWidget(
              //             rating: rating,
              //           );
              //         },
              //         error: (error, stackTrace) => ErrorText(
              //               error: error.toString(),
              //             ),
              //         loading: () => const LoaderAll()),
              Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(0, 11),
                          blurRadius: 11,
                          color: Colors.black.withOpacity(0.06))
                    ],
                    borderRadius: BorderRadius.circular(5),
                    color: CupertinoColors.lightBackgroundGray),
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: TitleText(
                  '${productReviewModelComment?.length ?? 0}',
                  color: CupertinoColors.darkBackgroundGray,
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // customText(' Brand',
              //     style: TextStyle(
              //         fontWeight: FontWeight.bold,
              //         color: Theme.of(context).primaryColor,
              //         fontSize: 16)),
              widget.ductProduct?.stockQuantity == 0
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 3),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10)),
                      child: customTitleText('Out of Stock'),
                    )
                  : widget.ductProduct?.salePrice == 0 ||
                          widget.ductProduct?.salePrice == null
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 3),
                          decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(10)),
                          child: customText(
                              NumberFormat.currency(
                                      name:
                                          widget.ductProduct?.productLocation ==
                                                  'Nigeria'
                                              ? '₦'
                                              : '£')
                                  .format(double.parse(
                                      widget.ductProduct!.price.toString())),
                              //'N ${widget.ductProduct!.price}',
                              style: TextStyle(
                                color: Colors.yellow,
                                fontWeight: FontWeight.bold,
                                fontSize: context.responsiveValue(
                                    mobile: Get.height * 0.03,
                                    tablet: Get.height * 0.03,
                                    desktop: Get.height * 0.03),
                              )),
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 3),
                          decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(10)),
                          child: customText(
                              NumberFormat.currency(
                                      name:
                                          widget.ductProduct?.productLocation ==
                                                  'Nigeria'
                                              ? '₦'
                                              : '£')
                                  .format(double.parse(widget
                                      .ductProduct!.salePrice
                                      .toString())),
                              //'N ${widget.ductProduct!.price}',
                              style: TextStyle(
                                color: CupertinoColors.systemRed,
                                fontWeight: FontWeight.bold,
                                fontSize: context.responsiveValue(
                                    mobile: Get.height * 0.03,
                                    tablet: Get.height * 0.03,
                                    desktop: Get.height * 0.03),
                              )),
                        ),
            ],
          ),
        ),
        widget.ductProduct?.stockQuantity == 0
            ? Container()
            : widget.ductProduct?.salePrice == 0 ||
                    widget.ductProduct?.salePrice == null
                ? Container()
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 3),
                      decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(10)),
                      child: customText(
                          NumberFormat.currency(
                                  name: widget.ductProduct?.productLocation ==
                                          'Nigeria'
                                      ? '₦'
                                      : '£')
                              .format(double.parse(
                                  widget.ductProduct!.price.toString())),

                          //'N ${widget.ductProduct!.price}',

                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: CupertinoColors.systemYellow,
                            fontWeight: FontWeight.bold,
                            fontSize: context.responsiveValue(
                                mobile: Get.height * 0.02,
                                tablet: Get.height * 0.02,
                                desktop: Get.height * 0.02),
                          )),
                    ),
                  ),
        Row(
          children: <Widget>[
            const Icon(Icons.place),
            Row(
              children: [
                customText(widget.ductProduct!.productState,
                    // ductProduct == null
                    //     ? ''
                    //     : formatter.format(ductProduct.price),
                    style: TextStyle(
                      color: Colors.blueGrey[800],
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    )),
                customText(', ${widget.ductProduct!.productLocation}',
                    // ductProduct == null
                    //     ? ''
                    //     : formatter.format(ductProduct.price),
                    style: TextStyle(
                      color: Colors.blueGrey[800],
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    )),
              ],
            ),
          ],
        ),

        Container(
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0, 11),
                    blurRadius: 11,
                    color: Colors.black.withOpacity(0.06))
              ],
              borderRadius: BorderRadius.circular(18),
              color: CupertinoColors.systemYellow),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(0, 11),
                              blurRadius: 11,
                              color: Colors.black.withOpacity(0.06))
                        ],
                        borderRadius: BorderRadius.circular(18),
                        color: CupertinoColors.darkBackgroundGray),
                    padding: const EdgeInsets.all(5.0),
                    child: Text('Brand:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: CupertinoColors.systemYellow))),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(widget.ductProduct!.brand.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = widget.isWelcomePage
        ? ViewductsUser()
        : ref.watch(currentUserDetailsProvider).value;
    final vendor = widget.isWelcomePage
        ? ViewductsUser()
        : ref.watch(userDetailsProvider(widget.ductProduct!.userId!)).value;
    final staff = widget.isWelcomePage
        ? [StaffUserModel()]
        : ref.watch(getStaffProvider(currentUser!.userId.toString())).value;

    // getData() async {
    //   try {
    //     plugin.initialize(publicKey: publicKey.toString());
    //     final database = Databases(
    //       clientConnect(),
    //     );
    //     await database
    //         .listDocuments(
    //       databaseId: databaseId,
    //       collectionId: exchangeRateColl,
    //     )
    //         .then((data) {
    //       userCartController.exchangeRate.value = data.documents
    //           .map((e) => ExchangeRateModel.fromJson(e.data))
    //           .toList();
    //     });
    //     await database
    //         .listDocuments(
    //       databaseId: databaseId,
    //       collectionId: subscrptionColl,
    //     )
    //         .then((data) {
    //       userCartController.subscriptionModel.value = data.documents
    //           .map((e) => SubscriptionViewDuctsModel.fromJson(e.data))
    //           .toList();
    //       cprint(
    //           '${userCartController.subscriptionModel.map((data) => data.price)} subscription');
    //     });
    //     await database
    //         .listDocuments(
    //       databaseId: databaseId,
    //       collectionId: oficialNameColl,
    //     )
    //         .then((data) {
    //       var value = data.documents
    //           .map((e) => OficialViewductsStoreNameModel.fromSnapshot(e.data))
    //           .toList();

    //       userCartController.storeNameViewductsOficial.value = value;
    //     });
    //     await database.listDocuments(
    //         databaseId: databaseId,
    //         collectionId: productReviews,
    //         queries: [
    //           Query.equal('productId', widget.ductProduct!.key.toString())
    //         ]).then((data) {
    //       var value = data.documents
    //           .map((e) => ProductReviewModel.fromSnapshot(e.data))
    //           .toList();

    //       userCartController.productReviewModelComment = value.obs;
    //       ratingValue.value = (int.parse(userCartController
    //           .productReviewModelComment
    //           .map((data) => data.rating)
    //           .reduce((value, element) => value! + element!)
    //           .toString()));
    //       finalRatingValue = (int.parse(ratingValue.value.toString()) /
    //               int.parse(userCartController.productReviewModelComment.length
    //                   .toString()))
    //           .toInt();
    //       cprint('${int.parse(ratingValue.value.toString())} ratings');
    //     });
    //   } on AppwriteException catch (e) {
    //     cprint("$e");
    //   }
    // }

    // useEffect(
    //   () {
    //     getData();

    //     return () {};
    //   },
    //   [feedState.productlist, feedState.state],
    // );

    return widget.isWelcomePage == true
        ? Container()
        : widget.ductProduct!.activeState != 'Aproved' &&
                currentUser?.userId != widget.ductProduct?.userId
            ? Container()
            : GestureDetector(
                onTap: () {},
                child: Container(
                  width: context.responsiveValue(
                      mobile: Get.height * 0.3,
                      tablet: Get.height * 0.25,
                      desktop: Get.height * 0.25),
                  child: Stack(
                    children: <Widget>[
                      Column(
                        children: [
                          currentUser?.userId ==
                                      widget.ductProduct?.userId.obs ||
                                  staff
                                          ?.firstWhere(
                                              (e) =>
                                                  e.id == currentUser?.userId,
                                              orElse: () => StaffUserModel())
                                          .role ==
                                      'admin' ||
                                  staff
                                          ?.firstWhere(
                                              (e) =>
                                                  e.id == currentUser?.userId,
                                              orElse: () => StaffUserModel())
                                          .role ==
                                      'Sales Agent' ||
                                  staff
                                          ?.firstWhere(
                                              (e) =>
                                                  e.id == currentUser?.userId,
                                              orElse: () => StaffUserModel())
                                          .role ==
                                      'General Manager'
                              ? Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () async {
                                          DateFormat("E")
                                                      .format(DateTime.now()) ==
                                                  'Sun'
                                              ? Container()
                                              : showModalBottomSheet(
                                                  backgroundColor: Colors.red,
                                                  // isDismissible: false,
                                                  // bounce: true,
                                                  context: context,
                                                  builder: (context) =>
                                                      OpenContainer(
                                                        closedBuilder:
                                                            (context, action) {
                                                          return EditProductPage(
                                                            product: widget
                                                                .ductProduct,
                                                          );
                                                        },
                                                        openBuilder:
                                                            (context, action) {
                                                          return EditProductPage(
                                                            product: widget
                                                                .ductProduct,
                                                          );
                                                        },
                                                      ));
                                        },
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
                                                    .systemOrange),
                                            padding: const EdgeInsets.all(5.0),
                                            child: TitleText('Edit Product >',
                                                color: CupertinoColors
                                                    .lightBackgroundGray)),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Container(
                                          height: 100,
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                    offset: const Offset(0, 11),
                                                    blurRadius: 11,
                                                    color: Colors.black
                                                        .withOpacity(0.06))
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: CupertinoColors
                                                  .lightBackgroundGray),
                                          padding: const EdgeInsets.all(10),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                          offset: const Offset(
                                                              0, 11),
                                                          blurRadius: 11,
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.06))
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: CupertinoColors
                                                        .systemYellow),
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: TitleText(
                                                  'This is the commission you get after buying the product and ducting it to your friends and family in ViewDucts',
                                                  color: CupertinoColors
                                                      .darkBackgroundGray,
                                                )),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              offset: const Offset(0, 11),
                                              blurRadius: 11,
                                              color: Colors.black
                                                  .withOpacity(0.06))
                                        ],
                                        borderRadius: BorderRadius.circular(5),
                                        color: CupertinoColors.inactiveGray),
                                    padding: const EdgeInsets.all(5.0),
                                    child: customTitleText('Duct Commission:',
                                        colors: CupertinoColors
                                            .lightBackgroundGray),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    NumberFormat.currency(
                                            name: widget.ductProduct
                                                        ?.productLocation ==
                                                    'Nigeria'
                                                ? '₦'
                                                : '£')
                                        .format(double.parse(
                                      widget.ductProduct!.commissionPrice
                                          .toString(),
                                    )),
                                    style: const TextStyle(
                                      color: Colors.cyan,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          frostedOrange(
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blueGrey[50],
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.yellow.withOpacity(0.1),
                                      Colors.white60.withOpacity(0.2),
                                      Colors.orange.withOpacity(0.3)
                                    ],
                                    // begin: Alignment.topCenter,
                                    // end: Alignment.bottomCenter,
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    frostedYellow(
                                      Container(
                                          // width: context.responsiveValue(
                                          //     mobile: Get.height * 0.25,
                                          //     tablet: Get.height * 0.25,
                                          //     desktop: Get.height * 0.25),
                                          height: context.responsiveValue(
                                              mobile: Get.height * 0.25,
                                              tablet: Get.height * 0.25,
                                              desktop: Get.height * 0.25),
                                          child: Stack(
                                            children: [
                                              ProductDuctImage(
                                                  model: widget.ductProduct,
                                                  type: widget.type,
                                                  currentUser: currentUser,
                                                  vendor: vendor),
                                              widget.ductProduct?.salePrice ==
                                                          0 ||
                                                      widget.ductProduct
                                                              ?.salePrice ==
                                                          null
                                                  ? Container()
                                                  : Positioned(
                                                      left: 0,
                                                      bottom: 0,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: Container(
                                                            decoration: BoxDecoration(
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      offset:
                                                                          const Offset(
                                                                              0,
                                                                              11),
                                                                      blurRadius:
                                                                          11,
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.06))
                                                                ],
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            18),
                                                                color: CupertinoColors
                                                                    .systemRed),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(5.0),
                                                            child: TitleText(
                                                              'On Sale',
                                                              color: CupertinoColors
                                                                  .lightBackgroundGray,
                                                            )),
                                                      ),
                                                    ),
                                              Positioned(
                                                left: 0,
                                                top: 5,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                                offset:
                                                                    const Offset(
                                                                        0, 11),
                                                                blurRadius: 11,
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.06))
                                                          ],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: CupertinoColors
                                                              .lightBackgroundGray),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: TitleText(
                                                        widget.ductProduct
                                                                ?.type ??
                                                            '',
                                                        color: CupertinoColors
                                                            .darkBackgroundGray,
                                                      )),
                                                ),
                                              ),
                                            ],
                                          )),
                                    ),
                                    _timeWidget(context, currentUser),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              currentUser?.userId ==
                                          widget.ductProduct?.userId ||
                                      staff
                                              ?.firstWhere(
                                                  (e) =>
                                                      e.id ==
                                                      currentUser?.userId,
                                                  orElse: () =>
                                                      StaffUserModel())
                                              .role ==
                                          'admin' ||
                                      staff
                                              ?.firstWhere(
                                                  (e) =>
                                                      e.id ==
                                                      currentUser?.userId,
                                                  orElse: () =>
                                                      StaffUserModel())
                                              .role ==
                                          'Sales Agent' ||
                                      staff
                                              ?.firstWhere(
                                                  (e) =>
                                                      e.id ==
                                                      currentUser?.userId,
                                                  orElse: () =>
                                                      StaffUserModel())
                                              .role ==
                                          'General Manager'
                                  ? widget.ductProduct?.activeState == 'Aproved'
                                      ? Container(
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                    offset: const Offset(0, 11),
                                                    blurRadius: 11,
                                                    color: Colors.black
                                                        .withOpacity(0.06))
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color:
                                                  CupertinoColors.systemGreen),
                                          padding: const EdgeInsets.all(5.0),
                                          child: TitleText(
                                            'Product is Live',
                                            color: CupertinoColors
                                                .lightBackgroundGray,
                                          ))
                                      : widget.ductProduct?.activeState ==
                                              'Expired'
                                          ? GestureDetector(
                                              onTap: () async {
                                                EasyLoading.show(
                                                    status: 'initializing',
                                                    dismissOnTap: true);
                                                final database = Databases(
                                                  clientConnect(),
                                                );

                                                // await feedState.addProductIncartTotalPrice(
                                                //     userCartController
                                                //             .subscriptionModel
                                                //             .firstWhere(
                                                //                 (data) =>
                                                //                     data.subType ==
                                                //                     'product',
                                                //                 orElse: () =>
                                                //                     SubscriptionViewDuctsModel())
                                                //             .price!
                                                //             .toDouble() *
                                                //         userCartController
                                                //             .exchangeRate
                                                //             .firstWhere(
                                                //                 (curr) =>
                                                //                     curr.currency ==
                                                //                     'dollar',
                                                //                 orElse: () =>
                                                //                     ExchangeRateModel())
                                                //             .rate!
                                                //             .toDouble(),
                                                //     currentUser.userId,
                                                //     '');

                                                // await database
                                                //     .getDocument(
                                                //         databaseId: databaseId,
                                                //         collectionId: initPayment,
                                                //         documentId:
                                                //             currentUser.userId!)
                                                //     .then((doc) {
                                                //   // setState(() {
                                                //   userPayment =
                                                //       InitPaymentModel.fromJson(
                                                //           doc.data);
                                                //   // });
                                                // });
                                                // await Future.delayed(
                                                //     const Duration(seconds: 5), () {
                                                //   EasyLoading.dismiss();
                                                // });
                                                // _showDialog(context);
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                            offset:
                                                                const Offset(
                                                                    0, 11),
                                                            blurRadius: 11,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.06))
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color: CupertinoColors
                                                          .systemPink),
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: TitleText(
                                                    'Product Expired',
                                                    color: CupertinoColors
                                                        .lightBackgroundGray,
                                                  )),
                                            )
                                          : widget.ductProduct?.activeState ==
                                                  'error'
                                              ? GestureDetector(
                                                  onTap: () {
                                                    DateFormat("E").format(
                                                                DateTime
                                                                    .now()) ==
                                                            'Sun'
                                                        ? Container()
                                                        : showModalBottomSheet(
                                                            backgroundColor:
                                                                Colors.red,
                                                            // isDismissible: false,
                                                            // bounce: true,
                                                            context: context,
                                                            builder: (context) =>
                                                                OpenContainer(
                                                                  closedBuilder:
                                                                      (context,
                                                                          action) {
                                                                    return EditProductPage(
                                                                      product:
                                                                          widget
                                                                              .ductProduct,
                                                                      error:
                                                                          true,
                                                                    );
                                                                  },
                                                                  openBuilder:
                                                                      (context,
                                                                          action) {
                                                                    return EditProductPage(
                                                                      product:
                                                                          widget
                                                                              .ductProduct,
                                                                      error:
                                                                          true,
                                                                    );
                                                                  },
                                                                ));
                                                  },
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                                offset:
                                                                    const Offset(
                                                                        0, 11),
                                                                blurRadius: 11,
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.06))
                                                          ],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: CupertinoColors
                                                              .systemRed),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: TitleText(
                                                        'error in product',
                                                        color: CupertinoColors
                                                            .lightBackgroundGray,
                                                      )),
                                                )
                                              : GestureDetector(
                                                  onTap: () {},
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                                offset:
                                                                    const Offset(
                                                                        0, 11),
                                                                blurRadius: 11,
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.06))
                                                          ],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: CupertinoColors
                                                              .inactiveGray),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: TitleText(
                                                        'Reviewing Product',
                                                        color: CupertinoColors
                                                            .lightBackgroundGray,
                                                      )),
                                                )
                                  : Container(),
                            ],
                          ),
                          ViewDuctMenuHolder(
                            onPressed: () {},
                            menuItems: <DuctFocusedMenuItem>[
                              currentUser?.userId ==
                                          widget.ductProduct?.userId ||
                                      staff
                                              ?.firstWhere(
                                                  (e) =>
                                                      e.id ==
                                                      currentUser?.userId,
                                                  orElse: () =>
                                                      StaffUserModel())
                                              .role ==
                                          'admin' ||
                                      staff
                                              ?.firstWhere(
                                                  (e) =>
                                                      e.id ==
                                                      currentUser?.userId,
                                                  orElse: () =>
                                                      StaffUserModel())
                                              .role ==
                                          'Sales Agent' ||
                                      staff
                                              ?.firstWhere(
                                                  (e) =>
                                                      e.id ==
                                                      currentUser?.userId,
                                                  orElse: () =>
                                                      StaffUserModel())
                                              .role ==
                                          'General Manager'
                                  ? DuctFocusedMenuItem(
                                      title: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      OpenContainer(
                                                        closedBuilder:
                                                            (context, action) {
                                                          return CompoaseDuctsPageResponsive(
                                                            isRetweet: false,
                                                            isTweet: true,
                                                            ductIds: widget
                                                                .ductProduct
                                                                ?.key,
                                                            isVendor: true,
                                                          );
                                                        },
                                                        openBuilder:
                                                            (context, action) {
                                                          return CompoaseDuctsPageResponsive(
                                                            isRetweet: false,
                                                            isTweet: true,
                                                            ductIds: widget
                                                                .ductProduct
                                                                ?.key,
                                                            isVendor: true,
                                                          );
                                                        },
                                                      )));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0),
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
                                                    BorderRadius.circular(18),
                                                color: CupertinoColors
                                                    .lightBackgroundGray),
                                            padding: const EdgeInsets.all(5.0),
                                            child: const Text(
                                              'Duct Product',
                                              style: TextStyle(
                                                //fontSize: Get.width * 0.03,
                                                color: AppColor.darkGrey,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    OpenContainer(
                                                      closedBuilder:
                                                          (context, action) {
                                                        return CompoaseDuctsPageResponsive(
                                                          isRetweet: false,
                                                          isTweet: true,
                                                          ductIds: widget
                                                              .ductProduct?.key,
                                                          isVendor: true,
                                                        );
                                                      },
                                                      openBuilder:
                                                          (context, action) {
                                                        return CompoaseDuctsPageResponsive(
                                                          isRetweet: false,
                                                          isTweet: true,
                                                          ductIds: widget
                                                              .ductProduct?.key,
                                                          isVendor: true,
                                                        );
                                                      },
                                                    )));
                                      },
                                      trailingIcon: const Icon(
                                          CupertinoIcons.app_badge_fill))
                                  : DuctFocusedMenuItem(
                                      title: GestureDetector(
                                        onTap: () {
                                          DateFormat("E")
                                                      .format(DateTime.now()) ==
                                                  'Sun'
                                              ? Container()
                                              : showModalBottomSheet(
                                                  backgroundColor: Colors.red,
                                                  // isDismissible: false,
                                                  // bounce: true,
                                                  context: context,
                                                  builder: (context) =>
                                                      OpenContainer(
                                                        closedBuilder:
                                                            (context, action) {
                                                          return ProductResponsiveView(
                                                            model: widget
                                                                .ductProduct,
                                                            rating:
                                                                finalRatingValue,
                                                          );
                                                        },
                                                        openBuilder:
                                                            (context, action) {
                                                          return ProductResponsiveView(
                                                            model: widget
                                                                .ductProduct,
                                                            rating:
                                                                finalRatingValue,
                                                          );
                                                        },
                                                      ));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30.0),
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
                                                    BorderRadius.circular(18),
                                                color: CupertinoColors
                                                    .lightBackgroundGray),
                                            padding: const EdgeInsets.all(5.0),
                                            child: const Text(
                                              'Buy Product',
                                              style: TextStyle(
                                                //fontSize: Get.width * 0.03,
                                                color: AppColor.darkGrey,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        DateFormat("E")
                                                    .format(DateTime.now()) ==
                                                'Sun'
                                            ? Container()
                                            : showModalBottomSheet(
                                                backgroundColor: Colors.red,
                                                // isDismissible: false,
                                                // bounce: true,
                                                context: context,
                                                builder: (context) =>
                                                    OpenContainer(
                                                      closedBuilder:
                                                          (context, action) {
                                                        return ProductResponsiveView(
                                                          model: widget
                                                              .ductProduct,
                                                          rating:
                                                              finalRatingValue,
                                                        );
                                                      },
                                                      openBuilder:
                                                          (context, action) {
                                                        return ProductResponsiveView(
                                                          model: widget
                                                              .ductProduct,
                                                          rating:
                                                              finalRatingValue,
                                                        );
                                                      },
                                                    ));
                                      },
                                      trailingIcon: const Icon(
                                          CupertinoIcons.bag_badge_plus)),
                              DuctFocusedMenuItem(
                                  title: GestureDetector(
                                    onTap: () {
                                      buildDynamicLinks(
                                          widget.ductProduct!.productName!,
                                          widget.ductProduct!.productImage ??
                                              '',
                                          widget.ductProduct!.key!,
                                          widget
                                              .ductProduct!.productDescription!,
                                          true);
                                      // Share.share(
                                      //     subject: 'Products',
                                      //     'checkout this product ${ductProduct?.productName},You will love it when you get it. https://viewducts.page.link/products?id=${ductProduct!.key}');
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  offset: const Offset(0, 11),
                                                  blurRadius: 11,
                                                  color: Colors.black
                                                      .withOpacity(0.06))
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            color: CupertinoColors.systemRed),
                                        padding: const EdgeInsets.all(5.0),
                                        child: const Text(
                                          'Share Product',
                                          style: TextStyle(
                                              //fontSize: Get.width * 0.03,
                                              color: CupertinoColors
                                                  .darkBackgroundGray),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    buildDynamicLinks(
                                        widget.ductProduct!.productName!,
                                        widget.ductProduct!.productImage ?? '',
                                        widget.ductProduct!.key!,
                                        widget.ductProduct!.key!,
                                        true);
                                    // Share.share(
                                    //     subject: 'Products',
                                    //     'Check out this product ${ductProduct?.productName},You will love when you get it. https://viewducts.page.link/products?id=${ductProduct!.key}&ucom=${authState.appUser?.$id}');
                                  },
                                  trailingIcon:
                                      const Icon(CupertinoIcons.share_solid)),
                              DuctFocusedMenuItem(
                                  title: GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                            height: Get.height * 0.7,
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
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                                offset:
                                                                    const Offset(
                                                                        0, 11),
                                                                blurRadius: 11,
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.06))
                                                          ],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: CupertinoColors
                                                              .darkBackgroundGray),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: TitleText(
                                                        '${widget.ductProduct?.productName} Reviews',
                                                        color: CupertinoColors
                                                            .systemYellow,
                                                      )),
                                                ),
                                                ref
                                                    .watch(
                                                        getProductReviewCommentProvider(
                                                            widget.ductProduct!
                                                                .key
                                                                .toString()))
                                                    .when(
                                                        data:
                                                            (productReviewModelComment) {
                                                          return productReviewModelComment
                                                                  .isEmpty
                                                              ? Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    SizedBox(
                                                                      height:
                                                                          150,
                                                                    ),
                                                                    Align(
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                                offset: const Offset(0, 11),
                                                                                blurRadius: 11,
                                                                                color: Colors.black.withOpacity(0.06))
                                                                          ],
                                                                          borderRadius:
                                                                              BorderRadius.circular(18),
                                                                        ),
                                                                        child: BubbleSpecialThree(
                                                                            isSender:
                                                                                false,
                                                                            tail:
                                                                                true,
                                                                            color:
                                                                                CupertinoColors.systemOrange,
                                                                            text: 'No reviews yet for this product at the moment'),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              : Expanded(
                                                                  child:
                                                                      ListView(
                                                                    children: productReviewModelComment
                                                                        .where((item) => item.productId == widget.ductProduct!.key)
                                                                        .map((data) => Row(
                                                                              crossAxisAlignment: currentUser?.userId == data.userId ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                                                              mainAxisAlignment: currentUser?.userId == data.userId ? MainAxisAlignment.end : MainAxisAlignment.start,
                                                                              children: [
                                                                                Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  children: [
                                                                                    currentUser?.userId == data.userId
                                                                                        ? Container()
                                                                                        : Padding(
                                                                                            padding: const EdgeInsets.all(5.0),
                                                                                            child: TitleText(
                                                                                              data.senderName,
                                                                                              color: CupertinoColors.darkBackgroundGray,
                                                                                            ),
                                                                                          ),
                                                                                    Container(
                                                                                      decoration: BoxDecoration(
                                                                                        boxShadow: [
                                                                                          BoxShadow(offset: const Offset(0, 11), blurRadius: 11, color: Colors.black.withOpacity(0.06))
                                                                                        ],
                                                                                        borderRadius: BorderRadius.circular(18),
                                                                                      ),
                                                                                      child: BubbleSpecialThree(
                                                                                        isSender: currentUser?.userId == data.userId ? true : false,
                                                                                        tail: true,
                                                                                        color: currentUser?.userId == data.userId ? CupertinoColors.lightBackgroundGray : CupertinoColors.systemYellow,
                                                                                        text: data.reviewComment.toString(),
                                                                                      ),
                                                                                    ),
                                                                                    SingleChildScrollView(
                                                                                      scrollDirection: Axis.horizontal,
                                                                                      child: Row(
                                                                                        children: [
                                                                                          RatingStatWidget(
                                                                                            rating: data.rating!,
                                                                                          ),
                                                                                          Text(keysOfRating[data.rating! - 1]),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ))
                                                                        .toList(),
                                                                  ),
                                                                );
                                                        },
                                                        error: (error,
                                                                stackTrace) =>
                                                            ErrorText(
                                                              error: error
                                                                  .toString(),
                                                            ),
                                                        loading: () =>
                                                            const LoaderAll()),
                                              ],
                                            ),
                                            // child: Padding(
                                            //   padding: const EdgeInsets.all(5.0),
                                            //   child: Container(
                                            //       decoration: BoxDecoration(
                                            //           boxShadow: [
                                            //             BoxShadow(
                                            //                 offset:
                                            //                     const Offset(0, 11),
                                            //                 blurRadius: 11,
                                            //                 color: Colors.black
                                            //                     .withOpacity(0.06))
                                            //           ],
                                            //           borderRadius:
                                            //               BorderRadius.circular(5),
                                            //           color: CupertinoColors
                                            //               .systemYellow),
                                            //       padding: const EdgeInsets.all(5.0),
                                            //       child: TitleText(
                                            //         'This is the commission you get after buying the product and ducting it to your friends and family in ViewDucts',
                                            //         color: CupertinoColors
                                            //             .darkBackgroundGray,
                                            //       )),
                                            // ),
                                          );
                                        },
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  offset: const Offset(0, 11),
                                                  blurRadius: 11,
                                                  color: Colors.black
                                                      .withOpacity(0.06))
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            color:
                                                CupertinoColors.systemYellow),
                                        padding: const EdgeInsets.all(5.0),
                                        child: const Text(
                                          'Product Reviews',
                                          style: TextStyle(
                                              //fontSize: Get.width * 0.03,
                                              color: CupertinoColors
                                                  .darkBackgroundGray),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {},
                                  trailingIcon:
                                      const Icon(CupertinoIcons.bubble_left)),
                            ],
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 3),
                                      decoration: BoxDecoration(
                                          color: Colors.cyan,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: customText(
                                        'More',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ),
                                    const Icon(CupertinoIcons.app_badge),
                                  ]),
                            ),
                          ),

                          //  : Container(),
                          //  )
                          //   _likeCommentsIcons(context, widget.ductProduct!)
                        ],
                      ),
                      Positioned(
                        right: 0,
                        bottom: context.responsiveValue(
                            mobile: Get.height * 0.25,
                            tablet: Get.height * 0.25,
                            desktop: Get.height * 0.25),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () async {
                              // DateFormat("E").format(DateTime.now()) == 'Sun'
                              //     ? Container()
                              //     :
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.red,
                                  // isDismissible: false,
                                  // bounce: true,
                                  context: context,
                                  builder: (context) => Container(
                                        height: fullHeight(context) * 0.96,
                                        width: fullWidth(context),
                                        child: ProductResponsiveView(
                                            model: widget.ductProduct,
                                            rating: finalRatingValue,
                                            currentUser: currentUser,
                                            vendor: vendor),
                                      )
                                  //  OpenContainer(
                                  //       closedBuilder: (context, action) {
                                  //         return ProductResponsiveView(
                                  //             model: widget.ductProduct,
                                  //             rating: finalRatingValue,
                                  //             currentUser: currentUser,
                                  //             vendor: vendor);
                                  //       },
                                  //       openBuilder: (context, action) {
                                  //         return ProductResponsiveView(
                                  //           model: widget.ductProduct,
                                  //           rating: finalRatingValue,
                                  //         );
                                  //       },
                                  //     )
                                  );
                            },
                            child: Container(
                                padding: const EdgeInsets.all(0),
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.yellow),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: customTitleText('Buy'),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ));
  }
}

class _Customers extends StatelessWidget {
  const _Customers({Key? key, this.user, this.id}) : super(key: key);
  final ViewductsUser? user;
  final String? id;

  @override
  Widget build(BuildContext context) {
    // var authState = Provider.of<AuthState>(context, listen: false);
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(0),
            bottomLeft: Radius.circular(20)),
      ),
      child: frostedOrange(
        ListTile(
          onTap: () {
            kAnalytics.logViewSearchResults(searchTerm: user!.userName!);
            // Navigator.of(context)
            //     .pushNamed("/Stores/", arguments: _Customers(id: user.userId));
//Navigator.of(context).pushNamed('/ProfilePage/' + user?.userId);
          },
          leading: Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(100),
              child: customImage(context, user!.profilePic, height: 40)),
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
      ),
    );
  }
}

class FeedAsymmetricView extends StatelessWidget {
  final Widget? trailing;
  final DuctType? type;
  final bool isSearchPage;
  const FeedAsymmetricView(
      {Key? key,
      this.model,
      this.trailing,
      this.type,
      this.isSearchPage = false})
      : super(key: key);

  final List<FeedModel>? model;

  List<Container> _buildColumns(BuildContext context) {
    if (model == null || model!.isEmpty) {
      return const <Container>[];
    }

    // This will return a list of columns. It will oscillate between the two
    // kinds of columns. Even cases of the index (0, 2, 4, etc) will be
    // TwoProductCardColumn and the odd cases will be OneProductCardColumn.
    //
    // Each pair of columns will advance us 3 model forward (2 + 1). That's
    // some kinda awkward math so we use _evenCasesIndex and _oddCasesIndex as
    // helpers for creating the index of the model list that will correspond
    // to the index of the list of columns.
    return List<Container>.generate(_listItemCount(model!.length), (int index) {
      double width = .8 * Get.width;
      Widget column;
      if (index % 2 == 0) {
        /// Even cases
        final int bottom = _evenCasesIndex(index);
        column = TwoFeedCardColumn(
          bottom: model![bottom],
          top: model!.length - 1 >= bottom + 1 ? model![bottom + 1] : null,
        );
        width += 32.0;
      } else {
        /// Odd cases
        column = OneFeedCardColumn(
          model: model![_oddCasesIndex(index)],
        );
      }
      return Container(
        width: width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: column,
        ),
      );
    }).toList();
  }

  int _evenCasesIndex(int input) {
    // The operator ~/ is a cool one. It's the truncating division operator. It
    // divides the number and if there's a remainder / decimal, it cuts it off.
    // This is like dividing and then casting the result to int. Also, it's
    // functionally equivalent to floor() in this case.
    return input ~/ 2 * 3;
  }

  int _oddCasesIndex(int input) {
    assert(input > 0);
    return (input / 2).ceil() * 3 - 1;
  }

  int _listItemCount(int totalItems) {
    return (totalItems % 3 == 0)
        ? totalItems ~/ 3 * 2
        : (totalItems / 3).ceil() * 2 - 1;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(0.0, 34.0, 16.0, 44.0),
      children: _buildColumns(context),
      physics: const AlwaysScrollableScrollPhysics(),
    );
  }
}

class TwoFeedCardColumn extends StatelessWidget {
  const TwoFeedCardColumn({
    required FeedModel this.bottom,
    this.top,
    this.trailing,
    this.type,
    this.isSearchPage = false,
  });

  final FeedModel? bottom, top;
  final Widget? trailing;
  final DuctType? type;
  final bool isSearchPage;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      const double spacerHeight = 44.0;

      final double heightOfCards =
          (constraints.biggest.height - spacerHeight) / 2.0;
      final double heightOfImages = heightOfCards - _ItemCard.kTextBoxHeight;
      final double imageAspectRatio =
          (heightOfImages >= 0.0 && constraints.biggest.width > heightOfImages)
              ? constraints.biggest.width / heightOfImages
              : 33 / 49;

      return ListView(
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 28.0),
            child: top != null
                ? Duct(
                    model: top,
                    trailing: DuctBottomSheet().ductOptionIcon(
                      context,
                      top,
                      DuctType.Duct,
                    ),
                  )
                //  _ItemCard(
                //     imageAspectRatio: imageAspectRatio,
                //     ductProduct: top,
                //   )
                : SizedBox(
                    height: heightOfCards > 0 ? heightOfCards : spacerHeight,
                  ),
          ),
          const SizedBox(height: spacerHeight),
          Padding(
              padding: const EdgeInsetsDirectional.only(end: 28.0),
              child: Duct(
                model: bottom,
                trailing: DuctBottomSheet().ductOptionIcon(
                  context,
                  bottom,
                  DuctType.Duct,
                ),
              )
              // _ItemCard(
              //   imageAspectRatio: imageAspectRatio,
              //   ductProduct: bottom,
              // ),
              ),
          SizedBox(
            height: fullWidth(context) * 0.4,
          )
        ],
      );
    });
  }
}

class OneFeedCardColumn extends StatelessWidget {
  const OneFeedCardColumn(
      {this.model, this.trailing, this.type, this.isSearchPage = false});

  final FeedModel? model;
  final Widget? trailing;
  final DuctType? type;
  final bool isSearchPage;
  @override
  Widget build(BuildContext context) {
    return ListView(
      //reverse: true,
      children: <Widget>[
        const SizedBox(
          height: 40.0,
        ),
        Duct(
          model: model,
          trailing: DuctBottomSheet().ductOptionIcon(
            context,
            model,
            DuctType.Duct,
          ),
        ),
      ],
    );
  }
}

class ViewPostAsymmetricView extends StatelessWidget {
  final Widget? trailing;
  final DuctType? type;
  final bool isSearchPage;
  const ViewPostAsymmetricView(
      {Key? key,
      this.model,
      this.trailing,
      this.type,
      this.isSearchPage = false})
      : super(key: key);

  final List<ProductModel>? model;

  List<Container> _buildColumns(BuildContext context) {
    if (model == null || model!.isEmpty) {
      return const <Container>[];
    }

    // This will return a list of columns. It will oscillate between the two
    // kinds of columns. Even cases of the index (0, 2, 4, etc) will be
    // TwoProductCardColumn and the odd cases will be OneProductCardColumn.
    //
    // Each pair of columns will advance us 3 model forward (2 + 1). That's
    // some kinda awkward math so we use _evenCasesIndex and _oddCasesIndex as
    // helpers for creating the index of the model list that will correspond
    // to the index of the list of columns.
    return List<Container>.generate(_listItemCount(model!.length), (int index) {
      double width = .59 * MediaQuery.of(context).size.width;
      Widget column;
      if (index % 2 == 0) {
        /// Even cases
        final int bottom = _evenCasesIndex(index);
        column = TwoProductViewCardColumn(
          bottom: model![bottom],
          top: model!.length - 1 >= bottom + 1 ? model![bottom + 1] : null,
        );
        width += 32.0;
      } else {
        /// Odd cases
        column = OneProductViewCardColumn(
          model: model![_oddCasesIndex(index)],
        );
      }
      return Container(
        width: width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: column,
        ),
      );
    }).toList();
  }

  int _evenCasesIndex(int input) {
    // The operator ~/ is a cool one. It's the truncating division operator. It
    // divides the number and if there's a remainder / decimal, it cuts it off.
    // This is like dividing and then casting the result to int. Also, it's
    // functionally equivalent to floor() in this case.
    return input ~/ 2 * 3;
  }

  int _oddCasesIndex(int input) {
    assert(input > 0);
    return (input / 2).ceil() * 3 - 1;
  }

  int _listItemCount(int totalItems) {
    return (totalItems % 3 == 0)
        ? totalItems ~/ 3 * 2
        : (totalItems / 3).ceil() * 2 - 1;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(0.0, 34.0, 16.0, 44.0),
      children: _buildColumns(context),
      physics: const AlwaysScrollableScrollPhysics(),
    );
  }
}

class TwoProductViewCardColumn extends StatelessWidget {
  const TwoProductViewCardColumn({
    Key? key,
    required ProductModel this.bottom,
    this.top,
    this.trailing,
    this.type,
    this.isSearchPage = false,
  }) : super(key: key);

  final ProductModel? bottom, top;
  final Widget? trailing;
  final DuctType? type;
  final bool isSearchPage;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      const double spacerHeight = 44.0;

      final double heightOfCards =
          (constraints.biggest.height - spacerHeight) / 2.0;
      final double heightOfImages = heightOfCards - _ItemCard.kTextBoxHeight;
      final double imageAspectRatio =
          (heightOfImages >= 0.0 && constraints.biggest.width > heightOfImages)
              ? constraints.biggest.width / heightOfImages
              : 33 / 49;

      return ListView(
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 28.0),
            child: top != null
                ? _ItemCardView(
                    imageAspectRatio: imageAspectRatio,
                    ductProduct: top,
                  )
                : SizedBox(
                    height: heightOfCards > 0 ? heightOfCards : spacerHeight,
                  ),
          ),
          const SizedBox(height: spacerHeight),
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 28.0),
            child: _ItemCardView(
              imageAspectRatio: imageAspectRatio,
              ductProduct: bottom,
            ),
          ),
          SizedBox(
            height: fullWidth(context) * 0.4,
          )
        ],
      );
    });
  }
}

class OneProductViewCardColumn extends StatelessWidget {
  const OneProductViewCardColumn(
      {this.model, this.trailing, this.type, this.isSearchPage = false});

  final ProductModel? model;
  final Widget? trailing;
  final DuctType? type;
  final bool isSearchPage;
  @override
  Widget build(BuildContext context) {
    return ListView(
      //reverse: true,
      children: const <Widget>[
        SizedBox(
          height: 40.0,
        ),
        // _ItemCard(
        //   ductProduct: model,
        //   isSearchPage: isSearchPage,
        // ),
      ],
    );
  }
}

class _ItemCardView extends StatefulWidget {
  const _ItemCardView({
    this.imageAspectRatio = 33 / 49,
    this.ductProduct,
    this.type,
    this.profileId,
    this.isSearchPage,
  }) : assert(imageAspectRatio > 0);
  final DuctType? type;
  final double imageAspectRatio;
  final String? profileId;

  // final Products products;
  final ProductModel? ductProduct;
  final bool? isSearchPage;

  @override
  __ItemCardViewState createState() => __ItemCardViewState();
}

//ValueNotifier<bool> imageNotready = ValueNotifier(false);

class __ItemCardViewState extends State<_ItemCardView> {
  var isDropdown = false.obs;
  double? height, width, xPosiion, yPosition;
  late OverlayEntry floatingMenu;
  DuctType? type;
  Color? iconColor;
  Color? iconEnableColor;
  double? size;
  bool isDuctDetail = false;
  String? ductId;

  String? senderId;

  String? userImage;

  bool? isContinuing;

  FocusNode textFieldFocus = FocusNode();

  FocusNode imageTextFieldFocus = FocusNode();

  //ChatState state = ChatState();

  // AuthState authState = AuthState();

  // FeedState feedState = FeedState();

  ValueNotifier<bool> isSelected = ValueNotifier(false);

  String? chatUserProductId, myOrders;

  String? peerAvatar, peerNo, currentUserNo, privateKey, sharedSecret;

  bool locked = false;
  bool hidden = false;

  int? chatStatus, unread;

  GlobalKey? actionKey;

  dynamic lastSeen;

  String? chatId;

  bool isWriting = false;

  var showEmojiPicker = false.obs;

  File? imageFile;

  bool isLoading = false;
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

  late VideoPlayerController _videoController;
  final GlobalKey<State> keyLoader = GlobalKey<State>();
  // List<dynamic> size;
  //FeedState? productState;

  Future<void>? _initializeVideoplayerfuture;

  setQuantity(String type) {
    setState(() {
      if (type == 'inc') {
        if (quantity != 5) {
          quantity = quantity + 1;
        }
      } else {
        if (quantity != 1) {
          quantity = quantity - 1;
        }
      }
    });
  }

  showKeyboard() => textFieldFocus.requestFocus();

  hideKeyboard() => textFieldFocus.unfocus();

  hideEmojiContainer() {
    showEmojiPicker.value = false;
  }

  showEmojiContainer() {
    showEmojiPicker.value = true;
  }

  void onLongPressedTweet(BuildContext context) {
    if (widget.type == DuctType.Detail || widget.type == DuctType.ParentDuct) {
      // var text = ClipboardData(text: widget.ductProduct!.ductComment);
      // Clipboard.setData(text);
      Get.snackbar("Copied", 'Duct copied to clipboard');
    }
  }

  void onTapDuct(BuildContext context) {}

  void _vDuct(
    BuildContext context,
  ) async {
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        // var appSize = MediaQuery.of(context).size;

        // // double heightFactor = 300 / fullHeight(context);
        // var authState = Provider.of<AuthState>(context, listen: false);
        // var state = Provider.of<FeedState>(context, listen: false);
        ViewductsUser model;
        return frostedWhite(
          Container(
            padding: const EdgeInsets.only(top: 5, bottom: 0),
            height: fullWidth(context) * 0.6,
            // (type == TweetType.Tweet
            //     ? (isMyTweet ? .25 : .44)
            //     : (isMyTweet ? .38 : .52)),
            width: fullWidth(context),
            decoration: const BoxDecoration(
                // color: Theme.of(context).bottomSheetTheme.backgroundColor,
                // borderRadius: BorderRadius.only(
                //   topLeft: Radius.circular(20),
                //   topRight: Radius.circular(20),
                // ),
                ),
            child: Stack(
              children: [
                Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(50),
                            elevation: 2,
                            color: Colors.teal,
                            child: frostedYellow(Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: customText('VDucting',
                                  style: const TextStyle(color: Colors.white)),
                            )),
                          ),
                        ),
                        Row(
                          children: [
                            Material(
                              borderRadius: BorderRadius.circular(100),
                              elevation: 20,
                              child: Container(
                                width: 40,
                                height: 40,
                                // child: GestureDetector(
                                //   onTap: () {
                                //     // If tweet is displaying on someone's profile then no need to navigate to same user's profile again.
                                //     // if (isSearchPage) {
                                //     //   return;
                                //     // }
                                //     // Navigator.of(context).pushNamed(
                                //     //     '/ProfilePage/' + model?.userId);
                                //   },
                                //   child: customImage(context,
                                //       widget.ductProduct!.user!.profilePic),
                                // ),
                              ),
                            ),
                            frostedBlack(
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                // child: UrlText(
                                //   text: widget.ductProduct!.ductComment,
                                //   style: TextStyle(
                                //     color:
                                //         Theme.of(context).colorScheme.onPrimary,
                                //     fontSize: 14,
                                //     fontWeight: FontWeight.w400,
                                //   ),
                                //   urlStyle: TextStyle(
                                //       color: Colors.blue,
                                //       fontWeight: FontWeight.w400),
                                // ),
                              ),
                            ),
                          ],
                        ),
                        _bottomEntryField(),
                      ],
                    )),
                Positioned(
                    right: 5,
                    top: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Material(
                            elevation: 10,
                            borderRadius: BorderRadius.circular(20),
                            child: SizedBox(
                              width: fullWidth(context) * 0.2,
                              height: fullWidth(context) * 0.2,
                              child: customNetworkImage(
                                widget.ductProduct?.imagePath,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        );
      },
    );
  }

  void _opTions(
    BuildContext context,
  ) async {
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        // var appSize = MediaQuery.of(context).size;

        // // double heightFactor = 300 / fullHeight(context);
        // var authState = Provider.of<AuthState>(context, listen: false);
        // var state = Provider.of<FeedState>(context, listen: false);
        ViewductsUser model;
        return frostedOrange(
          Container(
            padding: const EdgeInsets.only(top: 5, bottom: 0),
            height: fullHeight(context) * 0.8,
            // (type == TweetType.Tweet
            //     ? (isMyTweet ? .25 : .44)
            //     : (isMyTweet ? .38 : .52)),
            width: fullWidth(context),
            decoration: const BoxDecoration(
                // color: Theme.of(context).bottomSheetTheme.backgroundColor,
                // borderRadius: BorderRadius.only(
                //   topLeft: Radius.circular(20),
                //   topRight: Radius.circular(20),
                // ),
                ),
            child: Stack(
              children: [
                Material(
                  color: Colors.transparent,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Container(
                      width: fullWidth(context),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Stack(
                            children: [
                              SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: fullWidth(context),
                                        //height: fullHeight(context),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Material(
                                                    elevation: 10,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: Container(
                                                      width:
                                                          fullWidth(context) *
                                                              0.4,
                                                      height:
                                                          fullWidth(context) *
                                                              0.4,
                                                      //decoration: BoxDecoration(),
                                                      child: AspectRatio(
                                                          aspectRatio: 4 / 3,
                                                          child: customNetworkImage(
                                                              widget
                                                                  .ductProduct!
                                                                  .imagePath,
                                                              fit: BoxFit
                                                                  .contain)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const Divider(),
                                              Row(
                                                children: [
                                                  customText(
                                                    widget.ductProduct
                                                        ?.productName,
                                                    style: const TextStyle(
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              const Divider(),
                                              Row(
                                                children: [
                                                  customText(
                                                    'Qauntity : ',
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      GestureDetector(
                                                        onTap: () {
                                                          setQuantity('dec');
                                                        },
                                                        child: Icon(
                                                          CupertinoIcons
                                                              .minus_circled,
                                                          size: 30,
                                                          color: Colors
                                                              .blueGrey[900],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 8),
                                                        child: Text(quantity
                                                            .toString()),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          setQuantity('inc');
                                                        },
                                                        child: Icon(
                                                          CupertinoIcons
                                                              .add_circled_solid,
                                                          size: 30,
                                                          color: Colors
                                                              .blueGrey[900],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const Divider(),
                                              Row(
                                                children: [
                                                  customText(
                                                    'Brand: ',
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  customText(
                                                    widget.ductProduct?.brand,
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white),
                                                  )
                                                ],
                                              ),
                                              const Divider(),
                                              Row(
                                                children: [
                                                  customText(
                                                    'location: ',
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  customText(
                                                    widget.ductProduct
                                                        ?.productName,
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white),
                                                  )
                                                ],
                                              ),
                                              const Divider(),
                                              Row(
                                                children: [
                                                  Container(
                                                    width: fullWidth(context) *
                                                        0.9,
                                                    child: Column(
                                                      children: [
                                                        customText(
                                                          'Description:',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: Colors
                                                                      .red),
                                                        ),
                                                        customText(
                                                          widget.ductProduct
                                                              ?.productDescription,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 20,
                                                                  color: Colors
                                                                      .white),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 100,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: fullWidth(context) * 0.05,
                  right: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () async {
                            // await addToShoppingBag(feedState, authState);
                            Navigator.maybePop(context).then((value) {
                              Navigator.of(context).pop();
                            });
                          },
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  //  await addToShoppingBag(feedState, authState);
                                  Navigator.maybePop(context).then((value) {
                                    Navigator.of(context).pop();
                                  });
                                },
                                child: const Icon(
                                  CupertinoIcons.add_circled_solid,
                                  size: 30,
                                ),
                              ),
                              Container(
                                width: fullWidth(context) * 0.2,
                                height: fullWidth(context) * 0.08,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blueGrey[50],
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black87.withOpacity(0.1),
                                      Colors.black87.withOpacity(0.2),
                                      Colors.black87.withOpacity(0.3)
                                      // Color(0xfffbfbfb),
                                      // Color(0xfff7f7f7),
                                    ],
                                    // begin: Alignment.topCenter,
                                    // end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: customText(
                                  'Cart',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () async {
                            //  await addToShoppingBag(feedState, authState);
                            Navigator.maybePop(context).then((value) {
                              Navigator.of(context).pop();
                              // ignore: unnecessary_cast
                            }).then((value) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ShoppingCart(),
                                ),
                              );
                            }
                                // as FutureOr<_> Function(Null)
                                );
                          },
                          child: Row(
                            children: [
                              // GestureDetector(
                              //   onTap: () async {
                              //     await addToShoppingBag(state, authState);
                              //     Navigator.maybePop(context).then((value) {
                              //       Navigator.of(context).pop();
                              //     }).then((value) {
                              //       Navigator.of(context).push(
                              //         MaterialPageRoute(
                              //           builder: (context) => ShoppingCart(),
                              //         ),
                              //       );
                              //     });
                              //   },
                              //   child: CircleAvatar(
                              //     radius: 15,
                              //     backgroundColor: Colors.transparent,
                              //     child: Image.asset('assets/carts.png'),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () async {
                            //await Navigator.maybePop(context);

                            // final chatState =
                            //     Provider.of<ChatState>(context, listen: false);
                            // final authState =
                            //     Provider.of<AuthState>(context, listen: false);
                            // final searchState = Provider.of<SearchState>(
                            //     context,
                            //     listen: false);
                            //chatState.setChatUser = model;

                            // if (searchState.userlist!.any((x) =>
                            //     x.userId ==
                            //     feedState.ductDetailModel!.last!.userId)) {
                            //   chatState.setChatUser = searchState.userlist!
                            //       .where((x) =>
                            //           x.userId ==
                            //           feedState.ductDetailModel!.last!.userId)
                            //       .first;
                            // }

                            Navigator.of(context).pop();
                            Navigator.pushNamed(context, '/ChatScreenPage');
                          },
                          child: Row(
                            children: [
                              // GestureDetector(
                              //   onTap: () async {
                              //     // await Navigator.maybePop(context);

                              //     final chatState = Provider.of<ChatState>(
                              //         context,
                              //         listen: false);
                              //     final authState = Provider.of<AuthState>(
                              //         context,
                              //         listen: false);
                              //     final searchState = Provider.of<SearchState>(
                              //         context,
                              //         listen: false);
                              //     //chatState.setChatUser = model;
                              //     chatState.onLine(authState.userModel.userId);
                              //     if (searchState.userlist.any((x) =>
                              //         x.userId ==
                              //         state.ductDetailModel.last.userId)) {
                              //       chatState.setChatUser = searchState.userlist
                              //           .where((x) =>
                              //               x.userId ==
                              //               state.ductDetailModel.last.userId)
                              //           .first;
                              //     }

                              //     if (authState.userModel.locked != null &&
                              //         authState.userModel.locked.contains(
                              //             chatState.chatUser.userId)) {
                              //       NavigatorState state =
                              //           Navigator.of(context);
                              //       // ChatControl.authenticate(
                              //       //     authState, 'Authentication needed to unlock the chat.',
                              //       //     state: state,
                              //       //     shouldPop: false,
                              //       //     type: ViewDucts.getAuthenticationType(
                              //       //         biometricEnabled, authState),
                              //       //     prefs: prefs, onSuccess: () {
                              //       //   cprint('security working');
                              //       //   // state.pushReplacement(new MaterialPageRoute(
                              //       //   //     builder: (context) => new ChatScreen(
                              //       //   //         unread: unread,
                              //       //   //         model: _cachedModel,
                              //       //   //         currentUserNo: currentUserNo,
                              //       //   //         peerNo: user[PHONE] as String)));
                              //       //   chatState.onLine(authState.userModel.userId);
                              //       //   Navigator.pushNamed(context, '/ChatScreenPage');
                              //       // });
                              //     } else {
                              //       chatState
                              //           .onLine(authState.userModel.userId);
                              //       Navigator.of(context).pop();
                              //       Navigator.pushNamed(
                              //           context, '/ChatScreenPage');
                              //     }
                              //   },
                              //   child: CircleAvatar(
                              //     radius: 15,
                              //     backgroundColor: Colors.transparent,
                              //     child: Image.asset('assets/chatchat.png'),
                              //   ),
                              // ),
                              Container(
                                width: fullWidth(context) * 0.2,
                                height: fullWidth(context) * 0.08,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blueGrey[50],
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black87.withOpacity(0.1),
                                      Colors.black87.withOpacity(0.2),
                                      Colors.black87.withOpacity(0.3)
                                      // Color(0xfffbfbfb),
                                      // Color(0xfff7f7f7),
                                    ],
                                    // begin: Alignment.topCenter,
                                    // end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: customText(
                                  'Chat',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.amber),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  setSizeOptions(String size) {
    setState(() {
      sizeValue = size;
    });
  }

  setProductData(var state) {
    setState(() {
      itemDetails = ModalRoute.of(context)!.settings.arguments;
    });
    String productValues =
        '{"price": "${widget.ductProduct!.price}","productId": "${widget.ductProduct!.key}","color": "${colorValue.toString()}","selectedCard": "${sizeValue.toString()}"}';

    itemDetails = jsonDecode(productValues);
    // final Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;

    // setState(() {
    //   itemDetails = args;
    // });
  }

//   addToShoppingBag(FeedState _shoppingBagService, AuthState authState) async {
//     setProductData(_shoppingBagService);

//     // showInSnackBar(msg, Colors.black);
//     if (sizeValue == '' && sizeValue.isNotEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           backgroundColor: Colors.red,
//           content: const Text('Select size'),
//           action: SnackBarAction(
//             label: 'Close',
//             textColor: Colors.white,
//             onPressed: () {
//               ScaffoldMessenger.of(context).removeCurrentSnackBar();
//             },
//           ),
//         ),
//       );
//     } else {
//       // String msg = await _shoppingBagService.addProductTocart(
//       //   itemDetails['productId'],
//       //   sizeValue,
//       //   colorValue,
//       //   quantity,
//       //   authState.userId,
//       //   widget.ductProduct!.user!.userId,
//       // );
// //Navigator.of(keyLoader.currentContext, rootNavigator: true).pop();
//       // ScaffoldMessenger.of(context).showSnackBar(
//       //   SnackBar(
//       //     backgroundColor: Colors.teal,
//       //     content: new Text(msg),
//       //     action: SnackBarAction(
//       //       label: 'Close',
//       //       textColor: Colors.white,
//       //       onPressed: () {
//       //         ScaffoldMessenger.of(context).removeCurrentSnackBar();
//       //       },
//       //     ),
//       //   ),
//       // );

//       // Loader.showLoadingScreen(context, keyLoader);

//     }
//   }

  // OverlayEntry _mediaView(BuildContext contexts, FeedState state) {
  //   // double heightFactor = 300 / fullHeight(context);
  //   //var authState = Provider.of<AuthState>(context, listen: false);
  //   //  var state = Provider.of<FeedState>(context, listen: false);
  //   //FeedModel model;
  //   final NumberFormat formatter = NumberFormat.simpleCurrency(
  //     decimalDigits: 0,
  //     locale: Localizations.localeOf(context).toString(),
  //   );
  //   return OverlayEntry(
  //     builder: (context) {
  //       List<FeedModel>? list = feedState.getStoreProductList(authState.userId);

  //       if (feedState.feedlist != null && feedState.feedlist!.isNotEmpty) {
  //         list = feedState.getStoreProductList(authState.userId);
  //         // .where((x) => x.userId == id)
  //         // .toList();
  //       }
  //       return GestureDetector(
  //         onTap: () {
  //           // setState(() {
  //           //   // _video = null;
  //           //   // _image = null;
  //           //   // if (isDropdown.value) {
  //           //   //   floatingMenu.remove();
  //           //   // } else {
  //           //   //   // _postProsductoption();
  //           //   //   floatingMenu = _mediaView(
  //           //   //     context,
  //           //   //   );
  //           //   //   Overlay.of(context).insert(floatingMenu);
  //           //   // }

  //           //   // isDropdown.value = !isDropdown.value;
  //           // });
  //         },
  //         child: SafeArea(
  //           child: Scaffold(
  //             backgroundColor: Colors.transparent,
  //             body: frostedPink(
  //               Stack(
  //                 children: [
  //                   Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: Column(
  //                       children: [
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             GestureDetector(
  //                               onTap: () {
  //                                 // if (_image == null) {
  //                                 //   _image = File(image);
  //                                 // }
  //                                 if (isDropdown.value) {
  //                                   floatingMenu.remove();
  //                                 } else {
  //                                   // _postProsductoption();
  //                                   floatingMenu = _mediaView(context, state);
  //                                   Overlay.of(context)!.insert(floatingMenu);
  //                                 }

  //                                 isDropdown.value = !isDropdown.value;
  //                               },
  //                               child: const Icon(Icons.close),
  //                             ),
  //                             // GestureDetector(
  //                             //     onTap: () {

  //                             //     },
  //                             //     child: Row(
  //                             //       children: [
  //                             //         customTitleText('Next'),
  //                             //         Icon(Icons.arrow_forward_ios)
  //                             //       ],
  //                             //     ))
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   Positioned(
  //                       bottom: 0,
  //                       left: 0,
  //                       right: 0,
  //                       child: Column(
  //                         mainAxisAlignment: MainAxisAlignment.start,
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Container(
  //                             height: fullWidth(context) * 0.6,
  //                             width: fullWidth(context),
  //                             child:
  //                                 //Column(children: [],)
  //                                 CustomScrollView(
  //                               slivers: <Widget>[
  //                                 SliverList(
  //                                   delegate: SliverChildListDelegate(
  //                                     state.ductReplyMap.isEmpty ||
  //                                             state.ductReplyMap[postId] == null
  //                                         // state.ductReplyMap == null ||
  //                                         //         state.ductReplyMap.length == 0 ||
  //                                         //         state.ductReplyMap[widget
  //                                         //                 .model.replyDuctKeyList] ==
  //                                         //             null
  //                                         ? [
  //                                             const Center(
  //                                               child: Text(
  //                                                 'No comments',
  //                                                 style: TextStyle(
  //                                                     color: Colors.white),
  //                                               ),
  //                                             )
  //                                           ]
  //                                         : state.ductReplyMap[postId]!
  //                                             .map((x) =>
  //                                                 _commentRow(x, context))
  //                                             .toList(),
  //                                   ),
  //                                 )
  //                               ],
  //                             ),
  //                           ),
  //                           const Divider(color: Colors.white),
  //                           Container(
  //                               constraints: BoxConstraints(
  //                                 maxHeight: fullHeight(context) * 0.3,
  //                               ),
  //                               child: FutureBuilder(
  //                                 future: _initializeVideoplayerfuture,
  //                                 // initialData: InitialData,
  //                                 builder: (BuildContext context,
  //                                     AsyncSnapshot snapshot) {
  //                                   if (snapshot.connectionState ==
  //                                       ConnectionState.done) {
  //                                     return SizedBox.expand(
  //                                       child: FittedBox(
  //                                         fit: BoxFit.cover,
  //                                         child: frostedBlack(
  //                                           SizedBox(
  //                                             width: fullWidth(context),
  //                                             height: fullHeight(context),
  //                                             child: GestureDetector(
  //                                               onTap: () {
  //                                                 if (_videoController
  //                                                     .value.isPlaying) {
  //                                                   _videoController.pause();
  //                                                 } else {
  //                                                   _videoController.play();
  //                                                 }
  //                                               },
  //                                               child: VideoPlayer(
  //                                                   _videoController),
  //                                             ),
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     );
  //                                   } else {
  //                                     return const Center(
  //                                         child: CircularProgressIndicator());
  //                                   }
  //                                 },
  //                               )),
  //                           const Divider(color: Colors.white),
  //                           Padding(
  //                             padding: const EdgeInsets.all(8.0),
  //                             child: GestureDetector(
  //                               onTap: () {
  //                                 if (isDropdown.value) {
  //                                   floatingMenu.remove();
  //                                 } else {
  //                                   //  _postProsductoption();
  //                                   floatingMenu = _mediaView(context, state);
  //                                   Overlay.of(context)!.insert(floatingMenu);
  //                                 }

  //                                 isDropdown.value = !isDropdown.value;

  //                                 _opTions(context);
  //                               },
  //                               child: Container(
  //                                   padding: const EdgeInsets.all(0),
  //                                   decoration: const BoxDecoration(
  //                                       shape: BoxShape.circle,
  //                                       color: Colors.yellow),
  //                                   child: Padding(
  //                                     padding: const EdgeInsets.all(8.0),
  //                                     child: customTitleText(''),
  //                                   )),
  //                             ),
  //                           ),
  //                           Row(
  //                             children: [
  //                               // Material(
  //                               //   borderRadius: BorderRadius.circular(100),
  //                               //   elevation: 20,
  //                               //   child: Container(
  //                               //     width: 40,
  //                               //     height: 40,
  //                               //     child: GestureDetector(
  //                               //       onTap: () {
  //                               //         if (isDropdown.value) {
  //                               //           floatingMenu.remove();
  //                               //         } else {
  //                               //           //  _postProsductoption();
  //                               //           floatingMenu =
  //                               //               _mediaView(context, state);
  //                               //           Overlay.of(context)!
  //                               //               .insert(floatingMenu);
  //                               //         }

  //                               //         isDropdown.value = !isDropdown.value;
  //                               //         // Get.to(() => ProfilePage(
  //                               //         //       profileId: widget
  //                               //         //           .ductProduct!.user!.userId,
  //                               //         //       profileType: ProfileType.Store,
  //                               //         //     ));

  //                               //         // If tweet is displaying on someone's profile then no need to navigate to same user's profile again.
  //                               //         // if (isSearchPage) {
  //                               //         //   return;
  //                               //         // }
  //                               //         // Navigator.of(context).pushNamed(
  //                               //         //     '/ProfilePage/' + model?.userId);
  //                               //       },
  //                               //       child: customImage(context,
  //                               //           widget.ductProduct!.user!.profilePic),
  //                               //     ),
  //                               //   ),
  //                               // ),
  //                               frostedBlack(
  //                                 Padding(
  //                                   padding: const EdgeInsets.all(8.0),
  //                                   child: UrlText(
  //                                     text: widget
  //                                         .ductProduct!.productDescription,
  //                                     style: TextStyle(
  //                                       color: Theme.of(context)
  //                                           .colorScheme
  //                                           .onPrimary,
  //                                       fontSize: 14,
  //                                       fontWeight: FontWeight.w400,
  //                                     ),
  //                                     urlStyle: const TextStyle(
  //                                         color: Colors.blue,
  //                                         fontWeight: FontWeight.w400),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                           _bottomEntryField(),
  //                         ],
  //                       )),
  //                   Positioned(
  //                       right: 5,
  //                       bottom: fullWidth(context) * 0.18,
  //                       child: Padding(
  //                         padding: const EdgeInsets.all(8.0),
  //                         child: Column(
  //                           children: [
  //                             Material(
  //                               elevation: 10,
  //                               borderRadius: BorderRadius.circular(20),
  //                               child: SizedBox(
  //                                 width: fullWidth(context) * 0.2,
  //                                 height: fullWidth(context) * 0.2,
  //                                 child: customNetworkImage(
  //                                   widget.ductProduct?.imagePath,
  //                                   fit: BoxFit.cover,
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       )),
  //                   Positioned(
  //                     top: 10,
  //                     right: 20,
  //                     child: Container(
  //                         height: 60,
  //                         width: 60,
  //                         padding: const EdgeInsets.all(0),
  //                         decoration: const BoxDecoration(
  //                             shape: BoxShape.circle, color: Colors.white),
  //                         child: Material(
  //                           elevation: 10,
  //                           //borderRadius: BorderRadius.circular(100),
  //                           child: Stack(
  //                             children: [
  //                               Align(
  //                                 alignment: Alignment.center,
  //                                 child: Padding(
  //                                   padding: const EdgeInsets.all(10.0),
  //                                   child: customText(
  //                                       // formatter
  //                                       widget.ductProduct!.price,
  //                                       //     .format(widget.ductProduct.price),
  //                                       style: TextStyle(
  //                                           fontWeight: FontWeight.bold,
  //                                           fontSize:
  //                                               fullWidth(context) * 0.05),
  //                                       context: context),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         )),
  //                   )
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _bottomEntryField() {
    setWritingTo(bool val) {
      setState(() {
        isWriting = val;
      });
    }

    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: <Widget>[
                  Expanded(
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        frostedOrange(
                          TextField(
                            controller: textEditingController,
                            focusNode: textFieldFocus,
                            onTap: () => hideEmojiContainer(),
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            onChanged: (val) {
                              (val.isNotEmpty && val.trim() != "")
                                  ? setWritingTo(true)
                                  : setWritingTo(false);
                            },
                            maxLines: null,
                            decoration: const InputDecoration(
                              hintText: "Say Something",
                              hintStyle: TextStyle(color: Colors.white
//color: UniversalVariables.greyColor,
                                  ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(50.0),
                                  ),
                                  borderSide: BorderSide.none),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              filled: true,
//fillColor: UniversalVariables.separatorColor,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // if (!showEmojiPicker.value) {
                            //   // keyboard is visible
                            //   hideKeyboard();
                            //   showEmojiContainer();
                            // } else {
                            //   //keyboard is hidden
                            //   showKeyboard();
                            //   hideEmojiContainer();
                            // }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Material(
                              elevation: 5,
                              borderRadius: BorderRadius.circular(100),
                              child: CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.transparent,
                                child: Image.asset('assets/happy (1).png'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  isWriting
                      ? Container(
                          margin: const EdgeInsets.only(left: 10),
                          decoration: const BoxDecoration(
                              color: Colors.blueGrey,
                              //  gradient: UniversalVariables.fabGradient,
                              shape: BoxShape.circle),
                          child: IconButton(
                              icon: const Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                _submitButton(context);
                              }
                              //  statusInit == ChatStatus.blocked.index
                              //     ? null
                              //     : () => ductId != null
                              //         ? submitMessage(
                              //             textEditingController.text,
                              //             MessagesType.Products,
                              //             DateTime.now().millisecondsSinceEpoch,
                              //             ductId,
                              //           )
                              //         : chatUserProductId != null
                              //             ? submitMessage(
                              //                 textEditingController.text,
                              //                 MessagesType.ChatUserProducts,
                              //                 DateTime.now()
                              //                     .millisecondsSinceEpoch,
                              //                 chatUserProductId,
                              //               )
                              //             : myOrders != null
                              //                 ? submitMessage(
                              //                     textEditingController.text,
                              //                     MessagesType.MyOrders,
                              //                     DateTime.now()
                              //                         .millisecondsSinceEpoch,
                              //                     myOrders,
                              //                   )
                              //                 : _image != null
                              //                     ? submitMessage(
                              //                         textEditingController.text,
                              //                         MessagesType.Image,
                              //                         DateTime.now()
                              //                             .millisecondsSinceEpoch,
                              //                         null,
                              //                       )
                              //                     : submitMessage(
                              //                         textEditingController.text,
                              //                         MessagesType.Text,
                              //                         DateTime.now()
                              //                             .millisecondsSinceEpoch,
                              //                         null,
                              //                       ),
                              //    color: viewductWhite,
                              ),
                        )
                      : Container()
                ],
              ),
              showEmojiPicker.value
                  ? Container(child: emojiContainer())
                  : Container()
            ],
          ),
        ),
        width: double.infinity,
//height: 100.0,
      ),
    );
  }

  emojiContainer() {
    return SingleChildScrollView(
      child: FittedBox(
        fit: BoxFit.fill,
        child: Container(
          width: fullWidth(context),
          child: Row(
            children: const [
              // EmojiPicker(
              //   bgColor: UniversalVariables.separatorColor,
              //   indicatorColor: UniversalVariables.blueColor,
              //   rows: 3,
              //   columns: 7,
              //   onEmojiSelected: (emoji, category) {
              //     setState(() {
              //       isWriting = true;
              //     });

              //     textEditingController.text =
              //         textEditingController.text + emoji.emoji;
              //   },
              //   recommendKeywords: ["face", "happy", "party", "sad"],
              //   numRecommended: 50,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void addLikeToDuct(BuildContext context) {
    // var state = Provider.of<FeedState>(context, listen: false);
    // var authState = Provider.of<AuthState>(context, listen: false);
    // feedState.addLikeToDuct(widget.ductProduct!, authState.userId);
  }

  void onLikeTextPressed(BuildContext context) {
    // Navigator.of(context).push(
    //   CustomRoute<bool>(
    //     builder: (BuildContext context) => UsersListPage(
    //       pageTitle: "Liked by",
    //       userIdsList:
    //           widget.ductProduct!.likeList!.map((userId) => userId).toList(),
    //       emptyScreenText: "This tweet has no like yet",
    //       emptyScreenSubTileText:
    //           "Once a user likes this tweet, user list will be shown here",
    //     ),
    //   ),
    // );
  }

  Widget _commentRow(FeedModel model, BuildContext context) {
    return chatMessages(model, context);
  }

  BorderRadius getBorder(bool myMessage) {
    return BorderRadius.only(
      topLeft: const Radius.circular(20),
      topRight: const Radius.circular(20),
      bottomRight:
          myMessage ? const Radius.circular(0) : const Radius.circular(20),
      bottomLeft:
          myMessage ? const Radius.circular(20) : const Radius.circular(0),
    );
  }

  Widget chatMessages(
    FeedModel message,
    BuildContext context,
  ) {
    // if (senderId == null) {
    //   return Container();
    // }
    if (message.userId == "authState.user!.uid") {
      return _userComments(message, true);
    } else {
      return _userComments(message, false);
    }
  }

  Widget _userComments(FeedModel comment, bool myMessage) {
    return Column(
      crossAxisAlignment:
          myMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisAlignment:
          myMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            const SizedBox(
              width: 15,
            ),
            myMessage
                ? const SizedBox()
                : CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage:
                        customAdvanceNetworkImage(comment.user!.profilePic),
                  ),
            Expanded(
              child: Container(
                alignment:
                    myMessage ? Alignment.centerRight : Alignment.centerLeft,
                margin: EdgeInsets.only(
                  right: myMessage ? 10 : (fullWidth(context) / 4),
                  top: 20,
                  left: myMessage ? (fullWidth(context) / 4) : 10,
                ),
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: getBorder(myMessage),
                        color: myMessage ? Colors.grey : TwitterColor.mystic,
                      ),
                      child: UrlText(
                        text: comment.ductComment,
                        style: TextStyle(
                          fontSize: 16,
                          color: myMessage ? TwitterColor.white : Colors.black,
                        ),
                        urlStyle: TextStyle(
                          fontSize: 16,
                          color: myMessage
                              ? TwitterColor.white
                              : TwitterColor.dodgetBlue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: InkWell(
                        borderRadius: getBorder(myMessage),
                        onTap: () {
                          // onTapDuct(context);
                          // var text = ClipboardData(text: chat.ductComment);
                          // Clipboard.setData(text);
                          // _scaffoldKey.currentState.hideCurrentSnackBar();
                          // _scaffoldKey.currentState.showSnackBar(
                          //   SnackBar(
                          //     backgroundColor: TwitterColor.white,
                          //     content: Text(
                          //       'Message copied',
                          //       style: TextStyle(color: Colors.black),
                          //     ),
                          //   ),
                          // );
                        },
                        child: const SizedBox(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        customText(getPostTime2(comment.createdAt),
            style: const TextStyle(color: Colors.yellow)
            // Theme.of(context).textTheme.caption.copyWith(fontSize: 12),
            )
        // Padding(
        //   padding: EdgeInsets.only(right: 10, left: 10),
        //   child: Text(
        //     getChatTime(chat.createdAt),
        //     style: Theme.of(context).textTheme.caption.copyWith(fontSize: 12),
        //   ),
        // )
      ],
    );
  }

  void _message(BuildContext context, var state) async {
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        var appSize = MediaQuery.of(context).size;

        // double heightFactor = 300 / fullHeight(context);
        // var authState = Provider.of<AuthState>(context, listen: false);
        //var state = Provider.of<FeedState>(context, listen: false);
        // final List<FeedModel>? commentsList =
        //     // topDucts.value
        //     //     ? state.getTopDuctList(authState.userModel)
        //     //     : visibleSwitch.value
        //     //?
        //     state.ductComments(widget.ductProduct!.replyDuctKeyList);
        return frostedWhite(
          Container(
            padding: const EdgeInsets.only(top: 5, bottom: 0),
            height: fullHeight(context),
            // (type == TweetType.Tweet
            //     ? (isMyTweet ? .25 : .44)
            //     : (isMyTweet ? .38 : .52)),
            width: fullWidth(context),
            decoration: const BoxDecoration(
                // color: Theme.of(context).bottomSheetTheme.backgroundColor,
                // borderRadius: BorderRadius.only(
                //   topLeft: Radius.circular(20),
                //   topRight: Radius.circular(20),
                // ),
                ),
            child: Stack(
              children: [
                Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: appSize.width * 0.6,
                          width: appSize.width,
                          child:
                              //Column(children: [],)
                              CustomScrollView(
                            slivers: <Widget>[
                              SliverList(
                                delegate: SliverChildListDelegate(
                                  state.ductReplyMap.isEmpty ||
                                          state.ductReplyMap[postId] == null
                                      // state.ductReplyMap == null ||
                                      //         state.ductReplyMap.length == 0 ||
                                      //         state.ductReplyMap[widget
                                      //                 .model.replyDuctKeyList] ==
                                      //             null
                                      ? [
                                          const Center(
                                            child: Text(
                                              'No comments',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          )
                                        ]
                                      : state.ductReplyMap[postId]!
                                          .map((x) => _commentRow(x, context))
                                          .toList(),
                                ),
                              )
                            ],
                          ),
                        ),
                        const Divider(color: Colors.white),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(50),
                            elevation: 2,
                            color: Colors.teal,
                            child: frostedTeal(Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: customText('Commenting..',
                                  style: const TextStyle(color: Colors.white)),
                            )),
                          ),
                        ),
                        Row(
                          children: [
                            // Material(
                            //   borderRadius: BorderRadius.circular(100),
                            //   elevation: 20,
                            //   child: Container(
                            //     width: 40,
                            //     height: 40,
                            //     child: GestureDetector(
                            //       onTap: () {
                            //         // If tweet is displaying on someone's profile then no need to navigate to same user's profile again.
                            //         // if (isSearchPage) {
                            //         //   return;
                            //         // }
                            //         // Navigator.of(context).pushNamed(
                            //         //     '/ProfilePage/' + model?.userId);
                            //       },
                            //       child: customImage(context,
                            //           widget.ductProduct!.user!.profilePic),
                            //     ),
                            //   ),
                            // ),
                            frostedBlack(
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: UrlText(
                                  text: widget.ductProduct!.productDescription,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  urlStyle: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          ],
                        ),
                        _bottomEntryField(),
                      ],
                    )),
                Positioned(
                    right: 5,
                    bottom: fullWidth(context) * 0.18,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Material(
                            elevation: 10,
                            borderRadius: BorderRadius.circular(20),
                            child: SizedBox(
                              width: fullWidth(context) * 0.2,
                              height: fullWidth(context) * 0.2,
                              child: customNetworkImage(
                                widget.ductProduct!.imagePath,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        );
      },
    );
  }

  FeedModel createTweetModel() {
    // var state = Provider.of<FeedState>(context, listen: false);
    // var authState = Provider.of<AuthState>(context, listen: false);
    //var myUser = authState.userModel!;
    //  var profilePic = myUser.profilePic ?? dummyProfilePic;
    var commentedUser = ViewductsUser(
        // displayName: myUser.displayName ?? myUser.email!.split('@')[0],
        // profilePic: profilePic,
        // userId: myUser.userId,
        // isVerified: authState.userModel!.isVerified,
        // userName: authState.userModel!.userName
        );
    var tags = getHashTags(textEditingController.text);

    FeedModel reply = FeedModel(
        ductComment: textEditingController.text,
        user: commentedUser,
        cProduct: ductId,
        createdAt: DateTime.now().toUtc().toString(),
        tags: tags,
        parentkey:
            //  widget.isTweet
            //     ? null
            //     : widget.isRetweet
            //         ? null
            //:
            "feedState.ductToReplyModel!.value!.key",
        childVductkey:
            //  widget.isTweet
            //     ? null
            //     : widget.isRetweet
            //         ? model.key
            //         :
            null,
        userId: "myUser.userId");
    return reply;
  }

  /// Submit tweet to save in firebase database
  void _submitButton(BuildContext context) async {
    if (textEditingController.text.isEmpty ||
        textEditingController.text.length > 280) {
      return;
    }
    //  var state = Provider.of<FeedState>(context, listen: false);
    //kScreenloader.showLoader(context);

    FeedModel tweetModel = createTweetModel();
    //  feedState.addcommentToPost(tweetModel);

    /// If tweet contain image
    /// First image is uploaded on firebase storage
    /// After sucessfull image upload to firebase storage it returns image path
    /// Add this image path to tweet model and save to firebase database
    // if (_image != null) {
    //   await state.uploadFile(_image).then((imagePath) {
    //     if (imagePath != null) {
    //       tweetModel.imagePath = imagePath;

    //       /// If type of tweet is new tweet
    //       if (widget.isTweet) {
    //         state.createDuct(tweetModel);
    //       }

    //       /// If type of tweet is  retweet
    //       else if (widget.isRetweet) {
    //         state.createvDuct(tweetModel);
    //       }

    //       /// If type of tweet is new comment tweet
    //       else {
    //         state.addcommentToPost(tweetModel);
    //       }
    //     }
    //   });
    // }

    // /// if duct has a video
    // else if (_video != null && _thumbnail != null) {
    //   await state.uploadFile(_video).then((videoPath) async {
    //     if (videoPath != null) {
    //       tweetModel.videoPath = videoPath;

    //       await state.uploadFile(_thumbnail).then((thumbPath) {
    //         tweetModel.imagePath = thumbPath;
    //       });

    //       tweetModel.duration = _duration.toString();

    //       /// If type of tweet is new tweet
    //       if (widget.isTweet) {
    //         state.createDuct(tweetModel);
    //       }

    //       /// If type of tweet is  retweet
    //       else if (widget.isRetweet) {
    //         state.createvDuct(tweetModel);
    //       }

    //       /// If type of tweet is new comment tweet
    //       else {
    //         state.addcommentToPost(tweetModel);
    //       }
    //     }
    //   });
    // }

    // /// If tweet did not contain image
    // else {
    //   /// If type of tweet is new tweet
    //   if (widget.isTweet) {
    //     state.createDuct(tweetModel);
    //   }

    //   /// If type of tweet is  retweet
    //   else if (widget.isRetweet) {
    //     state.createvDuct(tweetModel);
    //   }

    //   /// If type of tweet is new comment tweet
    //   else {
    //     state.addcommentToPost(tweetModel);
    //   }
    // }

    /// Checks for username in tweet ductComment
    /// If foud sends notification to all tagged user
    /// If no user found or not compost tweet screen is closed and redirect back to home page.
    // await composeductState.sendNotification(tweetModel, searchState).then((_) {
    //   textEditingController.clear();

    //   /// Hide running loader on screen
    //   // kScreenloader.hideLoader();

    //   /// Navigate back to home page
    //   //  Navigator.pop(context);
    // });
  }

//   OverlayEntry _insight(BuildContext contexts) {
//     var appSize = MediaQuery.of(context).size;
//     final NumberFormat formatter = NumberFormat.simpleCurrency(
//       decimalDigits: 0,
//       locale: Localizations.localeOf(context).toString(),
//     );
//     // final state = searchState;
//     // // double heightFactor = 300 / fullHeight(context);
//     // var authState = Provider.of<AuthState>(context, listen: false);
//     // var feedState = Provider.of<FeedState>(context, listen: false);
//     List<ViewductsUser>? userList =
//         searchState.getVendors(authState.userModel!.location);
//     // var userImage = state.chatUser.profilePic;
//     // String id = widget.userProfileId ?? state.chatUser.userId;

//     FeedModel model;
//     return OverlayEntry(
//       builder: (context) {
//         List<FeedModel>? list = feedState.getStoreProductList(authState.userId);

//         if (feedState.feedlist != null && feedState.feedlist!.isNotEmpty) {
//           list = feedState.getStoreProductList(authState.userId);
//           // .where((x) => x.userId == id)
//           // .toList();
//         }
//         return GestureDetector(
//           onTap: () {
//             if (isDropdown.value) {
//               floatingMenu.remove();
//             } else {
//               // _postProsductoption();
//               floatingMenu = _insight(context);
//               Overlay.of(context)!.insert(floatingMenu);
//             }

//             isDropdown.value = !isDropdown.value;
//           },
//           child: Material(
//             color: Colors.transparent,
//             child: frostedOrange(
//               Container(
//                 height: appSize.width,
//                 width: appSize.width,
//                 child: Stack(
//                   children: [
//                     Positioned(
//                       bottom: appSize.width * 0.1,
// //                        right: xPosiion - appSize.width * 0.5,
//                       right: xPosiion,
//                       // width: width,
//                       // height: 4 + height + 40,
//                       child: Container(
//                         height: appSize.height,
//                         width: appSize.width,
//                         child: Stack(
//                           children: [
//                             Positioned(
//                               top: fullWidth(context) * 0.2,
//                               left: 0,
//                               right: 0,
//                               child: Container(
//                                 height: fullHeight(context),
//                                 width: fullWidth(context),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     Container(
//                                       height: fullWidth(context),
//                                       width: fullWidth(context),
//                                       child: SfCircularChart(
//                                           legend: Legend(isVisible: true),
//                                           title: ChartTitle(
//                                               text: 'Detailed Analysis',
//                                               textStyle: const TextStyle(
//                                                   fontWeight: FontWeight.w800)),
//                                           series: <
//                                               PieSeries<SalesData, String>>[
//                                             PieSeries<SalesData, String>(
//                                               dataSource: <SalesData>[
//                                                 SalesData('Clicks', 100),
//                                                 SalesData('Conversion', 380),
//                                                 SalesData('Customers', 300),
//                                                 SalesData('Male', 168),
//                                                 SalesData('female', 132),
//                                               ],
//                                               xValueMapper: (sales, index) =>
//                                                   sales.year,
//                                               yValueMapper: (sales, index) =>
//                                                   sales.sales,
//                                             ),
//                                           ]),
//                                     ),
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Row(
//                                           children: [
//                                             frostedPink(Padding(
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                               child: customTitleText(
//                                                 'Product Sales:',
//                                               ),
//                                             )),
//                                             const Padding(
//                                               padding: EdgeInsets.all(8.0),
//                                               child: Text(
//                                                 '546',
//                                                 style: TextStyle(
//                                                   color: Colors.blueGrey,
//                                                   fontWeight: FontWeight.w800,
//                                                   fontSize: 20,
//                                                 ),
//                                               ),
//                                             )
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Row(
//                                           children: [
//                                             frostedPink(Padding(
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                               child: customTitleText(
//                                                 'Product Profit:',
//                                               ),
//                                             )),
//                                             Padding(
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                               child: Text(
//                                                 formatter.format(15673.14),
//                                                 style: const TextStyle(
//                                                   color: Colors.red,
//                                                   fontWeight: FontWeight.w800,
//                                                   fontSize: 20,
//                                                 ),
//                                               ),
//                                             )
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Row(
//                                           children: [
//                                             frostedPink(Padding(
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                               child: customTitleText(
//                                                 'Clicks:',
//                                               ),
//                                             )),
//                                             const Padding(
//                                               padding: EdgeInsets.all(8.0),
//                                               child: Text(
//                                                 '1567',
//                                                 style: TextStyle(
//                                                   color: Colors.blueGrey,
//                                                   fontWeight: FontWeight.w800,
//                                                   fontSize: 20,
//                                                 ),
//                                               ),
//                                             )
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Row(
//                                           children: [
//                                             frostedPink(Padding(
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                               child: customTitleText(
//                                                 'Product',
//                                               ),
//                                             )),
//                                             const Padding(
//                                               padding: EdgeInsets.all(8.0),
//                                               child: Text(
//                                                 'live',
//                                                 style: TextStyle(
//                                                   color: Colors.green,
//                                                   fontWeight: FontWeight.w800,
//                                                   fontSize: 20,
//                                                 ),
//                                               ),
//                                             )
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Row(
//                                           children: [
//                                             frostedPink(Padding(
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                               child: customTitleText(
//                                                 'Promotion',
//                                               ),
//                                             )),
//                                             const Padding(
//                                               padding: EdgeInsets.all(8.0),
//                                               child: Text(
//                                                 'Active',
//                                                 style: TextStyle(
//                                                   color: Colors.green,
//                                                   fontWeight: FontWeight.w800,
//                                                   fontSize: 20,
//                                                 ),
//                                               ),
//                                             )
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             Positioned(
//                               bottom: fullWidth(context) * 0.3,
//                               right: 10,
//                               child: Material(
//                                 elevation: 20,
//                                 borderRadius: BorderRadius.circular(20),
//                                 child: frostedPink(Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: customTitleText(
//                                     'Promote',
//                                   ),
//                                 )),
//                               ),
//                             ),
//                             Positioned(
//                               top: fullWidth(context) * 0.4,
//                               child: Container(
//                                 width: fullWidth(context),
//                                 child: Column(
//                                   children: [
//                                     Material(
//                                       borderRadius: BorderRadius.circular(20),
//                                       color: Colors.transparent,
//                                       child: ExpandableNotifier(
//                                           child: ScrollOnExpand(
//                                               child: Column(
//                                         children: [
//                                           ExpandablePanel(
//                                             theme: const ExpandableThemeData(
//                                               headerAlignment:
//                                                   ExpandablePanelHeaderAlignment
//                                                       .center,
//                                               tapBodyToExpand: true,
//                                               tapBodyToCollapse: true,
//                                               hasIcon: false,
//                                             ),
//                                             header: Stack(
//                                               children: [
//                                                 Row(
//                                                   children: [
//                                                     Row(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .spaceBetween,
//                                                       children: [
//                                                         Row(
//                                                           children: [
//                                                             frostedPink(Padding(
//                                                               padding:
//                                                                   const EdgeInsets
//                                                                       .all(8.0),
//                                                               child:
//                                                                   customTitleText(
//                                                                 'Customers',
//                                                               ),
//                                                             )),
//                                                           ],
//                                                         ),
//                                                         ExpandableIcon(
//                                                           theme:
//                                                               const ExpandableThemeData(
//                                                             expandIcon: Icons
//                                                                 .keyboard_arrow_right,
//                                                             collapseIcon: Icons
//                                                                 .keyboard_arrow_down,
//                                                             iconSize: 28.0,
//                                                             iconRotationAngle:
//                                                                 math.pi / 2,
//                                                             iconPadding:
//                                                                 EdgeInsets.only(
//                                                                     right: 5),
//                                                             hasIcon: false,
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ],
//                                                 )
//                                               ],
//                                             ),
//                                             expanded: Padding(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       vertical: 15.0),
//                                               child: frostedWhite(
//                                                 Container(
//                                                   width: fullWidth(context),
//                                                   child: Column(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment.start,
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: <Widget>[
//                                                       userList == null
//                                                           ? Container()
//                                                           : Container(
//                                                               width:
//                                                                   appSize.width,
//                                                               height: userList.length ==
//                                                                       1
//                                                                   ? fullWidth(
//                                                                           context) *
//                                                                       0.2
//                                                                   : appSize
//                                                                           .width *
//                                                                       0.5,
//                                                               child: ListView
//                                                                   .separated(
//                                                                 addAutomaticKeepAlives:
//                                                                     false,
//                                                                 physics:
//                                                                     const BouncingScrollPhysics(),
//                                                                 itemBuilder:
//                                                                     (context,
//                                                                             index) =>
//                                                                         Padding(
//                                                                   padding:
//                                                                       const EdgeInsets
//                                                                               .all(
//                                                                           8.0),
//                                                                   child: _Customers(
//                                                                       user: userList[
//                                                                           index]),
//                                                                 ),
//                                                                 separatorBuilder:
//                                                                     (_, index) =>
//                                                                         const Divider(
//                                                                   height: 0,
//                                                                 ),
//                                                                 itemCount:
//                                                                     userList
//                                                                         .length,
//                                                               ),
//                                                             ),
//                                                       const SizedBox(
//                                                         height: 20,
//                                                       )
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             collapsed: Container(),
//                                             // expanded: Column(
//                                             //   children: [],
//                                             // ),
//                                           )
//                                         ],
//                                       ))),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

  Widget _likeCommentsIcons(BuildContext context, FeedModel model) {
    // var authState = Provider.of<AuthState>(context, listen: false);
    final NumberFormat formatter = NumberFormat.simpleCurrency(
      decimalDigits: 0,
      locale: Localizations.localeOf(context).toString(),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: frostedYellow(
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    InkWell(
                        child: Image.asset(
                          'assets/reshare.png',
                          width: 25,
                        ),
                        //  ImageIcon(
                        //   AssetImage('assets/reshare.png'),
                        //   size: 25,
                        //   color: Colors.blueGrey[300],
                        // ),
                        //Icon(CupertinoIcons.circle),
                        onTap: () {
                          _vDuct(context);
                          // DuctBottomSheet()
                          //     .openvDuctbottomSheet(context, type, model);
                        }),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        isDuctDetail ? '' : model.vductCount.toString(),
                      ),
                    )
                  ],
                ),
                widget.type == DuctType.Detail
                    ? Container()
                    : Row(
                        children: [
                          InkWell(
                              child: Image.asset(
                                'assets/chatchat.png',
                                width: 25,
                              ),
                              //  ImageIcon(
                              //   AssetImage('assets/comment.png'),
                              //   size: 25,
                              //   // color: Colors.blueGrey[300],
                              // ),
                              onTap: () {
                                // var state = Provider.of<FeedState>(context,
                                //     listen: false);
                                //  state.clearAllDetailAndReplyDuctStack();
                                // feedState.getpostDetailFromDatabase(null,
                                //     model: model);
                                // state.setDuctToReply = widget.model;
                                // _message(context, feedState);
                                // Navigator.of(context)

                                // //     .pushNamed('/ComposeTweetPage');
                                // Navigator.of(context)
                                //   .pushNamed('/FeedPostDetail/' + model.key);
                              }),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              isDuctDetail ? '' : model.commentCount.toString(),
                            ),
                          )
                        ],
                      ),
                // _iconWidget(
                //   context,
                //   text: isDuctDetail ? '' : model.commentCount.toString(),
                //   icon: AppIcon.reply,
                //   iconColor: iconColor,
                //   size: size ?? 20,
                //   onPressed: () {
                //     var state = Provider.of<FeedState>(context, listen: false);
                //     state.setDuctToReply = model;
                //     Navigator.of(context).pushNamed('/ComposeTweetPage');
                //   },
                // ),
                // _iconWidget(context,
                //     text:
                //     icon: AppIcon.retweet,
                //     iconColor: iconColor,
                //     size: size ?? 20, onPressed: () {

                // }),
                _iconWidget(
                  context,
                  text: isDuctDetail ? '' : model.likeCount.toString(),
                  icon: model.likeList!
                          .any((userId) => userId == "authState.userId")
                      ? AppIcon.heartFill
                      : AppIcon.heartEmpty,
                  onPressed: () {
                    addLikeToDuct(context);
                  },
                  iconColor: model.likeList!
                          .any((userId) => userId == "authState.userId")
                      ? iconEnableColor
                      : iconColor,
                  size: size ?? 20,
                ),
                // _iconWidget(context, text: '', icon: null, sysIcon: Icons.share,
                //     onPressed: () {
                //   share('${model.description}',
                //       subject: '${model.user.displayName}\'s post');
                // }, iconColor: iconColor, size: size ?? 20),
                // model.caption == 'product'
                //     ? Text(
                //         formatter.format(model.price),
                //         style: TextStyle(
                //           color: Colors.red,
                //           fontWeight: FontWeight.w800,
                //           fontSize: 20,
                //         ),
                //       )
                //     // formatter.format(model.price)

                //     // Row(
                //     //     children: [
                //     //       ImageIcon(
                //     //         AssetImage('assets/naira.png'),
                //     //         size: fullWidth(context) * 0.05,
                //     //         color: Colors.grey,
                //     //       ),
                //     //       Text(
                //     //         '${model.price}',
                //     //         style: TextStyle(
                //     //             fontWeight: FontWeight.bold,
                //     //             color: Colors.green,
                //     //             fontSize: 18),
                //     //       )
                //     //     ],
                //     //   )
                //     : Container()
              ],
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: <Widget>[
            //     Row(
            //       children: [
            //         InkWell(
            //             child: ImageIcon(
            //               AssetImage('assets/comment.png'),
            //               size: 25,
            //               color: Colors.blueGrey[300],
            //             ),
            //             onTap: () {
            //               var state =
            //                   Provider.of<FeedState>(context, listen: false);
            //               state.setDuctToReply = model;
            //               Navigator.of(context).pushNamed('/ComposeTweetPage');
            //             }),
            //         Padding(
            //           padding: const EdgeInsets.all(8.0),
            //           child: Text(
            //             widget.ductProduct.commentCount.toString(),
            //           ),
            //         )
            //       ],
            //     ),
            //     Row(
            //       children: [
            //         InkWell(
            //             child: Icon(CupertinoIcons.circle),
            //             onTap: () {
            //               DuctBottomSheet()
            //                   .openvDuctbottomSheet(context, type, model);
            //             }),
            //         Padding(
            //           padding: const EdgeInsets.all(8.0),
            //           child: Text(
            //             widget.ductProduct.vductCount.toString(),
            //           ),
            //         )
            //       ],
            //     ),
            //     _iconWidget(
            //       context,
            //       text: widget.ductProduct.likeCount.toString(),
            //       icon: widget.ductProduct.likeList
            //               .any((userId) => userId == authState.userId)
            //           ? AppIcon.heartFill
            //           : AppIcon.heartEmpty,
            //       onPressed: () {
            //         addLikeToDuct(context);
            //       },
            //       iconColor: widget.ductProduct.likeList
            //               .any((userId) => userId == authState.userId)
            //           ? iconEnableColor
            //           : iconColor,
            //       size: size ?? 20,
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  // Widget _likeCommentWidget(BuildContext context) {
  //   bool isLikeAvailable = widget.ductProduct.likeCount != null
  //       ? widget.ductProduct.likeCount > 0
  //       : false;
  //   bool isRetweetAvailable = widget.ductProduct.vductCount > 0;
  //   bool isLikeRetweetAvailable = isRetweetAvailable || isLikeAvailable;
  //   return Column(
  //     children: <Widget>[
  //       Divider(
  //         endIndent: 10,
  //         height: 0,
  //       ),
  //       AnimatedContainer(
  //         padding:
  //             EdgeInsets.symmetric(vertical: isLikeRetweetAvailable ? 12 : 0),
  //         duration: Duration(milliseconds: 500),
  //         child: !isLikeRetweetAvailable
  //             ? SizedBox.shrink()
  //             : Row(
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: <Widget>[
  //                   !isRetweetAvailable
  //                       ? SizedBox.shrink()
  //                       : customText(widget.ductProduct.vductCount.toString(),
  //                           style: TextStyle(fontWeight: FontWeight.bold)),
  //                   !isRetweetAvailable
  //                       ? SizedBox.shrink()
  //                       : SizedBox(width: 5),
  //                   AnimatedCrossFade(
  //                     firstChild: SizedBox.shrink(),
  //                     secondChild: customText('Retweets', style: subtitleStyle),
  //                     crossFadeState: !isRetweetAvailable
  //                         ? CrossFadeState.showFirst
  //                         : CrossFadeState.showSecond,
  //                     duration: Duration(milliseconds: 800),
  //                   ),
  //                   !isRetweetAvailable
  //                       ? SizedBox.shrink()
  //                       : SizedBox(width: 20),
  //                   InkWell(
  //                     onTap: () {
  //                       onLikeTextPressed(context);
  //                     },
  //                     child: AnimatedCrossFade(
  //                       firstChild: SizedBox.shrink(),
  //                       secondChild: Row(
  //                         children: <Widget>[
  //                           customSwitcherWidget(
  //                             duraton: Duration(milliseconds: 300),
  //                             child: customText(
  //                                 widget.ductProduct.likeCount.toString(),
  //                                 style: TextStyle(fontWeight: FontWeight.bold),
  //                                 key: ValueKey(widget.ductProduct.likeCount)),
  //                           ),
  //                           SizedBox(width: 5),
  //                           customText('Likes', style: subtitleStyle)
  //                         ],
  //                       ),
  //                       crossFadeState: !isLikeAvailable
  //                           ? CrossFadeState.showFirst
  //                           : CrossFadeState.showSecond,
  //                       duration: Duration(milliseconds: 300),
  //                     ),
  //                   )
  //                 ],
  //               ),
  //       ),
  //       !isLikeRetweetAvailable
  //           ? SizedBox.shrink()
  //           : Divider(
  //               endIndent: 10,
  //               height: 0,
  //             ),
  //     ],
  //   );
  // }

  // void onLikeTextPressed(BuildContext context) {
  //   Navigator.of(context).push(
  //     CustomRoute<bool>(
  //       builder: (BuildContext context) => UsersListPage(
  //         pageTitle: "Liked by",
  //         userIdsList:
  //             widget.ductProduct.likeList.map((userId) => userId).toList(),
  //         emptyScreenText: "This tweet has no like yet",
  //         emptyScreenSubTileText:
  //             "Once a user likes this tweet, user list will be shown here",
  //       ),
  //     ),
  //   );
  // }

  // void addLikeToDuct(BuildContext context) {
  //   var state = Provider.of<FeedState>(context, listen: false);
  //   var authState = Provider.of<AuthState>(context, listen: false);
  //   state.addLikeToDuct(widget.ductProduct, authState.userId);
  // }

  Widget _iconWidget(BuildContext context,
      {String? text,
      int? icon,
      Function? onPressed,
      IconData? sysIcon,
      Color? iconColor,
      double size = 20}) {
    return Expanded(
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: () {
              if (onPressed != null) onPressed();
            },
            icon: sysIcon != null
                ? Icon(sysIcon, color: iconColor, size: size)
                : customIcon(
                    context,
                    size: size,
                    icon: icon!,
                    istwitterIcon: true,
                    iconColor: iconColor,
                  ),
          ),
          customText(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: iconColor,
              fontSize: size - 5,
            ),
            context: context,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(
      decimalDigits: 0,
      locale: Localizations.localeOf(context).toString(),
    );
    // var authState = Provider.of<AuthState>(context);
    // var state = Provider.of<FeedState>(context);
    // String? id = widget.profileId ?? authState.userId;
    // List<FeedModel> list;

    // if (feedState.feedlist != null && feedState.feedlist!.isNotEmpty) {
    //   list = feedState.feedlist!.where((x) => x.userId == id).toList();
    // }
    final ThemeData theme = Theme.of(context);

    // final Image imageWidget = Image.asset(
    //   widget.ductProduct.productName,
    //   package: widget.ductProduct.imageList[0],
    //   fit: BoxFit.cover,
    // );

    // return Consumer<FeedState>(
    //   builder: (
    //     context,
    //     value,
    //     child,
    //   ) {
    return GestureDetector(
        onTap: () {
          if (type == DuctType.ParentDuct) {
            return;
          }

          // // var state = Provider.of<FeedState>(context, listen: false);
          // feedState.getpostDetailFromDatabase(null, model: widget.ductProduct);
          // // state.getpostDetailFromDatabase(widget.model.key);
          // feedState.setDuctToReply = widget.ductProduct.obs;

          // Navigator.pushNamed(context, '/ItemDetailspage');

          //_videoView(context);

          if (isDropdown.value) {
            floatingMenu.remove();
          } else {
            //  _postProsductoption();
            // floatingMenu = _mediaView(context, feedState);
            // Overlay.of(context)!.insert(floatingMenu);
          }

          isDropdown.value = !isDropdown.value;

          // var state = Provider.of<FeedState>(context, listen: false);
          // state.getpostDetailFromDatabase(widget.ductProduct.key);
          // state.setDuctToReply = widget.ductProduct;
          // Navigator.pushNamed(context, '/ItemDetailspage');
          // Navigator.of(context).push(MaterialPageRoute(
          //     builder: (context) => ItemDetailspage(
          //           ductProduct: widget.ductProduct,
          //           heroTag: !imageNotready.value
          //               ? 'assets/smartphone.png'
          //               : widget.ductProduct.imagePath,
          //         )));
          //  model.addProductToCart(ductProduct.id);
        },
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 5,
              top: fullWidth(context) * 0.3,
              child: Column(
                children: [
                  Material(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blueGrey[50],
                        gradient: LinearGradient(
                          colors: [
                            Colors.black87.withOpacity(0.1),
                            Colors.black87.withOpacity(0.2),
                            Colors.black87.withOpacity(0.3)
                            // Color(0xfffbfbfb),
                            // Color(0xfff7f7f7),
                          ],
                          // begin: Alignment.topCenter,
                          // end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.ductProduct == null
                              ? ''
                              : widget.ductProduct!.price!,
                          // formatter.format(widget.ductProduct.price),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // IconButton(
                  //     iconSize: 40,
                  //     icon: Icon(
                  //       CupertinoIcons.add_circled_solid,
                  //     ),
                  //     onPressed: () {
                  //       state.productToCart(widget.ductProduct);
                  //     }),
                ],
              ),
            ),
            Positioned(
              top: fullWidth(context) * 0.1,
              right: 0,
              child: Material(
                elevation: 10,
                shadowColor: TwitterColor.mystic,
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(100),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 5),
                      shape: BoxShape.circle),
                  child: RippleButton(
                    // child: customImage(
                    //   context,
                    //   widget.ductProduct!.user!.profilePic,
                    //   height: 40,
                    // ),
                    borderRadius: BorderRadius.circular(50),
                    onPressed: () {
                      // Get.to(() => ProfilePage(
                      //       profileId: widget.ductProduct!.user!.userId,
                      //       profileType: ProfileType.Store,
                      //     ));

                      // Navigator.of(context).pushNamed("/Stores/",
                      //     arguments: _ItemCard(
                      //       profileId: widget.ductProduct.user.userId,
                      //     ));
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              right: 10,
              bottom: fullWidth(context) * 0.2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    _opTions(context);
                  },
                  child: Container(
                      padding: const EdgeInsets.all(0),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.yellow),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: customTitleText(''),
                      )),
                ),
              ),
            ),
          ],
        ));
  }
}

class ProductItemWidget extends StatelessWidget {
  final ProductModel? cartItem;

  const ProductItemWidget({Key? key, this.cartItem}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network(
            '${cartItem!.imagePath}',
            width: 80,
          ),
        ),
        Expanded(
            child: Wrap(
          direction: Axis.vertical,
          children: [
            Container(
                padding: const EdgeInsets.only(left: 14),
                child: Text(
                  '${cartItem!.productName}',
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () {
                      //cartController.decreaseQuantity(cartItem);
                    }),
                // Padding(
                //   padding:
                //   const EdgeInsets.all(
                //       8.0),
                //   child: CustomText(
                //     text: cartItem!.stockQauntity.toString(),
                //   ),
                // ),
                IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () {
                      //cartController.increaseQuantity(cartItem);
                    }),
              ],
            )
          ],
        )),
        // Padding(
        //   padding:
        //   const EdgeInsets.all(14),
        //   child: CustomText(
        //     text: "\$${cartItem.cost}",
        //     size: 22,
        //     weight: FontWeight.bold,
        //   ),
        // ),
      ],
    );
  }
}
