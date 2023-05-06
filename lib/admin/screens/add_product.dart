// ignore_for_file: unnecessary_statements, prefer_typing_uninitialized_variables, duplicate_ignore, deprecated_member_use, body_might_complete_normally_nullable, unused_element

import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as appModels;
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aws_s3_client/flutter_aws_s3_client.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_paystack_payment/flutter_paystack_payment.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:minio/io.dart';
import 'package:minio/minio.dart';
import 'package:status_alert/status_alert.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:uuid/uuid.dart';
import 'package:viewducts/admin/Admin_dashbord/constants.dart';
import 'package:viewducts/admin/db/product.dart';
import 'package:viewducts/admin/screens/video_admin_upload.dart';
import 'package:viewducts/helper/theme.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/chatModel.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/model/fileModel.dart';
import 'package:path/path.dart' as path;
import 'package:viewducts/page/message/chatScreenPage.dart';
import 'package:viewducts/state/feedState.dart';
import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/frosted.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
//import 'package:fluttertoast/fluttertoast.dart';

class AddProduct extends StatefulWidget {
  final bool isTweet;
  final bool isRetweet;
  final userId;

  const AddProduct(
      {Key? key, this.isTweet = false, this.isRetweet = false, this.userId})
      : super(key: key);
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final FeedState _feedState = FeedState();
  ProductService productService = ProductService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController searchController = TextEditingController();
  TextEditingController searchControllerColors = TextEditingController();
  TextEditingController productStateController = TextEditingController();
  TextEditingController productLocationController = TextEditingController();
  TextEditingController productBrandController = TextEditingController();
  TextEditingController productNameController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  TextEditingController shippingFeeController = TextEditingController();

  TextEditingController keyWord = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController shippingController = TextEditingController();
  TextEditingController commissionController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  List<appModels.Document> types = <appModels.Document>[];
  TextEditingController textEditingController = TextEditingController();
  List<appModels.Document> groceriesCategory = <appModels.Document>[];
  List<appModels.Document> electronicsCategory = <appModels.Document>[];
  List<appModels.Document> fashionCategory = <appModels.Document>[];
  List<appModels.Document> housingCategory = <appModels.Document>[];
  List<appModels.Document> farmCategory = <appModels.Document>[];
  List<appModels.Document> booksCategory = <appModels.Document>[];
  List<appModels.Document> section = <appModels.Document>[];
  List<appModels.Document> childrenCategory = <appModels.Document>[];
  List<DropdownMenuItem<String>> sectionDropDown = <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> childrenCategoriesDropDown =
      <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> fashionCategoriesDropDown =
      <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> groceriesCategoriesDropDown =
      <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> electronicsCategoriesDropDown =
      <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> booksCategoriesDropDown =
      <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> housingCategoriesDropDown =
      <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> farmCategoriesDropDown =
      <DropdownMenuItem<String>>[];

  List<DropdownMenuItem<String>> typesDropDown = <DropdownMenuItem<String>>[];
  late FeedModel model;
  RxDouble commissionP = 0.0.obs;
  RxInt? sellingPrice;
  String? totalPrice;
  String? _currentCategory;
  String? _currentFashionCategory;
  String? _currentFarmCategory;
  String? _currentChildrenCategory;
  String? _currentElectronicsCategory;
  String? _currentGroceriesCategory;
  String? _currentHousingCategory;
  String? _currentBooksCategory;
  String? _currentType;
  String? _currentSection;
  late VideoPlayerController _controller;
  Color white = Colors.white;
  Color black = Colors.black;
  Color grey = Colors.grey;
  Color red = Colors.red;
  double? commissionPrice;
  List<String> selectedSizes = <String>[];
  List<String> selectedColors = <String>[];
  File? _video;
  File? _image1;
  File? _image2;
  File? _image3;
  Duration? _duration;
  bool isLoading = false,
      _childrenSection = true,
      _electronicsSection = true,
      _groceriesSection = true,
      _booksSection = true,
      _housingSection = true,
      _farmSection = true,
      // ignore: unused_field
      _cakeGroceriesCategory = true,
      // ignore: unused_field
      _fruitsGroceriesCategory = true,
      _adultfashionSection = true;
  InitPaymentModel? userPayment;
  double? _stockNumber = 0.0;
  final plugin = PaystackPayment();
  String backendUrl = 'https://api.paystack.co';
  var publicKey = userCartController.wasabiAws.value.payStackPublickey;
  @override
  void initState() {
    plugin.initialize(publicKey: publicKey.toString());
    getDate();
    _getChildrenCategories();
    _getElectronicsCategories();
    _getFashionCategories();
    _getGroceriesCategories();
    _getBooksCategories();
    _getFarmCategories();
    _getHousingCategories();
    _getTypes();
    _getSections();
    super.initState();
  }

  _clear({String? ref}) async {
    // var auth = Provider.of<AuthState>(context, listen: false);
    //setState(() => _inProgress = true);
    _formKey.currentState?.save();

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

  _updateStatus(String reference, String message) {
    _showMessage('Reference: $reference \n Response: $message',
        const Duration(seconds: 7));
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

  _startAfreshCharge() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // int amt = await int.tryParse(userPayment?.totalPrice.toString() ?? '0') ?? 0;
      // Charge charge = Charge();
      Charge charge = Charge()
        ..amount = int.tryParse(userPayment!.totalPrice!.toString())! * 100
        ..reference = _getReference()
        ..accessCode = await _fetchAccessCodeFrmServer(_getReference())
        // or ..accessCode = _getAccessCodeFrmInitialization()
        ..email = authState.userModel?.email;

      // charge.card = _getCardFromUI();
      // charge.accessCode = await _fetchAccessCodeFrmServer(_getReference());
      _chargeCard(charge);
    }
  }

  getDate() async {
    try {
      final database = Databases(
        clientConnect(),
      );
      await database.listDocuments(
          databaseId: databaseId,
          collectionId: vendorColl,
          queries: [
            Query.equal('vendorId', authState.appUser?.$id)
          ]).then((data) {
        // if (data.documents.isNotEmpty) {
        var value =
            data.documents.map((e) => VendorModel.fromJson(e.data)).toList();

        setState(() {
          userCartController.venDor.value = value
              .firstWhere((data) => data.vendorId == authState.appUser?.$id);
        });
        //}
      });
      await database.listDocuments(
          databaseId: databaseId,
          collectionId: sectionCollection,
          queries: [
            Query.equal('section', userCartController.venDor.value.storeType)
          ]).then((data) {
        //  if (data.documents.isNotEmpty) {
        var value =
            data.documents.map((e) => SectionModel.fromJson(e.data)).toList();

        setState(() {
          userCartController.categorySection.value = value.firstWhere((data) =>
              data.section == userCartController.venDor.value.storeType);
        });
        //  }
      });
      await database
          .getDocument(
              databaseId: databaseId,
              collectionId: initPayment,
              documentId: authState.appUser!.$id)
          .then((doc) {
        setState(() {
          userPayment = InitPaymentModel.fromJson(doc.data);
        });
      });
    } on AppwriteException catch (e) {
      if (kDebugMode) {
        cprint(e.toString());
      }
    }
  }

  int comissionValue =
      userCartController.categorySection.value.categoryCommission ?? 0;
// ignore: prefer_const_constructors
  var id = Uuid().v1();
  // ignore: prefer_typing_uninitialized_variables
  var selectedItemsSizes;
  var selectedItemsColors;
  var selectedItemsShoeSize;
  String region = "us-east-1";
  String bucketId = "storage-viewduct";
  String accessKey = "I6AC8ZFJQ5Z75PC9HXLA";
  String secretKey = "qdiwW0clT8558Ual2NT8IVcqq7kByFMLCBBkERuO";
  bool isUploading = false;
  bool isUploadingStateError = false;
  _submitButton({String? ref}) async {
    try {
      if (_formKey.currentState!.validate()) {
        // var state = Provider.of<FeedState>(context, listen: false);

        FeedModel tweetModel = createTweetModel();
        tweetModel.reference = ref;

        /// If tweet contain image
        /// First image is uploaded on firebase storage
        /// After sucessfull image upload to firebase storage it returns image path
        /// Add this image path to tweet model and save to firebase database
        if (_image1 != null && _video != null) {
          setState(() {
            isUploading = true;
            isUploadingStateError = false;
          });
          // kScreenloader.showLoader(context);
          Storage storage = Storage(clientConnect());
          String imageName =
              '${DateTime.now().toUtc().toString().replaceAll(RegExp(r'\.\d*Z$'), 'Z').replaceAll(RegExp(r'[:-]|\.\d{3}'), '').split(' ').join('T')}${path.extension(_image1!.path)}';
          await storage
              .createFile(
                  bucketId: productBucketId,
                  fileId: "unique()",
                  file: InputFile(path: _image1?.path, filename: imageName))
              .then((storageFilePath) {
            tweetModel.imagePath = storageFilePath.$id;
            cprint('image uploapded');
          }).then((value) async {
            // Storage storage = Storage(clientConnect());
            // await storage
            //     .createFile(
            //         bucketId: productBucketId,
            //         fileId: "unique()",
            //         file: InputFile(path: _video?.path))
            //     .then((storageFilePath) {
            //   tweetModel.videoPath = storageFilePath.$id;
            //   tweetModel.duration = _duration?.inSeconds.toString();
            // });
            final keyImagePath =
                '${DateTime.now().toUtc().toString().replaceAll(RegExp(r'\.\d*Z$'), 'Z').replaceAll(RegExp(r'[:-]|\.\d{3}'), '').split(' ').join('T')}${path.extension(_image1!.path.toString())}';
            final AwsS3Client s3client = AwsS3Client(
                region: userCartController.wasabiAws.value.region.toString(),
                host: "s3.wasabisys.com",
                bucketId: "storage-viewduct",
                accessKey:
                    userCartController.wasabiAws.value.accessKey.toString(),
                secretKey:
                    userCartController.wasabiAws.value.secretKey.toString());
            final minio = Minio(
                endPoint:
                    userCartController.wasabiAws.value.endPoint.toString(),
                accessKey:
                    userCartController.wasabiAws.value.accessKey.toString(),
                secretKey:
                    userCartController.wasabiAws.value.secretKey.toString(),
                region: userCartController.wasabiAws.value.region.toString());

            await minio
                .fPutObject(
                    userCartController.wasabiAws.value.buckedId.toString(),
                    keyImagePath,
                    _image1!.path.toString())
                .onError((error, stackTrace) {
              setState(() {
                isUploading = false;
                isUploadingStateError = true;
              });
              Fluttertoast.showToast(
                msg: 'Network timeout',
                // toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP_LEFT,
                timeInSecForIosWeb: 10,
                backgroundColor: CupertinoColors.systemRed,
              );
              if (kDebugMode) {
                cprint(error.toString());
              }
              return error.toString();
            });
            var uplodedImagePath =
                await s3client.buildSignedGetParams(key: keyImagePath).uri;
            // final AwsS3Client s3client = AwsS3Client(
            //     region: region,
            //     host: "s3.wasabisys.com",
            //     bucketId: bucketId,
            //     accessKey: "I6AC8ZFJQ5Z75PC9HXLA",
            //     secretKey: "qdiwW0clT8558Ual2NT8IVcqq7kByFMLCBBkERuO");
            var uplodedVideoPath = await s3client
                .buildSignedGetParams(
                    key:
                        '${DateTime.now().toUtc().toString().replaceAll(RegExp(r'\.\d*Z$'), 'Z').replaceAll(RegExp(r'[:-]|\.\d{3}'), '').split(' ').join('T')}${path.extension(_video!.path)}')
                .uri;
            // final minio = Minio(
            //     endPoint: 's3.wasabisys.com',
            //     accessKey: 'I6AC8ZFJQ5Z75PC9HXLA',
            //     secretKey: 'qdiwW0clT8558Ual2NT8IVcqq7kByFMLCBBkERuO',
            //     region: 'us-east-1');

            await minio
                .fPutObject(
                    'storage-viewduct',
                    '${DateTime.now().toUtc().toString().replaceAll(RegExp(r'\.\d*Z$'), 'Z').replaceAll(RegExp(r'[:-]|\.\d{3}'), '').split(' ').join('T')}${path.extension(_video!.path)}',
                    _video!.path)
                .onError((error, stackTrace) {
              setState(() {
                isUploading = false;
                isUploadingStateError = true;
              });
              Fluttertoast.showToast(
                msg: 'Network timeout',
                // toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP_LEFT,
                timeInSecForIosWeb: 10,
                backgroundColor: CupertinoColors.systemRed,
              );
              if (kDebugMode) {
                cprint(error.toString());
              }
              return error.toString();
            });
            tweetModel.videoPath = uplodedVideoPath.toString();
            tweetModel.duration = _duration?.inSeconds.toString();
            tweetModel.productImage = uplodedImagePath.toString();
            cprint('video uploapded');

            /// If type of tweet is new tweet
            if (widget.isTweet && isUploadingStateError == false) {
              feedState.createProDuctItems(tweetModel, key: id);
              cprint('product added uploapded');
              // feedState.createSearchKeyWord(keyWord.text.trim());
            }
          });
        }

        /// If tweet did not contain image
        else {
          /// If type of tweet is new tweet
          if (widget.isTweet && isUploadingStateError == false) {
            feedState.createProDuctItems(tweetModel, key: id);
            cprint('product added uploapded');
            //  feedState.createSearchKeyWord(keyWord.text.trim());
          }
        }
        //  kScreenloader.hideLoader();

        /// Checks for username in tweet ductComment
        /// If foud sends notification to all tagged user
        /// If no user found or not compost tweet screen is closed and redirect back to home page.
        await composeductState
            .sendNotification(tweetModel, searchState)
            .then((_) {
          /// Hide running loader on screen
          // kScreenloader.hideLoader();
          if (isUploadingStateError == false) {
            setState(() {
              isUploading = false;
            });
            StatusAlert.show(Get.context!,
                duration: const Duration(seconds: 2),
                title: 'Products',
                subtitle: "${productNameController.text} was added ",
                configuration: const IconConfiguration(
                    icon: CupertinoIcons.cart_badge_plus));

            /// Navigate back to home page
            Navigator.pop(context);
          }
        });
        // setState(() => isLoading = true);
      }
    } on AppwriteException catch (e) {
      // kScreenloader.hideLoader();
      setState(() {
        isUploading = false;
      });
      StatusAlert.show(Get.context!,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
          title: 'Products',
          subtitle: "$e ",
          configuration:
              const IconConfiguration(icon: CupertinoIcons.cart_badge_plus));
      cprint('add products error:$e');
    }
  }

  /// Return Tweet model which is either a new Tweet , retweet model or comment model
  /// If tweet is new tweet then `parentkey` and `childRetwetkey` should be null
  /// IF tweet is a comment then it should have `parentkey`
  /// IF tweet is a retweet then it should have `childRetwetkey`
  FeedModel createTweetModel() {
    // var state = Provider.of<FeedState>(context, listen: false);
    // var authState = Provider.of<AuthState>(context, listen: false);
    //var myUser = authState.userModel!;

    // var profilePic = myUser.profilePic ?? dummyProfilePic;
    //  ViewductsUser? commentedUser;
    // var commentedUser = ViewductsUser(
    //     displayName: myUser.displayName ?? myUser.email!.split('@')[0],
    //     profilePic: profilePic,
    //     userId: myUser.userId,
    //     isVerified: authState.userModel!.isVerified,
    //     userName: authState.userModel!.userName);
    var tags = getHashTags(textEditingController.text);

    FeedModel reply = FeedModel(
        productName: widget.isTweet ? productNameController.text : '',
        section: userCartController.venDor.value.storeType != "admin"
            ? userCartController.venDor.value.storeType
            : _currentSection,
        shoeSize: widget.isTweet ? selectedItemsShoeSize ?? [] : [],
        brand: widget.isTweet ? productBrandController.text : '',
        keyword: widget.isTweet ? keyWord.text : '',
        productDescription:
            widget.isTweet ? productDescriptionController.text : '',
        price: widget.isTweet ? totalPrice : '',
        shippingFee: int.parse(shippingFeeController.text),
        sizes: widget.isTweet ? selectedItemsSizes ?? [] : [],
        colors: widget.isTweet ? selectedItemsColors ?? [] : [],
        commissionPrice:
            widget.isTweet ? int.parse(commissionController.text) : 0,
        weight: widget.isTweet ? int.parse(weightController.text) : 0,
        productLocation: userCartController.venDor.value.storeType != "admin"
            ? productLocationController.text
            : authState.userModel?.location,
        productState: productStateController.text,
        // "images": imageList,
        stockQuantity: widget.isTweet ? _stockNumber!.ceil() : 0,
        type: widget.isTweet ? _currentType : '',
        productCategory: widget.isTweet ? _currentCategory : '',
        caption: widget.isTweet ? "product" : '',
        ductComment: productDescriptionController.text.toString(),
        user: authState.userModel,
        createdAt: DateTime.now().toUtc().toString(),
        paymentDate: DateTime.now().toUtc().toString(),
        tags: tags,
        key: id,
        ductId: id,
        parentkey: id,
        childVductkey: id,
        ads: 'No Ads',
        cProduct: '',
        commentCount: 0,
        commissionUser: '',
        culture: '',
        likeCount: 0,
        likeList: [],
        productimagePath: [],
        thumbPath: '',
        vductCount: 0,
        salePrice: 0,
        replyDuctKeyList: [],
        store: userCartController.venDor.value.businessName.toString(),
        userId: authState.userId);
    return reply;
  }

  List<DropdownMenuItem<String>> getChildrenCategoriesDropdown() {
    List<DropdownMenuItem<String>> items = [];
    for (int i = 0; i < childrenCategory.length; i++) {
      setState(() {
        items.insert(
            0,
            DropdownMenuItem(
                child: Text(childrenCategory[i].data['childrenCategory']),
                value: childrenCategory[i].data['childrenCategory']));
      });
    }
    return items;
  }

  List<DropdownMenuItem<String>> getElectronicsCategoriesDropdown() {
    List<DropdownMenuItem<String>> eitems = [];
    for (int i = 0; i < electronicsCategory.length; i++) {
      setState(() {
        eitems.insert(
            0,
            DropdownMenuItem(
                child: Text(electronicsCategory[i].data['electronicsCategory']),
                value: electronicsCategory[i].data['electronicsCategory']));
      });
    }
    return eitems;
  }

  List<DropdownMenuItem<String>> getGroceriesCategoriesDropdown() {
    List<DropdownMenuItem<String>> gitems = [];
    for (int i = 0; i < groceriesCategory.length; i++) {
      setState(() {
        gitems.insert(
            0,
            DropdownMenuItem(
                child: Text(groceriesCategory[i].data['groceryCategory']),
                value: groceriesCategory[i].data['groceryCategory']));
      });
    }
    return gitems;
  }

  List<DropdownMenuItem<String>> getHousingCategoriesDropdown() {
    List<DropdownMenuItem<String>> gitems = [];
    for (int i = 0; i < housingCategory.length; i++) {
      setState(() {
        gitems.insert(
            0,
            DropdownMenuItem(
                child: Text(housingCategory[i].data['housingCategory']),
                value: housingCategory[i].data['housingCategory']));
      });
    }
    return gitems;
  }

  List<DropdownMenuItem<String>> getFarmCategoriesDropdown() {
    List<DropdownMenuItem<String>> gitems = [];
    for (int i = 0; i < farmCategory.length; i++) {
      setState(() {
        gitems.insert(
            0,
            DropdownMenuItem(
                child: Text(farmCategory[i].data['farmCategory']),
                value: farmCategory[i].data['farmCategory']));
      });
    }
    return gitems;
  }

  List<DropdownMenuItem<String>> getBooksCategoriesDropdown() {
    List<DropdownMenuItem<String>> gitems = [];
    for (int i = 0; i < booksCategory.length; i++) {
      setState(() {
        gitems.insert(
            0,
            DropdownMenuItem(
                child: Text(booksCategory[i].data['booksCategory']),
                value: booksCategory[i].data['booksCategory']));
      });
    }
    return gitems;
  }

  List<DropdownMenuItem<String>> getFashionCategoriesDropdown() {
    List<DropdownMenuItem<String>> fitems = [];
    for (int i = 0; i < fashionCategory.length; i++) {
      setState(() {
        fitems.insert(
            0,
            DropdownMenuItem(
                child: Text(fashionCategory[i].data['fashionCategory']),
                value: fashionCategory[i].data['fashionCategory']));
      });
    }
    return fitems;
  }

  List<DropdownMenuItem<String>> getTypeDropDown() {
    List<DropdownMenuItem<String>> bitems = [];
    for (int i = 0; i < types.length; i++) {
      setState(() {
        bitems.insert(
            0,
            DropdownMenuItem(
                child: Text(types[i].data['type']),
                value: types[i].data['type']));
      });
    }
    return bitems;
  }

  List<DropdownMenuItem<String>> getSectionsDropDown() {
    List<DropdownMenuItem<String>> sitems = [];
    for (int i = 0; i < section.length; i++) {
      setState(() {
        sitems.insert(
            0,
            DropdownMenuItem(
                child: Text(section[i].data['section']),
                value: section[i].data['section']));
      });
    }
    return sitems;
  }

  Future<bool?> _showDialog() {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return frostedYellow(
          Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.transparent,
            child: frostedTeal(
              Container(
                height: fullWidth(context) * 0.4,
                width: fullWidth(context),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: SafeArea(
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Column(
                          children: [
                            ModalTile(
                              title: "File Exceeds Limit",
                              subtitle: "Please reduce your file size",
                              icon: Icons.tab,
                              onTap: () async {
                                Navigator.maybePop(context);
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.maybePop(context);
                                },
                                child: Container(
                                    padding: const EdgeInsets.all(0),
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.yellow),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: customTitleText('Ok'),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  FileModel? selectedModel;
  String? image;
  late List<FileModel> imageFiles;
  List<DropdownMenuItem> getFiles() {
    return imageFiles
        .map((e) => DropdownMenuItem(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: customText(e.folder,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              value: e,
            ))
        .toList();
  }

  // getImagesPath() async {
  //   //String imagePath = '';
  //   try {
  //     var imagePath = await StoragePath.imagesPath;

  //     var images = jsonDecode(imagePath) as List;
  //     imageFiles = images.map<FileModel>((e) => FileModel.fromJson(e)).toList();
  //     if (imageFiles != null && imageFiles.length > 0) {
  //       setState(() {
  //         selectedModel = imageFiles[0];
  //         image = imageFiles[0].files[0];
  //       });
  //     } else {
  //       Container();
  //     }
  //   } catch (e) {
  //     cprint('$e');
  //   }
  //   //  return imagePath;
  // }
  final List<SelectedListItem> _data = [
    // SelectedListItem(false, 'S'),
    // SelectedListItem(false, 'M'),
    // SelectedListItem(false, 'L'),
    // SelectedListItem(false, 'XL'),
    // SelectedListItem(false, 'XXL'),
    // SelectedListItem(false, 'XXXL'),
  ];
  final List<SelectedListItem> _shoeSize = [
    // SelectedListItem(false, '5.5'),
    // SelectedListItem(false, '6'),
    // SelectedListItem(false, '6.5'),
    // SelectedListItem(false, '7'),
    // SelectedListItem(false, '7.5'),
    // SelectedListItem(false, '8'),
    // SelectedListItem(false, '8.5'),
    // SelectedListItem(false, '9'),
    // SelectedListItem(false, '9.5'),
    // SelectedListItem(false, '10'),
    // SelectedListItem(false, '10.5'),
    // SelectedListItem(false, '11'),
    // SelectedListItem(false, '11.5'),
    // SelectedListItem(false, '12'),
    // SelectedListItem(false, '12.5'),
    // SelectedListItem(false, '13'),
    // SelectedListItem(false, '13.5'),
    // SelectedListItem(false, '14'),
    // SelectedListItem(false, '14.5'),
    // SelectedListItem(false, '15'),
    // SelectedListItem(false, '15.5'),
    // SelectedListItem(false, '16'),
    // SelectedListItem(false, '17'),
    // SelectedListItem(false, '17.5'),
    // SelectedListItem(false, '18'),
    // SelectedListItem(false, '18.5'),
    // SelectedListItem(false, '19'),
    // SelectedListItem(false, '19.5'),
    // SelectedListItem(false, '20'),
    // SelectedListItem(false, '20.5'),
    // SelectedListItem(false, '21'),
    // SelectedListItem(false, '21.5'),
    // SelectedListItem(false, '22'),
    // SelectedListItem(false, '22.5'),
    // SelectedListItem(false, '23'),
    // SelectedListItem(false, '23.5'),
    // SelectedListItem(false, '30'),
    // SelectedListItem(false, '30.5'),
    // SelectedListItem(false, '31'),
    // SelectedListItem(false, '31.5'),
    // SelectedListItem(false, '32'),
    // SelectedListItem(false, '32.5'),
    // SelectedListItem(false, '33'),
    // SelectedListItem(false, '33.5'),
    // SelectedListItem(false, '34'),
    // SelectedListItem(false, '34.5'),
    // SelectedListItem(false, '35'),
    // SelectedListItem(false, '35.5'),
    // SelectedListItem(false, '36'),
    // SelectedListItem(false, '36.5'),
    // SelectedListItem(false, '37'),
    // SelectedListItem(false, '37.5'),
    // SelectedListItem(false, '38'),
    // SelectedListItem(false, '38.5'),
    // SelectedListItem(false, '39'),
    // SelectedListItem(false, '39.5'),
    // SelectedListItem(false, '40'),
    // SelectedListItem(false, '41'),
    // SelectedListItem(false, '42'),
    // SelectedListItem(false, '43'),
    // SelectedListItem(false, '44'),
    // SelectedListItem(false, '45'),
    // SelectedListItem(false, '46'),
    // SelectedListItem(false, '47'),
    // SelectedListItem(false, '48'),
    // SelectedListItem(false, '49'),
    // SelectedListItem(false, '50'),
  ];
  final List<SelectedListItem> _colordata = [
    // SelectedListItem(false, 'White'),
    // SelectedListItem(false, 'Black'),
    // SelectedListItem(false, 'Blue'),
    // SelectedListItem(false, 'Sky Blue'),
    // SelectedListItem(false, 'Grey'),
    // SelectedListItem(false, 'Green'),
    // SelectedListItem(false, 'Red'),
    // SelectedListItem(false, 'Wine Red'),
    // SelectedListItem(false, 'Navy Blue'),
    // SelectedListItem(false, 'Pink'),
    // SelectedListItem(false, 'Yellow'),
    // SelectedListItem(false, 'Pitch'),
    // SelectedListItem(false, 'Gold'),
    // SelectedListItem(false, 'Purple'),
  ];
  @override
  Widget build(BuildContext context) {
    cprint('$commissionPrice');
    //var authState = Provider.of<AuthState>(context, listen: false);
    return KeyboardDismisser(
      gestures: const [
        GestureType.onTap,
        GestureType.onPanUpdateUpDirection,
      ],
      child: Scaffold(
        // backgroundColor: bgColor,
        // appBar: widget.isTweet
        //     ? Container
        //     : AppBar(
        //         elevation: 0.1,
        //         backgroundColor: white,
        //         // leading: Icon(
        //         //   Icons.close,
        //         //   color: black,
        //         // ),
        //         title: Text(
        //           "add product",
        //           style: TextStyle(color: black),
        //         ),
        //       ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Stack(
              children: [
                Positioned(
                  top: Get.height * 0.1,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: Get.height * 0.8,
                    width: Get.width,
                    child: SingleChildScrollView(
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
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
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          color: CupertinoColors.systemYellow),
                                      padding: const EdgeInsets.all(5.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          // Navigator.maybePop(context);
                                        },
                                        child: Text(
                                          'USD ${userCartController.subscriptionModel.firstWhere((data) => data.subType == 'product', orElse: () => SubscriptionViewDuctsModel()).price ?? ''}/year',
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
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: CupertinoColors
                                              .darkBackgroundGray),
                                      padding: const EdgeInsets.all(5.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          // Navigator.maybePop(context);
                                        },
                                        child: Text(
                                          'Each product you add is charge ${userCartController.subscriptionModel.firstWhere((data) => data.subType == 'product', orElse: () => SubscriptionViewDuctsModel()).price ?? ''}USD a year',
                                          style: TextStyle(
                                              color: CupertinoColors
                                                  .lightBackgroundGray,
                                              fontWeight: FontWeight.w200),
                                        ),
                                      )),
                                ),
                                // Row(
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   children: <Widget>[
                                //     // customImage(context, authState.user?.photoURL, height: 40),

                                //     Expanded(
                                //       child: _TextField(
                                //         isTweet: true,
                                //         textEditingController: textEditingController,
                                //       ),
                                //     ),
                                //     SizedBox(
                                //       width: 10,
                                //     ),
                                //     customImage(context, authState.user!.photoURL,
                                //         height: 40),
                                //   ],
                                // ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // DuctAwesomeDropDown<DropdownMenuItem>(
                                      //     dropDownList: typesDropDown),

                                      Row(
                                        children: <Widget>[
                                          Padding(
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
                                                            18),
                                                    color:
                                                        CupertinoColors.white),
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: const Text(
                                                  'Select Type',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w200),
                                                )),
                                          ),
                                          DropdownButton(
                                            style: const TextStyle(
                                                color: CupertinoColors
                                                    .darkBackgroundGray),
                                            dropdownColor:
                                                CupertinoColors.systemYellow,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10)),
                                            items: typesDropDown,
                                            onChanged: changeSelectedTypes,
                                            value: _currentType,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                _video == null
                                    ? Container()
                                    : Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          color: Colors.grey.withOpacity(.3),
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.4,
                                        child: Stack(
                                          children: [
                                            VideoUploadAdmin(
                                              videoFile: File(_video!.path),
                                              videoPath: _video!.path,
                                            ),
                                            _image1 == null
                                                ? Container()
                                                : Positioned(
                                                    right: 0,
                                                    bottom: 0,
                                                    child: Container(
                                                      width: Get.height * 0.1,
                                                      height: Get.height * 0.1,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 30),
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: FileImage(
                                                                _image1!),
                                                            fit:
                                                                BoxFit.contain),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color: Colors.grey
                                                            .withOpacity(.3),
                                                      ),
                                                    ),
                                                  )
                                          ],
                                        ),
                                      ),

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
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
                                              color: _video == null
                                                  ? CupertinoColors.white
                                                  : CupertinoColors
                                                      .activeGreen),
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            _video == null
                                                ? 'Add Product Video'
                                                : 'Update Product Video',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w200),
                                          )),
                                    ),
                                    GestureDetector(
                                        // borderSide: BorderSide(
                                        //     color: grey.withOpacity(0.5),
                                        //     width: 2.5),
                                        onTap: () async {
                                          XTypeGroup typeGroup = XTypeGroup(
                                            extensions: <String>['mp4', 'mov'],
                                          );
                                          // Navigator.maybePop(context);
                                          if (Platform.isMacOS ||
                                              Platform.isWindows) {
                                            final files = await openFile(
                                                acceptedTypeGroups: <
                                                    XTypeGroup>[typeGroup]);

                                            File file = File(files!.path);
                                            if (file.lengthSync() > 80000000) {
                                              setState(() {
                                                //file = null;
                                                _video = null;
                                              });

                                              _showDialog();
                                            } else {
                                              setState(() {
                                                _video = file;
                                              });

                                              if (_video != null) {
                                                setState(() {
                                                  _controller =
                                                      VideoPlayerController
                                                          .file(_video!)
                                                        ..initialize()
                                                            .then((value) {
                                                          setState(() {
                                                            _duration =
                                                                _controller
                                                                    .value
                                                                    .duration;
                                                          });
                                                        });
                                                });
                                              }
                                            }
                                          } else {
                                            PickedFile? pickedFile =
                                                await (ImagePicker().getVideo(
                                                    source: ImageSource.gallery,
                                                    maxDuration: const Duration(
                                                        seconds: 45)));
                                            File file = File(pickedFile!.path);
                                            cprint('${file.lengthSync()}');
                                            if (file.lengthSync() > 50000000) {
                                              setState(() {
                                                //file = null;
                                                _video = null;
                                              });

                                              _showDialog();
                                            } else {
                                              setState(() {
                                                _video = file;
                                              });

                                              if (_video != null) {
                                                setState(() {
                                                  _controller =
                                                      VideoPlayerController
                                                          .file(_video!)
                                                        ..initialize()
                                                            .then((value) {
                                                          setState(() {
                                                            _duration =
                                                                _controller
                                                                    .value
                                                                    .duration;
                                                          });
                                                        });
                                                });
                                              }
                                            }
                                          }
                                        },
                                        child: _displayVideo()),
                                  ],
                                ),

                                _video == null
                                    ? Container()
                                    : Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
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
                                                            18),
                                                    color: _image1 == null
                                                        ? CupertinoColors.white
                                                        : CupertinoColors
                                                            .activeGreen),
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  _image1 == null
                                                      ? 'Add Product Image'
                                                      : 'Update Product Image',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w200),
                                                )),
                                          ),
                                          GestureDetector(
                                              onTap: () async {
                                                XTypeGroup typeGroup =
                                                    XTypeGroup(
                                                  extensions: <String>[
                                                    'jpg',
                                                    'png'
                                                  ],
                                                );
                                                // Navigator.maybePop(context);
                                                if (Platform.isMacOS ||
                                                    Platform.isWindows) {
                                                  var files = await openFile(
                                                      acceptedTypeGroups: <
                                                          XTypeGroup>[
                                                        typeGroup
                                                      ]);
                                                  // setState(() {
                                                  // //  _image = File(file!.path);
                                                  // });
                                                  if (File(files!.path)
                                                          .lengthSync() >
                                                      1000000) {
                                                    setState(() {
                                                      files = null;
                                                      _video = null;
                                                    });

                                                    _showDialog();
                                                  } else {
                                                    File tempImg =
                                                        File(files.path);
                                                    switch (1) {
                                                      case 1:
                                                        setState(() =>
                                                            _image1 = tempImg);
                                                        break;
                                                      case 2:
                                                        setState(() =>
                                                            _image2 = tempImg);
                                                        break;
                                                      case 3:
                                                        setState(() =>
                                                            _image3 = tempImg);
                                                        break;
                                                    }
                                                  }
                                                } else {
                                                  _selectImage(
                                                      await (ImagePicker()
                                                          .getImage(
                                                              source: ImageSource
                                                                  .gallery)),
                                                      1);
                                                }
                                              },
                                              child: _displayChild1()),
                                          // Expanded(
                                          //   child: Padding(
                                          //     padding: const EdgeInsets.all(8.0),
                                          //     child: Container(),
                                          //   ),
                                          // ),
                                          // Expanded(
                                          //   child: Padding(
                                          //     padding: const EdgeInsets.all(8.0),
                                          //     child: Container(),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                _video == null || _image1 == null
                                    ? Container()
                                    : Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.2,
                                        margin: const EdgeInsets.only(top: 30),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          color: Colors.grey.withOpacity(.3),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 4),
                                          child: TextFormField(
                                            controller: productNameController,
                                            decoration: const InputDecoration(
                                              hintText: 'Product name',
                                              fillColor: Colors.white,
                                              border: InputBorder.none,
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'You must enter the product name';
                                              } else if (value.length > 220) {
                                                return 'Product name can\'t have more than 180 letters';
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                _video == null || _image1 == null
                                    ? Container()
                                    : Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.2,
                                        margin: const EdgeInsets.only(top: 30),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.grey.withOpacity(.3),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 4),
                                          child: TextFormField(
                                            controller:
                                                productDescriptionController,
                                            decoration: const InputDecoration(
                                                fillColor: Colors.white,
                                                border: InputBorder.none,
                                                hintText:
                                                    'Product Description or Specifications'),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'You must enter the product name';
                                              } else if (value.length > 1000) {
                                                return 'Product name cant have more than 220 letters';
                                              }
                                            },
                                            maxLines: null,
                                          ),
                                        ),
                                      ),
                                _video == null || _image1 == null
                                    ? Container()
                                    : Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.2,
                                        margin: const EdgeInsets.only(top: 30),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          color: Colors.grey.withOpacity(.3),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 4),
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            controller: shippingFeeController,
                                            decoration: const InputDecoration(
                                                fillColor: Colors.white,
                                                border: InputBorder.none,
                                                hintText:
                                                    'Product Shipping fee within your State'),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'You must enter the product name';
                                              } else if (value.length > 10000) {
                                                return 'Product name cant have more than 220 letters';
                                              }
                                            },
                                            maxLines: null,
                                          ),
                                        ),
                                      ),

                                _video == null || _image1 == null
                                    ? Container()
                                    : userCartController
                                                .venDor.value.storeType ==
                                            "admin"
                                        ? Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.2,
                                            margin:
                                                const EdgeInsets.only(top: 30),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              color:
                                                  Colors.grey.withOpacity(.3),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 4),
                                              child: TextFormField(
                                                controller:
                                                    productLocationController,
                                                decoration: const InputDecoration(
                                                    fillColor: Colors.white,
                                                    border: InputBorder.none,
                                                    hintText:
                                                        'Your Product Location Country'),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'You must enter the product name';
                                                  } else if (value.length >
                                                      220) {
                                                    return 'Product name cant have more than 220 letters';
                                                  }
                                                  // return value;
                                                },
                                              ),
                                            ),
                                          )
                                        : Container(),
                                _video == null || _image1 == null
                                    ? Container()
                                    : Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.2,
                                        margin: const EdgeInsets.only(top: 30),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          color: Colors.grey.withOpacity(.3),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 4),
                                          child: TextFormField(
                                            controller: productStateController,
                                            decoration: const InputDecoration(
                                                fillColor: Colors.white,
                                                border: InputBorder.none,
                                                hintText:
                                                    'Product State location in your country'),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'You must enter the product state';
                                              } else if (value.length > 100) {
                                                return 'Product name cant have more than 220 letters';
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                _video == null || _image1 == null
                                    ? Container()
                                    : Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.2,
                                        margin: const EdgeInsets.only(top: 30),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          color: Colors.grey.withOpacity(.3),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 4),
                                          child: TextFormField(
                                            controller: priceController,
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              fillColor: Colors.white,
                                              border: InputBorder.none,
                                              hintText: 'Product Selling Price',
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'You must enter the price of the product';
                                              }
                                              // return value;
                                            },
                                          ),
                                        ),
                                      ),
                                _video == null || _image1 == null
                                    ? Container()
                                    : Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.2,
                                        margin: const EdgeInsets.only(top: 30),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          color: Colors.grey.withOpacity(.3),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 4),
                                          child: TextFormField(
                                            controller: commissionController,
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              fillColor: Colors.white,
                                              border: InputBorder.none,
                                              hintText:
                                                  'Duct Commission Amount',
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'You must enter how much commission you will give';
                                              }
                                              // return value;
                                            },
                                          ),
                                        ),
                                      ),

                                commissionController.text.isEmpty ||
                                        priceController.text.isEmpty ||
                                        //   productLocationController.text.isEmpty ||
                                        productDescriptionController
                                            .text.isEmpty ||
                                        productNameController.text.isEmpty
                                    //  ||
                                    // productStateController.text.isEmpty
                                    ? Container()
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Material(
                                            elevation: 10,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: frostedOrange(
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 3),
                                                child: customTitleText(
                                                    'Section and Category'),
                                              ),
                                            ),
                                          ),
                                          userCartController
                                                      .venDor.value.storeType !=
                                                  "admin"
                                              ? Container()
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          'Select Product Section: ',
                                                          style: TextStyle(
                                                              color: red),
                                                        ),
                                                      ),
                                                      DropdownButton(
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.yellow),
                                                        dropdownColor: Colors
                                                            .grey
                                                            .withOpacity(.3),
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    10)),
                                                        items: sectionDropDown,
                                                        value: _currentSection,
                                                        onChanged:
                                                            changeSelectedSection,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                          userCartController
                                                      .venDor.value.storeType ==
                                                  "Children"
                                              ? _children()
                                              : Container(),
                                          userCartController
                                                      .venDor.value.storeType ==
                                                  "Adult Fashion"
                                              ? _fashion()
                                              : Container(),
                                          userCartController
                                                      .venDor.value.storeType ==
                                                  "Grocery"
                                              ? _groceries()
                                              : Container(),
                                          userCartController
                                                      .venDor.value.storeType ==
                                                  "Electronics"
                                              ? _electronics()
                                              : Container(),
                                          userCartController
                                                      .venDor.value.storeType ==
                                                  "Farms"
                                              ? _farm()
                                              : Container(),
                                          userCartController
                                                      .venDor.value.storeType ==
                                                  "Books"
                                              ? _books()
                                              : Container(),
                                          userCartController
                                                      .venDor.value.storeType ==
                                                  "Housing"
                                              ? _children()
                                              : Container(),
                                          //  userCartController.venDor.value.storeType=="Cars"?_children():Container(),

                                          userCartController
                                                      .venDor.value.storeType ==
                                                  "admin"
                                              ? Column(
                                                  children: [
                                                    _childrenSection
                                                        ? Container()
                                                        : _children(),
                                                    _adultfashionSection
                                                        ? Container()
                                                        : _fashion(),
                                                    _groceriesSection
                                                        ? Container()
                                                        : _groceries(),
                                                    _electronicsSection
                                                        ? Container()
                                                        : _electronics(),
                                                    _booksSection
                                                        ? Container()
                                                        : _books(),
                                                    _housingSection
                                                        ? Container()
                                                        : _housing(),
                                                    _farmSection
                                                        ? Container()
                                                        : _farm(),
                                                  ],
                                                )
                                              : Container()
                                        ],
                                      ),
                                weightController.text.isEmpty ||
                                        keyWord.text.isEmpty ||
                                        productBrandController.text.isEmpty
                                    ? Container()
                                    :
                                    // GestureDetector(
                                    //     onTap: () => _submitButton(),
                                    //     child: Material(
                                    //       elevation: 10,
                                    //       borderRadius: BorderRadius.circular(10),
                                    //       child: frostedOrange(
                                    //         Container(
                                    //           decoration: BoxDecoration(
                                    //               borderRadius: BorderRadius.circular(20),
                                    //               color: Colors.blueGrey[50],
                                    //               gradient: LinearGradient(
                                    //                 colors: [
                                    //                   Colors.yellow.withOpacity(0.1),
                                    //                   Colors.white60.withOpacity(0.2),
                                    //                   Colors.teal.withOpacity(0.3)
                                    //                 ],
                                    //                 // begin: Alignment.topCenter,
                                    //                 // end: Alignment.bottomCenter,
                                    //               )),
                                    //           child: Padding(
                                    //             padding: const EdgeInsets.symmetric(
                                    //                 horizontal: 8.0, vertical: 3),
                                    //             child: customTitleText('Submit'),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ),

                                    Row(
                                        children: [
                                          _CustomeSubmitbutton(
                                            onActionPressed: userCartController
                                                        .venDor
                                                        .value
                                                        .storeType ==
                                                    "admin"
                                                ? _submitButton
                                                : _startAfreshCharge,
                                            isCrossButton: true,
                                            submitButtonText:
                                                //widget.isTweet
                                                // ?
                                                isUploading == true
                                                    ? "Product Adding..."
                                                    : 'Add Product',
                                            isSubmitDisable: !composeductState
                                                    .enableSubmitButton.value ||
                                                feedState.isBusy,
                                            isbootomLine: composeductState
                                                .isScrollingDown,
                                          ),
                                          isUploading == true
                                              ? Container(
                                                  height: 30,
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
                                                      color: CupertinoColors
                                                          .lightBackgroundGray),
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Stack(
                                                    alignment: Alignment.center,
                                                    children: <Widget>[
                                                      const CupertinoActivityIndicator(
                                                        radius: 10,
                                                      )
                                                    ],
                                                  ),
                                                )
                                              : Container()
                                        ],
                                      ),
                                SizedBox(height: fullWidth(context))
                                // FlatButton(
                                //     color: red,
                                //     textColor: white,
                                //     child: Text('add product'),
                                //     onPressed: _submitButton),
                              ],
                            ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          isUploading = false;
                          Navigator.pop(context);
                        },
                        color: Colors.black,
                        icon: const Icon(CupertinoIcons.back),
                      ),
                      Material(
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 3),
                                  child: customTitleText('ViewDucts'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getChildrenCategories() async {
    List<appModels.Document> data = await _feedState.getChildrenCategories();
    if (kDebugMode) {
      print(data.length);
    }
    setState(() {
      childrenCategory = data;
      childrenCategoriesDropDown = getChildrenCategoriesDropdown();
      _currentChildrenCategory = childrenCategory[0].data['category'];
      _currentCategory = _currentChildrenCategory;
    });
  }

  _getFashionCategories() async {
    List<appModels.Document> data = await _feedState.getFashionCategories();
    if (kDebugMode) {
      print(data.length);
    }
    setState(() {
      fashionCategory = data;
      fashionCategoriesDropDown = getFashionCategoriesDropdown();
      _currentFashionCategory = fashionCategory[0].data['category'];
      _currentCategory = _currentFashionCategory;
    });
  }

  _getElectronicsCategories() async {
    List<appModels.Document> data = await _feedState.getElectronicsCategories();
    if (kDebugMode) {}
    setState(() {
      electronicsCategory = data;
      electronicsCategoriesDropDown = getElectronicsCategoriesDropdown();
      _currentElectronicsCategory = electronicsCategory[0].data['category'];
      _currentCategory = _currentElectronicsCategory;
    });
  }

  _getGroceriesCategories() async {
    List<appModels.Document> data = await _feedState.getGroceriesCategories();

    setState(() {
      groceriesCategory = data;
      groceriesCategoriesDropDown = getGroceriesCategoriesDropdown();
      _currentGroceriesCategory = groceriesCategory[0].data['category'];
      _currentCategory = _currentGroceriesCategory;
    });
  }

  _getFarmCategories() async {
    List<appModels.Document> data = await _feedState.getFarmCategories();

    setState(() {
      farmCategory = data;
      farmCategoriesDropDown = getFarmCategoriesDropdown();
      _currentFarmCategory = farmCategory[0].data['category'];
      _currentCategory = _currentFarmCategory;
    });
  }

  _getBooksCategories() async {
    List<appModels.Document> data = await _feedState.getBooksCategories();

    setState(() {
      booksCategory = data;
      booksCategoriesDropDown = getBooksCategoriesDropdown();
      _currentBooksCategory = booksCategory[0].data['category'];
      _currentCategory = _currentBooksCategory;
    });
  }

  _getHousingCategories() async {
    List<appModels.Document> data = await _feedState.getHousingCategories();

    setState(() {
      housingCategory = data;
      housingCategoriesDropDown = getHousingCategoriesDropdown();
      _currentHousingCategory = housingCategory[0].data['category'];
      _currentCategory = _currentHousingCategory;
    });
  }

  _getSections() async {
    List<appModels.Document> data = await _feedState.getSections();

    setState(() {
      section = data;
      sectionDropDown = getSectionsDropDown();
      _currentSection = section[0].data['section'];
    });
  }

  _getTypes() async {
    List<appModels.Document> data = await _feedState.getTypes();

    setState(() {
      types = data;
      typesDropDown = getTypeDropDown();
      _currentType = types[0].data['type'];
    });
  }

  changeSelectedChildrenCategory(String? selectedCategory) {
    setState(() {
      _currentChildrenCategory = selectedCategory;
      _currentCategory = selectedCategory;
    });
  }

  changeSelectedFarmCategory(String? selectedCategory) {
    setState(() {
      _currentFarmCategory = selectedCategory;
      _currentCategory = selectedCategory;
    });
  }

  changeSelectedBooksCategory(String? selectedCategory) {
    setState(() {
      _currentBooksCategory = selectedCategory;
      _currentCategory = selectedCategory;
    });
  }

  changeSelectedHousingCategory(String? selectedCategory) {
    setState(() {
      _currentHousingCategory = selectedCategory;
      _currentCategory = selectedCategory;
    });
  }

  changeSelectedElectronicsCategory(String? selectedCategory) {
    setState(() {
      _currentElectronicsCategory = selectedCategory;
      _currentCategory = selectedCategory;
    });
  }

  changeSelectedFashionCategory(String? selectedCategory) {
    setState(() {
      _currentFashionCategory = selectedCategory;
      _currentCategory = selectedCategory;
    });
  }

  changeSelectedGroceriesCategory(String? selectedCategory) {
    switch (selectedCategory) {
      case 'Cake':
        setState(() {
          _cakeGroceriesCategory = false;
          _fruitsGroceriesCategory = true;
        });

        break;
      case 'Fruits':
        setState(() {
          _cakeGroceriesCategory = true;
          _fruitsGroceriesCategory = false;
        });

        break;

      default:
    }
    setState(() {
      _currentGroceriesCategory = selectedCategory;
      _currentCategory = selectedCategory;
    });
  }

  changeSelectedTypes(String? selectedtype) {
    setState(() => _currentType = selectedtype);
  }

  _children() {
    int vDuctPrice = int.tryParse(commissionController.text)!;
    // commissionPrice =
    //     comissionValue;

    commissionP.value =
        (userCartController.venDor.value.commission!.toDouble() *
            double.parse(priceController.text));
    totalPrice =
        (int.tryParse(priceController.text)! + commissionP.value + vDuctPrice)
            .toStringAsFixed(0);
    // totalPrice +
    //     ((int.tryParse(priceController.text) *
    //             int.tryParse(commissionController.text) /
    //             100) +
    //         int.parse(priceController.text) +
    //         (int.parse(priceController.text) * comissionValue / 100));
    return Column(
      children: [
        //              select category
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Children Category: ',
                style: TextStyle(color: red),
              ),
            ),
            DropdownButton(
              style: const TextStyle(color: Colors.yellow),
              dropdownColor: Colors.grey.withOpacity(.3),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              items: childrenCategoriesDropDown,
              onChanged: changeSelectedChildrenCategory,
              value: _currentChildrenCategory,
              hint: const Text('Select a Category'),
            ),
          ],
        ),
        _currentChildrenCategory == null
            ? Container()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    margin: const EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.grey.withOpacity(.3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      child: TextFormField(
                        controller: productBrandController,
                        decoration: const InputDecoration(hintText: 'Brand'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'You must enter the product Brand';
                          } else if (value.length > 10) {
                            return 'Brand name cant have more than 10 letters';
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  frostedWhite(Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customTitleText(
                          'Product in Stocks',
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SfSlider(
                                  min: 1.0,
                                  max: 24.0,
                                  interval: 4.0,
                                  activeColor: Colors.teal,
                                  showLabels: true,
                                  inactiveColor: Colors.grey,
                                  enableTooltip: true,
                                  value: _stockNumber,
                                  onChanged: (value) {
                                    setState(() {
                                      _stockNumber = value;
                                    });
                                  }),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  _stockNumber.toString(),
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    margin: const EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.grey.withOpacity(.3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      child: TextFormField(
                        controller: keyWord,
                        //   keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Search Keyword',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'You must enter the product stock qauntity';
                          }
                        },
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    margin: const EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.grey.withOpacity(.3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      child: TextFormField(
                        controller: weightController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Product Weight in (g)',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'You must enter the weight of the product';
                          }
                        },
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                              onTap: () {
                                DropDownState(DropDown(
                                        // bottomSheetTitle: 'Shoe Size',
                                        submitButtonChild: Text('Add'),
                                        dropDownBackgroundColor: bgColor,
                                        selectedItems: (items) {
                                          selectedItemsShoeSize = items;
                                          // changeSelectedSize(items);
                                          setState(() {});
                                          //                cprint('$selectedItemsColors');
                                        },
                                        // searchBackgroundColor: bgColor,
                                        // searchController:
                                        //     searchControllerColors,
                                        data: _shoeSize,
                                        enableMultipleSelection: true))
                                    .showModal(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                margin: const EdgeInsets.only(top: 30),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.yellow.withOpacity(.3),
                                ),
                                child: const Text(
                                  'Select Shoe Size >',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )),
                          selectedItemsShoeSize == null
                              ? Container()
                              : SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      const Text(
                                        "Selected Shoe Size:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.cyan),
                                      ),
                                      Text(
                                        " $selectedItemsShoeSize",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                              onTap: () {
                                DropDownState(DropDown(
                                        ////
                                        submitButtonChild: Text('Add'),
                                        dropDownBackgroundColor: bgColor,
                                        selectedItems: (items) {
                                          selectedItemsColors = items;
                                          // changeSelectedSize(items);
                                          setState(() {});
                                          //                cprint('$selectedItemsColors');
                                        },
                                        // searchBackgroundColor: bgColor,
                                        // searchController:
                                        //     searchControllerColors,
                                        data: _colordata,
                                        enableMultipleSelection: true))
                                    .showModal(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                margin: const EdgeInsets.only(top: 30),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.yellow.withOpacity(.3),
                                ),
                                child: const Text(
                                  'Select Colors >',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )),
                          selectedItemsColors == null
                              ? Container()
                              : SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      const Text(
                                        "Selected Colors:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.cyan),
                                      ),
                                      Text(
                                        " $selectedItemsColors",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                              onTap: () {
                                DropDownState(DropDown(

                                        /// bottomSheetTitle: 'Sizes',
                                        submitButtonChild: Text('Add'),
                                        dropDownBackgroundColor: bgColor,
                                        selectedItems: (items) {
                                          selectedItemsSizes = items;
                                          // changeSelectedSize(items);
                                          setState(() {});
                                          //  cprint('$selectedItemsSizes');
                                        },
                                        // searchBackgroundColor: bgColor,
                                        // searchController: searchController,
                                        data: _data,
                                        enableMultipleSelection: true))
                                    .showModal(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                margin: const EdgeInsets.only(top: 30),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.yellow.withOpacity(.3),
                                ),
                                child: const Text(
                                  'Select Cloth Sizes >',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )),
                          selectedItemsSizes == null
                              ? Container()
                              : SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      const Text(
                                        "Selected Sizes:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.cyan),
                                      ),
                                      Text(
                                        " $selectedItemsSizes",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blueGrey[50],
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.1),
                                      Colors.white.withOpacity(0.2),
                                      Colors.white.withOpacity(0.3)
                                      // Color(0xfffbfbfb),
                                      // Color(0xfff7f7f7),
                                    ],
                                    // begin: Alignment.topCenter,
                                    // end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: customText(
                                    authState.userModel?.location == 'Nigeria'
                                        ? 'Duct Comission : ₦${commissionController.text}'
                                        : 'Duct Comission : £${commissionController.text}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w100),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blueGrey[50],
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.1),
                                      Colors.white.withOpacity(0.2),
                                      Colors.white.withOpacity(0.3)
                                      // Color(0xfffbfbfb),
                                      // Color(0xfff7f7f7),
                                    ],
                                    // begin: Alignment.topCenter,
                                    // end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: customText(
                                    authState.userModel?.location == 'Nigeria'
                                        ? 'Category Commission : ₦${commissionP}'
                                        : 'Category Commission : £${commissionP}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w100),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blueGrey[50],
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.1),
                                      Colors.white.withOpacity(0.2),
                                      Colors.white.withOpacity(0.3)
                                      // Color(0xfffbfbfb),
                                      // Color(0xfff7f7f7),
                                    ],
                                    // begin: Alignment.topCenter,
                                    // end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: customText(
                                    authState.userModel?.location == 'Nigeria'
                                        ? 'Product Price : ₦${priceController.text}'
                                        : 'Product Price : £${priceController.text}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text(
                              'Total',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              authState.userModel?.location == 'Nigeria'
                                  ? '₦$totalPrice'
                                  : '£$totalPrice',
                              style: const TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              )
      ],
    );
  }

  _housing() {
    int vDuctPrice = int.tryParse(commissionController.text)!;
    // double vDuctPrice = int.tryParse(priceController.text)! *
    //     int.tryParse(commissionController.text)! /
    //     100;
    // double commissionPrice =
    //     int.tryParse(priceController.text)! * comissionValue / 100;
    commissionP.value =
        (userCartController.venDor.value.commission!.toDouble() *
            double.parse(priceController.text));
    // if (commissionP.value > 20000 &&
    //     authState.userModel?.location == 'Nigeria') {
    //   setState(() {
    //     commissionP.value = 20000;
    //   });
    // }
    totalPrice =
        (int.tryParse(priceController.text)! + commissionP.value + vDuctPrice)
            .toString();
    return Column(
      children: [
        //              select category
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Housing Category: ',
                style: TextStyle(color: red),
              ),
            ),
            DropdownButton(
              style: const TextStyle(color: Colors.yellow),
              dropdownColor: Colors.grey.withOpacity(.3),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              items: housingCategoriesDropDown,
              onChanged: changeSelectedHousingCategory,
              value: _currentHousingCategory,
              hint: const Text('Select a Category'),
            ),
          ],
        ),
        _currentHousingCategory == null
            ? Container()
            : Column(children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: productBrandController,
                    decoration: const InputDecoration(hintText: 'Brand'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'You must enter the product Brand';
                      } else if (value.length > 10) {
                        return 'Brand name cant have more than 10 letters';
                      }
                    },
                  ),
                ),

//

                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: keyWord,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Stock Quantity',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'You must enter the product stock qauntity';
                      }
                    },
                  ),
                ),

                // Padding(
                //   padding: const EdgeInsets.all(12.0),
                //   child: TextFormField(
                //     controller: priceController,
                //     keyboardType: TextInputType.number,
                //     decoration: InputDecoration(
                //       hintText: 'Price',
                //     ),
                //     validator: (value) {
                //       if (value.isEmpty) {
                //         return 'You must enter the price of the product';
                //       }
                //     },
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.all(12.0),
                //   child: TextFormField(
                //     controller: commissionController,
                //     keyboardType: TextInputType.number,
                //     decoration: InputDecoration(
                //       hintText: 'vDuct Commission(%)',
                //     ),
                //     validator: (value) {
                //       if (value.isEmpty) {
                //         return 'You must enter how much commission you will give';
                //       }
                //     },
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: weightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Product Weight in (g)',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'You must enter the weight of the product';
                      }
                    },
                  ),
                ),
              ]),
      ],
    );
  }

  _farm() {
    int vDuctPrice = int.tryParse(commissionController.text)!;
    // double vDuctPrice = int.tryParse(priceController.text)! *
    //     int.tryParse(commissionController.text)! /
    //     100;
    // double commissionPrice =
    //     int.tryParse(priceController.text)! * comissionValue / 100;
    commissionP.value =
        (userCartController.venDor.value.commission!.toDouble() *
            double.parse(priceController.text));
    totalPrice =
        (int.tryParse(priceController.text)! + commissionP.value + vDuctPrice)
            .toString();
    return Column(
      children: [
        //              select category
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Farm Category: ',
                style: TextStyle(color: red),
              ),
            ),
            DropdownButton(
              style: const TextStyle(color: Colors.yellow),
              dropdownColor: Colors.grey.withOpacity(.3),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              items: farmCategoriesDropDown,
              onChanged: changeSelectedFarmCategory,
              value: _currentFarmCategory,
              hint: const Text('Select a Category'),
            ),
          ],
        ),
        _currentFarmCategory == null
            ? Container()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    margin: const EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.grey.withOpacity(.3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      child: TextFormField(
                        controller: productBrandController,
                        decoration: const InputDecoration(hintText: 'Brand'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'You must enter the product Brand';
                          } else if (value.length > 10) {
                            return 'Brand name cant have more than 10 letters';
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  frostedWhite(Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customTitleText(
                          'Product in Stocks',
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SfSlider(
                                  min: 1.0,
                                  max: 24.0,
                                  interval: 4.0,
                                  activeColor: Colors.teal,
                                  showLabels: true,
                                  inactiveColor: Colors.grey,
                                  enableTooltip: true,
                                  value: _stockNumber,
                                  onChanged: (value) {
                                    setState(() {
                                      _stockNumber = value;
                                    });
                                  }),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  _stockNumber.toString(),
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    margin: const EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.grey.withOpacity(.3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      child: TextFormField(
                        controller: keyWord,
                        //   keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Search Keyword',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'You must enter the product stock qauntity';
                          }
                        },
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    margin: const EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.grey.withOpacity(.3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      child: TextFormField(
                        controller: weightController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Product Weight in (g)',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'You must enter the weight of the product';
                          }
                        },
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                              onTap: () {
                                DropDownState(DropDown(
                                        ////
                                        submitButtonChild: Text('Add'),
                                        dropDownBackgroundColor: bgColor,
                                        selectedItems: (items) {
                                          selectedItemsColors = items;
                                          // changeSelectedSize(items);
                                          setState(() {});
                                          cprint('$selectedItemsColors');
                                        },
                                        // searchBackgroundColor: bgColor,
                                        // searchController:
                                        //     searchControllerColors,
                                        data: _colordata,
                                        enableMultipleSelection: true))
                                    .showModal(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                margin: const EdgeInsets.only(top: 30),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.yellow.withOpacity(.3),
                                ),
                                child: const Text(
                                  'Select Colors >',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )),
                          selectedItemsColors == null
                              ? Container()
                              : Row(
                                  children: [
                                    const Text(
                                      "Selected Colors:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.cyan),
                                    ),
                                    Text(
                                      " $selectedItemsColors",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                              onTap: () {
                                DropDownState(DropDown(

                                        /// bottomSheetTitle: 'Sizes',
                                        submitButtonChild: Text('Add'),
                                        dropDownBackgroundColor: bgColor,
                                        selectedItems: (items) {
                                          selectedItemsSizes = items;
                                          // changeSelectedSize(items);
                                          setState(() {});
                                          //  cprint('$selectedItemsSizes');
                                        },
                                        // searchBackgroundColor: bgColor,
                                        // searchController: searchController,
                                        data: _data,
                                        enableMultipleSelection: true))
                                    .showModal(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                margin: const EdgeInsets.only(top: 30),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.yellow.withOpacity(.3),
                                ),
                                child: const Text(
                                  'Select Sizes >',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )),
                          selectedItemsSizes == null
                              ? Container()
                              : Row(
                                  children: [
                                    const Text(
                                      "Selected Sizes:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.cyan),
                                    ),
                                    Text(
                                      " $selectedItemsSizes",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blueGrey[50],
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.1),
                                      Colors.white.withOpacity(0.2),
                                      Colors.white.withOpacity(0.3)
                                      // Color(0xfffbfbfb),
                                      // Color(0xfff7f7f7),
                                    ],
                                    // begin: Alignment.topCenter,
                                    // end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: customText(
                                    authState.userModel?.location == 'Nigeria'
                                        ? 'Duct Comission : ₦${commissionController.text}'
                                        : 'Duct Comission : £${commissionController.text}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w100),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blueGrey[50],
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.1),
                                      Colors.white.withOpacity(0.2),
                                      Colors.white.withOpacity(0.3)
                                      // Color(0xfffbfbfb),
                                      // Color(0xfff7f7f7),
                                    ],
                                    // begin: Alignment.topCenter,
                                    // end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: customText(
                                    authState.userModel?.location == 'Nigeria'
                                        ? 'Category Commission : ₦${commissionP}'
                                        : 'Category Commission : £${commissionP}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w100),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blueGrey[50],
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.1),
                                      Colors.white.withOpacity(0.2),
                                      Colors.white.withOpacity(0.3)
                                      // Color(0xfffbfbfb),
                                      // Color(0xfff7f7f7),
                                    ],
                                    // begin: Alignment.topCenter,
                                    // end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: customText(
                                    authState.userModel?.location == 'Nigeria'
                                        ? 'Product Price : ₦${priceController.text}'
                                        : 'Product Price : £${priceController.text}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text(
                              'Total',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              authState.userModel?.location == 'Nigeria'
                                  ? '₦$totalPrice'
                                  : '£$totalPrice',
                              style: const TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              )
      ],
    );
  }

  _books() {
    int vDuctPrice = int.tryParse(commissionController.text)!;
    // double vDuctPrice = int.tryParse(priceController.text)! *
    //     int.tryParse(commissionController.text)! /
    //     100;
    // double commissionPrice =
    //     int.tryParse(priceController.text)! * comissionValue / 100;
    commissionP.value =
        (userCartController.venDor.value.commission!.toDouble() *
            double.parse(priceController.text));
    totalPrice =
        (int.tryParse(priceController.text)! + commissionP.value + vDuctPrice)
            .toString();
    return Column(
      children: [
        //              select category
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Books Category: ',
                style: TextStyle(color: red),
              ),
            ),
            DropdownButton(
              style: const TextStyle(color: Colors.yellow),
              dropdownColor: Colors.grey.withOpacity(.3),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              items: booksCategoriesDropDown,
              onChanged: changeSelectedBooksCategory,
              value: _currentBooksCategory,
              hint: const Text('Select a Category'),
            ),
          ],
        ),
        _currentBooksCategory == null
            ? Container()
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      controller: productBrandController,
                      decoration: const InputDecoration(hintText: 'Brand'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'You must enter the product Brand';
                        } else if (value.length > 10) {
                          return 'Brand name cant have more than 10 letters';
                        }
                      },
                    ),
                  ),

//

                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      controller: keyWord,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Stock Quantity',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'You must enter the product stock qauntity';
                        }
                      },
                    ),
                  ),

                  // Padding(
                  //   padding: const EdgeInsets.all(12.0),
                  //   child: TextFormField(
                  //     controller: priceController,
                  //     keyboardType: TextInputType.number,
                  //     decoration: InputDecoration(
                  //       hintText: 'Price',
                  //     ),
                  //     validator: (value) {
                  //       if (value.isEmpty) {
                  //         return 'You must enter the price of the product';
                  //       }
                  //     },
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.all(12.0),
                  //   child: TextFormField(
                  //     controller: commissionController,
                  //     keyboardType: TextInputType.number,
                  //     decoration: InputDecoration(
                  //       hintText: 'vDuct Commission(%)',
                  //     ),
                  //     validator: (value) {
                  //       if (value.isEmpty) {
                  //         return 'You must enter how much commission you will give';
                  //       }
                  //     },
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      controller: weightController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Product Weight in (g)',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'You must enter the weight of the product';
                        }
                      },
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blueGrey[50],
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.1),
                                      Colors.white.withOpacity(0.2),
                                      Colors.white.withOpacity(0.3)
                                      // Color(0xfffbfbfb),
                                      // Color(0xfff7f7f7),
                                    ],
                                    // begin: Alignment.topCenter,
                                    // end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: customText(
                                    'Duct Comission : ₦${commissionController.text}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w100),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blueGrey[50],
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.1),
                                      Colors.white.withOpacity(0.2),
                                      Colors.white.withOpacity(0.3)
                                      // Color(0xfffbfbfb),
                                      // Color(0xfff7f7f7),
                                    ],
                                    // begin: Alignment.topCenter,
                                    // end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: customText(
                                    authState.userModel?.location == 'Nigeria'
                                        ? 'Category Commission : ₦${commissionP}'
                                        : 'Category Commission : £${commissionP}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w100),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blueGrey[50],
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.1),
                                      Colors.white.withOpacity(0.2),
                                      Colors.white.withOpacity(0.3)
                                      // Color(0xfffbfbfb),
                                      // Color(0xfff7f7f7),
                                    ],
                                    // begin: Alignment.topCenter,
                                    // end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: customText(
                                    authState.userModel?.location == 'Nigeria'
                                        ? 'Product Price : ₦${priceController.text}'
                                        : 'Product Price : £${priceController.text}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text(
                              'Total',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              authState.userModel?.location == 'Nigeria'
                                  ? '₦$totalPrice'
                                  : '£$totalPrice',
                              style: const TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              )
      ],
    );
  }

  _cakeCategory() {
    return Column(
      children: [
        const Text('Available Flavors'),
        Row(
          children: <Widget>[
            Checkbox(
                value: selectedSizes.contains('XS'),
                onChanged: (value) => changeSelectedSize('XS')),
            const Text('XS'),
            Checkbox(
                value: selectedSizes.contains('S'),
                onChanged: (value) => changeSelectedSize('S')),
            const Text('S'),
            Checkbox(
                value: selectedSizes.contains('M'),
                onChanged: (value) => changeSelectedSize('M')),
            const Text('M'),
            Checkbox(
                value: selectedSizes.contains('L'),
                onChanged: (value) => changeSelectedSize('L')),
            const Text('L'),
            Checkbox(
                value: selectedSizes.contains('XL'),
                onChanged: (value) => changeSelectedSize('XL')),
            const Text('XL'),
            Checkbox(
                value: selectedSizes.contains('XXL'),
                onChanged: (value) => changeSelectedSize('XXL')),
            const Text('XXL'),
          ],
        ),
        const Text('Avalable Steps'),
        Row(
          children: <Widget>[
            Checkbox(
                value: selectedSizes.contains('28'),
                onChanged: (value) => changeSelectedSize('28')),
            const Text('28'),
            Checkbox(
                value: selectedSizes.contains('30'),
                onChanged: (value) => changeSelectedSize('30')),
            const Text('30'),
            Checkbox(
                value: selectedSizes.contains('32'),
                onChanged: (value) => changeSelectedSize('32')),
            const Text('32'),
            Checkbox(
                value: selectedSizes.contains('34'),
                onChanged: (value) => changeSelectedSize('34')),
            const Text('34'),
            Checkbox(
                value: selectedSizes.contains('36'),
                onChanged: (value) => changeSelectedSize('36')),
            const Text('36'),
            Checkbox(
                value: selectedSizes.contains('38'),
                onChanged: (value) => changeSelectedSize('38')),
            const Text('38'),
          ],
        ),
        Row(
          children: <Widget>[
            Checkbox(
                value: selectedSizes.contains('40'),
                onChanged: (value) => changeSelectedSize('40')),
            const Text('40'),
            Checkbox(
                value: selectedSizes.contains('42'),
                onChanged: (value) => changeSelectedSize('42')),
            const Text('42'),
            Checkbox(
                value: selectedSizes.contains('44'),
                onChanged: (value) => changeSelectedSize('44')),
            const Text('44'),
            Checkbox(
                value: selectedSizes.contains('46'),
                onChanged: (value) => changeSelectedSize('46')),
            const Text('46'),
            Checkbox(
                value: selectedSizes.contains('48'),
                onChanged: (value) => changeSelectedSize('48')),
            const Text('48'),
            Checkbox(
                value: selectedSizes.contains('50'),
                onChanged: (value) => changeSelectedSize('50')),
            const Text('50'),
          ],
        ),
      ],
    );
  }

  _fruitsCategory() {
    return Column(
      children: [
        const Text('Available types'),
        Row(
          children: <Widget>[
            Checkbox(
                value: selectedSizes.contains('XS'),
                onChanged: (value) => changeSelectedSize('XS')),
            const Text('XS'),
            Checkbox(
                value: selectedSizes.contains('S'),
                onChanged: (value) => changeSelectedSize('S')),
            const Text('S'),
            Checkbox(
                value: selectedSizes.contains('M'),
                onChanged: (value) => changeSelectedSize('M')),
            const Text('M'),
            Checkbox(
                value: selectedSizes.contains('L'),
                onChanged: (value) => changeSelectedSize('L')),
            const Text('L'),
            Checkbox(
                value: selectedSizes.contains('XL'),
                onChanged: (value) => changeSelectedSize('XL')),
            const Text('XL'),
            Checkbox(
                value: selectedSizes.contains('XXL'),
                onChanged: (value) => changeSelectedSize('XXL')),
            const Text('XXL'),
          ],
        ),
        const Text('Avalable Steps'),
        Row(
          children: <Widget>[
            Checkbox(
                value: selectedSizes.contains('28'),
                onChanged: (value) => changeSelectedSize('28')),
            const Text('28'),
            Checkbox(
                value: selectedSizes.contains('30'),
                onChanged: (value) => changeSelectedSize('30')),
            const Text('30'),
            Checkbox(
                value: selectedSizes.contains('32'),
                onChanged: (value) => changeSelectedSize('32')),
            const Text('32'),
            Checkbox(
                value: selectedSizes.contains('34'),
                onChanged: (value) => changeSelectedSize('34')),
            const Text('34'),
            Checkbox(
                value: selectedSizes.contains('36'),
                onChanged: (value) => changeSelectedSize('36')),
            const Text('36'),
            Checkbox(
                value: selectedSizes.contains('38'),
                onChanged: (value) => changeSelectedSize('38')),
            const Text('38'),
          ],
        ),
        Row(
          children: <Widget>[
            Checkbox(
                value: selectedSizes.contains('40'),
                onChanged: (value) => changeSelectedSize('40')),
            const Text('40'),
            Checkbox(
                value: selectedSizes.contains('42'),
                onChanged: (value) => changeSelectedSize('42')),
            const Text('42'),
            Checkbox(
                value: selectedSizes.contains('44'),
                onChanged: (value) => changeSelectedSize('44')),
            const Text('44'),
            Checkbox(
                value: selectedSizes.contains('46'),
                onChanged: (value) => changeSelectedSize('46')),
            const Text('46'),
            Checkbox(
                value: selectedSizes.contains('48'),
                onChanged: (value) => changeSelectedSize('48')),
            const Text('48'),
            Checkbox(
                value: selectedSizes.contains('50'),
                onChanged: (value) => changeSelectedSize('50')),
            const Text('50'),
          ],
        ),
      ],
    );
  }

  _groceries() {
    int vDuctPrice = int.tryParse(commissionController.text)!;
    // double vDuctPrice = int.tryParse(priceController.text)! *
    //     int.tryParse(commissionController.text)! /
    //     100;
    // double commissionPrice =
    //     int.tryParse(priceController.text)! * comissionValue / 100;
    commissionP.value =
        (userCartController.venDor.value.commission!.toDouble() *
            double.parse(priceController.text));
    totalPrice =
        (int.tryParse(priceController.text)! + commissionP.value + vDuctPrice)
            .toString();
    return Column(
      children: [
        //              select category
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Grocery Category: ',
                style: TextStyle(color: red),
              ),
            ),
            DropdownButton(
              style: const TextStyle(color: Colors.yellow),
              dropdownColor: Colors.grey.withOpacity(.3),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              items: groceriesCategoriesDropDown,
              onChanged: changeSelectedGroceriesCategory,
              value: _currentGroceriesCategory,
              hint: const Text('Select a Category'),
            ),
          ],
        ),
        _currentGroceriesCategory == null
            ? Container()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    margin: const EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.grey.withOpacity(.3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      child: TextFormField(
                        controller: productBrandController,
                        decoration: const InputDecoration(hintText: 'Brand'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'You must enter the product Brand';
                          } else if (value.length > 10) {
                            return 'Brand name cant have more than 10 letters';
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  frostedWhite(Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customTitleText(
                          'Product in Stocks',
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SfSlider(
                                  min: 1.0,
                                  max: 24.0,
                                  interval: 4.0,
                                  activeColor: Colors.teal,
                                  showLabels: true,
                                  inactiveColor: Colors.grey,
                                  enableTooltip: true,
                                  value: _stockNumber,
                                  onChanged: (value) {
                                    setState(() {
                                      _stockNumber = value;
                                    });
                                  }),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  _stockNumber.toString(),
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    margin: const EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.grey.withOpacity(.3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      child: TextFormField(
                        controller: keyWord,
                        //   keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Search Keyword',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'You must enter the product stock qauntity';
                          }
                        },
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    margin: const EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.grey.withOpacity(.3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      child: TextFormField(
                        controller: weightController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Product Weight in (g)',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'You must enter the weight of the product';
                          }
                        },
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                              onTap: () {
                                DropDownState(DropDown(
                                        ////

                                        submitButtonChild: Text('Add'),
                                        dropDownBackgroundColor: bgColor,
                                        selectedItems: (items) {
                                          selectedItemsColors = items;
                                          // changeSelectedSize(items);
                                          setState(() {});
                                          cprint('$selectedItemsColors');
                                        },
                                        // searchBackgroundColor: bgColor,
                                        // searchController:
                                        //     searchControllerColors,
                                        data: _colordata,
                                        enableMultipleSelection: true))
                                    .showModal(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                margin: const EdgeInsets.only(top: 30),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.yellow.withOpacity(.3),
                                ),
                                child: const Text(
                                  'Select Colors >',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )),
                          selectedItemsColors == null
                              ? Container()
                              : Row(
                                  children: [
                                    const Text(
                                      "Selected Colors:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.cyan),
                                    ),
                                    Text(
                                      " $selectedItemsColors",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                              onTap: () {
                                DropDownState(DropDown(
                                        // bottomSheetTitle: 'Sizes',
                                        submitButtonChild: Text('Add'),
                                        dropDownBackgroundColor: bgColor,
                                        selectedItems: (items) {
                                          selectedItemsSizes = items;
                                          // changeSelectedSize(items);
                                          setState(() {});
                                          // cprint('$selectedItemsSizes');
                                        },
                                        // searchBackgroundColor: bgColor,
                                        // searchController: searchController,
                                        data: _data,
                                        enableMultipleSelection: true))
                                    .showModal(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                margin: const EdgeInsets.only(top: 30),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.yellow.withOpacity(.3),
                                ),
                                child: const Text(
                                  'Select Sizes >',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )),
                          selectedItemsSizes == null
                              ? Container()
                              : Row(
                                  children: [
                                    const Text(
                                      "Selected Sizes:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.cyan),
                                    ),
                                    Text(
                                      " $selectedItemsSizes",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blueGrey[50],
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.1),
                                      Colors.white.withOpacity(0.2),
                                      Colors.white.withOpacity(0.3)
                                      // Color(0xfffbfbfb),
                                      // Color(0xfff7f7f7),
                                    ],
                                    // begin: Alignment.topCenter,
                                    // end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: customText(
                                    authState.userModel?.location == 'Nigeria'
                                        ? 'Duct Comission : ₦${commissionController.text}'
                                        : 'Duct Comission : £${commissionController.text}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w100),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blueGrey[50],
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.1),
                                      Colors.white.withOpacity(0.2),
                                      Colors.white.withOpacity(0.3)
                                      // Color(0xfffbfbfb),
                                      // Color(0xfff7f7f7),
                                    ],
                                    // begin: Alignment.topCenter,
                                    // end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: customText(
                                    authState.userModel?.location == 'Nigeria'
                                        ? 'Category Commission : ₦${commissionP}'
                                        : 'Category Commission : £${commissionP}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w100),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blueGrey[50],
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.1),
                                      Colors.white.withOpacity(0.2),
                                      Colors.white.withOpacity(0.3)
                                      // Color(0xfffbfbfb),
                                      // Color(0xfff7f7f7),
                                    ],
                                    // begin: Alignment.topCenter,
                                    // end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: customText(
                                    'Product Price : ₦${priceController.text}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text(
                              'Total',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              authState.userModel?.location == 'Nigeria'
                                  ? '₦$totalPrice'
                                  : '£$totalPrice',
                              style: const TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              )
//             Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: TextFormField(
//                       controller: productBrandController,
//                       decoration: InputDecoration(hintText: 'Brand'),
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'You must enter the product Brand';
//                         } else if (value.length > 10) {
//                           return 'Brand name cant have more than 10 letters';
//                         }
//                       },
//                     ),
//                   ),

// //

//                   Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: TextFormField(
//                       controller: keyWord,
//                       keyboardType: TextInputType.number,
//                       decoration: InputDecoration(
//                         hintText: 'Stock Quantity',
//                       ),
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'You must enter the product stock qauntity';
//                         }
//                       },
//                     ),
//                   ),

//                   // Padding(
//                   //   padding: const EdgeInsets.all(12.0),
//                   //   child: TextFormField(
//                   //     controller: priceController,
//                   //     keyboardType: TextInputType.number,
//                   //     decoration: InputDecoration(
//                   //       hintText: 'Price',
//                   //     ),
//                   //     validator: (value) {
//                   //       if (value.isEmpty) {
//                   //         return 'You must enter the price of the product';
//                   //       }
//                   //     },
//                   //   ),
//                   // ),
//                   // Padding(
//                   //   padding: const EdgeInsets.all(12.0),
//                   //   child: TextFormField(
//                   //     controller: commissionController,
//                   //     keyboardType: TextInputType.number,
//                   //     decoration: InputDecoration(
//                   //       hintText: 'vDuct Commission(%)',
//                   //     ),
//                   //     validator: (value) {
//                   //       if (value.isEmpty) {
//                   //         return 'You must enter how much commission you will give';
//                   //       }
//                   //     },
//                   //   ),
//                   // ),
//                   Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: TextFormField(
//                       controller: weightController,
//                       keyboardType: TextInputType.number,
//                       decoration: InputDecoration(
//                         hintText: 'Product Weight(kg)',
//                       ),
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'You must enter the weight of the product';
//                         }
//                       },
//                     ),
//                   ),
//                   _cakeGroceriesCategory ? Container() : _cakeCategory(),
//                   _fruitsGroceriesCategory ? Container() : _fruitsCategory(),
//                   Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Column(
//                             children: [
//                               Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(20),
//                                   color: Colors.blueGrey[50],
//                                   gradient: LinearGradient(
//                                     colors: [
//                                       Colors.white.withOpacity(0.1),
//                                       Colors.white.withOpacity(0.2),
//                                       Colors.white.withOpacity(0.3)
//                                       // Color(0xfffbfbfb),
//                                       // Color(0xfff7f7f7),
//                                     ],
//                                     // begin: Alignment.topCenter,
//                                     // end: Alignment.bottomCenter,
//                                   ),
//                                 ),
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(5.0),
//                                   child: customText(
//                                     'Duct Comission : ₦${commissionController.text}',
//                                     style: TextStyle(
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.w100),
//                                   ),
//                                 ),
//                               ),
//                               Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(20),
//                                   color: Colors.blueGrey[50],
//                                   gradient: LinearGradient(
//                                     colors: [
//                                       Colors.white.withOpacity(0.1),
//                                       Colors.white.withOpacity(0.2),
//                                       Colors.white.withOpacity(0.3)
//                                       // Color(0xfffbfbfb),
//                                       // Color(0xfff7f7f7),
//                                     ],
//                                     // begin: Alignment.topCenter,
//                                     // end: Alignment.bottomCenter,
//                                   ),
//                                 ),
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(5.0),
//                                   child: customText(
//                                     'Category Commission : $comissionValue%',
//                                     style: TextStyle(
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.w100),
//                                   ),
//                                 ),
//                               ),
//                               Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(20),
//                                   color: Colors.blueGrey[50],
//                                   gradient: LinearGradient(
//                                     colors: [
//                                       Colors.white.withOpacity(0.1),
//                                       Colors.white.withOpacity(0.2),
//                                       Colors.white.withOpacity(0.3)
//                                       // Color(0xfffbfbfb),
//                                       // Color(0xfff7f7f7),
//                                     ],
//                                     // begin: Alignment.topCenter,
//                                     // end: Alignment.bottomCenter,
//                                   ),
//                                 ),
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(5.0),
//                                   child: customText(
//                                     'Product Price : ₦${priceController.text}',
//                                     style: TextStyle(
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.w600),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                       Padding(
//                         padding:
//                             const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 4.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: <Widget>[
//                             Text(
//                               'Total',
//                               style: TextStyle(
//                                   fontSize: 18.0, fontWeight: FontWeight.w600),
//                             ),
//                             Text(
//                               'NGN$totalPrice',
//                               style: TextStyle(
//                                   fontSize: 18.0, fontWeight: FontWeight.w600),
//                             )
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               )
      ],
    );
  }

  _electronics() {
    int vDuctPrice = int.tryParse(commissionController.text)!;
    // double vDuctPrice = int.tryParse(priceController.text)! *
    //     int.tryParse(commissionController.text)! /
    //     100;
    // double commissionPrice =
    //     int.tryParse(priceController.text)! * comissionValue / 100;
    commissionP.value =
        (userCartController.venDor.value.commission!.toDouble() *
            double.parse(priceController.text));
    if (commissionP.value > 20000 &&
        authState.userModel?.location == 'Nigeria') {
      setState(() {
        commissionP.value = 20000;
      });
    }
    totalPrice =
        (int.tryParse(priceController.text)! + commissionP.value + vDuctPrice)
            .toString();
    return Column(
      children: [
        //              select category
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Electronics Category: ',
                style: TextStyle(color: red),
              ),
            ),
            DropdownButton(
              style: const TextStyle(color: Colors.yellow),
              dropdownColor: Colors.grey.withOpacity(.3),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              items: electronicsCategoriesDropDown,
              onChanged: changeSelectedElectronicsCategory,
              value: _currentElectronicsCategory,
              hint: const Text('Select a Category'),
            ),
          ],
        ),
        _currentElectronicsCategory == null
            ? Container()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    margin: const EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.grey.withOpacity(.3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      child: TextFormField(
                        controller: productBrandController,
                        decoration: const InputDecoration(hintText: 'Brand'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'You must enter the product Brand';
                          } else if (value.length > 10) {
                            return 'Brand name cant have more than 10 letters';
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  frostedWhite(Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customTitleText(
                          'Product in Stocks',
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SfSlider(
                                  min: 1.0,
                                  max: 24.0,
                                  interval: 4.0,
                                  activeColor: Colors.teal,
                                  showLabels: true,
                                  inactiveColor: Colors.grey,
                                  enableTooltip: true,
                                  value: _stockNumber,
                                  onChanged: (value) {
                                    setState(() {
                                      _stockNumber = value;
                                    });
                                  }),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  _stockNumber.toString(),
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    margin: const EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.grey.withOpacity(.3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      child: TextFormField(
                        controller: keyWord,
                        //   keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Search Keyword',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'You must enter the product stock qauntity';
                          }
                        },
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    margin: const EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.grey.withOpacity(.3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      child: TextFormField(
                        controller: weightController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Product Weight in (g)',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'You must enter the weight of the product';
                          }
                        },
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                              onTap: () {
                                DropDownState(DropDown(
                                        //bottomSheetTitle: 'Colors',
                                        // submitButtonText: 'Add',
                                        submitButtonChild: Text('Add'),
                                        dropDownBackgroundColor: bgColor,
                                        selectedItems: (items) {
                                          selectedItemsColors = items;
                                          // changeSelectedSize(items);
                                          setState(() {});
                                          cprint('$selectedItemsColors');
                                        },
                                        // searchBackgroundColor: bgColor,
                                        // searchController:
                                        //     searchControllerColors,
                                        data: _colordata,
                                        enableMultipleSelection: true))
                                    .showModal(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                margin: const EdgeInsets.only(top: 30),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.yellow.withOpacity(.3),
                                ),
                                child: const Text(
                                  'Select Colors >',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )),
                          selectedItemsColors == null
                              ? Container()
                              : Row(
                                  children: [
                                    const Text(
                                      "Selected Colors:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.cyan),
                                    ),
                                    Text(
                                      " $selectedItemsColors",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                              onTap: () {
                                DropDownState(DropDown(
                                        // bottomSheetTitle: 'Sizes',
                                        submitButtonChild: Text('Add'),
                                        dropDownBackgroundColor: bgColor,
                                        selectedItems: (items) {
                                          selectedItemsSizes = items;
                                          // changeSelectedSize(items);
                                          setState(() {});
                                          //  cprint('$selectedItemsSizes');
                                        },
                                        // searchBackgroundColor: bgColor,
                                        // searchController: searchController,
                                        data: _data,
                                        enableMultipleSelection: true))
                                    .showModal(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                margin: const EdgeInsets.only(top: 30),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.yellow.withOpacity(.3),
                                ),
                                child: const Text(
                                  'Select Sizes >',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )),
                          selectedItemsSizes == null
                              ? Container()
                              : Row(
                                  children: [
                                    const Text(
                                      "Selected Sizes:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.cyan),
                                    ),
                                    Text(
                                      " $selectedItemsSizes",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blueGrey[50],
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.1),
                                      Colors.white.withOpacity(0.2),
                                      Colors.white.withOpacity(0.3)
                                      // Color(0xfffbfbfb),
                                      // Color(0xfff7f7f7),
                                    ],
                                    // begin: Alignment.topCenter,
                                    // end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: customText(
                                    authState.userModel?.location == 'Nigeria'
                                        ? 'Duct Comission : ₦${commissionController.text}'
                                        : 'Duct Comission : £${commissionController.text}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w100),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blueGrey[50],
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.1),
                                      Colors.white.withOpacity(0.2),
                                      Colors.white.withOpacity(0.3)
                                      // Color(0xfffbfbfb),
                                      // Color(0xfff7f7f7),
                                    ],
                                    // begin: Alignment.topCenter,
                                    // end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: customText(
                                    authState.userModel?.location == 'Nigeria'
                                        ? 'Category Commission : ₦${commissionP}'
                                        : 'Category Commission : £${commissionP}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w100),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blueGrey[50],
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.1),
                                      Colors.white.withOpacity(0.2),
                                      Colors.white.withOpacity(0.3)
                                      // Color(0xfffbfbfb),
                                      // Color(0xfff7f7f7),
                                    ],
                                    // begin: Alignment.topCenter,
                                    // end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: customText(
                                    authState.userModel?.location == 'Nigeria'
                                        ? 'Product Price : ₦${priceController.text}'
                                        : 'Product Price : £${priceController.text}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text(
                              'Total',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              authState.userModel?.location == 'Nigeria'
                                  ? '₦$totalPrice'
                                  : '£$totalPrice',
                              style: const TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              )
      ],
    );
  }

  _fashion() {
    int vDuctPrice = int.tryParse(commissionController.text)!;
    // double vDuctPrice = int.tryParse(priceController.text)! *
    //     int.tryParse(commissionController.text)! /
    //     100;
    // double commissionPrice =
    //     int.tryParse(priceController.text)! * comissionValue / 100;
    commissionP.value =
        (userCartController.venDor.value.commission!.toDouble() *
            double.parse(priceController.text));
    totalPrice =
        (int.tryParse(priceController.text)! + commissionP.value + vDuctPrice)
            .toString();
    return Column(
      children: [
        //              select category
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Fashion Category: ',
                style: TextStyle(color: red),
              ),
            ),
            DropdownButton(
              style: const TextStyle(color: Colors.yellow),
              dropdownColor: Colors.grey.withOpacity(.3),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              items: fashionCategoriesDropDown,
              onChanged: changeSelectedFashionCategory,
              value: _currentFashionCategory,
              hint: const Text('Select a Category'),
            ),
          ],
        ),
        _currentFashionCategory == null
            ? Container()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    margin: const EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.grey.withOpacity(.3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      child: TextFormField(
                        controller: productBrandController,
                        decoration: const InputDecoration(hintText: 'Brand'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'You must enter the product Brand';
                          } else if (value.length > 10) {
                            return 'Brand name cant have more than 10 letters';
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  frostedWhite(Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customTitleText(
                          'Product in Stocks',
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SfSlider(
                                  min: 1.0,
                                  max: 24.0,
                                  interval: 4.0,
                                  activeColor: Colors.teal,
                                  showLabels: true,
                                  inactiveColor: Colors.grey,
                                  enableTooltip: true,
                                  value: _stockNumber,
                                  onChanged: (value) {
                                    setState(() {
                                      _stockNumber = value;
                                    });
                                  }),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  _stockNumber.toString(),
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    margin: const EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.grey.withOpacity(.3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      child: TextFormField(
                        controller: keyWord,
                        //   keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Search Keyword',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'You must enter the product stock qauntity';
                          }
                        },
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    margin: const EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.grey.withOpacity(.3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      child: TextFormField(
                        controller: weightController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Product Weight in (g)',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'You must enter the weight of the product';
                          }
                        },
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                              onTap: () {
                                DropDownState(DropDown(
                                        //
                                        // submitButtonText: 'Add',
                                        submitButtonChild: Text('Add'),
                                        dropDownBackgroundColor: bgColor,
                                        selectedItems: (items) {
                                          selectedItemsColors = items;
                                          // changeSelectedSize(items);
                                          setState(() {});
                                          cprint('$selectedItemsColors');
                                        },
                                        // searchBackgroundColor: bgColor,
                                        // searchController:
                                        //     searchControllerColors,
                                        data: _colordata,
                                        enableMultipleSelection: true))
                                    .showModal(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                margin: const EdgeInsets.only(top: 30),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.yellow.withOpacity(.3),
                                ),
                                child: const Text(
                                  'Select Colors >',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )),
                          selectedItemsColors == null
                              ? Container()
                              : Row(
                                  children: [
                                    const Text(
                                      "Selected Colors:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.cyan),
                                    ),
                                    Text(
                                      " $selectedItemsColors",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                              onTap: () {
                                DropDownState(DropDown(
                                        // bottomSheetTitle: 'Sizes',
                                        submitButtonChild: Text('Add'),
                                        dropDownBackgroundColor: bgColor,
                                        selectedItems: (items) {
                                          selectedItemsSizes = items;
                                          // changeSelectedSize(items);
                                          setState(() {});
                                          // cprint('$selectedItemsSizes');
                                        },
                                        // searchBackgroundColor: bgColor,
                                        // searchController: searchController,
                                        data: _data,
                                        enableMultipleSelection: true))
                                    .showModal(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                margin: const EdgeInsets.only(top: 30),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.yellow.withOpacity(.3),
                                ),
                                child: const Text(
                                  'Select Sizes >',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )),
                          selectedItemsSizes == null
                              ? Container()
                              : Row(
                                  children: [
                                    const Text(
                                      "Selected Sizes:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.cyan),
                                    ),
                                    Text(
                                      " $selectedItemsSizes",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blueGrey[50],
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.1),
                                      Colors.white.withOpacity(0.2),
                                      Colors.white.withOpacity(0.3)
                                      // Color(0xfffbfbfb),
                                      // Color(0xfff7f7f7),
                                    ],
                                    // begin: Alignment.topCenter,
                                    // end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: customText(
                                    authState.userModel?.location == 'Nigeria'
                                        ? 'Duct Comission : ₦${commissionController.text}'
                                        : 'Duct Comission : £${commissionController.text}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w100),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blueGrey[50],
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.1),
                                      Colors.white.withOpacity(0.2),
                                      Colors.white.withOpacity(0.3)
                                      // Color(0xfffbfbfb),
                                      // Color(0xfff7f7f7),
                                    ],
                                    // begin: Alignment.topCenter,
                                    // end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: customText(
                                    authState.userModel?.location == 'Nigeria'
                                        ? 'Category Commission : ₦${commissionP}'
                                        : 'Category Commission : £${commissionP}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w100),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blueGrey[50],
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.1),
                                      Colors.white.withOpacity(0.2),
                                      Colors.white.withOpacity(0.3)
                                      // Color(0xfffbfbfb),
                                      // Color(0xfff7f7f7),
                                    ],
                                    // begin: Alignment.topCenter,
                                    // end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: customText(
                                    'Product Price : ₦${priceController.text}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text(
                              'Total',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              authState.userModel?.location == 'Nigeria'
                                  ? '₦$totalPrice'
                                  : '£$totalPrice',
                              style: const TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              )
      ],
    );
  }

  changeSelectedSection(String? selectedSection) {
    switch (selectedSection) {
      case "Children":
        setState(() {
          _childrenSection = false;
          _electronicsSection = true;
          _adultfashionSection = true;
          _groceriesSection = true;
          _booksSection = true;
          _housingSection = true;
          _farmSection = true;
        });

        break;
      case "Adult Fashion":
        setState(() {
          _childrenSection = true;
          _electronicsSection = true;
          _adultfashionSection = false;
          _groceriesSection = true;
          _booksSection = true;
          _housingSection = true;
          _farmSection = true;
        });
        break;
      case "Books":
        setState(() {
          _childrenSection = true;
          _electronicsSection = true;
          _adultfashionSection = true;
          _groceriesSection = true;
          _booksSection = false;
          _housingSection = true;
          _farmSection = true;
        });
        break;
      case "Farm":
        setState(() {
          _childrenSection = true;
          _electronicsSection = true;
          _adultfashionSection = true;
          _groceriesSection = true;
          _booksSection = true;
          _housingSection = true;
          _farmSection = false;
        });
        break;
      case "Housing":
        setState(() {
          _childrenSection = true;
          _electronicsSection = true;
          _adultfashionSection = true;
          _groceriesSection = true;
          _booksSection = true;
          _housingSection = false;
          _farmSection = true;
        });
        break;
      case "Groceries":
        setState(() {
          _childrenSection = true;
          _electronicsSection = true;
          _adultfashionSection = true;
          _booksSection = true;
          _housingSection = true;
          _farmSection = true;
          _groceriesSection = false;
        });

        break;
      case "Electronics":
        setState(() {
          _childrenSection = true;
          _electronicsSection = false;
          _adultfashionSection = true;
          _booksSection = true;
          _housingSection = true;
          _farmSection = true;
          _groceriesSection = true;
        });
        break;
      default:
    }
    setState(() {
      _currentSection = selectedSection;
    });
  }

  void changeSelectedSize(String size) {
    if (selectedSizes.contains(size)) {
      setState(() {
        selectedSizes.remove(size);
      });
    } else {
      setState(() {
        selectedSizes.insert(0, size);
      });
    }
  }

  void changeSelectedColors(String color) {
    if (selectedColors.contains(color)) {
      setState(() {
        selectedColors.remove(color);
      });
    } else {
      setState(() {
        selectedColors.insert(0, color);
      });
    }
  }

  void _selectImage(PickedFile? pickImage, int imageNumber) async {
    if (File(pickImage!.path).lengthSync() > 1000000) {
      setState(() {
        pickImage = null;
        _video = null;
      });

      _showDialog();
    } else {
      File tempImg = File(pickImage.path);
      switch (imageNumber) {
        case 1:
          setState(() => _image1 = tempImg);
          break;
        case 2:
          setState(() => _image2 = tempImg);
          break;
        case 3:
          setState(() => _image3 = tempImg);
          break;
      }
    }
  }

  Widget _displayChild1() {
    //  if (_image1 == null) {
    return Icon(
      CupertinoIcons.camera_fill,
      color: grey,
      size: Get.height * 0.07,
    );
    //  }
    //  else {
    //   return Container(
    //     width: Get.height * 0.5,
    //     height: Get.height * 0.4,
    //     margin: const EdgeInsets.only(top: 30),
    //     decoration: BoxDecoration(
    //       image:
    //           DecorationImage(image: FileImage(_image1!), fit: BoxFit.contain),
    //       borderRadius: BorderRadius.circular(25),
    //       color: Colors.grey.withOpacity(.3),
    //     ),
    //   );
    // }
  }

  Widget _displayVideo() {
    // if (_video == null) {
    return Icon(
      CupertinoIcons.videocam_fill,
      color: grey,
      size: Get.height * 0.07,
    );
    // }
    // else {
    //   return Stack(
    //     children: [
    //       Column(
    //         children: [
    //           Container(
    //             height: fullWidth(context) * 0.5,
    //             width: fullWidth(context),
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(20),
    //             ),
    //             child: SizedBox.expand(
    //               child: FittedBox(
    //                   //spectRatio: 2 / 2,
    //                   fit: BoxFit.contain,
    //                   child: Padding(
    //                     padding: const EdgeInsets.all(5.0),
    //                     child: frostedTeal(
    //                       SizedBox(
    //                           height: fullWidth(context),
    //                           width: fullWidth(context),
    //                           child: Stack(
    //                             children: [
    //                               GestureDetector(
    //                                 onTap: () {
    //                                   if (_controller.value.isPlaying) {
    //                                     _controller.pause();
    //                                   } else {
    //                                     _controller.play();
    //                                   }
    //                                 },
    //                                 child: VideoPlayer(_controller),
    //                               ),
    //                             ],
    //                           )),
    //                     ),
    //                   )),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ],
    //   );
    // }
  }

  Widget _displayChild2() {
    if (_image2 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 50, 14, 50),
        child: Icon(
          Icons.add,
          color: grey,
        ),
      );
    } else {
      return Image.file(
        _image2!,
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
  }

  Widget _displayChild3() {
    if (_image3 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 50, 14, 50),
        child: Icon(
          Icons.add,
          color: grey,
        ),
      );
    } else {
      return Image.file(
        _image3!,
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
  }
}

class _TextField extends StatelessWidget {
  const _TextField(
      {Key? key,
      this.textEditingController,
      this.isTweet = false,
      this.isRetweet = false})
      : super(key: key);
  final TextEditingController? textEditingController;
  final bool isTweet;
  final bool isRetweet;

  @override
  Widget build(BuildContext context) {
    //final searchState = Provider.of<SearchState>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        frostedBlack(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextFormField(
              controller: textEditingController,
              onChanged: (text) {
                composeductState.onDescriptionChanged(text, searchState);
              },
              maxLines: null,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: isTweet
                      ? 'What\'s the latest Product?'
                      : isRetweet
                          ? 'Add a comment'
                          : 'Duct your reply',
                  hintStyle: const TextStyle(fontSize: 18)),
            ),
          ),
        ),
      ],
    );
  }
}

class _CustomeSubmitbutton extends StatefulWidget {
  const _CustomeSubmitbutton(
      {Key? key,
      this.leading,
      this.title,
      this.actions,
      this.scaffoldKey,
      this.icon,
      this.onActionPressed,
      this.textController,
      this.isBackButton = false,
      this.isCrossButton = false,
      this.submitButtonText,
      this.isSubmitDisable = true,
      this.isbootomLine = true,
      this.onSearchChanged})
      : super(key: key);

  final List<Widget>? actions;
  final int? icon;
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
  __CustomeSubmitbuttonState createState() => __CustomeSubmitbuttonState();
}

class __CustomeSubmitbuttonState extends State<_CustomeSubmitbutton> {
  List<Widget> _getActionButtons(BuildContext context) {
    return <Widget>[
      widget.submitButtonText != null
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: customInkWell(
                context: context,
                radius: BorderRadius.circular(40),
                onPressed: () {
                  if (widget.onActionPressed != null) widget.onActionPressed!();
                },
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(50),
                  shadowColor: Theme.of(context).primaryColor.withAlpha(150),
                  child: Container(
                    alignment: Alignment.center,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    decoration: BoxDecoration(
                      color: !widget.isSubmitDisable
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).primaryColor.withAlpha(150),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.submitButtonText!,
                      style: TextStyle(
                          fontSize: 25,
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                ),
              ),
            )
          : widget.icon == null
              ? Container()
              : IconButton(
                  onPressed: () {
                    if (widget.onActionPressed != null) {
                      widget.onActionPressed!();
                    }
                  },
                  icon: customIcon(context,
                      icon: widget.icon!,
                      istwitterIcon: true,
                      iconColor: AppColor.primary,
                      size: fullWidth(context) * 0.1),
                )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: _getActionButtons(context),
    );
  }
}
