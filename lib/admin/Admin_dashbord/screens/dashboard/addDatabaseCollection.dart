import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/frosted.dart';

class AddDataBaseCollectionsApi extends StatelessWidget {
  const AddDataBaseCollectionsApi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: Get.height * 0.1,
            left: 10,
            child: frostedBlueGray(
              Container(
                height: Get.height,
                width: Get.width * 0.7,
                child: Container(
                  child: ListView(
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       dataBaseApi.createDuctsDataBase();
                      //       cprint('addedData');
                      //     },
                      //     child: frostedYellow(
                      //       Container(
                      //         padding: const EdgeInsets.symmetric(
                      //             horizontal: 8.0, vertical: 3),
                      //         decoration: BoxDecoration(
                      //             boxShadow: [
                      //               BoxShadow(
                      //                 color: Colors.grey.withOpacity(.5),
                      //                 blurRadius: 10,
                      //               )
                      //             ],
                      //             color: Colors.yellowAccent,
                      //             borderRadius: BorderRadius.circular(10)),
                      //         child: customTitleText('creatDctsDatabase'),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       dataBaseApi.createProductCollectionDataBase();
                      //       cprint('added products collection');
                      //     },
                      //     child: frostedYellow(
                      //       Container(
                      //         padding: const EdgeInsets.symmetric(
                      //             horizontal: 8.0, vertical: 3),
                      //         decoration: BoxDecoration(
                      //             boxShadow: [
                      //               BoxShadow(
                      //                 color: Colors.grey.withOpacity(.5),
                      //                 blurRadius: 10,
                      //               )
                      //             ],
                      //             color: Colors.yellowAccent,
                      //             borderRadius: BorderRadius.circular(10)),
                      //         child: customTitleText('creatProductCollection'),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       dataBaseApi.createStoryCollectionDataBase();
                      //       cprint('added story Collection');
                      //     },
                      //     child: frostedYellow(
                      //       Container(
                      //         padding: const EdgeInsets.symmetric(
                      //             horizontal: 8.0, vertical: 3),
                      //         decoration: BoxDecoration(
                      //             boxShadow: [
                      //               BoxShadow(
                      //                 color: Colors.grey.withOpacity(.5),
                      //                 blurRadius: 10,
                      //               )
                      //             ],
                      //             color: Colors.yellowAccent,
                      //             borderRadius: BorderRadius.circular(10)),
                      //         child: customTitleText('creatStoryCollection'),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       dataBaseApi.createStoryChatsDataBase();
                      //       cprint('addedData Story chats');
                      //     },
                      //     child: frostedYellow(
                      //       Container(
                      //         padding: const EdgeInsets.symmetric(
                      //             horizontal: 8.0, vertical: 3),
                      //         decoration: BoxDecoration(
                      //             boxShadow: [
                      //               BoxShadow(
                      //                 color: Colors.grey.withOpacity(.5),
                      //                 blurRadius: 10,
                      //               )
                      //             ],
                      //             color: Colors.yellowAccent,
                      //             borderRadius: BorderRadius.circular(10)),
                      //         child: customTitleText('creatStoryChats'),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       dataBaseApi.createStoryUserViewsDataBase();
                      //       cprint('addedData Story userviews');
                      //     },
                      //     child: frostedYellow(
                      //       Container(
                      //         padding: const EdgeInsets.symmetric(
                      //             horizontal: 8.0, vertical: 3),
                      //         decoration: BoxDecoration(
                      //             boxShadow: [
                      //               BoxShadow(
                      //                 color: Colors.grey.withOpacity(.5),
                      //                 blurRadius: 10,
                      //               )
                      //             ],
                      //             color: Colors.yellowAccent,
                      //             borderRadius: BorderRadius.circular(10)),
                      //         child: customTitleText('creatStoryUserViews'),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       dataBaseApi.createHeartLikesCollectionDataBase();
                      //       cprint('addedData hearts likes collection');
                      //     },
                      //     child: frostedYellow(
                      //       Container(
                      //         padding: const EdgeInsets.symmetric(
                      //             horizontal: 8.0, vertical: 3),
                      //         decoration: BoxDecoration(
                      //             boxShadow: [
                      //               BoxShadow(
                      //                 color: Colors.grey.withOpacity(.5),
                      //                 blurRadius: 10,
                      //               )
                      //             ],
                      //             color: Colors.yellowAccent,
                      //             borderRadius: BorderRadius.circular(10)),
                      //         child: customTitleText('creatHeartsLikesColl'),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       dataBaseApi.creatProfileUserCollectionDataBase();
                      //       cprint('addedData profile');
                      //     },
                      //     child: frostedYellow(
                      //       Container(
                      //         padding: const EdgeInsets.symmetric(
                      //             horizontal: 8.0, vertical: 3),
                      //         decoration: BoxDecoration(
                      //             boxShadow: [
                      //               BoxShadow(
                      //                 color: Colors.grey.withOpacity(.5),
                      //                 blurRadius: 10,
                      //               )
                      //             ],
                      //             color: Colors.yellowAccent,
                      //             borderRadius: BorderRadius.circular(10)),
                      //         child: customTitleText('creatprofileCollection'),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       dataBaseApi
                      //           .createMainUserProfileViewsCollectionDataBase();
                      //       cprint('addedData profile views');
                      //     },
                      //     child: frostedYellow(
                      //       Container(
                      //         padding: const EdgeInsets.symmetric(
                      //             horizontal: 8.0, vertical: 3),
                      //         decoration: BoxDecoration(
                      //             boxShadow: [
                      //               BoxShadow(
                      //                 color: Colors.grey.withOpacity(.5),
                      //                 blurRadius: 10,
                      //               )
                      //             ],
                      //             color: Colors.yellowAccent,
                      //             borderRadius: BorderRadius.circular(10)),
                      //         child: customTitleText('creatProfileViews'),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       dataBaseApi
                      //           .createChildrenCategoryCollectionDataBase();
                      //       cprint('addedData children category');
                      //     },
                      //     child: frostedYellow(
                      //       Container(
                      //         padding: const EdgeInsets.symmetric(
                      //             horizontal: 8.0, vertical: 3),
                      //         decoration: BoxDecoration(
                      //             boxShadow: [
                      //               BoxShadow(
                      //                 color: Colors.grey.withOpacity(.5),
                      //                 blurRadius: 10,
                      //               )
                      //             ],
                      //             color: Colors.yellowAccent,
                      //             borderRadius: BorderRadius.circular(10)),
                      //         child: customTitleText('creatChildernCategory'),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       dataBaseApi
                      //           .createFashionCategoryCollectionDataBase();
                      //       cprint('addedData fashion category');
                      //     },
                      //     child: frostedYellow(
                      //       Container(
                      //         padding: const EdgeInsets.symmetric(
                      //             horizontal: 8.0, vertical: 3),
                      //         decoration: BoxDecoration(
                      //             boxShadow: [
                      //               BoxShadow(
                      //                 color: Colors.grey.withOpacity(.5),
                      //                 blurRadius: 10,
                      //               )
                      //             ],
                      //             color: Colors.yellowAccent,
                      //             borderRadius: BorderRadius.circular(10)),
                      //         child: customTitleText('createFashionCategory'),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       dataBaseApi
                      //           .createElectronicsCategoryCollectionDataBase();
                      //       cprint('addedData electronics category');
                      //     },
                      //     child: frostedYellow(
                      //       Container(
                      //         padding: const EdgeInsets.symmetric(
                      //             horizontal: 8.0, vertical: 3),
                      //         decoration: BoxDecoration(
                      //             boxShadow: [
                      //               BoxShadow(
                      //                 color: Colors.grey.withOpacity(.5),
                      //                 blurRadius: 10,
                      //               )
                      //             ],
                      //             color: Colors.yellowAccent,
                      //             borderRadius: BorderRadius.circular(10)),
                      //         child:
                      //             customTitleText('creatElectronicsCategory'),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       dataBaseApi.createGroceriesCollectionDataBase();
                      //       cprint('addedData groceries');
                      //     },
                      //     child: frostedYellow(
                      //       Container(
                      //         padding: const EdgeInsets.symmetric(
                      //             horizontal: 8.0, vertical: 3),
                      //         decoration: BoxDecoration(
                      //             boxShadow: [
                      //               BoxShadow(
                      //                 color: Colors.grey.withOpacity(.5),
                      //                 blurRadius: 10,
                      //               )
                      //             ],
                      //             color: Colors.yellowAccent,
                      //             borderRadius: BorderRadius.circular(10)),
                      //         child: customTitleText('creatGroceriedCategory'),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       dataBaseApi.createSectionCollectionDataBase();
                      //       cprint('addedData section');
                      //     },
                      //     child: frostedYellow(
                      //       Container(
                      //         padding: const EdgeInsets.symmetric(
                      //             horizontal: 8.0, vertical: 3),
                      //         decoration: BoxDecoration(
                      //             boxShadow: [
                      //               BoxShadow(
                      //                 color: Colors.grey.withOpacity(.5),
                      //                 blurRadius: 10,
                      //               )
                      //             ],
                      //             color: Colors.yellowAccent,
                      //             borderRadius: BorderRadius.circular(10)),
                      //         child: customTitleText('createSection'),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       dataBaseApi.createTypeCollectionDataBase();
                      //       cprint('addedData type');
                      //     },
                      //     child: frostedYellow(
                      //       Container(
                      //         padding: const EdgeInsets.symmetric(
                      //             horizontal: 8.0, vertical: 3),
                      //         decoration: BoxDecoration(
                      //             boxShadow: [
                      //               BoxShadow(
                      //                 color: Colors.grey.withOpacity(.5),
                      //                 blurRadius: 10,
                      //               )
                      //             ],
                      //             color: Colors.yellowAccent,
                      //             borderRadius: BorderRadius.circular(10)),
                      //         child: customTitleText('creatType'),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            dataBaseApi.createChatListCollection();
                            cprint('addedData chatList Collection');
                          },
                          child: frostedYellow(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 3),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(.5),
                                      blurRadius: 10,
                                    )
                                  ],
                                  color: Colors.yellowAccent,
                                  borderRadius: BorderRadius.circular(10)),
                              child: customTitleText('creatChatListCollection'),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            dataBaseApi.createShoppingCart();
                            cprint('addedData shoppingcart');
                          },
                          child: frostedYellow(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 3),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(.5),
                                      blurRadius: 10,
                                    )
                                  ],
                                  color: Colors.yellowAccent,
                                  borderRadius: BorderRadius.circular(10)),
                              child: customTitleText('creatShoppingCart'),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            dataBaseApi.createProfileViews();
                            cprint('addedData ProfileViews');
                          },
                          child: frostedYellow(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 3),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(.5),
                                      blurRadius: 10,
                                    )
                                  ],
                                  color: Colors.yellowAccent,
                                  borderRadius: BorderRadius.circular(10)),
                              child: customTitleText('createProfileViews'),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            dataBaseApi.createCountryCollection();
                            cprint('addedData CountryCollection');
                          },
                          child: frostedYellow(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 3),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(.5),
                                      blurRadius: 10,
                                    )
                                  ],
                                  color: Colors.yellowAccent,
                                  borderRadius: BorderRadius.circular(10)),
                              child: customTitleText('creatCountryCollection'),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            dataBaseApi.createKeywordCollection();
                            cprint('addedData KeywordsCollection');
                          },
                          child: frostedYellow(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 3),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(.5),
                                      blurRadius: 10,
                                    )
                                  ],
                                  color: Colors.yellowAccent,
                                  borderRadius: BorderRadius.circular(10)),
                              child: customTitleText('creatKeywordCollection'),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            dataBaseApi.createOdersStateCollection();
                            cprint('addedData OdersStateCollection');
                          },
                          child: frostedYellow(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 3),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(.5),
                                      blurRadius: 10,
                                    )
                                  ],
                                  color: Colors.yellowAccent,
                                  borderRadius: BorderRadius.circular(10)),
                              child:
                                  customTitleText('createOdersStateCollection'),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            dataBaseApi.createUsersOrdersCollection();
                            cprint('addedData UsersOrdersCollection');
                          },
                          child: frostedYellow(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 3),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(.5),
                                      blurRadius: 10,
                                    )
                                  ],
                                  color: Colors.yellowAccent,
                                  borderRadius: BorderRadius.circular(10)),
                              child: customTitleText(
                                  'createUsersOrdersCollection'),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            dataBaseApi.createInitPaymentCollection();
                            cprint('InitPaymentCollection');
                          },
                          child: frostedYellow(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 3),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(.5),
                                      blurRadius: 10,
                                    )
                                  ],
                                  color: Colors.yellowAccent,
                                  borderRadius: BorderRadius.circular(10)),
                              child: customTitleText(
                                  'createInitPaymentCollection'),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            dataBaseApi.createViewBankstCollection();
                            cprint('createViewBankstCollection');
                          },
                          child: frostedYellow(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 3),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(.5),
                                      blurRadius: 10,
                                    )
                                  ],
                                  color: Colors.yellowAccent,
                                  borderRadius: BorderRadius.circular(10)),
                              child:
                                  customTitleText('createViewBankstCollection'),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            dataBaseApi.createChipperCash();
                            cprint('createChipperCash');
                          },
                          child: frostedYellow(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 3),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(.5),
                                      blurRadius: 10,
                                    )
                                  ],
                                  color: Colors.yellowAccent,
                                  borderRadius: BorderRadius.circular(10)),
                              child: customTitleText('createChipperCash'),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            dataBaseApi.createUnPaidCommision();
                            cprint('createUnPaidCommision');
                          },
                          child: frostedYellow(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 3),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(.5),
                                      blurRadius: 10,
                                    )
                                  ],
                                  color: Colors.yellowAccent,
                                  borderRadius: BorderRadius.circular(10)),
                              child: customTitleText('createUnPaidCommision'),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            dataBaseApi.createShippingAdress();
                            cprint('createShippingAdress');
                          },
                          child: frostedYellow(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 3),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(.5),
                                      blurRadius: 10,
                                    )
                                  ],
                                  color: Colors.yellowAccent,
                                  borderRadius: BorderRadius.circular(10)),
                              child: customTitleText('createShippingAdress'),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            dataBaseApi.createBooksCollectionDataBase();
                            cprint('createBooksCollectionDataBase');
                          },
                          child: frostedYellow(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 3),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(.5),
                                      blurRadius: 10,
                                    )
                                  ],
                                  color: Colors.yellowAccent,
                                  borderRadius: BorderRadius.circular(10)),
                              child: customTitleText(
                                  'createBooksCollectionDataBase'),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            dataBaseApi.createHousingCollectionDataBase();
                            cprint('createHousingCollectionDataBase');
                          },
                          child: frostedYellow(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 3),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(.5),
                                      blurRadius: 10,
                                    )
                                  ],
                                  color: Colors.yellowAccent,
                                  borderRadius: BorderRadius.circular(10)),
                              child: customTitleText(
                                  'createHousingCollectionDataBase'),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            dataBaseApi.createCarsCollectionDataBase();
                            cprint('createCarsCollectionDataBase');
                          },
                          child: frostedYellow(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 3),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(.5),
                                      blurRadius: 10,
                                    )
                                  ],
                                  color: Colors.yellowAccent,
                                  borderRadius: BorderRadius.circular(10)),
                              child: customTitleText(
                                  'createCarsCollectionDataBase'),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            dataBaseApi.createFarmCollectionDataBase();
                            cprint('createFarmCollectionDataBase');
                          },
                          child: frostedYellow(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 3),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(.5),
                                      blurRadius: 10,
                                    )
                                  ],
                                  color: Colors.yellowAccent,
                                  borderRadius: BorderRadius.circular(10)),
                              child: customTitleText(
                                  'createFarmCollectionDataBase'),
                            ),
                          ),
                        ),
                      ),
                      Container(height: 200),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 1,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
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
    );
  }
}
