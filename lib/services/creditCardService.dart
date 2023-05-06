// ignore_for_file: file_names

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:viewducts/page/profile/shippingAdress.dart';
import 'package:viewducts/services/cardImputFomatter.dart';
import 'package:viewducts/services/cardValidator.dart';
import 'package:viewducts/state/authState.dart';
import 'package:viewducts/state/feedState.dart';

class AddCreditCard extends StatefulWidget {
  const AddCreditCard({Key? key}) : super(key: key);

  @override
  _AddCreditCardState createState() => _AddCreditCardState();
}

class _AddCreditCardState extends State<AddCreditCard> {
  String cardNumber = 'XXXX XXXX XXXX XXXX';
  String expiryDate = 'MM/YY';
  String cardHolderName = 'CardHolder name';
  String cvvCode = 'CVV/CVC';
  bool isCvvFocused = false;
  bool autoValidate = false;
  String iconColorState = "";

  final PaymentCard _paymentCard = PaymentCard();
  final FeedState _checkoutService = FeedState();
  final GlobalKey _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _paymentCard.type = CardType.Others;
  }

  void addNewCard() async {
    var authState = Provider.of<AuthState>(context, listen: false);

    final FormState form = _formKey.currentState as FormState;
    if (form.validate()) {
      await _checkoutService.newCreditCardDetails(
          cardNumber, expiryDate, cardHolderName, authState.userId);
      Navigator.of(context).pushNamed('/PaymentMethod/');
    } else {
      setState(() {
        autoValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CheckoutAppBar('Cancel', 'Next', addNewCard),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        child: Form(
          key: _formKey,
          // autovalidate: autoValidate,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Add new Card',
                  style: TextStyle(
                      fontSize: 35.0,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black54,
                          blurRadius: 2.0,
                          spreadRadius: 0.0,
                          offset: Offset(2.0, 2.0),
                        )
                      ],
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black54,
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            cardNumber,
                            style: const TextStyle(
                                fontSize: 24.0, color: Colors.white),
                          ),
                          const SizedBox(height: 100.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  expiryDate,
                                  style: const TextStyle(
                                      fontSize: 18.0, color: Colors.white),
                                ),
                                Text(
                                  cvvCode,
                                  style: const TextStyle(
                                      fontSize: 18.0, color: Colors.white),
                                )
                              ],
                            ),
                          ),
                          Text(
                            cardHolderName,
                            style: const TextStyle(
                                fontSize: 22.0, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Icon(
                      Icons.credit_card,
                      color: iconColorState == 'cardNumber'
                          ? Colors.black
                          : Colors.grey,
                    ),
                  ),
                  title: TextFormField(
                    onTap: () {
                      setState(() {
                        iconColorState = 'cardNumber';
                      });
                    },
                    onChanged: (text) {
                      setState(() {
                        if (text.isEmpty) {
                          cardNumber = 'XXXX XXXX XXXX XXXX';
                        } else {
                          cardNumber = text;
                        }
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Card Number'),
                    keyboardType: TextInputType.number,
                    validator: CreditCardValidation.validateCardNumber,
                    inputFormatters: [
                      // WhitelistingTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(16),
                      CardNumberInputFormatter()
                    ],
                  ),
                ),
                ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Icon(
                      Icons.calendar_today,
                      color: iconColorState == 'expiryDate'
                          ? Colors.black
                          : Colors.grey,
                    ),
                  ),
                  title: TextFormField(
                    onTap: () {
                      setState(() {
                        iconColorState = 'expiryDate';
                      });
                    },
                    onChanged: (text) {
                      setState(() {
                        if (text.isEmpty) {
                          expiryDate = 'MM/YY';
                        } else {
                          expiryDate = text;
                        }
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Expiry Date'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      // WhitelistingTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                      CardMonthInputFormatter()
                    ],
                    validator: CreditCardValidation.validateDate,
                    onSaved: (value) {
                      List<int> expiryDate =
                          CreditCardValidation.getExpiryDate(value!);
                      _paymentCard.month = expiryDate[0];
                      _paymentCard.year = expiryDate[1];
                    },
                  ),
                ),
                ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Icon(
                      Icons.person,
                      color: iconColorState == 'cardHolderName'
                          ? Colors.black
                          : Colors.grey,
                    ),
                  ),
                  title: TextFormField(
                    onTap: () {
                      setState(() {
                        iconColorState = 'cardHolderName';
                      });
                    },
                    onChanged: (text) {
                      setState(() {
                        if (text.isEmpty) {
                          cardHolderName = 'CardHolder name';
                        } else {
                          cardHolderName = text;
                        }
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Card Name'),
                    keyboardType: TextInputType.text,
                    validator: (String? value) =>
                        value!.isEmpty ? ErrorString.reqField : null,
                    onSaved: (String? value) {
                      _paymentCard.name = value;
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
