import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:viewducts/widgets/frosted.dart';

class TransactionHistory extends HookWidget {
  final String? currency;
  final String? currencyId;
  TransactionHistory({Key? key, this.currency, this.currencyId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final controllCurrency = useState(useTextEditingController());
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
    return Container(
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
                          color: CupertinoColors.activeOrange),
                      padding: const EdgeInsets.all(5.0),
                      child: const Text(
                        'DuctsWallet',
                        style: TextStyle(fontWeight: FontWeight.w200),
                      )),
                ),
              ]),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {},
                  child: frostedRed(Container(
                      width: Get.height * 0.45,
                      height: Get.height * 0.3,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(0, 11),
                              blurRadius: 11,
                              color: Colors.black.withOpacity(0.06))
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
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
                                                  color: CupertinoColors
                                                      .inactiveGray),
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: const Text(
                                                'Locked Balance:',
                                                style: TextStyle(
                                                    color: CupertinoColors
                                                        .lightBackgroundGray,
                                                    fontWeight:
                                                        FontWeight.w200),
                                              )),
                                        ),
                                        Padding(
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
                                                '12345678',
                                                style: TextStyle(
                                                    color: CupertinoColors
                                                        .lightBackgroundGray,
                                                    fontWeight:
                                                        FontWeight.w200),
                                              )),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
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
                                                  color: CupertinoColors
                                                      .inactiveGray),
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: const Text(
                                                'Ledger Balance:',
                                                style: TextStyle(
                                                    color: CupertinoColors
                                                        .lightBackgroundGray,
                                                    fontWeight:
                                                        FontWeight.w200),
                                              )),
                                        ),
                                        Padding(
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
                                                '12345678',
                                                style: TextStyle(
                                                    color: CupertinoColors
                                                        .lightBackgroundGray,
                                                    fontWeight:
                                                        FontWeight.w200),
                                              )),
                                        ),
                                      ],
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
                                                BorderRadius.circular(18),
                                          ),
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            currncyState.value == 'Euro'
                                                ? '€ 0.00'
                                                : currncyState.value == 'Pounds'
                                                    ? '£ 0.00'
                                                    : currncyState.value ==
                                                            'Naira'
                                                        ? '₦ 0.00'
                                                        : '$currencyId 0.00',
                                            style: TextStyle(
                                                fontSize: Get.height * 0.065,
                                                color:
                                                    CupertinoColors.activeGreen,
                                                fontWeight: FontWeight.w900),
                                          )),
                                    ),
                                  ]),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            offset: const Offset(0, 11),
                                            blurRadius: 11,
                                            color:
                                                Colors.black.withOpacity(0.06))
                                      ],
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    padding: const EdgeInsets.all(2.0),
                                    child: Center(
                                      child: Row(
                                        children: [
                                          Text(
                                            'DuctWallet Number:',
                                            style: TextStyle(
                                                color: CupertinoColors
                                                    .darkBackgroundGray,
                                                fontWeight: FontWeight.w900),
                                          ),
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
                                                color: CupertinoColors
                                                    .activeOrange),
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              '234567890',
                                              style: TextStyle(
                                                  color: CupertinoColors
                                                      .darkBackgroundGray,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              )
                            ]),
                      ))),
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
                      'DuctWallet Currency',
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
                      'Transactions:',
                      style: TextStyle(fontWeight: FontWeight.w200),
                    )),
              ),
            ]),
      ),
    );
  }
}
