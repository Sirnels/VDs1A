// ignore_for_file: invalid_use_of_visible_for_testing_member, unnecessary_null_comparison

import 'dart:io';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class VirtualSignUpAccount extends HookWidget {
  final String? currency;
  final String? currencyId;
  const VirtualSignUpAccount({Key? key, this.currency, this.currencyId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    File? selectedFil;

    // bool isLoading = false;
    // bool uploaded = false;
    final selectedFile = useState(selectedFil);

    final controller = useTextEditingController();
    final controllCurrency = useState(useTextEditingController());
    final firstNameController = useTextEditingController();
    final lastNameController = useTextEditingController();
    final bvnController = useTextEditingController();
    final stateController = useTextEditingController();
    final cityController = useTextEditingController();
    final streetController = useTextEditingController();
    final zipController = useTextEditingController();
    final documentIdController = useTextEditingController();
    final issudeDocumentIdController = useTextEditingController();
    final epireDateController = useTextEditingController();
    final idDocumentStateController = useTextEditingController();
    final accountTypeController = useTextEditingController();
    final countryStateController = useTextEditingController();
    final dateOfBirthController = useTextEditingController();
    final idDocumentState = useState(''.obs);
    final countryState = useState(''.obs);
    final accountTypeState = useState(''.obs);
    final currncyState = useState(currency);
    final feeState = useState(0);
    feeState.value =
        int.tryParse('{controllCurrency.value.text}') ?? feeState.value;
    useEffect(
      () {
        return () {};
      },
      [controllCurrency.value],
    );
    return Obx(
      () => Container(
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
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
                            color: CupertinoColors.inactiveGray),
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(CupertinoIcons.add_circled_solid)),
                  ),
                ]),
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
                      ),
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        'Requesting for ${currncyState.value == 'Euro' ? 'Euro(€)' : currncyState.value == 'Pounds' ? 'Pounds(£)' : currncyState.value == 'Naira' ? 'Naira(₦)' : ''} Account',
                        style: TextStyle(fontWeight: FontWeight.w200),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: Get.height * 0.5,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(0, 11),
                            blurRadius: 11,
                            color: Colors.black.withOpacity(0.06))
                      ],
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: CustomDropdown(
                        hintText: currncyState.value,
                        items: currency == 'Euro'
                            ? ['$currency', 'Pounds', 'Naira']
                            : currency == 'Pounds'
                                ? ['$currency', 'Euro', 'Naira']
                                : currency == 'Naira'
                                    ? ['$currency', 'Pounds', 'Euro']
                                    : [],
                        fillColor: CupertinoColors.systemYellow,
                        onChanged: (data) {
                          currncyState.value = data;
                        },
                        controller: controller),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: Get.height * 0.5,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(0, 11),
                            blurRadius: 11,
                            color: Colors.black.withOpacity(0.06))
                      ],
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: CustomDropdown(
                        hintText: 'Select Account Type',
                        items: ['individual'],
                        fillColor: CupertinoColors.systemYellow,
                        onChanged: (data) {
                          accountTypeState.value = data.obs;
                        },
                        controller: accountTypeController),
                  ),
                ),
                accountTypeState.value == ''
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: Get.height * 0.5,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0, 11),
                                  blurRadius: 11,
                                  color: Colors.black.withOpacity(0.06))
                            ],
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: CustomDropdown(
                              hintText: 'Select Country Id is Issued',
                              items: ['Nigeria(NGN)', 'United Kingdom(UK)'],
                              fillColor: CupertinoColors.systemYellow,
                              onChanged: (data) {
                                data == 'Nigeria(NGN)'
                                    ? countryState.value.value = 'NGN'
                                    : countryState.value.value = 'GBP';
                              },
                              controller: countryStateController),
                        ),
                      ),
                countryState.value == ''
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: Get.height * 0.5,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0, 11),
                                  blurRadius: 11,
                                  color: Colors.black.withOpacity(0.06))
                            ],
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: CustomDropdown(
                              hintText: 'Select Means of Identification ',
                              items: [
                                'passport',
                                'driverLicense',
                                'idCard, other'
                              ],
                              fillColor: CupertinoColors.systemYellow,
                              onChanged: (data) {
                                idDocumentState.value = data.obs;
                              },
                              controller: idDocumentStateController),
                        ),
                      ),
                idDocumentState.value == ''
                    ? Container()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                  ),
                                  padding: const EdgeInsets.all(5.0),
                                  child: const Text(
                                    'KYC Information',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w200),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 1.2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.withOpacity(.3),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: TextField(
                                    controller: firstNameController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      icon: Container(
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
                                            color: CupertinoColors.white),
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text('First',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      fillColor: CupertinoColors.systemYellow,
                                      border: InputBorder.none,
                                      hintText: "First Name",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 1.2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.withOpacity(.3),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: TextField(
                                    controller: lastNameController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      icon: Container(
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
                                            color: CupertinoColors.white),
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text('LastNamw',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      fillColor: CupertinoColors.systemYellow,
                                      border: InputBorder.none,
                                      hintText: "Last Name",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            countryState.value == 'NGN'
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width /
                                          1.2,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey.withOpacity(.3),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                        child: TextField(
                                          controller: bvnController,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            icon: Container(
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
                                                  color: CupertinoColors.white),
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text('BVN',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            fillColor:
                                                CupertinoColors.systemYellow,
                                            border: InputBorder.none,
                                            hintText: "Your BVN",
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 1.2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.withOpacity(.3),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: TextField(
                                    controller: dateOfBirthController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      icon: Container(
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
                                            color: CupertinoColors.white),
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text('BirthDay',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      fillColor: CupertinoColors.systemYellow,
                                      border: InputBorder.none,
                                      hintText: "(YYYY-MM-DD )",
                                    ),
                                  ),
                                ),
                              ),
                            ),
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
                                  ),
                                  padding: const EdgeInsets.all(5.0),
                                  child: const Text(
                                    'Address in Your ID',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w200),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 1.2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.withOpacity(.3),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: TextField(
                                    controller: stateController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      icon: Container(
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
                                            color: CupertinoColors.white),
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text('State',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      fillColor: CupertinoColors.systemYellow,
                                      border: InputBorder.none,
                                      hintText: "State",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 1.2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.withOpacity(.3),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: TextField(
                                    controller: cityController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      icon: Container(
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
                                            color: CupertinoColors.white),
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text('City',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      fillColor: CupertinoColors.systemYellow,
                                      border: InputBorder.none,
                                      hintText: "City",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 1.2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.withOpacity(.3),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: TextField(
                                    controller: streetController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      icon: Container(
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
                                            color: CupertinoColors.white),
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text('Street',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      fillColor: CupertinoColors.systemYellow,
                                      border: InputBorder.none,
                                      hintText: "Street",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 1.2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.withOpacity(.3),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: TextField(
                                    controller: zipController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      icon: Container(
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
                                            color: CupertinoColors.white),
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text('Zip',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      fillColor: CupertinoColors.systemYellow,
                                      border: InputBorder.none,
                                      hintText: "Zip",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 1.2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.withOpacity(.3),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: TextField(
                                    controller: documentIdController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      icon: Container(
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
                                            color: CupertinoColors.white),
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text('Document Id',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      fillColor: CupertinoColors.systemYellow,
                                      border: InputBorder.none,
                                      hintText: "Document Id",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Container(
                                  width: Get.height * 0.5,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          offset: const Offset(0, 11),
                                          blurRadius: 11,
                                          color: Colors.black.withOpacity(0.06))
                                    ],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.all(2.0),
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(children: [
                                          Container(
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
                                                color: CupertinoColors.white),
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text('Country',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Text(' ${countryState.value}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ]),
                                      ])),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Container(
                                  width: Get.height * 0.5,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          offset: const Offset(0, 11),
                                          blurRadius: 11,
                                          color: Colors.black.withOpacity(0.06))
                                    ],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.all(2.0),
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(children: [
                                          Container(
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
                                                color: CupertinoColors.white),
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text('Govement issued',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Text(' ${countryState.value}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ]),
                                      ])),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 1.2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.withOpacity(.3),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: TextField(
                                    controller: issudeDocumentIdController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      icon: Container(
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
                                            color: CupertinoColors.white),
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text('Doc Issued Date',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      fillColor: CupertinoColors.systemYellow,
                                      border: InputBorder.none,
                                      hintText: "(YYYY-MM-DD )",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 1.2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.withOpacity(.3),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: TextField(
                                    controller: epireDateController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      icon: Container(
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
                                            color: CupertinoColors.white),
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text('Doc Exp Date',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      fillColor: CupertinoColors.systemYellow,
                                      border: InputBorder.none,
                                      hintText: "(YYYY-MM-DD )",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Column(children: [
                              Container(
                                child: selectedFile.value != null
                                    ? Image.file(selectedFile.value!)
                                    : GestureDetector(
                                        onTap: () async {
                                          XTypeGroup typeGroup = XTypeGroup(
                                            extensions: <String>[
                                              'jpg',
                                              'png',
                                            ],
                                          );

                                          if (Platform.isMacOS ||
                                              Platform.isWindows) {
                                            final file = await openFile(
                                                acceptedTypeGroups: <
                                                    XTypeGroup>[typeGroup]);
                                            selectedFile.value =
                                                File(file!.path);
                                          } else {
                                            PickedFile? file = await ImagePicker
                                                .platform
                                                .pickImage(
                                                    source: ImageSource.gallery,
                                                    imageQuality: 50);
                                            selectedFile.value =
                                                File(file!.path);
                                          }

                                          ;
                                        },
                                        child: Padding(
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
                                                    BorderRadius.circular(18),
                                              ),
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: const Text(
                                                'Upload Document',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w200),
                                              )),
                                        ),
                                      ),
                              ),
                              Container(
                                child: selectedFile.value != null
                                    ? Image.file(selectedFile.value!)
                                    : GestureDetector(
                                        onTap: () async {
                                          XTypeGroup typeGroup = XTypeGroup(
                                            extensions: <String>[
                                              'jpg',
                                              'png',
                                            ],
                                          );

                                          if (Platform.isMacOS ||
                                              Platform.isWindows) {
                                            final file = await openFile(
                                                acceptedTypeGroups: <
                                                    XTypeGroup>[typeGroup]);
                                            selectedFile.value =
                                                File(file!.path);
                                          } else {
                                            PickedFile? file = await ImagePicker
                                                .platform
                                                .pickImage(
                                                    source: ImageSource.gallery,
                                                    imageQuality: 50);
                                            selectedFile.value =
                                                File(file!.path);
                                          }

                                          ;
                                        },
                                        child: Padding(
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
                                                    BorderRadius.circular(18),
                                              ),
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: const Text(
                                                'Upload Utility Bill/Account Statement',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w200),
                                              )),
                                        ),
                                      ),
                              ),
                              cityController == null ||
                                      streetController == null ||
                                      zipController == null ||
                                      firstNameController == null ||
                                      lastNameController == null ||
                                      bvnController == null ||
                                      stateController == null ||
                                      selectedFile.value == null ||
                                      epireDateController == null ||
                                      issudeDocumentIdController == null ||
                                      countryState.value == null ||
                                      documentIdController == null
                                  ? Container()
                                  : GestureDetector(
                                      onTap: () {},
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
                                            ),
                                            padding: const EdgeInsets.all(5.0),
                                            child: const Text(
                                              'Submit Request',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w200),
                                            )),
                                      ),
                                    ),
                            ]),
                          ]),
              ]),
        ),
      ),
    );
  }
}
