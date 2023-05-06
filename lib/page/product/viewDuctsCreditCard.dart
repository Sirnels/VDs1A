// ignore_for_file: file_names, constant_identifier_names, unnecessary_null_comparison, prefer_adjacent_string_concatenation

import 'dart:convert';

class Charging {
  ViewductPaymentCard? card;

  /// The email of the customer
  String? email;
  BankAccount? _account;

  /// Amount to pay in base currency. Must be a valid positive number
  int amount = 0;
  Map<String, dynamic>? _metadata;
  List<Map<String, dynamic>>? _customFields;
  bool _hasMeta = false;
  Map<String, String>? _additionalParameters;

  /// The locale used for formatting amount in the UI prompt. Defaults to [Strings.nigerianLocale]
  String? locale;
  String? accessCode;
  String? plan;
  String? reference;

  /// ISO 4217 payment currency code (e.g USD). Defaults to [Strings.ngn].
  ///
  /// If you're setting this value, also set [locale] for better formatting.
  String? currency;
  int? transactionCharging;

  /// Who bears Paystack chargings? [Bearer.Account] or [Bearer.SubAccount]
  Bearer? bearer;

  String? subAccount;

  Charging() {
    _metadata = {};
    amount = -1;
    _additionalParameters = {};
    _customFields = [];
    _metadata!['custom_fields'] = _customFields;
    locale = Strings.nigerianLocale;
    currency = Strings.ngn;
  }

  addParameter(String key, String value) {
    _additionalParameters![key] = value;
  }

  Map<String, String>? get additionalParameters => _additionalParameters;

  BankAccount? get account => _account;

  set account(BankAccount? value) {
    if (value == null) {
      // Precaution to avoid setting of this field outside the library
      throw PaystackException('account cannot be null');
    }
    _account = value;
  }

  putMetaData(String name, dynamic value) {
    _metadata![name] = value;
    _hasMeta = true;
  }

  putCustomField(String displayName, String value) {
    var customMap = {
      'value': value,
      'display_name': displayName,
      'variable_name':
          displayName.toLowerCase().replaceAll(RegExp(r'[^a-z0-9 ]'), "_")
    };
    _customFields!.add(customMap);
    _hasMeta = true;
  }

  String? get metadata {
    if (!_hasMeta) {
      return null;
    }

    return jsonEncode(_metadata);
  }
}

enum Bearer {
  Account,
  SubAccount,
}

/// The class for the Payment Card model. Has utility methods for validating
/// the card.
class ViewductPaymentCard {
  // List of supported card types
  final List<CardType> cardTypes = [
    _Visa(),
    _MasterCard(),
    _AmericanExpress(),
    _DinersClub(),
    _Discover(),
    _Jcb(),
    _Verve()
  ];

  /// Name on card
  String? name;

  /// Card number
  String? _number;

  /// Card CVV or CVC
  String? _cvc;

  /// Expiry month
  int expiryMonth = 0;

  /// Expiry year
  int expiryYear = 0;

  /// Bank Address line 1
  String? addressLine1;

  /// Bank Address line 2
  String? addressLine2;

  /// Bank Address line 3
  String? addressLine3;

  /// Bank Address line 4
  String? addressLine4;

  /// Postal code of the bank address
  String? addressPostalCode;

  /// Country of the bank
  String? addressCountry;

  String? country;

  /// Type of card
  String? _type;

  String? _last4Digits;

  set type(String? value) => _type = value;

  String? get number => _number;

  String? get last4Digits => _last4Digits;

  String? get type {
    // If type is empty and the number isn't empty
    if (StringUtils.isEmpty(_type)) {
      if (!StringUtils.isEmpty(number)) {
        for (var cardType in cardTypes) {
          if (cardType.hasFullMatch(number)) {
            return cardType.toString();
          }
        }
      }
      return CardType.unknown;
    }
    return _type;
  }

  // Get the card type by matching the starting characters against the Issuer
  // Identification Number (IIN)
  String getTypeForIIN(String cardNumber) {
    // If type is empty and the number isn't empty
    if (!StringUtils.isEmpty(cardNumber)) {
      for (var cardType in cardTypes) {
        if (cardType.hasStartingMatch(cardNumber)) {
          return cardType.toString();
        }
      }
      return CardType.unknown;
    }
    return CardType.unknown;
  }

  set number(String? value) {
    _number = CardUtils.getCleanedNumber(value);
    if (number!.length == 4) {
      _last4Digits = number;
    } else if (number!.length > 4) {
      _last4Digits = number!.substring(number!.length - 4);
    } else {
      // whatever is appropriate in this case
      _last4Digits = number;
    }
  }

  nullifyNumber() {
    _number = null;
  }

  String? get cvc => _cvc;

  set cvc(String? value) {
    _cvc = CardUtils.getCleanedNumber(value);
  }

  ViewductPaymentCard(
      {required String number,
      required String cvc,
      required this.expiryMonth,
      required this.expiryYear,
      String? name,
      String? addressLine1,
      String? addressLine2,
      String? addressLine3,
      String? addressLine4,
      String? addressPostCode,
      String? addressCountry,
      String? country}) {
    this.number = number;
    this.cvc = cvc;
    this.name = StringUtils.nullify(name);
    this.addressLine1 = StringUtils.nullify(addressLine1);
    this.addressLine2 = StringUtils.nullify(addressLine2);
    this.addressLine3 = StringUtils.nullify(addressLine3);
    this.addressLine4 = StringUtils.nullify(addressLine4);
    this.addressCountry = StringUtils.nullify(addressCountry);
    addressPostalCode = StringUtils.nullify(addressPostalCode);

    this.country = StringUtils.nullify(country);
    type = type;
  }

  ViewductPaymentCard.empty() {
    expiryYear = 0;
    expiryMonth = 0;
    _number = null;
    cvc = null;
  }

  /// Validates the CVC or CVV of the card
  /// Returns true if the cvc is valid
  bool isValid() {
    return cvc != null &&
        number != null &&
        validNumber(null) &&
        CardUtils.isNotExpired(expiryYear, expiryMonth) &&
        validCVC(null);
  }

  /// Validates the CVC or CVV of a card.
  /// Returns true if CVC is valid and false otherwise
  bool validCVC(String? cardCvc) {
    cardCvc ??= cvc;

    if (cardCvc == null || cardCvc.trim().isEmpty) return false;

    var cvcValue = cardCvc.trim();
    bool validLength =
        ((_type == null && cvcValue.length >= 3 && cvcValue.length <= 4) ||
            (CardType.americanExpress == _type && cvcValue.length == 4) ||
            (CardType.americanExpress != _type && cvcValue.length == 3));
    return (CardUtils.isWholeNumberPositive(cvcValue) && validLength);
  }

  /// Validates the number of the card
  /// Returns true if the number is valid. Returns false otherwise
  bool validNumber(String? cardNumber) {
    cardNumber ??= number;
    if (StringUtils.isEmpty(cardNumber)) return false;

    // Remove all non digits
    var formattedNumber = cardNumber!.trim().replaceAll(RegExp(r'[^0-9]'), '');

    // Verve card needs no other validation except it matched pattern
    if (CardType.fullPatternVerve.hasMatch(formattedNumber)) {
      return true;
    }

    //check if formattedNumber is empty or card isn't a whole positive number or isn't Luhn-valid
    if (StringUtils.isEmpty(formattedNumber) ||
        !CardUtils.isWholeNumberPositive(cardNumber) ||
        !_isValidLuhnNumber(cardNumber)) return false;

    // check type lengths
    if (CardType.americanExpress == _type) {
      return formattedNumber.length == CardType.maxLengthAmericanExpress;
    } else if (CardType.dinersClub == _type) {
      return formattedNumber.length == CardType.maxLengthDinersClub;
    } else {
      return formattedNumber.length == CardType.maxLengthNormal;
    }
  }

  /// Validates the number against Luhn algorithm https://de.wikipedia.org/wiki/Luhn-Algorithmus#Java
  /// [number]  - number to validate
  /// Returns true if the number is passes the verification.
  bool _isValidLuhnNumber(String number) {
    int sum = 0;
    int length = number.trim().length;
    for (var i = 0; i < length; i++) {
      // get digits in reverse order
      var source = number[length - i - 1];

      // Check if character is digit before parsing it
      if (!((number.codeUnitAt(i) ^ 0x30) <= 9)) {
        return false;
      }
      int digit = int.parse(source);

      // if it's odd, multiply by 2
      if (i % 2 == 1) {
        digit *= 2;
      }
      sum += digit > 9 ? (digit - 9) : digit;
    }

    return sum % 10 == 0;
  }

  @override
  String toString() {
    return 'ViewductPaymentCard{_cvc: $_cvc, expiryMonth: $expiryMonth, expiryYear: '
        '$expiryYear, _type: $_type, _last4Digits: $_last4Digits , _number: '
        '$_number}';
  }
}

class PaystackException implements Exception {
  String message;

  PaystackException(this.message);

  @override
  String toString() {
    if (message == null) {
      return Strings.unKnownError;
    }
    return message;
  }
}

class AuthenticationException extends PaystackException {
  AuthenticationException(String message) : super(message);
}

class CardException extends PaystackException {
  CardException(String message) : super(message);
}

class ChargingException extends PaystackException {
  ChargingException(String message) : super(message);
}

class ExpiredAccessCodeException extends PaystackException {
  ExpiredAccessCodeException(String message) : super(message);
}

class InvalidAmountException extends PaystackException {
  int amount = 0;

  InvalidAmountException(this.amount)
      : super('$amount is not a valid '
            'amount. only positive non-zero values are allowed.');
}

class InvalidEmailException extends PaystackException {
  String email;

  InvalidEmailException(this.email) : super('$email  is not a valid email');
}

class PaystackSdkNotInitializedException extends PaystackException {
  PaystackSdkNotInitializedException(String message) : super(message);
}

class ProcessingException extends ChargingException {
  ProcessingException()
      : super(
            'A transaction is currently processing, please wait till it concludes before attempting a new charging.');
}

class CardUtils {
  static bool isWholeNumberPositive(String value) {
    if (value == null) {
      return false;
    }

    for (var i = 0; i < value.length; ++i) {
      if (!((value.codeUnitAt(i) ^ 0x30) <= 9)) {
        return false;
      }
    }

    return true;
  }

  /// Returns true if both [year] and [month] has passed.
  /// Please, see the documentation for [hasYearPassed] and [convertYearTo4Digits]
  /// for nuances
  static bool hasMonthPassed(int year, int month) {
    if (year == null) return true;
    var now = DateTime.now();
    // The month has passed if:
    // 1. The year is in the past. In that case, we just assume that the month
    // has passed
    // 2. Card's month (plus another month) is more than current month.
    return hasYearPassed(year) ||
        convertYearTo4Digits(year) == now.year && (month < now.month + 1);
  }

  static bool isValidMonth(int month) {
    return month > 0 && month < 13;
  }

  /// Returns true if [year] is has passed.
  /// It calls [convertYearTo4Digits] on [year] so two digits year will be
  /// prepended with  "20":
  ///
  ///     var v = hasYearPassed(94);
  ///     print(v); // false because 94 is converted to 2094, and 2094 is in the future
  static bool hasYearPassed(int year) {
    int fourDigitsYear = convertYearTo4Digits(year);
    var now = DateTime.now();
    // The year has passed if the year we are currently is more than card's year
    return fourDigitsYear < now.year;
  }

  static bool isNotExpired(int year, int month) {
    if ((month == null) || (month > 12 || year > 2999)) {
      return false;
    }
    // It has not expired if both the year and date has not passed
    return !hasYearPassed(year) && !hasMonthPassed(year, month);
  }

  /// Convert the two-digit year to four-digit year if necessary
  /// When [year] is in the range of >=0  and < 100, it appends "20" to it:
  ///
  ///     var c = convertYearTo4Digits(10);
  ///     print(c); // 2010;
  ///
  ///     var x = convertYearTo4Digits(1);
  ///     print(x); // 2001
  ///
  /// If the year is not in the specified range above, it returns it as it is:
  ///
  ///     var v = convertYearTo4Digits(2333);
  ///     print(v); // 2333
  static int convertYearTo4Digits(int year) {
    if (year == null) return 0;
    if (year < 100 && year >= 0) {
      String prefix = "20";
      year = int.parse('$prefix${year.toString().padLeft(2, '0')}');
    }
    return year;
  }

  /// Removes non numerical characters from the string
  static String getCleanedNumber(String? text) {
    if (text == null) {
      return '';
    }
    RegExp regExp = RegExp(r"[^0-9]");
    return text.replaceAll(regExp, '');
  }

  /// Concatenates card number, cvv, month and year using "*" as the separator.
  ///
  /// Note: The card details are not validated.
  static String concatenateCardFields(ViewductPaymentCard card) {
    if (card == null) {
      throw CardException("Card cannot be null");
    }

    String? number = StringUtils.nullify(card.number);
    String? cvc = StringUtils.nullify(card.cvc);
    int expiryMonth = card.expiryMonth;
    int expiryYear = card.expiryYear;

    var cardFields = [
      number,
      cvc,
      expiryMonth.toString(),
      expiryYear.toString()
    ];

    if (!StringUtils.isEmpty(number)) {
      return cardFields.join("*");
    } else {
      throw CardException('Invalid card details: Card number is empty or null');
    }
  }

  /// Accepts a forward-slash("/") separated string and returns a 2 sized int list of
  /// the first number before the "/" and the last number after the "/
  static List<int> getExpiryDate(String value) {
    if (value == null) return [-1, -1];
    var split = value.split(RegExp(r'(\/)'));
    var month = int.tryParse(split[0]) ?? -1;
    if (split.length == 1) {
      return [month, -1];
    }
    var year = int.tryParse(split[split.length - 1]) ?? -1;
    return [month, year];
  }
}

class StringUtils {
  static bool isEmpty(String? value) {
    return value == null || value.isEmpty || value.toLowerCase() == "null";
  }

  static bool isValidEmail(String email) {
    if (isEmpty(email)) return false;
    RegExp regExp = RegExp(_emailRegex);
    return regExp.hasMatch(email);
  }

  ///  Method to nullify an empty String.
  ///  [value] - A string we want to be sure to keep null if empty
  ///  Returns null if a value is empty or null, otherwise, returns the value
  static String? nullify(String? value) {
    if (isEmpty(value)) {
      return null;
    }
    return value;
  }
}

const _emailRegex = r"[a-zA-Z0-9\\+\\.\\_\\%\\-\\+]{1,256}" +
    "\\@" +
    "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
    "(" +
    "\\." +
    "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
    ")+";

abstract class CardType {
  // Card types
  static const String visa = "Visa";
  static const String masterCard = "MasterCard";
  static const String americanExpress = "American Express";
  static const String dinersClub = "Diners Club";
  static const String discover = "Discover";
  static const String jcb = "JCB";
  static const String verve = "VERVE";
  static const String unknown = "Unknown";

  // Length for some cards
  static const int maxLengthNormal = 16;
  static const int maxLengthAmericanExpress = 15;
  static const int maxLengthDinersClub = 14;

  // Regular expressions to match complete numbers of the card
  //source of these regex patterns http://stackoverflow.com/questions/72768/how-do-you-detect-credit-card-type-based-on-number
  static final fullPatternVisa = RegExp(r'^4[0-9]{12}(?:[0-9]{3})?$');
  static final fullPatternMasterCard = RegExp(
      r'^(?:5[1-5][0-9]{2}|222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720)[0-9]{12}$');
  static final fullPatternAmericanExpress = RegExp(r'^3[47][0-9]{13}$');
  static final fullPatternDinersClub = RegExp(r'^3(?:0[0-5]|[68][0-9])'
      r'[0-9]{11}$');
  static final fullPatternDiscover = RegExp(r'^6(?:011|5[0-9]{2})[0-9]{12}$');
  static final fullPatternJCB = RegExp(r'^(?:2131|1800|35[0-9]{3})'
      r'[0-9]{11}$');
  static final fullPatternVerve =
      RegExp(r'^((506(0|1))|(507(8|9))|(6500))[0-9]{12,15}$');

  // Regular expression to match starting characters (aka issuer
  // identification number (IIN)) of the card
  // Source https://en.wikipedia.org/wiki/Payment_card_number
  static final startingPatternVisa = RegExp(r'[4]');
  static final startingPatternMasterCard = RegExp(
      r'((5[1-5])|(222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720))');
  static final startingPatternAmericanExpress = RegExp(r'((34)|(37))');
  static final startingPatternDinersClub =
      RegExp(r'((30[0-5])|(3[89])|(36)|(3095))');
  static final startingPatternJCB =
      RegExp(r'(2131)|(1800)(352[89])|(35[3-8]*[0-9])');
  static final startingPatternVerve = RegExp(r'((506(0|1))|(507(8|9))|(6500))');
  static final startingPatternDiscover = RegExp(r'((6[45])|(6011))');

  bool hasFullMatch(String? cardNumber);

  bool hasStartingMatch(String cardNumber);

  @override
  String toString();
}

class _Visa extends CardType {
  @override
  bool hasFullMatch(String? cardNumber) {
    return CardType.fullPatternVisa.hasMatch(cardNumber!);
  }

  @override
  bool hasStartingMatch(String cardNumber) {
    return cardNumber.startsWith(CardType.startingPatternVisa);
  }

  @override
  String toString() {
    return CardType.visa;
  }
}

class _MasterCard extends CardType {
  @override
  bool hasFullMatch(String? cardNumber) {
    return CardType.fullPatternMasterCard.hasMatch(cardNumber!);
  }

  @override
  bool hasStartingMatch(String cardNumber) {
    return cardNumber.startsWith(CardType.startingPatternMasterCard);
  }

  @override
  String toString() {
    return CardType.masterCard;
  }
}

class _AmericanExpress extends CardType {
  @override
  bool hasFullMatch(String? cardNumber) {
    return CardType.fullPatternAmericanExpress.hasMatch(cardNumber!);
  }

  @override
  bool hasStartingMatch(String cardNumber) {
    return cardNumber.startsWith(CardType.startingPatternAmericanExpress);
  }

  @override
  String toString() {
    return CardType.americanExpress;
  }
}

class _DinersClub extends CardType {
  @override
  bool hasFullMatch(String? cardNumber) {
    return CardType.fullPatternDinersClub.hasMatch(cardNumber!);
  }

  @override
  bool hasStartingMatch(String cardNumber) {
    return cardNumber.startsWith(CardType.startingPatternDinersClub);
  }

  @override
  String toString() {
    return CardType.dinersClub;
  }
}

class _Discover extends CardType {
  @override
  bool hasFullMatch(String? cardNumber) {
    return CardType.fullPatternDiscover.hasMatch(cardNumber!);
  }

  @override
  bool hasStartingMatch(String cardNumber) {
    return cardNumber.startsWith(CardType.startingPatternDiscover);
  }

  @override
  String toString() {
    return CardType.discover;
  }
}

class _Jcb extends CardType {
  @override
  bool hasFullMatch(String? cardNumber) {
    return CardType.fullPatternJCB.hasMatch(cardNumber!);
  }

  @override
  bool hasStartingMatch(String cardNumber) {
    return cardNumber.startsWith(CardType.startingPatternJCB);
  }

  @override
  String toString() {
    return CardType.jcb;
  }
}

class _Verve extends CardType {
  @override
  bool hasFullMatch(String? cardNumber) {
    return CardType.fullPatternVerve.hasMatch(cardNumber!);
  }

  @override
  bool hasStartingMatch(String cardNumber) {
    return cardNumber.startsWith(CardType.startingPatternVerve);
  }

  @override
  String toString() {
    return CardType.verve;
  }
}

class Strings {
  static const emptyStr = ' can be null but it should not be empty';
  static const String fieldReq = 'This field is required';
  static const String invalidNumber = 'Invalid card number';
  static const String invalidExpiry = 'Invalid card expiry';
  static const String invalidCVC = 'Invalid cvv';
  static const String invalidAcc =
      'Please enter a valid 10-digit NUBAN number ';
  static const String continue_ = 'Continue';
  static const String cancel = 'Cancel';
  static const String unKnownError = 'Unknown Error';
  static const String nigerianLocale = 'en_NG';
  static const String ngn = 'NGN';
  static const String noAccessCodeReference =
      'Pass either an access code or transaction '
      'reference';
  static const String sthWentWrong = 'Something went wrong.';
  static const String userTerminated = 'Transaction terminated';
  static const String unKnownResponse = 'Unknown server response';
  static const String cardInputInstruction = 'Enter your card details to pay';
}

class Bank {
  String name;
  int id;

  Bank(this.name, this.id);

  @override
  String toString() {
    return 'Bank{name: $name, id: $id}';
  }
}

class BankAccount {
  Bank bank;
  String number;

  BankAccount(this.bank, this.number);

  bool isValid() {
    if (number.length < 10) {
      return false;
    }

    if (bank == null) {
      return false;
    }
    return true;
  }

  @override
  String toString() {
    return 'BankAccount{bank: $bank, number: $number}';
  }
}
