// ignore_for_file: body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viewducts/helper/theme.dart';
import 'package:viewducts/state/feedState.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/frosted.dart';

class CreateSubscriptionPlan extends StatefulWidget {
  const CreateSubscriptionPlan({Key? key}) : super(key: key);

  @override
  _CreateSubscriptionPlanState createState() => _CreateSubscriptionPlanState();
}

class _CreateSubscriptionPlanState extends State<CreateSubscriptionPlan> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController babyVendorPlanNameController = TextEditingController();

  TextEditingController bossMemberPriceController = TextEditingController();

  TextEditingController productBrandController = TextEditingController();

  TextEditingController bossMemberPlanNameController = TextEditingController();

  TextEditingController bossMemberSubscriptionPlanController =
      TextEditingController();

  TextEditingController babyVendorSubscriptionPlanIntervalController =
      TextEditingController();

  TextEditingController babyVendorSubscrptionPriceController =
      TextEditingController();

  TextEditingController bossVendorSubscriptionIntervalController =
      TextEditingController();

  TextEditingController bossSubscriptionPriceController =
      TextEditingController();

  TextEditingController bossVendorNameController = TextEditingController();
  String? bossMemberId;
  @override
  Widget build(BuildContext context) {
    var state = Provider.of<FeedState>(context, listen: false);

    return SizedBox(
      width: fullWidth(context),
      height: fullHeight(context) * 0.85,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
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
                            Colors.teal.withOpacity(0.3)
                          ],
                          // begin: Alignment.topCenter,
                          // end: Alignment.bottomCenter,
                        )),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 3),
                          child: customTitleText('Boss Member Plan'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: bossMemberPlanNameController,
                  decoration:
                      const InputDecoration(hintText: 'Boss Member name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'You must enter the product name';
                    } else if (value.length > 15) {
                      return 'Product name can\'t have more than 10 letters';
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: bossMemberSubscriptionPlanController,
                  decoration: const InputDecoration(
                      hintText: 'Boss Member Subscrption Plan Interval'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'You must enter the product name';
                    } else if (value.length > 100) {
                      return 'Product name cant have more than 10 letters';
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: bossMemberPriceController,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(hintText: 'Boss Member Pice'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'You must enter the product name';
                    } else if (value.length > 100) {
                      return 'Product name cant have more than 10 letters';
                    }
                  },
                ),
              ),
              Container(
                width: fullWidth(context),
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20)),
                    color: Colors.white,
                    gradient: LinearGradient(
                      colors: [
                        TwitterColor.mystic.withOpacity(0.8),
                        TwitterColor.mystic.withOpacity(0.9),
                        TwitterColor.mystic.withOpacity(1.0)
                      ],
                      // begin: Alignment.topCenter,
                      // end: Alignment.bottomCenter,
                    )),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () async {
                          await state.bossMemberPlan(
                              bossMemberPlanNameController.text,
                              bossMemberSubscriptionPlanController.text,
                              int.tryParse(bossMemberPriceController.text));
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20)),
                                color: Colors.red,
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.teal.withOpacity(0.5),
                                    Colors.teal.withOpacity(0.6),
                                    Colors.teal.withOpacity(0.7)
                                  ],
                                  // begin: Alignment.topCenter,
                                  // end: Alignment.bottomCenter,
                                )),
                            child: const Center(
                                child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Create Plan',
                                  style: TextStyle(color: Colors.white)),
                            ))),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () async {
                          // var data = state.bossMemberPlanGetId();
                          // setState(() {
                          //   var bossMemberId = data;
                          // });
                          await state.bossMemberPlanUpdate(
                            bossMemberPlanNameController.text,
                            bossMemberSubscriptionPlanController.text,
                            int.tryParse(bossMemberPriceController.text),
                          );
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20)),
                                color: Colors.white,
                                gradient: LinearGradient(
                                  colors: [
                                    TwitterColor.mystic.withOpacity(0.8),
                                    TwitterColor.mystic.withOpacity(0.9),
                                    TwitterColor.mystic.withOpacity(1.0)
                                  ],
                                  // begin: Alignment.topCenter,
                                  // end: Alignment.bottomCenter,
                                )),
                            child: const Center(
                                child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Update Plan',
                                  style: TextStyle(color: Colors.teal)),
                            ))),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
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
                            Colors.red.withOpacity(0.3)
                          ],
                          // begin: Alignment.topCenter,
                          // end: Alignment.bottomCenter,
                        )),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 3),
                          child: customTitleText('Baby Vendor Plan'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: babyVendorPlanNameController,
                  decoration:
                      const InputDecoration(hintText: 'Baby Vendor Name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'You must enter the product name';
                    } else if (value.length > 100) {
                      return 'Product name cant have more than 10 letters';
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: babyVendorSubscriptionPlanIntervalController,
                  decoration: const InputDecoration(
                      hintText: 'Baby Vendor Subscrption interval'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'You must enter the product name';
                    } else if (value.length > 100) {
                      return 'Product name cant have more than 10 letters';
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: babyVendorSubscrptionPriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Baby Vendor Price',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'You must enter the price of the product';
                    }
                  },
                ),
              ),
              Container(
                width: fullWidth(context),
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20)),
                    color: Colors.white,
                    gradient: LinearGradient(
                      colors: [
                        TwitterColor.mystic.withOpacity(0.8),
                        TwitterColor.mystic.withOpacity(0.9),
                        TwitterColor.mystic.withOpacity(1.0)
                      ],
                      // begin: Alignment.topCenter,
                      // end: Alignment.bottomCenter,
                    )),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () async {
                          await state.babyVendorPlan(
                            babyVendorPlanNameController.text,
                            babyVendorSubscriptionPlanIntervalController.text,
                            int.tryParse(
                                babyVendorSubscrptionPriceController.text),
                          );
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20)),
                                color: Colors.red,
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.red.withOpacity(0.5),
                                    Colors.red.withOpacity(0.6),
                                    Colors.red.withOpacity(0.7)
                                  ],
                                  // begin: Alignment.topCenter,
                                  // end: Alignment.bottomCenter,
                                )),
                            child: const Center(
                                child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Create Plan',
                                  style: TextStyle(color: Colors.white)),
                            ))),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () async {
                          await state.babyVendorUpdate(
                            babyVendorPlanNameController.text,
                            babyVendorSubscriptionPlanIntervalController.text,
                            int.tryParse(
                                babyVendorSubscrptionPriceController.text),
                          );
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20)),
                                color: Colors.white,
                                gradient: LinearGradient(
                                  colors: [
                                    TwitterColor.mystic.withOpacity(0.8),
                                    TwitterColor.mystic.withOpacity(0.9),
                                    TwitterColor.mystic.withOpacity(1.0)
                                  ],
                                  // begin: Alignment.topCenter,
                                  // end: Alignment.bottomCenter,
                                )),
                            child: const Center(
                                child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Update Plan',
                                  style: TextStyle(color: Colors.black)),
                            ))),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
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
                            Colors.purple.withOpacity(0.3)
                          ],
                          // begin: Alignment.topCenter,
                          // end: Alignment.bottomCenter,
                        )),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 3),
                          child: customTitleText('Boss Vendor Plan'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: bossVendorNameController,
                  decoration:
                      const InputDecoration(hintText: 'Boss Vendor Name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'You must enter the product name';
                    } else if (value.length > 100) {
                      return 'Product name cant have more than 10 letters';
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: bossVendorSubscriptionIntervalController,
                  decoration: const InputDecoration(
                      hintText: 'Boss Vendor Subscription Plan'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'You must enter the product name';
                    } else if (value.length > 100) {
                      return 'Product name cant have more than 10 letters';
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: bossSubscriptionPriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Boss Vendor Price',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'You must enter how much commission you will give';
                    }
                    // return value;
                  },
                ),
              ),
              Container(
                width: fullWidth(context),
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20)),
                    color: Colors.white,
                    gradient: LinearGradient(
                      colors: [
                        TwitterColor.mystic.withOpacity(0.8),
                        TwitterColor.mystic.withOpacity(0.9),
                        TwitterColor.mystic.withOpacity(1.0)
                      ],
                      // begin: Alignment.topCenter,
                      // end: Alignment.bottomCenter,
                    )),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () async {
                          await state.bossVendorPlan(
                            bossVendorNameController.text,
                            bossVendorSubscriptionIntervalController.text,
                            int.tryParse(bossSubscriptionPriceController.text),
                          );
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20)),
                                color: Colors.red,
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.purple.withOpacity(0.5),
                                    Colors.purple.withOpacity(0.6),
                                    Colors.purple.withOpacity(0.7)
                                  ],
                                  // begin: Alignment.topCenter,
                                  // end: Alignment.bottomCenter,
                                )),
                            child: const Center(
                                child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Create Plan',
                                  style: TextStyle(color: Colors.white)),
                            ))),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () async {
                          await state.bossVendorUpdate(
                            bossVendorNameController.text,
                            bossVendorSubscriptionIntervalController.text,
                            int.tryParse(bossSubscriptionPriceController.text),
                          );
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20)),
                                color: Colors.white,
                                gradient: LinearGradient(
                                  colors: [
                                    TwitterColor.mystic.withOpacity(0.8),
                                    TwitterColor.mystic.withOpacity(0.9),
                                    TwitterColor.mystic.withOpacity(1.0)
                                  ],
                                  // begin: Alignment.topCenter,
                                  // end: Alignment.bottomCenter,
                                )),
                            child: const Center(
                                child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Update Plan',
                                  style: TextStyle(color: Colors.purple)),
                            ))),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // FlatButton(
              //     color: red,
              //     textColor: white,
              //     child: Text('add product'),
              //     onPressed: _submitButton),
            ],
          ),
        ),
      ),
    );
  }
}
