// ignore_for_file: invalid_use_of_protected_member, file_names

import 'dart:ui';

import 'package:azlistview/azlistview.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:permission_handler/permission_handler.dart' as permission;
import 'package:viewducts/helper/constant.dart';
import 'package:viewducts/helper/theme.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/page/responsiveView.dart';
//import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/frosted.dart';
import 'package:viewducts/widgets/newWidget/title_text.dart';

class NewMessagePage extends StatefulWidget {
  const NewMessagePage({Key? key, this.scaffoldKey}) : super(key: key);

  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  State<NewMessagePage> createState() => _NewMessagePageState();
}

class _NewMessagePageState extends State<NewMessagePage> {
//   @override
  TextEditingController textController = TextEditingController();

  // @override
  // Widget _searchField() {
  //   //final state = Provider.of<SearchState>(context);
  //   return Container(
  //       height: 50,
  //       padding: const EdgeInsets.symmetric(vertical: 5),
  //       child: TextField(
  //         onChanged: (text) {
  //           searchState.filterByUsername(text);
  //         },
  //         controller: textController,
  //         decoration: InputDecoration(
  //           border: const OutlineInputBorder(
  //             borderSide: BorderSide(width: 0, style: BorderStyle.none),
  //             borderRadius: BorderRadius.all(
  //               Radius.circular(25.0),
  //             ),
  //           ),
  //           hintText: 'Search ViewDucts Users',
  //           fillColor: AppColor.extraLightGrey,
  //           filled: true,
  //           focusColor: Colors.white,
  //           contentPadding:
  //               const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
  //         ),
  //       ));
  // }

  // // Widget _userTile(ViewductsUser user) {
  // Future<bool> _onWillPop() async {
  //   //final state = Provider.of<SearchState>(context, listen: false);
  //   searchState.filterByUsername("");
  //   return true;
  // }

  RxString? searchValue = ''.obs;
  RxList<Contact> contact = RxList<Contact>();
  Future<List<Contact>> getContactList() async {
    bool isGranted = await permission.Permission.contacts.isGranted;
    if (!isGranted) {
      isGranted = await permission.Permission.contacts.request().isGranted;
    }
    if (isGranted) {
      contact.value = await FastContacts.allContacts;
      try {
        FToast().init(Get.context!);
        // final database = Databases(
        //   clientConnect(),
        // );

        // //  if (searchValue != '') {
        // await database.listDocuments(
        //     databaseId: databaseId,
        //     collectionId: profileUserColl,
        //     queries: [
        //       // Query.equal(
        //       //     'contact',
        //       //     contact.value
        //       //         .map((data) =>
        //       //             int.tryParse(data.phones[0].toLowerCase().toString()))
        //       //         .toList())
        //     ]).then((data) {
        //   var value = data.documents
        //       .map((e) => ViewductsUser.fromJson(e.data))
        //       .toList();

        //   userCartController.listChatUser?.value = value;
        // });
        // await database.listDocuments(
        //     databaseId: databaseId,
        //     collectionId: mainUserViews,
        //     queries: [
        //       Query.orderDesc('createdAt'),
        //       Query.equal('viewerId', authState.appUser!.$id),
        //       Query.equal(
        //           'viewductUser',
        //           userCartController.listChatUser
        //               ?.map((data) => data.key)
        //               .toList()),
        //     ]).then((data) {
        //   var value = data.documents
        //       .map((e) => MainUserViewsModel.fromJson(e.data))
        //       .toList();
        //   feedState.userViers.value = value;
        // });
        return contact.value;
      } catch (e) {
        cprint(e.toString());
      }
      return contact.value;
    }
    return [];
  }

  void itemProduct(String value) {
    searchValue = value.obs;
    setState(() {});
    // allUser();
  }

  RxList<ViewductsUser>? listChatUser2 = RxList<ViewductsUser>();
  // allUser() async {
  //   final database = Databases(
  //     clientConnect(),
  //   );

  //   if (searchValue != '') {
  //     await database.listDocuments(
  //         databaseId: databaseId,
  //         collectionId: profileUserColl,
  //         queries: [
  //           Query.equal('contact', int.tryParse('${searchValue?.value}'))
  //         ]).then((data) {
  //       var value =
  //           data.documents.map((e) => ViewductsUser.fromJson(e.data)).toList();

  //       listChatUser2?.value = value;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // listChatUser!
    //     .bindStream(feedState.getContactFromDatabase(searchValue?.value));
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              bottom: -80,
              left: -250,
              child: Transform.rotate(
                angle: 90,
                child: Container(
                  height: fullWidth(context) * 0.8,
                  width: fullWidth(context),
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/ankkara1.jpg'))),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: -250,
              child: Transform.rotate(
                angle: 90,
                child: Container(
                  height: fullWidth(context) * 0.8,
                  width: fullWidth(context),
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/ankara3.jpg'))),
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              right: -260,
              child: Transform.rotate(
                angle: 30,
                child: Container(
                  height: fullWidth(context) * 0.8,
                  width: fullWidth(context),
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/ankkara1.jpg'))),
                ),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(
                color: (Colors.white12).withOpacity(0.1),
              ),
            ),
            FractionallySizedBox(
              heightFactor: 1 - 0.05,
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: context.height,
                width: context.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Flexible(
                    //   child: Material(
                    //     elevation: 10,
                    //     borderRadius: BorderRadius.circular(10),
                    //     child: frostedOrange(
                    //       Container(
                    //         decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(20),
                    //             color: Colors.blueGrey[50],
                    //             gradient: LinearGradient(
                    //               colors: [
                    //                 Colors.yellow.withOpacity(0.1),
                    //                 Colors.white60.withOpacity(0.2),
                    //                 Colors.orange.withOpacity(0.3)
                    //               ],
                    //               // begin: Alignment.topCenter,
                    //               // end: Alignment.bottomCenter,
                    //             )),
                    //         child: Row(
                    //           children: [
                    //             Material(
                    //               elevation: 10,
                    //               borderRadius: BorderRadius.circular(100),
                    //               child: CircleAvatar(
                    //                 radius: 14,
                    //                 backgroundColor: Colors.transparent,
                    //                 child: Image.asset('assets/delicious.png'),
                    //               ),
                    //             ),
                    //             Padding(
                    //               padding: const EdgeInsets.symmetric(
                    //                   horizontal: 8.0, vertical: 3),
                    //               child: customTitleText('ViewDucts'),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    // Flexible(
                    //   flex: 5,
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(4.0),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         Material(
                    //           elevation: 20,
                    //           borderRadius: BorderRadius.circular(100),
                    //           child: SizedBox(
                    //             width: context.responsiveValue(
                    //                 mobile: Get.height * 0.4,
                    //                 tablet: Get.height * 0.4,
                    //                 desktop: Get.height * 0.4),
                    //             height: context.responsiveValue(
                    //                 mobile: Get.height * 0.05,
                    //                 tablet: Get.height * 0.05,
                    //                 desktop: Get.height * 0.05),
                    //             child: CupertinoSearchTextField(
                    //                 placeholder: 'ViewDucts Users by Number',
                    //                 onChanged: (data) {
                    //                   return itemProduct(data);
                    //                 }),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),

                    //   //  CustomScrollView(
                    //   //   slivers: <Widget>[
                    //   //     CupertinoSliverNavigationBar(
                    //   //       backgroundColor: Colors.transparent,
                    //   //       leading: Container(),
                    //   //       largeTitle: Text(
                    //   //         'Contacts',
                    //   //         style: TextStyle(color: Colors.blueGrey[200]),
                    //   //       ),
                    //   //     ),
                    //   //   ],
                    //   // ),
                    // ),

                    listChatUser2!.isEmpty
                        ? Container()
                        : Flexible(
                            flex: 6,
                            child: SizedBox(
                              width: Get.width,
                              // height: Get.height,
                              child: ListView.separated(
                                addAutomaticKeepAlives: false,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container()
                                    //  _UserTile(
                                    //   user: listChatUser2?.value[index],
                                    // ),
                                    ),
                                separatorBuilder: (_, index) => const Divider(
                                  height: 0,
                                ),
                                itemCount: listChatUser2!.value.length,
                              ),
                            ),
                          ),
                    Material(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.transparent,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 3),
                          child: customText(
                            'Contacts',
                            style: const TextStyle(
                                // color: Colors.black45,
                                fontSize: 35,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                    Expanded(
                        flex: 20,
                        child: FutureBuilder(
                            initialData: contact.value,
                            future: getContactList(),
                            builder: ((context, AsyncSnapshot snapshot) {
                              // allUser();
                              if (snapshot.data == null) {
                                return Center(
                                    child: SizedBox(
                                  width: Get.height * 0.2,
                                  height: Get.height * 0.2,
                                  child: LoadingIndicator(
                                      indicatorType: Indicator.ballTrianglePath,

                                      /// Required, The loading type of the widget
                                      colors: const [
                                        Colors.pink,
                                        Colors.green,
                                        Colors.blue
                                      ],

                                      /// Optional, The color collections
                                      strokeWidth: 0.5,

                                      /// Optional, The stroke of the line, only applicable to widget which contains line
                                      backgroundColor: Colors.transparent,

                                      /// Optional, Background of the widget
                                      pathBackgroundColor: Colors.blue

                                      /// Optional, the stroke backgroundColor
                                      ),
                                )
                                    //  CircularProgressIndicator
                                    //     .adaptive()
                                    );
                              }
                              return AzListView(
                                data: contact
                                    .map((data) => ContactModel(
                                        name: data.displayName,
                                        tag: data.displayName[0].toUpperCase()))
                                    .toList(),
                                indexBarMargin: EdgeInsets.all(8),
                                indexHintBuilder: (context, hint) => Container(
                                  alignment: Alignment.center,
                                  width: 60,
                                  height: 60,
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
                                  child: TitleText(hint,
                                      color: CupertinoColors.systemYellow),
                                ),
                                indexBarOptions: IndexBarOptions(
                                    selectTextStyle: TextStyle(
                                        color: CupertinoColors.systemYellow),
                                    selectItemDecoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            CupertinoColors.darkBackgroundGray),
                                    needRebuild: true,
                                    indexHintAlignment: Alignment.center,
                                    indexHintOffset: Offset(20, 0)),
                                // selectedTextStyle: TextStyle(
                                //     color: CupertinoColors.systemYellow),
                                // unselectedTextStyle: TextStyle(),
                                itemCount: contact.length,
                                // overlayWidget: (value) => Stack(
                                //   alignment: Alignment.center,
                                //   children: [
                                //     Icon(
                                //       Icons.star,
                                //       size: 50,
                                //       color: CupertinoColors.darkBackgroundGray,
                                //     ),
                                //     Container(
                                //       height: 50,
                                //       width: 50,
                                //       decoration: BoxDecoration(
                                //         shape: BoxShape.circle,
                                //       ),
                                //       alignment: Alignment.center,
                                //       child: Text(
                                //         '$value'.toUpperCase(),
                                //         style: TextStyle(
                                //             fontSize: 18, color: Colors.white),
                                //       ),
                                //     ),
                                //   ],
                                // ),

                                itemBuilder: (
                                  context,
                                  index,
                                ) {
                                  contact.value = snapshot.data;
                                  Contact contacts = contact[index];

                                  ContactModel item = ContactModel(
                                      name: contacts.displayName,
                                      tag: contacts.displayName);
                                  final tag = item.getSuspensionTag();

                                  // contact
                                  //     .map((data) => ContactModel(
                                  //             name: data.displayName,
                                  //             tag: data.displayName[0]
                                  //                 .toUpperCase())
                                  //         .getSuspensionTag())
                                  //     .first;
                                  final offStage = !item.isShowSuspension;
                                  // contact
                                  //     .map((data) => ContactModel(
                                  //             name: data.displayName,
                                  //             tag: data.displayName[0]
                                  //                 .toUpperCase())
                                  //         .isShowSuspension)
                                  //     .first;
                                  SuspensionUtil.setShowSuspensionStatus(contact
                                      .map((data) => ContactModel(
                                          name: data.displayName,
                                          tag: data.displayName[0]
                                              .toUpperCase()))
                                      .toList());
                                  SuspensionUtil.sortListBySuspensionTag(contact
                                      .map((data) => ContactModel(
                                          name: data.displayName,
                                          tag: data.displayName[0]
                                              .toUpperCase()))
                                      .toList());
                                  return Column(
                                    children: [
                                      Offstage(
                                        offstage: offStage,
                                        child: Container(
                                          height: 40,
                                          child: TitleText('$tag'),
                                        ),
                                      ),
                                      ListTile(
                                          onTap: () async {
                                            // chatState.chatMessage.value =
                                            //     await SQLHelper.findLocalMessages(
                                            //         '${authState.appUser?.$id.splitByLengths((authState.appUser!.$id.length) ~/ 2)[0]}_${userCartController.listChatUser?.value.firstWhere((data) => data.contact == int.tryParse(contact.phones[0]), orElse: () => ViewductsUser()).userId!.splitByLengths((userCartController.listChatUser!.value.firstWhere((data) => data.contact == int.tryParse(contact.phones[0]), orElse: () => ViewductsUser()).userId!.length) ~/ 2)[0]}');
                                            // if (chatState
                                            //     .chatMessage.value.isEmpty) {
                                            //   chatState.chatMessage.value =
                                            //       await SQLHelper.findLocalMessages(
                                            //           '${userCartController.listChatUser!.value.firstWhere((data) => data.contact == int.tryParse(contact.phones[0]), orElse: () => ViewductsUser()).userId!.splitByLengths((userCartController.listChatUser!.value.firstWhere((data) => data.contact == int.tryParse(contact.phones[0]), orElse: () => ViewductsUser()).userId!.length) ~/ 2)[0]}_${authState.appUser!.$id.splitByLengths((authState.appUser!.$id.length) ~/ 2)[0]}');
                                            // }
                                            // chatState.chatMessage.value = [];
                                            // feedState.dataBaseChatsId?.value ==
                                            //     null;
                                            // chatState.setChatUser =
                                            //     userCartController
                                            //         .listChatUser?.value
                                            //         .firstWhere(
                                            //             (data) =>
                                            //                 data.contact ==
                                            //                 int.tryParse(
                                            //                     contact.phones[0]
                                            //                         .toString()),
                                            //             orElse: () =>
                                            //                 ViewductsUser());
                                            // userCartController.listChatUser?.value
                                            //             .firstWhere(
                                            //                 (data) =>
                                            //                     data.contact ==
                                            //                     int.tryParse(contact
                                            //                         .phones[0]
                                            //                         .toString()),
                                            //                 orElse: () =>
                                            //                     ViewductsUser())
                                            //             .contact ==
                                            //         null
                                            //     ? SizedBox()
                                            //     : kAnalytics.logViewSearchResults(
                                            //         searchTerm: userCartController
                                            //                 .listChatUser?.value
                                            //                 .firstWhere(
                                            //                     (data) =>
                                            //                         data.contact ==
                                            //                         int.tryParse(contact.phones[0]),
                                            //                     orElse: () => ViewductsUser())
                                            //                 .userName ??
                                            //             '');
                                            // // final chatState = Provider.of<ChatState>(context, listen: false);
                                            // userCartController.listChatUser?.value
                                            //             .firstWhere(
                                            //                 (data) =>
                                            //                     data.contact ==
                                            //                     int.tryParse(contact
                                            //                         .phones[0]),
                                            //                 orElse: () =>
                                            //                     ViewductsUser())
                                            //             .contact ==
                                            //         null
                                            //     ? SizedBox()
                                            //     : chatState.setChatUser =
                                            //         userCartController
                                            //             .listChatUser?.value
                                            //             .firstWhere(
                                            //                 (data) =>
                                            //                     data.contact ==
                                            //                     int.tryParse(contact.phones[0]),
                                            //                 orElse: () => ViewductsUser());
                                            // userCartController.listChatUser?.value
                                            //             .firstWhere(
                                            //                 (data) =>
                                            //                     data.contact ==
                                            //                     int.tryParse(
                                            //                         contact.phones[
                                            //                             0]),
                                            //                 orElse: () =>
                                            //                     ViewductsUser())
                                            //             .contact ==
                                            //         null
                                            //     ? SizedBox()
                                            //     : Get.back();
                                            // // Navigator.pop(Get.context);
                                            // userCartController.listChatUser?.value
                                            //             .firstWhere(
                                            //                 (data) =>
                                            //                     data.contact ==
                                            //                     int.tryParse(
                                            //                         contact.phones[
                                            //                             0]),
                                            //                 orElse: () =>
                                            //                     ViewductsUser())
                                            //             .contact ==
                                            //         null
                                            //     ? SizedBox()
                                            //     : Get.to(
                                            //         () => ChatResponsive(
                                            //               chatIdUsers: null,
                                            //               userProfileId: userCartController
                                            //                   .listChatUser?.value
                                            //                   .firstWhere(
                                            //                       (data) =>
                                            //                           data.contact ==
                                            //                           int.tryParse(
                                            //                               contact.phones[
                                            //                                   0]),
                                            //                       orElse: () =>
                                            //                           ViewductsUser())
                                            //                   .userId,
                                            //             ),
                                            //         transition:
                                            //             Transition.downToUp);
                                          },
                                          leading: Stack(
                                            children: [
                                              CircleAvatar(
                                                radius: 25,
                                                backgroundColor:
                                                    Colors.transparent,
                                                child: Stack(
                                                  children: [
                                                    // userCartController
                                                    //             .listChatUser!
                                                    //             .value
                                                    //             .firstWhere(
                                                    //                 (data) =>
                                                    //                     data.contact ==
                                                    //                     int.tryParse(contact
                                                    //                         .phones[
                                                    //                             0]
                                                    //                         .toString()),
                                                    //                 orElse: () =>
                                                    //                     ViewductsUser())
                                                    //             .email !=
                                                    //         null
                                                    //     ? Align(
                                                    //         alignment:
                                                    //             Alignment.center,
                                                    //         child: CircleAvatar(
                                                    //           radius: 24,
                                                    //           backgroundColor:
                                                    //               Colors.yellow
                                                    //                   .shade200,
                                                    //         ),
                                                    //       )
                                                    //     : Container(),
                                                    // Align(
                                                    //   alignment: Alignment.center,
                                                    //   child: CircleAvatar(
                                                    //     radius: 22,
                                                    //     backgroundColor:
                                                    //         Colors.transparent,
                                                    //     child: Material(
                                                    //       elevation: 20,
                                                    //       borderRadius:
                                                    //           BorderRadius
                                                    //               .circular(100),
                                                    //       child: userCartController
                                                    //                   .listChatUser!
                                                    //                   .value
                                                    //                   .firstWhere((data) => data.contact == int.tryParse(contact.phones[0].toString()),
                                                    //                       orElse: () =>
                                                    //                           ViewductsUser())
                                                    //                   .email ==
                                                    //               null
                                                    //           ? Padding(
                                                    //               padding:
                                                    //                   const EdgeInsets
                                                    //                           .all(
                                                    //                       8.0),
                                                    //               child: Align(
                                                    //                 alignment:
                                                    //                     Alignment
                                                    //                         .center,
                                                    //                 child:
                                                    //                     TitleText(
                                                    //                   contact
                                                    //                       .displayName
                                                    //                       .substring(
                                                    //                           0,
                                                    //                           2),
                                                    //                   fontSize:
                                                    //                       16,
                                                    //                 ),
                                                    //               ),
                                                    //             )
                                                    //           : customImage(
                                                    //               context,
                                                    //               userCartController
                                                    //                   .listChatUser
                                                    //                   ?.value
                                                    //                   .firstWhere((data) => data.contact == int.tryParse(contact.phones[0].toString()),
                                                    //                       orElse: () =>
                                                    //                           ViewductsUser())
                                                    //                   .profilePic,
                                                    //               height: fullHeight(
                                                    //                       context) *
                                                    //                   0.06),
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                              // Positioned(
                                              //   right: 0,
                                              //   bottom: 0,
                                              //   child: userCartController
                                              //               .listChatUser!.value
                                              //               .firstWhere(
                                              //                   (data) =>
                                              //                       data.contact ==
                                              //                       int.tryParse(contact
                                              //                           .phones[0]
                                              //                           .toString()),
                                              //                   orElse: () =>
                                              //                       ViewductsUser())
                                              //               .email !=
                                              //           null
                                              //       ? Material(
                                              //           elevation: 10,
                                              //           borderRadius:
                                              //               BorderRadius.circular(
                                              //                   100),
                                              //           child: CircleAvatar(
                                              //             radius: 9,
                                              //             backgroundColor:
                                              //                 Colors.transparent,
                                              //             child: Image.asset(
                                              //                 'assets/delicious.png'),
                                              //           ),
                                              //         )
                                              //       : Container(),
                                              // )
                                            ],
                                          ),
                                          title: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Flexible(
                                                child: TitleText(
                                                    // userCartController
                                                    //         .listChatUser!.value
                                                    //         .where(
                                                    //           (data) =>
                                                    //               data.contact ==
                                                    //               int.tryParse(contact
                                                    //                   .phones[0]),
                                                    //         )
                                                    //         .isEmpty
                                                    //     ? contact.displayName
                                                    //     : userCartController
                                                    //                 .listChatUser
                                                    //                 ?.value
                                                    //                 .firstWhere(
                                                    //                     (data) =>
                                                    //                         data.contact ==
                                                    //                         int.tryParse(
                                                    //                             contact.phones[
                                                    //                                 0]),
                                                    //                     orElse: () =>
                                                    //                         ViewductsUser())
                                                    //                 .displayName ==
                                                    //             null
                                                    //         ? contact.displayName
                                                    //         : userCartController
                                                    //                 .listChatUser
                                                    //                 ?.value
                                                    //                 .firstWhere(
                                                    //                     (data) =>
                                                    //                         data.contact ==
                                                    //                         int.tryParse(
                                                    //                             contact.phones[
                                                    //                                 0]),
                                                    //                     orElse: () =>
                                                    //                         ViewductsUser())
                                                    //                 .displayName ??
                                                    contacts.displayName,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w800,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                              const SizedBox(width: 3),
                                              // userCartController
                                              //             .listChatUser?.value
                                              //             .firstWhere(
                                              //                 (data) =>
                                              //                     data.contact ==
                                              //                     int.tryParse(
                                              //                         contact.phones[
                                              //                             0]),
                                              //                 orElse: () =>
                                              //                     ViewductsUser())
                                              //             .isVerified ==
                                              //         true
                                              //     ? customIcon(
                                              //         context,
                                              //         icon: AppIcon.blueTick,
                                              //         istwitterIcon: true,
                                              //         iconColor: AppColor.primary,
                                              //         size: 9,
                                              //         paddingIcon: 3,
                                              //       )
                                              //     : const SizedBox(width: 0),
                                            ],
                                          ),
                                          subtitle: Text(contacts.phones[0]

                                              // userCartController
                                              //       .listChatUser!.value
                                              //       .where(
                                              //         (data) =>
                                              //             data.contact ==
                                              //             int.tryParse(
                                              //                 contacts.phones[0]),
                                              //       )
                                              //       .isEmpty
                                              //   ? contacts.phones[0]
                                              //   : userCartController.listChatUser?.value
                                              //               .firstWhere(
                                              //                   (data) =>
                                              //                       data.contact ==
                                              //                       int.tryParse(contact
                                              //                           .phones[0]),
                                              //                   orElse: () =>
                                              //                       ViewductsUser())
                                              //               .contact ==
                                              //           null
                                              //       ? contacts.phones[0]
                                              //       : userCartController
                                              //               .listChatUser?.value
                                              //               .firstWhere(
                                              //                   (data) =>
                                              //                       data.contact ==
                                              //                       int.tryParse(
                                              //                           contact.phones[0]),
                                              //                   orElse: () => ViewductsUser())
                                              //               .contact
                                              //               .toString() ??
                                              //           contact.phones[0]

                                              ),
                                          // title: Text(contact.displayName),
                                          // subtitle: Text(contact.phones[0]),
                                          trailing:
                                              // userCartController
                                              //             .listChatUser?.value
                                              //             .firstWhere(
                                              //                 (data) =>
                                              //                     data.contact ==
                                              //                     int.tryParse(contact
                                              //                         .phones[0]),
                                              //                 orElse: () =>
                                              //                     ViewductsUser())
                                              //             .contact ==
                                              //         null
                                              //     ?
                                              GestureDetector(
                                            onTap: () async {
                                              // String uri =
                                              //     'sms:${contact.phones[0]}?body=hello%20there%20check out Viewducts https://viewducts.page.link/invite?${authState.userModel?.key}';
                                              // if (await canLaunchUrl(
                                              //     Uri.parse(uri))) {
                                              //   await launchURL(uri);
                                              // } else {
                                              //   // iOS
                                              //   String uri =
                                              //       'sms:${contact.phones[0]}?body=hello%20there%20check out Viewducts https://viewducts.page.link/invite?${authState.userModel?.key}';
                                              //   if (await canLaunchUrl(
                                              //       Uri.parse(uri))) {
                                              //     await launchURL(uri);
                                              //   } else {
                                              //     throw 'Could not launch $uri';
                                              //   }
                                              // }
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 30),
                                              child: Container(
                                                  // height: Get.width * 0.1,
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
                                                          .systemYellow),
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: const Text(
                                                    'Invite',
                                                    style: TextStyle(
                                                        color: CupertinoColors
                                                            .darkBackgroundGray,
                                                        fontWeight:
                                                            FontWeight.w900),
                                                  )),
                                            ),
                                          )
                                          // :
                                          //  SizedBox(
                                          //     height: 30,
                                          //     child: Obx(
                                          //       () => feedState.userViers
                                          //               .where((data) =>
                                          //                   data
                                          //                       .viewductUser ==
                                          //                   userCartController
                                          //                       .listChatUser!
                                          //                       .value
                                          //                       .firstWhere(
                                          //                         (data) =>
                                          //                             data.contact ==
                                          //                             int.tryParse(
                                          //                                 contact.phones[0]),
                                          //                       )
                                          //                       .key)
                                          //               .isNotEmpty
                                          //           // userCartController
                                          //           //         .listChatUser!.value
                                          //           //         .where(
                                          //           //           (data) =>
                                          //           //               data.contact ==
                                          //           //               int.tryParse(contact
                                          //           //                   .phones[0]),
                                          //           //         )
                                          //           //         .isNotEmpty
                                          //           //  feedState
                                          //           //   .userViers
                                          //           //   .value[index]
                                          //           //   .viewductUser

                                          //           //  userCartController.listChatUser?.value
                                          //           //                                             .firstWhere(
                                          //           //                                                 (data) =>
                                          //           //                                                     data.contact ==
                                          //           //                                                     contact.phones[
                                          //           //                                                         0],
                                          //           //                                                 orElse: () =>
                                          //           //                                                     ViewductsUser())
                                          //           //                                             .
                                          //           //       where((id) => id.viewerId == authState.userId)
                                          //           //       .isNotEmpty
                                          //           ? GestureDetector(
                                          //               onTap: () {
                                          //                 feedState.deletViewUser(
                                          //                     userCartController
                                          //                         .listChatUser
                                          //                         ?.value
                                          //                         .firstWhere(
                                          //                             (data) =>
                                          //                                 data.contact ==
                                          //                                 int.tryParse(contact.phones[
                                          //                                     0]),
                                          //                             orElse: () =>
                                          //                                 ViewductsUser())
                                          //                         .key,
                                          //                     userCartController
                                          //                         .listChatUser
                                          //                         ?.value
                                          //                         .firstWhere(
                                          //                             (data) =>
                                          //                                 data.contact ==
                                          //                                 int.tryParse(contact.phones[0]),
                                          //                             orElse: () => ViewductsUser()));
                                          //                 setState(() {});
                                          //               },
                                          //               child: Padding(
                                          //                 padding:
                                          //                     const EdgeInsets
                                          //                             .symmetric(
                                          //                         horizontal:
                                          //                             30),
                                          //                 child: Container(
                                          //                     // height: Get.width * 0.1,
                                          //                     decoration: BoxDecoration(
                                          //                         boxShadow: [
                                          //                           BoxShadow(
                                          //                               offset: const Offset(0,
                                          //                                   11),
                                          //                               blurRadius:
                                          //                                   11,
                                          //                               color: Colors
                                          //                                   .black
                                          //                                   .withOpacity(0.06))
                                          //                         ],
                                          //                         borderRadius:
                                          //                             BorderRadius.circular(
                                          //                                 18),
                                          //                         color: CupertinoColors
                                          //                             .activeGreen),
                                          //                     padding:
                                          //                         const EdgeInsets
                                          //                                 .all(
                                          //                             5.0),
                                          //                     child:
                                          //                         const Text(
                                          //                       'Viewing',
                                          //                       style: TextStyle(
                                          //                           color: CupertinoColors
                                          //                               .darkBackgroundGray,
                                          //                           fontWeight:
                                          //                               FontWeight
                                          //                                   .w900),
                                          //                     )),
                                          //               ),
                                          //             )
                                          //           : GestureDetector(
                                          //               onTap: () async {
                                          //                 await feedState.viewUser(
                                          //                     authState
                                          //                         .appUser!
                                          //                         .$id,
                                          //                     viewductUser: userCartController
                                          //                         .listChatUser
                                          //                         ?.value
                                          //                         .firstWhere(
                                          //                             (data) =>
                                          //                                 data.contact ==
                                          //                                 int.tryParse(contact.phones[
                                          //                                     0]),
                                          //                             orElse: () =>
                                          //                                 ViewductsUser())
                                          //                         .key);
                                          //                 setState(() {});
                                          //                 // await Future.delayed(
                                          //                 //     const Duration(
                                          //                 //         seconds: 8),
                                          //                 //     () {});

                                          //                 FToast().showToast(
                                          //                     child: Padding(
                                          //                       padding:
                                          //                           const EdgeInsets
                                          //                                   .all(
                                          //                               5.0),
                                          //                       child: Container(
                                          //                           // width:
                                          //                           //    Get.width * 0.3,
                                          //                           decoration: BoxDecoration(boxShadow: [
                                          //                             BoxShadow(
                                          //                                 offset: const Offset(
                                          //                                     0, 11),
                                          //                                 blurRadius:
                                          //                                     11,
                                          //                                 color:
                                          //                                     Colors.black.withOpacity(0.06))
                                          //                           ], borderRadius: BorderRadius.circular(18), color: CupertinoColors.activeGreen),
                                          //                           padding: const EdgeInsets.all(5.0),
                                          //                           child: Text(
                                          //                             'You are now Viewing ${userCartController.listChatUser?.value.firstWhere((data) => data.contact == int.tryParse(contact.phones[0]), orElse: () => ViewductsUser()).displayName}',
                                          //                             style: TextStyle(
                                          //                                 color:
                                          //                                     CupertinoColors.darkBackgroundGray,
                                          //                                 fontWeight: FontWeight.w900),
                                          //                           )),
                                          //                     ),
                                          //                     gravity:
                                          //                         ToastGravity
                                          //                             .TOP_LEFT,
                                          //                     toastDuration:
                                          //                         Duration(
                                          //                             seconds:
                                          //                                 3));
                                          //                 // setState(() {});
                                          //               },
                                          //               child: Padding(
                                          //                 padding:
                                          //                     const EdgeInsets
                                          //                             .symmetric(
                                          //                         horizontal:
                                          //                             30),
                                          //                 child: Container(
                                          //                     // height: Get.width * 0.1,
                                          //                     decoration: BoxDecoration(
                                          //                         boxShadow: [
                                          //                           BoxShadow(
                                          //                               offset: const Offset(0,
                                          //                                   11),
                                          //                               blurRadius:
                                          //                                   11,
                                          //                               color: Colors
                                          //                                   .black
                                          //                                   .withOpacity(0.06))
                                          //                         ],
                                          //                         borderRadius:
                                          //                             BorderRadius.circular(
                                          //                                 18),
                                          //                         color: Colors
                                          //                             .cyan),
                                          //                     padding:
                                          //                         const EdgeInsets
                                          //                                 .all(
                                          //                             5.0),
                                          //                     child:
                                          //                         const Text(
                                          //                       'Start Viewing',
                                          //                       style: TextStyle(
                                          //                           color: CupertinoColors
                                          //                               .darkBackgroundGray,
                                          //                           fontWeight:
                                          //                               FontWeight
                                          //                                   .w900),
                                          //                     )),
                                          //               ),
                                          //             ),
                                          //     ),
                                          //   ),

                                          ),
                                    ],
                                  );
                                },
                              );
                            })))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

isFollower(BuildContext context) {
  // var authstate = Provider.of<AuthState>(context, listen: false);
  // if (authState.profileUserModel!.viewersList != null &&
  //     authState.profileUserModel!.viewersList!.isNotEmpty) {
  //   return (authState.profileUserModel!.viewersList!
  //       .any((x) => x == authState.userModel!.userId));
  // } else {
  //   return false;
  // }
}

class _UserTile extends StatelessWidget {
  const _UserTile({Key? key, this.user}) : super(key: key);
  final ViewductsUser? user;

  @override
  Widget build(BuildContext context) {
    // itsViewing() async {
    //   final database = Databases(
    //     clientConnect(),
    //   );
    //   await database.listDocuments(
    //       databaseId: databaseId,
    //       collectionId: mainUserViews,
    //       queries: [
    //         Query.equal('viewerId', authState.appUser!.$id),
    //         Query.equal('viewductUser', user!.key),
    //       ]).then((data) {
    //     var value = data.documents
    //         .map((e) => MainUserViewsModel.fromJson(e.data))
    //         .toList();
    //     feedState.userViers.value = value.obs;
    //   });
    // }

    // useEffect(
    //   () {
    //     itsViewing();
    //     FToast().init(Get.context!);

    //     return () {};
    //   },
    //   [feedState.userViers],
    // );
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(0),
            bottomLeft: Radius.circular(20)),
      ),
      child: frostedWhite(
        ListTile(
          onTap: () {
            kAnalytics.logViewSearchResults(searchTerm: user!.userName!);
            // final chatState = Provider.of<ChatState>(context, listen: false);
            // feedState.dataBaseChatsId?.value == null;
            // chatState.setChatUser = user;
            Get.back();
            // Navigator.pop(Get.context);
            Get.to(
                () => ChatResponsive(
                      userProfileId: user!.userId,
                    ),
                transition: Transition.downToUp);
            // Navigator.pushNamed(context, '/ChatScreenPage');
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
                  ? customIcon(
                      context,
                      icon: AppIcon.blueTick,
                      istwitterIcon: true,
                      iconColor: AppColor.primary,
                      size: 9,
                      paddingIcon: 3,
                    )
                  : const SizedBox(width: 0),
            ],
          ),
          subtitle: Text(user!.userName!),
          trailing: SizedBox(
            height: 30,
            child:
                //  feedState.userViers.value
                //         .where((id) => id.viewerId == authState.userId)
                //         .isNotEmpty
                //     ? GestureDetector(
                //         onTap: () {
                //           feedState.deletViewUser(user!.key, user);
                //         },
                //         child: Container(
                //             // height: Get.width * 0.1,
                //             decoration: BoxDecoration(
                //                 boxShadow: [
                //                   BoxShadow(
                //                       offset: const Offset(0, 11),
                //                       blurRadius: 11,
                //                       color: Colors.black.withOpacity(0.06))
                //                 ],
                //                 borderRadius: BorderRadius.circular(18),
                //                 color: CupertinoColors.activeGreen),
                //             padding: const EdgeInsets.all(5.0),
                //             child: const Text(
                //               'Viewing',
                //               style: TextStyle(
                //                   color: CupertinoColors.darkBackgroundGray,
                //                   fontWeight: FontWeight.w900),
                //             )),
                //       )
                //     :

                GestureDetector(
              onTap: () async {
                // await feedState.viewUser(authState.appUser!.$id,
                //     viewductUser: user!.key);
                // setState(() {});
                // await Future.delayed(
                //     const Duration(
                //         seconds: 8),
                //     () {});

                FToast().showToast(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                          // width:
                          //    Get.width * 0.3,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    offset: const Offset(0, 11),
                                    blurRadius: 11,
                                    color: Colors.black.withOpacity(0.06))
                              ],
                              borderRadius: BorderRadius.circular(18),
                              color: CupertinoColors.activeGreen),
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            'You are now Viewing ${user!.displayName}',
                            style: TextStyle(
                                color: CupertinoColors.darkBackgroundGray,
                                fontWeight: FontWeight.w900),
                          )),
                    ),
                    gravity: ToastGravity.TOP_LEFT,
                    toastDuration: Duration(seconds: 3));
                // setState(() {});
              },
              child: Container(
                  // height: Get.width * 0.1,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(0, 11),
                            blurRadius: 11,
                            color: Colors.black.withOpacity(0.06))
                      ],
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.cyan),
                  padding: const EdgeInsets.all(5.0),
                  child: const Text(
                    'View',
                    style: TextStyle(
                        color: CupertinoColors.darkBackgroundGray,
                        fontWeight: FontWeight.w900),
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
