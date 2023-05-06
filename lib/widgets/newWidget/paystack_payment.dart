// ignore_for_file: constant_identifier_names, empty_catches, deprecated_member_use

import 'dart:async';
import 'package:async/async.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:platform_info/platform_info.dart' as platforminfo;

const kFullTabHeight = 74.0;

class CheckoutWidget extends StatefulWidget {
  final CheckoutMethod method;
  final Charge charge;
  final bool fullscreen;
  final Widget? logo;
  final bool hideEmail;
  final bool hideAmount;
  final BankServiceContract bankService;
  final CardServiceContract cardsService;
  final String publicKey;

  const CheckoutWidget({
    required this.method,
    required this.charge,
    required this.bankService,
    required this.cardsService,
    required this.publicKey,
    this.fullscreen = false,
    this.logo,
    this.hideEmail = false,
    this.hideAmount = false,
  });

  @override
  _CheckoutWidgetState createState() => _CheckoutWidgetState(charge);
}

class _CheckoutWidgetState extends BaseState<CheckoutWidget>
    with TickerProviderStateMixin {
  static const tabBorderRadius = BorderRadius.all(Radius.circular(4.0));
  final Charge _charge;
  int? _currentIndex = 0;
  var _showTabs = true;
  String? _paymentError;
  bool _paymentSuccessful = false;
  TabController? _tabController;
  late List<MethodItem> _methodWidgets;
  double _tabHeight = kFullTabHeight;
  late AnimationController _animationController;
  CheckoutResponse? _response;

  _CheckoutWidgetState(this._charge);

  @override
  void initState() {
    super.initState();
    _init();
    _initPaymentMethods();
    _currentIndex = _getCurrentTab();
    _showTabs = widget.method == CheckoutMethod.selectable ? true : false;
    _tabController = TabController(
        vsync: this,
        length: _methodWidgets.length,
        initialIndex: _currentIndex!);
    _tabController!.addListener(_indexChange);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _charge.card ??= PaymentCard.empty();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget buildChild(BuildContext context) {
    var securedWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Icon(Icons.lock, size: 10),
            Padding(
              padding: EdgeInsetsDirectional.only(start: 3),
              child: Text(
                "Secured by",
                key: Key("SecuredBy"),
                style: TextStyle(fontSize: 10),
              ),
            )
          ],
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (widget.logo != null)
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 3),
                child: Image.asset(
                  'assets/images/paystack_icon.png',
                  key: const Key("PaystackBottomIcon"),
                  package: 'flutter_paystack',
                  height: 16,
                ),
              ),
            Image.asset(
              'assets/images/paystack.png',
              key: const Key("PaystackLogo"),
              package: 'flutter_paystack',
              height: 15,
            )
          ],
        )
      ],
    );
    return CustomAlertDialog(
      expanded: true,
      fullscreen: widget.fullscreen,
      titlePadding: const EdgeInsets.all(0.0),
      onCancelPress: onCancelPress,
      title: _buildTitle(),
      content: Container(
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            behavior: HitTestBehavior.translucent,
            child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 10.0),
                child: Column(
                  children: <Widget>[
                    _showProcessingError()
                        ? _buildErrorWidget()
                        : _paymentSuccessful
                            ? _buildSuccessfulWidget()
                            : _methodWidgets[_currentIndex!].child,
                    const SizedBox(height: 20),
                    securedWidget
                  ],
                )),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    final accentColor = Theme.of(context).colorScheme.secondary;
    var emailAndAmount = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        if (!widget.hideEmail && _charge.email != null)
          Text(
            _charge.email!,
            key: const Key("ChargeEmail"),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.grey, fontSize: 12.0),
          ),
        if (!widget.hideAmount && !_charge.amount.isNegative)
          Row(
            key: const Key("DisplayAmount"),
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Pay',
                style: TextStyle(fontSize: 14.0, color: Colors.black54),
              ),
              const SizedBox(
                width: 5.0,
              ),
              Flexible(
                  child: Text(Utils.formatAmount(_charge.amount),
                      style: TextStyle(
                          fontSize: 15.0,
                          color: Theme.of(context).textTheme.bodyText1!.color,
                          fontWeight: FontWeight.w500)))
            ],
          )
      ],
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if (widget.logo == null)
                Image.asset(
                  'assets/images/paystack_icon.png',
                  key: const Key("PaystackIcon"),
                  package: 'flutter_paystack',
                  width: 25,
                )
              else
                SizedBox(
                  key: const Key("Logo"),
                  child: widget.logo,
                ),
              const SizedBox(
                width: 50,
              ),
              Expanded(child: emailAndAmount),
            ],
          ),
        ),
        if (_showTabs) buildCheckoutMethods(accentColor)
      ],
    );
  }

  Widget buildCheckoutMethods(Color accentColor) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      vsync: this,
      curve: Curves.fastOutSlowIn,
      child: Container(
        color: Colors.grey.withOpacity(0.1),
        height: _tabHeight,
        alignment: Alignment.center,
        child: TabBar(
          controller: _tabController,
          isScrollable: true,
          unselectedLabelColor: Colors.black54,
          labelColor: accentColor,
          labelStyle:
              const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
          indicator: ShapeDecoration(
            shape: RoundedRectangleBorder(
                  borderRadius: tabBorderRadius,
                  side: BorderSide(
                    color: accentColor,
                    width: 1.0,
                  ),
                ) +
                const RoundedRectangleBorder(
                  borderRadius: tabBorderRadius,
                  side: BorderSide(
                    color: Colors.transparent,
                    width: 6.0,
                  ),
                ),
          ),
          tabs: _methodWidgets.map<Tab>((MethodItem m) {
            return Tab(
              text: m.text,
              icon: Icon(
                m.icon,
                size: 24.0,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _indexChange() {
    setState(() {
      _currentIndex = _tabController!.index;
      // Update the checkout here just in case the user terminates the transaction
      // forcefully by tapping the close icon
    });
  }

  void _initPaymentMethods() {
    _methodWidgets = [
      MethodItem(
          text: 'Card',
          icon: Icons.credit_card,
          child: CardCheckout(
            key: const Key("CardCheckout"),
            publicKey: widget.publicKey,
            service: widget.cardsService,
            charge: _charge,
            onProcessingChange: _onProcessingChange,
            onResponse: _onPaymentResponse,
            hideAmount: widget.hideAmount,
            onCardChange: (PaymentCard? card) {
              if (card == null) return;
              _charge.card!.number = card.number;
              _charge.card!.cvc = card.cvc;
              _charge.card!.expiryMonth = card.expiryMonth;
              _charge.card!.expiryYear = card.expiryYear;
            },
          )),
      MethodItem(
        text: 'Bank',
        icon: Icons.account_balance,
        child: BankCheckout(
          publicKey: widget.publicKey,
          charge: _charge,
          service: widget.bankService,
          onResponse: _onPaymentResponse,
          onProcessingChange: _onProcessingChange,
        ),
      )
    ];
  }

  void _onProcessingChange(bool processing) {
    setState(() {
      _tabHeight = processing || _paymentSuccessful || _showProcessingError()
          ? 0.0
          : kFullTabHeight;
      processing = processing;
    });
  }

  _showProcessingError() {
    return !(_paymentError == null || _paymentError!.isEmpty);
  }

  void _onPaymentResponse(CheckoutResponse response) {
    _response = response;
    if (!mounted) return;
    if (response.status == true) {
      _onPaymentSuccess();
    } else {
      _onPaymentError(response.message);
    }
  }

  void _onPaymentSuccess() {
    setState(() {
      _paymentSuccessful = true;
      _paymentError = null;
      _onProcessingChange(false);
    });
  }

  void _onPaymentError(String? value) {
    setState(() {
      _paymentError = value;
      _paymentSuccessful = false;
      _onProcessingChange(false);
    });
  }

  int? _getCurrentTab() {
    int? checkedTab;
    switch (widget.method) {
      case CheckoutMethod.selectable:
      case CheckoutMethod.card:
        checkedTab = 0;
        break;
      case CheckoutMethod.bank:
        checkedTab = 1;
        break;
    }
    return checkedTab;
  }

  Widget _buildErrorWidget() {
    _initPaymentMethods();
    void _resetShowTabs() {
      _response = null; // Reset the response
      _showTabs = widget.method == CheckoutMethod.selectable ? true : false;
    }

    return ErrorWidget(
      text: _paymentError,
      method: widget.method,
      isCardPayment: _charge.card!.isValid(),
      vSync: this,
      payWithBank: () {
        setState(() {
          _resetShowTabs();
          _onPaymentError(null);
          _charge.card = PaymentCard.empty();
          _tabController!.index = 1;
          _paymentError = null;
        });
      },
      tryAnotherCard: () {
        setState(() {
          _resetShowTabs();
          _onPaymentError(null);
          _charge.card = PaymentCard.empty();
          _tabController!.index = 0;
        });
      },
      startOverWithCard: () {
        _resetShowTabs();
        _onPaymentError(null);
        _tabController!.index = 0;
      },
    );
  }

  Widget _buildSuccessfulWidget() => SuccessfulWidget(
        amount: _charge.amount,
        onCountdownComplete: () {
          if (_response!.card != null) {
            _response!.card!.nullifyNumber();
          }
          Navigator.of(context).pop(_response);
        },
      );

  @override
  getPopReturnValue() {
    return _getResponse();
  }

  CheckoutResponse _getResponse() {
    CheckoutResponse? response = _response;
    if (response == null) {
      response = CheckoutResponse.defaults();
      response.method = _tabController!.index == 0
          ? CheckoutMethod.card
          : CheckoutMethod.bank;
    }
    if (response.card != null) {
      response.card!.nullifyNumber();
    }
    return response;
  }

  _init() {
    Utils.setCurrencyFormatter(_charge.currency, _charge.locale);
  }
}

typedef OnResponse<CheckoutResponse> = void Function(CheckoutResponse response);

class BankTransactionManager extends BaseTransactionManager {
  BankChargeRequestBody? chargeRequestBody;
  final BankServiceContract service;

  BankTransactionManager(
      {required this.service,
      required Charge charge,
      required BuildContext context,
      required String publicKey})
      : super(charge: charge, context: context, publicKey: publicKey);

  Future<CheckoutResponse> chargeBank() async {
    await initiate();
    return sendCharge();
  }

  @override
  postInitiate() {
    chargeRequestBody = BankChargeRequestBody(charge);
  }

  @override
  Future<CheckoutResponse> sendChargeOnServer() {
    return _getTransactionId();
  }

  Future<CheckoutResponse> _getTransactionId() async {
    String? id = await service.getTransactionId(chargeRequestBody!.accessCode);
    if (id == null || id.isEmpty) {
      return notifyProcessingError('Unable to verify access code');
    }

    chargeRequestBody!.transactionId = id;
    return _chargeAccount();
  }

  Future<CheckoutResponse> _chargeAccount() {
    Future<TransactionApiResponse> future =
        service.chargeBank(chargeRequestBody);
    return handleServerResponse(future);
  }

  Future<CheckoutResponse> _sendTokenToServer() {
    Future<TransactionApiResponse> future = service.validateToken(
        chargeRequestBody, chargeRequestBody!.tokenParams());
    return handleServerResponse(future);
  }

  @override
  Future<CheckoutResponse> handleApiResponse(
      TransactionApiResponse response) async {
    var auth = response.auth;

    if (response.status == 'success') {
      setProcessingOff();
      return onSuccess(transaction);
    }

    if (auth == 'failed' || auth == 'timeout') {
      return notifyProcessingError(ChargeException(response.message));
    }

    if (auth == 'birthday') {
      return getBirthdayFrmUI(response);
    }

    if (auth == 'payment_token' || auth == 'registration_token') {
      return getOtpFrmUI(response: response);
    }

    return notifyProcessingError(
        PaystackException(response.message ?? Strings.unKnownResponse));
  }

  @override
  Future<CheckoutResponse> handleOtpInput(
      String token, TransactionApiResponse? response) {
    chargeRequestBody!.token = token;
    return _sendTokenToServer();
  }

  @override
  Future<CheckoutResponse> handleBirthdayInput(
      String birthday, TransactionApiResponse response) {
    chargeRequestBody!.birthday = birthday;
    return _chargeAccount();
  }

  @override
  CheckoutMethod checkoutMethod() => CheckoutMethod.bank;
}

class BankCheckout extends StatefulWidget {
  final Charge charge;
  final OnResponse<CheckoutResponse> onResponse;
  final ValueChanged<bool> onProcessingChange;
  final BankServiceContract service;
  final String publicKey;

  const BankCheckout({
    required this.charge,
    required this.onResponse,
    required this.onProcessingChange,
    required this.service,
    required this.publicKey,
  });

  @override
  _BankCheckoutState createState() => _BankCheckoutState(onResponse);
}

class _BankCheckoutState extends BaseCheckoutMethodState<BankCheckout> {
  var _formKey = GlobalKey<FormState>();
  late AnimationController _controller;
  late Animation<double> _animation;
  var _autoValidate = AutovalidateMode.disabled;
  late Future<List<Bank>?>? _futureBanks;
  Bank? _currentBank;
  BankAccount? _account;
  var _loading = false;

  _BankCheckoutState(OnResponse<CheckoutResponse> onResponse)
      : super(onResponse, CheckoutMethod.bank);

  @override
  void initState() {
    _futureBanks = widget.service.fetchSupportedBanks();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _animation = Tween(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    );
    _animation.addListener(_rebuild);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget buildAnimatedChild() {
    return Container(
      alignment: Alignment.center,
      child: FutureBuilder<List<Bank>?>(
        future: _futureBanks,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          Widget widget;
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              widget = Center(
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  margin: const EdgeInsets.symmetric(vertical: 30.0),
                  child: const CircularProgressIndicator(
                    strokeWidth: 3.0,
                  ),
                ),
              );
              break;
            case ConnectionState.done:
              widget = snapshot.hasData
                  ? _getCompleteUI(snapshot.data)
                  : retryButton();
              break;
            default:
              widget = retryButton();
              break;
          }
          return widget;
        },
      ),
    );
  }

  Widget _getCompleteUI(List<Bank> banks) {
    var container = Container();
    return Container(
      child: Form(
        autovalidateMode: _autoValidate,
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: 10.0,
            ),
            _currentBank == null
                ? const Icon(
                    Icons.account_balance,
                    color: Colors.black,
                    size: 35.0,
                  )
                : container,
            _currentBank == null
                ? const SizedBox(
                    height: 20.0,
                  )
                : container,
            Text(
              _currentBank == null
                  ? 'Choose your bank to start the payment'
                  : 'Enter your acccount number',
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0,
                  color: Colors.black),
            ),
            const SizedBox(
              height: 20.0,
            ),
            DropdownButtonHideUnderline(
                child: InputDecorator(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                isDense: true,
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 0.5)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).accentColor, width: 1.0)),
                hintText: 'Tap here to choose',
              ),
              isEmpty: _currentBank == null,
              child: DropdownButton<Bank>(
                value: _currentBank,
                isDense: true,
                onChanged: (Bank? newValue) {
                  setState(() {
                    _currentBank = newValue;
                    _controller.forward();
                  });
                },
                items: banks.map((Bank value) {
                  return DropdownMenuItem<Bank>(
                    value: value,
                    child: Text(value.name!),
                  );
                }).toList(),
              ),
            )),
            ScaleTransition(
              scale: _animation,
              child: _currentBank == null
                  ? container
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const SizedBox(
                          height: 15.0,
                        ),
                        AccountField(
                            onSaved: (String? value) =>
                                _account = BankAccount(_currentBank, value)),
                        const SizedBox(
                          height: 20.0,
                        ),
                        AccentButton(
                            onPressed: _validateInputs,
                            showProgress: _loading,
                            text: 'Verify Account')
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _validateInputs() {
    FocusScope.of(context).requestFocus(FocusNode());
    final FormState form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      widget.charge.account = _account;
      widget.onProcessingChange(true);
      setState(() => _loading = true);
      _chargeAccount();
    } else {
      setState(() => _autoValidate = AutovalidateMode.always);
    }
  }

  void _chargeAccount() async {
    final response = await BankTransactionManager(
            charge: widget.charge,
            service: widget.service,
            context: context,
            publicKey: widget.publicKey)
        .chargeBank();

    if (!mounted) return;

    setState(() => _loading = false);
    onResponse(response);
  }

  Widget retryButton() {
    banksMemo = null;
    banksMemo = AsyncMemoizer();
    _futureBanks = widget.service.fetchSupportedBanks();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: AccentButton(
          onPressed: () => setState(() {}),
          showProgress: false,
          text: 'Display banks'),
    );
  }

  void _rebuild() {
    setState(() {
      // Rebuild in order to animate views.
    });
  }
}

class AccountField extends BaseTextField {
  AccountField({required FormFieldSetter<String> onSaved})
      : super(
          labelText: 'Bank Account Number(10 digits)',
          validator: _validate,
          onSaved: onSaved,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
        );

  static String? _validate(String? value) {
    if (value == null || value.trim().isEmpty) return Strings.invalidAcc;
    return value.length == 10 ? null : Strings.invalidAcc;
  }
}

abstract class BaseCheckoutMethodState<T extends StatefulWidget>
    extends BaseAnimatedState<T> {
  final OnResponse<CheckoutResponse> onResponse;
  final CheckoutMethod _method;

  BaseCheckoutMethodState(this.onResponse, this._method);

  CheckoutMethod get method => _method;
}

class CardCheckout extends StatefulWidget {
  final Charge charge;
  final OnResponse<CheckoutResponse> onResponse;
  final ValueChanged<bool> onProcessingChange;
  final ValueChanged<PaymentCard?> onCardChange;
  final bool hideAmount;
  final CardServiceContract service;
  final String publicKey;

  const CardCheckout({
    Key? key,
    required this.charge,
    required this.onResponse,
    required this.onProcessingChange,
    required this.onCardChange,
    required this.service,
    required this.publicKey,
    this.hideAmount = false,
  }) : super(key: key);

  @override
  _CardCheckoutState createState() => _CardCheckoutState(charge, onResponse);
}

class _CardCheckoutState extends BaseCheckoutMethodState<CardCheckout> {
  final Charge _charge;

  _CardCheckoutState(this._charge, OnResponse<CheckoutResponse> onResponse)
      : super(onResponse, CheckoutMethod.card);

  @override
  Widget buildAnimatedChild() {
    var amountText =
        _charge.amount.isNegative ? '' : Utils.formatAmount(_charge.amount);

    return Container(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          const Text(
            Strings.cardInputInstruction,
            key: Key("InstructionKey"),
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 20.0,
          ),
          CardInput(
            key: const Key("CardInput"),
            buttonText: widget.hideAmount ? "Continue" : 'Pay $amountText',
            card: _charge.card,
            onValidated: _onCardValidated,
          ),
        ],
      ),
    );
  }

  void _onCardValidated(PaymentCard? card) {
    if (card == null) return;
    _charge.card = card;
    widget.onCardChange(_charge.card);
    widget.onProcessingChange(true);

    if ((_charge.accessCode != null && _charge.accessCode!.isNotEmpty) ||
        _charge.reference != null && _charge.reference!.isNotEmpty) {
      _chargeCard(_charge);
    } else {
      // This should never happen. Validation has already been done in [PaystackPlugin .checkout]
      throw ChargeException(Strings.noAccessCodeReference);
    }
  }

  void _chargeCard(Charge charge) async {
    final response = await CardTransactionManager(
      charge: charge,
      context: context,
      service: widget.service,
      publicKey: widget.publicKey,
    ).chargeCard();
    onResponse(response);
  }
}

class CardTransactionManager extends BaseTransactionManager {
  late ValidateRequestBody validateRequestBody;
  late CardRequestBody chargeRequestBody;
  final CardServiceContract service;
  var _invalidDataSentRetries = 0;

  CardTransactionManager(
      {required Charge charge,
      required this.service,
      required BuildContext context,
      required String publicKey})
      : assert(charge.card != null,
            'please add a card to the charge before ' 'calling chargeCard'),
        super(charge: charge, context: context, publicKey: publicKey);

  @override
  postInitiate() async {
    chargeRequestBody =
        await CardRequestBody.getChargeRequestBody(publicKey, charge);
    validateRequestBody = ValidateRequestBody();
  }

  Future<CheckoutResponse> chargeCard() async {
    try {
      if (charge.card == null || !charge.card!.isValid()) {
        return getCardInfoFrmUI(charge.card);
      } else {
        await initiate();
        return sendCharge();
      }
    } catch (e) {
      if (!(e is ProcessingException)) {
        setProcessingOff();
      }
      return CheckoutResponse(
          message: e.toString(),
          reference: transaction.reference,
          status: false,
          card: charge.card?..nullifyNumber(),
          method: CheckoutMethod.card,
          verify: !(e is PaystackException));
    }
  }

  Future<CheckoutResponse> _validate() async {
    try {
      return _validateChargeOnServer();
    } catch (e) {
      return notifyProcessingError(e);
    }
  }

  Future<CheckoutResponse> _reQuery() async {
    try {
      return _reQueryChargeOnServer();
    } catch (e) {
      return notifyProcessingError(e);
    }
  }

  Future<CheckoutResponse> _validateChargeOnServer() {
    Map<String, String?> params = validateRequestBody.paramsMap();
    Future<TransactionApiResponse> future = service.validateCharge(params);
    return handleServerResponse(future);
  }

  Future<CheckoutResponse> _reQueryChargeOnServer() {
    Future<TransactionApiResponse> future =
        service.reQueryTransaction(transaction.id);
    return handleServerResponse(future);
  }

  @override
  Future<CheckoutResponse> sendChargeOnServer() {
    Future<TransactionApiResponse> future =
        service.chargeCard(chargeRequestBody.paramsMap());
    return handleServerResponse(future);
  }

  @override
  Future<CheckoutResponse> handleApiResponse(
      TransactionApiResponse apiResponse) async {
    var status = apiResponse.status;
    if (status == '1' || status == 'success') {
      setProcessingOff();
      return onSuccess(transaction);
    }

    if (status == '2') {
      return getPinFrmUI();
    }

    if (status == '3' && apiResponse.hasValidReferenceAndTrans()) {
      validateRequestBody.trans = apiResponse.trans;
      return getOtpFrmUI(message: apiResponse.message);
    }

    if (transaction.hasStartedOnServer()) {
      if (status == 'requery') {
        await Future.delayed(const Duration(seconds: 5));
        return _reQuery();
      }

      if (apiResponse.hasValidAuth() &&
          apiResponse.auth!.toLowerCase() == '3DS'.toLowerCase() &&
          apiResponse.hasValidUrl()) {
        return getAuthFrmUI(apiResponse.otpMessage);
      }

      if (apiResponse.hasValidAuth() &&
          (apiResponse.auth!.toLowerCase() == 'otp' ||
              apiResponse.auth!.toLowerCase() == 'phone') &&
          apiResponse.hasValidOtpMessage()) {
        validateRequestBody.trans = transaction.id;
        return getOtpFrmUI(message: apiResponse.otpMessage);
      }
    }

    if (status == '0'.toLowerCase() || status == 'error') {
      if (apiResponse.message!.toLowerCase() ==
              'Invalid Data Sent'.toLowerCase() &&
          _invalidDataSentRetries < 0) {
        _invalidDataSentRetries++;
        return chargeCard();
      }

      if (apiResponse.message!.toLowerCase() ==
          'Access code has expired'.toLowerCase()) {
        return sendCharge();
      }

      return notifyProcessingError(ChargeException(apiResponse.message));
    }

    return notifyProcessingError(PaystackException(Strings.unKnownResponse));
  }

  @override
  Future<CheckoutResponse> handleCardInput() {
    return chargeCard();
  }

  @override
  Future<CheckoutResponse> handleOtpInput(
      String otp, TransactionApiResponse? response) {
    validateRequestBody.token = otp;
    return _validate();
  }

  @override
  Future<CheckoutResponse> handlePinInput(String pin) async {
    await chargeRequestBody.addPin(pin);
    return sendCharge();
  }

  @override
  CheckoutMethod checkoutMethod() => CheckoutMethod.card;
}

class MethodItem {
  final String text;
  final IconData icon;
  final Widget child;

  MethodItem({required this.text, required this.icon, required this.child});
}

class ErrorWidget extends StatelessWidget {
  final TickerProvider vSync;
  final AnimationController controller;
  final CheckoutMethod method;
  final String? text;
  final VoidCallback? payWithBank;
  final VoidCallback? tryAnotherCard;
  final VoidCallback? startOverWithCard;
  final bool isCardPayment;

  ErrorWidget({
    required this.text,
    required this.vSync,
    required this.method,
    required this.isCardPayment,
    this.payWithBank,
    this.tryAnotherCard,
    this.startOverWithCard,
  }) : controller = AnimationController(
          duration: const Duration(milliseconds: 500),
          vsync: vSync,
        ) {
    controller.forward();
  }

  final emptyContainer = Container();

  @override
  Widget build(BuildContext context) {
    // Remove 'Retry buttons for bank payment because when you retry a transaction it ret
    var buttonMargin =
        isCardPayment ? const SizedBox(height: 5.0) : emptyContainer;
    return Container(
      child: CustomAnimatedWidget(
        controller: controller,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.warning,
              size: 50.0,
              color: Color(0xFFf9a831),
            ),
            const SizedBox(height: 10.0),
            Text(
              text!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w500,
                fontSize: 14.0,
              ),
            ),
            const SizedBox(height: 25.0),
            isCardPayment
                ? WhiteButton(
                    onPressed: tryAnotherCard, text: 'Try another card')
                : emptyContainer,
            buttonMargin,
            method == CheckoutMethod.selectable || method == CheckoutMethod.bank
                ? WhiteButton(
                    onPressed: payWithBank,
                    text: method == CheckoutMethod.bank || !isCardPayment
                        ? 'Retry'
                        : 'Try paying with your bank account',
                  )
                : emptyContainer,
            buttonMargin,
            isCardPayment
                ? WhiteButton(
                    onPressed: startOverWithCard,
                    text: 'Start over with same card',
                    iconData: Icons.refresh,
                    bold: false,
                    flat: true,
                  )
                : emptyContainer
          ],
        ),
      ),
    );
  }
}

class SuccessfulWidget extends StatefulWidget {
  final int amount;
  final VoidCallback onCountdownComplete;

  const SuccessfulWidget(
      {required this.amount, required this.onCountdownComplete});

  @override
  _SuccessfulWidgetState createState() {
    return _SuccessfulWidgetState();
  }
}

class _SuccessfulWidgetState extends State<SuccessfulWidget>
    with TickerProviderStateMixin {
  final sizedBox = const SizedBox(height: 20.0);
  late AnimationController _mainController;
  late AnimationController _opacityController;
  late Animation<double> _opacity;

  static const int kStartValue = 4;
  late AnimationController _countdownController;
  late Animation _countdownAnim;

  @override
  void initState() {
    super.initState();
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _mainController.forward();

    _countdownController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: kStartValue),
    );
    _countdownController.addListener(() => setState(() {}));
    _countdownAnim =
        StepTween(begin: kStartValue, end: 0).animate(_countdownController);

    _opacityController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _opacity = CurvedAnimation(parent: _opacityController, curve: Curves.linear)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _opacityController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _opacityController.forward();
        }
      });

    WidgetsBinding.instance.addPostFrameCallback((_) => _startCountdown());
  }

  @override
  void dispose() {
    _mainController.dispose();
    _countdownController.dispose();
    _opacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).accentColor;
    return Container(
      child: CustomAnimatedWidget(
        controller: _mainController,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            sizedBox,
            Image.asset(
              'assets/images/successful.png',
              color: accentColor,
              width: 50.0,
              package: 'flutter_paystack',
            ),
            sizedBox,
            const Text(
              'Payment Successful',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
            widget.amount.isNegative
                ? Container()
                : Text('You paid ${Utils.formatAmount(widget.amount)}',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.normal,
                      fontSize: 14.0,
                    )),
            sizedBox,
            FadeTransition(
              opacity: _opacity,
              child: Text(
                _countdownAnim.value.toString(),
                style: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0),
              ),
            ),
            const SizedBox(
              height: 30.0,
            )
          ],
        ),
      ),
    );
  }

  void _startCountdown() {
    if (_countdownController.isAnimating ||
        _countdownController.isCompleted ||
        !mounted) {
      return;
    }
    _countdownController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        widget.onCountdownComplete();
      }
    });
    _countdownController.forward();
    _opacityController.forward();
  }
}

class CustomAnimatedWidget extends StatelessWidget {
  final CurvedAnimation _animation;
  final Widget child;

  CustomAnimatedWidget(
      {required this.child, required AnimationController controller})
      : _animation = CurvedAnimation(
          parent: controller,
          curve: Curves.fastOutSlowIn,
        );

  final Tween<Offset> slideTween =
      Tween(begin: const Offset(0.0, 0.02), end: Offset.zero);
  final Tween<double> scaleTween = Tween(begin: 1.04, end: 1.0);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: slideTween.animate(_animation),
        child: ScaleTransition(
          scale: scaleTween.animate(_animation),
          child: Container(
            margin: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0.0),
            child: SafeArea(top: false, bottom: false, child: child),
          ),
        ),
      ),
    );
  }
}

abstract class BaseAnimatedState<T extends StatefulWidget> extends BaseState<T>
    with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    alwaysPop = true;
    controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget buildChild(BuildContext context) {
    return CustomAnimatedWidget(
      controller: controller,
      child: buildAnimatedChild(),
    );
  }

  Widget buildAnimatedChild();
}

class ValidateRequestBody extends BaseRequestBody {
  String _fieldTrans = 'trans';
  String _fieldToken = 'token';
  String? trans;
  String? token;

  @override
  Map<String, String?> paramsMap() {
    Map<String, String?> params = {_fieldTrans: trans, _fieldToken: token};
    if (device != null) {
      params[fieldDevice] = device;
    }
    return params;
  }
}

class CardRequestBody extends BaseRequestBody {
  static const String fieldClientData = "clientdata";
  static const String fieldLast4 = "last4";
  static const String fieldAccessCode = "access_code";
  static const String fieldPublicKey = "public_key";
  static const String fieldEmail = "email";
  static const String fieldAmount = "amount";
  static const String fieldReference = "reference";
  static const String fieldSubAccount = "subaccount";
  static const String fieldTransactionCharge = "transaction_charge";
  static const String fieldBearer = "bearer";
  static const String fieldHandle = "handle";
  static const String fieldMetadata = "metadata";
  static const String fieldCurrency = "currency";
  static const String fieldPlan = "plan";

  String _clientData;
  String? _last4;
  final String? _publicKey;
  String? _accessCode;
  String? _email;
  String _amount;
  String? _reference;
  String? _subAccount;
  String? _transactionCharge;
  String? _bearer;
  String? _handle;
  String? _metadata;
  String? _currency;
  String? _plan;
  Map<String, String?>? _additionalParameters;

  CardRequestBody._(this._publicKey, Charge charge, String clientData)
      : _clientData = clientData,
        _last4 = charge.card!.last4Digits,
        _email = charge.email,
        _amount = charge.amount.toString(),
        _reference = charge.reference,
        _subAccount = charge.subAccount,
        _transactionCharge =
            charge.transactionCharge != null && charge.transactionCharge! > 0
                ? charge.transactionCharge.toString()
                : null,
        _bearer = charge.bearer != null ? getBearer(charge.bearer) : null,
        _metadata = charge.metadata,
        _plan = charge.plan,
        _currency = charge.currency,
        _accessCode = charge.accessCode,
        _additionalParameters = charge.additionalParameters;

  static Future<CardRequestBody> getChargeRequestBody(
      String publicKey, Charge charge) async {
    return Crypto.encrypt(CardUtils.concatenateCardFields(charge.card))
        .then((clientData) => CardRequestBody._(publicKey, charge, clientData));
  }

  addPin(String pin) async {
    _handle = await Crypto.encrypt(pin);
  }

  static String? getBearer(Bearer? bearer) {
    if (bearer == null) return null;
    String? bearerStr;
    switch (bearer) {
      case Bearer.SubAccount:
        bearerStr = "subaccount";
        break;
      case Bearer.Account:
        bearerStr = "account";
        break;
    }
    return bearerStr;
  }

  @override
  Map<String, String?> paramsMap() {
    // set values will override additional params provided
    Map<String, String?> params = _additionalParameters!;
    params[fieldPublicKey] = _publicKey;
    params[fieldClientData] = _clientData;
    params[fieldLast4] = _last4;
    params[fieldAccessCode] = _accessCode;
    params[fieldEmail] = _email;
    params[fieldAmount] = _amount;
    params[fieldHandle] = _handle;
    params[fieldReference] = _reference;
    params[fieldSubAccount] = _subAccount;
    params[fieldTransactionCharge] = _transactionCharge;
    params[fieldBearer] = _bearer;
    params[fieldMetadata] = _metadata;
    params[fieldPlan] = _plan;
    params[fieldCurrency] = _currency;
    params[fieldDevice] = device;
    return params..removeWhere((key, value) => value == null || value.isEmpty);
  }
}

class Crypto {
  static Future<String> encrypt(String data) async {
    var completer = Completer<String>();

    try {
      String? result = await Utils.methodChannel
          .invokeMethod('getEncryptedData', {"stringData": data});
      completer.complete(result);
    } on PlatformException catch (e) {
      completer.completeError(e);
    }

    return completer.future;
  }

  static Future<String> decrypt(String data) async {
    // Well, let's hope we'll never decrypt
    throw UnimplementedError('Decrypt is not supported for now');
  }
}

class PinWidget extends StatefulWidget {
  @override
  _PinWidgetState createState() => _PinWidgetState();
}

class _PinWidgetState extends BaseState<PinWidget> {
  var heightBox = const SizedBox(height: 20.0);

  @override
  void initState() {
    confirmationMessage = 'Do you want to cancel PIN input?';
    super.initState();
  }

  @override
  Widget buildChild(BuildContext context) {
    return CustomAlertDialog(
      content: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              buildStar(),
              heightBox,
              const Text(
                'To confirm you\'re the owner of this card, please '
                'enter your card pin.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                  fontSize: 15.0,
                ),
              ),
              heightBox,
              PinField(onSaved: (String pin) => Navigator.of(context).pop(pin)),
              heightBox,
              WhiteButton(
                onPressed: onCancelPress,
                text: 'Cancel',
                flat: true,
                bold: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStar() {
    Icon star(Color color) => Icon(
          Icons.star,
          color: color,
          size: 12.0,
        );

    return Container(
      padding: const EdgeInsets.fromLTRB(6.0, 15.0, 6.0, 6.0),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColorDark,
          borderRadius: const BorderRadius.all(Radius.circular(5.0))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
            _startCount,
            (i) => star(i == (_startCount - 1)
                ? Theme.of(context).accentColor
                : Theme.of(context).primaryColorLight)),
      ),
    );
  }
}

const _startCount = 4;

abstract class BaseTransactionManager {
  bool processing = false;
  final Charge charge;
  final BuildContext context;
  final Transaction transaction = Transaction();
  final String publicKey;

  BaseTransactionManager({
    required this.charge,
    required this.context,
    required this.publicKey,
  });

  initiate() async {
    if (processing) throw ProcessingException();

    setProcessingOn();
    await postInitiate();
  }

  Future<CheckoutResponse> sendCharge() async {
    try {
      return sendChargeOnServer();
    } catch (e) {
      return notifyProcessingError(e);
    }
  }

  Future<CheckoutResponse> handleApiResponse(
      TransactionApiResponse apiResponse);

  Future<CheckoutResponse> _initApiResponse(
      TransactionApiResponse? apiResponse) {
    apiResponse ??= TransactionApiResponse.unknownServerResponse();

    transaction.loadFromResponse(apiResponse);

    return handleApiResponse(apiResponse);
  }

  Future<CheckoutResponse> handleServerResponse(
      Future<TransactionApiResponse> future) async {
    try {
      final apiResponse = await future;
      return _initApiResponse(apiResponse);
    } catch (e) {
      return notifyProcessingError(e);
    }
  }

  CheckoutResponse notifyProcessingError(Object e) {
    setProcessingOff();

    if (e is TimeoutException || e is SocketException) {
      e = 'Please  check your internet connection or try again later';
    }
    return CheckoutResponse(
        message: e.toString(),
        reference: transaction.reference,
        status: false,
        card: charge.card?..nullifyNumber(),
        account: charge.account,
        method: checkoutMethod(),
        verify: !(e is PaystackException));
  }

  setProcessingOff() => processing = false;

  setProcessingOn() => processing = true;

  Future<CheckoutResponse> getCardInfoFrmUI(PaymentCard? currentCard) async {
    PaymentCard? newCard = await showDialog<PaymentCard>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => CardInputWidget(currentCard));

    if (newCard == null || !newCard.isValid()) {
      return notifyProcessingError(CardException('Invalid card parameters'));
    } else {
      charge.card = newCard;
      return handleCardInput();
    }
  }

  Future<CheckoutResponse> getOtpFrmUI(
      {String? message, TransactionApiResponse? response}) async {
    assert(message != null || response != null);
    String? otp = await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => OtpWidget(
            message: message ??
                (response!.displayText == null || response.displayText!.isEmpty
                    ? response.message
                    : response.displayText)));

    if (otp != null && otp.isNotEmpty) {
      return handleOtpInput(otp, response);
    } else {
      return notifyProcessingError(
          PaystackException("You did not provide an OTP"));
    }
  }

  Future<CheckoutResponse> getAuthFrmUI(String? url) async {
    TransactionApiResponse apiResponse =
        TransactionApiResponse.unknownServerResponse();

    String? result = await Utils.methodChannel
        .invokeMethod<String>('getAuthorization', {"authUrl": url});

    if (result != null) {
      try {
        Map<String, dynamic> responseMap = json.decode(result);
        apiResponse = TransactionApiResponse.fromMap(responseMap);
      } catch (e) {}
    }
    return _initApiResponse(apiResponse);
  }

  Future<CheckoutResponse> getPinFrmUI() async {
    String? pin = await showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => PinWidget());

    if (pin != null && pin.length == 4) {
      return handlePinInput(pin);
    } else {
      return notifyProcessingError(
          PaystackException("PIN must be exactly 4 digits"));
    }
  }

  Future<CheckoutResponse> getBirthdayFrmUI(
      TransactionApiResponse response) async {
    String? birthday = await showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          var messageText =
              response.displayText == null || response.displayText!.isEmpty
                  ? response.message!
                  : response.displayText!;
          return BirthdayWidget(message: messageText);
        });

    if (birthday != null && birthday.isNotEmpty) {
      return handleBirthdayInput(birthday, response);
    } else {
      return notifyProcessingError(
          PaystackException("Date of birth not supplied"));
    }
  }

  CheckoutResponse onSuccess(Transaction transaction) {
    return CheckoutResponse(
        message: transaction.message,
        reference: transaction.reference,
        status: true,
        card: charge.card?..nullifyNumber(),
        account: charge.account,
        method: checkoutMethod(),
        verify: true);
  }

  Future<CheckoutResponse> handleCardInput() {
    throw UnsupportedError(
        "Handling of card input not supported for Bank payment method");
  }

  Future<CheckoutResponse> handleOtpInput(
      String otp, TransactionApiResponse? response);

  Future<CheckoutResponse> handlePinInput(String pin) {
    throw UnsupportedError("Pin Input not supported for ${checkoutMethod()}");
  }

  postInitiate();

  Future<CheckoutResponse> handleBirthdayInput(
      String birthday, TransactionApiResponse response) {
    throw UnsupportedError(
        "Birthday Input not supported for ${checkoutMethod()}");
  }

  CheckoutMethod checkoutMethod();

  Future<CheckoutResponse> sendChargeOnServer();
}

class Transaction {
  String? _id;
  String? _reference;
  String? _message;

  loadFromResponse(TransactionApiResponse t) {
    if (t.hasValidReferenceAndTrans()) {
      _reference = t.reference;
      _id = t.trans;
      _message = t.message;
    }
  }

  String? get reference => _reference;

  String? get id => _id;

  String get message => _message ?? "";

  bool hasStartedOnServer() {
    return (reference != null) && (id != null);
  }
}

const double _kPickerSheetHeight = 216.0;

class BirthdayWidget extends StatefulWidget {
  final String message;

  const BirthdayWidget({required this.message});

  @override
  _BirthdayWidgetState createState() => _BirthdayWidgetState();
}

class _BirthdayWidgetState extends BaseState<BirthdayWidget> {
  var _heightBox = const SizedBox(height: 20.0);
  DateTime? _pickedDate;

  @override
  void initState() {
    super.initState();
    confirmationMessage = 'Do you want to cancel birthday input?';
  }

  @override
  Widget buildChild(BuildContext context) {
    return CustomAlertDialog(
        content: SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Column(
          children: <Widget>[
            Image.asset('assets/images/dob.png',
                width: 30.0, package: 'flutter_paystack'),
            _heightBox,
            Text(
              widget.message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
                fontSize: 15.0,
              ),
            ),
            _heightBox,
            _pickedDate == null
                ? WhiteButton(onPressed: _selectBirthday, text: 'Pick birthday')
                : WhiteButton(
                    onPressed: _selectBirthday,
                    flat: true,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(flex: 4, child: dateItem(_getMonth())),
                        Flexible(flex: 2, child: dateItem(_getDay())),
                        Flexible(flex: 3, child: dateItem(_getYear()))
                      ],
                    ),
                  ),
            SizedBox(
              height: _pickedDate == null ? 5.0 : 20.0,
            ),
            _pickedDate == null
                ? Container()
                : AccentButton(onPressed: _onAuthorize, text: 'Authorize'),
            Container(
              padding: EdgeInsets.only(top: _pickedDate == null ? 15.0 : 20.0),
              child: WhiteButton(
                onPressed: onCancelPress,
                text: 'Cancel',
                flat: true,
                bold: true,
              ),
            ),
          ],
        ),
      ),
    ));
  }

  void _selectBirthday() async {
    updateDate(date) {
      setState(() => _pickedDate = date);
    }

    var now = DateTime.now();
    var minimumYear = 1900;
    if (Platform.isIOS) {
      showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) => Container(
                height: _kPickerSheetHeight,
                padding: const EdgeInsets.only(top: 6.0),
                color: CupertinoColors.white,
                child: DefaultTextStyle(
                  style: const TextStyle(
                    color: CupertinoColors.black,
                    fontSize: 22.0,
                  ),
                  child: GestureDetector(
                    // Blocks taps from propagating to the modal sheet and popping.
                    onTap: () {},
                    child: SafeArea(
                      top: false,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: now,
                        maximumDate: now,
                        minimumYear: minimumYear,
                        maximumYear: now.year,
                        onDateTimeChanged: updateDate,
                      ),
                    ),
                  ),
                ),
              ));
    } else {
      DateTime? result = await showDatePicker(
          context: context,
          selectableDayPredicate: (DateTime val) =>
              val.year > now.year && val.month > now.month && val.day > now.day
                  ? false
                  : true,
          initialDate: now,
          firstDate: DateTime(minimumYear),
          lastDate: now);

      updateDate(result);
    }
  }

  Widget dateItem(String text) {
    const side = BorderSide(color: Colors.grey, width: 0.5);
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(3.0)),
          border: Border(top: side, right: side, bottom: side, left: side)),
      child: Text(
        text,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _getMonth() {
    return DateFormat('MMMM').format(_pickedDate!);
  }

  String _getDay() {
    return DateFormat('dd').format(_pickedDate!);
  }

  String _getYear() {
    return DateFormat('yyyy').format(_pickedDate!);
  }

  void _onAuthorize() {
    String date = DateFormat('yyyy-MM-dd').format(_pickedDate!);
    Navigator.of(context).pop(date);
  }
}

class CardInputWidget extends StatefulWidget {
  final PaymentCard? card;

  const CardInputWidget(this.card);

  @override
  _CardInputWidgetState createState() {
    return _CardInputWidgetState();
  }
}

class _CardInputWidgetState extends BaseState<CardInputWidget> {
  @override
  void initState() {
    super.initState();
    confirmationMessage = 'Do you want to cancel card input?';
  }

  @override
  Widget buildChild(BuildContext context) {
    return CustomAlertDialog(
      content: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              const Text(
                'Please, provide valid card details.',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 35.0,
              ),
              CardInput(
                buttonText: 'Continue',
                card: widget.card,
                onValidated: _onCardValidated,
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                padding: const EdgeInsets.only(top: 10.0),
                child: WhiteButton(
                  onPressed: onCancelPress,
                  text: 'Cancel',
                  flat: true,
                  bold: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onCardValidated(PaymentCard? card) {
    Navigator.pop(context, card);
  }
}

/// This is a modification of [AlertDialog]. A lot of modifications was made. The goal is
/// to retain the dialog feel and look while adding the close IconButton
class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    Key? key,
    this.title,
    this.titlePadding,
    this.onCancelPress,
    this.contentPadding = const EdgeInsets.symmetric(vertical: 10.0),
    this.expanded = false,
    this.fullscreen = false,
    required this.content,
  }) : super(key: key);

  final Widget? title;
  final EdgeInsetsGeometry? titlePadding;
  final Widget content;
  final EdgeInsetsGeometry contentPadding;
  final VoidCallback? onCancelPress;
  final bool expanded;
  final bool fullscreen;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];

    if (title != null && titlePadding != null) {
      children.add(Padding(
        padding: titlePadding!,
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.headline6!,
          child: Semantics(child: title, namesRoute: true),
        ),
      ));
    }

    children.add(Flexible(
      child: Padding(
        padding: contentPadding,
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.subtitle1!,
          child: content,
        ),
      ),
    ));

    return buildContent(context, children);
  }

  Widget buildContent(context, List<Widget> children) {
    Widget widget;
    if (fullscreen) {
      widget = Material(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.grey,
        child: Container(
            child: onCancelPress == null
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 20.0,
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: children),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: onCancelPress,
                          color: Colors.black54,
                          padding: const EdgeInsets.all(15.0),
                          iconSize: 30.0,
                        ),
                      ),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          children: children,
                        ),
                      ))
                    ],
                  )),
      );
    } else {
      var body = Material(
        type: MaterialType.card,
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      );
      var child = IntrinsicWidth(
        child: onCancelPress == null
            ? body
            : Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(10.0),
                    child: IconButton(
                        highlightColor: Colors.white54,
                        splashColor: Colors.white54,
                        color: Colors.white,
                        iconSize: 30.0,
                        padding: const EdgeInsets.all(3.0),
                        icon: const Icon(
                          Icons.cancel,
                        ),
                        onPressed: onCancelPress),
                  ),
                  Flexible(child: body),
                ],
              ),
      );
      widget = CustomDialog(child: child, expanded: expanded);
    }
    return widget;
  }
}

/// This is a modification of [Dialog]. The only modification is increasing the
/// elevation and changing the Material type.
class CustomDialog extends StatelessWidget {
  const CustomDialog({
    Key? key,
    required this.child,
    required this.expanded,
    this.insetAnimationDuration = const Duration(milliseconds: 100),
    this.insetAnimationCurve = Curves.decelerate,
  }) : super(key: key);

  final Widget child;
  final Duration insetAnimationDuration;
  final Curve insetAnimationCurve;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets +
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      duration: insetAnimationDuration,
      curve: insetAnimationCurve,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: expanded
                    ? math.min(
                        (MediaQuery.of(context).size.width - 40.0), 332.0)
                    : 280.0),
            child: Material(
              elevation: 50.0,
              type: MaterialType.transparency,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class CardInput extends StatefulWidget {
  final String buttonText;
  final PaymentCard? card;
  final ValueChanged<PaymentCard?> onValidated;

  const CardInput({
    Key? key,
    required this.buttonText,
    required this.card,
    required this.onValidated,
  }) : super(key: key);

  @override
  _CardInputState createState() => _CardInputState(card);
}

class _CardInputState extends State<CardInput> {
  var _formKey = GlobalKey<FormState>();
  final PaymentCard? _card;
  var _autoValidate = AutovalidateMode.disabled;
  late TextEditingController numberController;
  bool _validated = false;

  _CardInputState(this._card);

  @override
  void initState() {
    super.initState();
    numberController = TextEditingController();
    numberController.addListener(_getCardTypeFrmNumber);
    if (_card?.number != null) {
      numberController.text = Utils.addSpaces(_card!.number!);
    }
  }

  @override
  void dispose() {
    super.dispose();
    numberController.removeListener(_getCardTypeFrmNumber);
    numberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: _autoValidate,
      key: _formKey,
      child: Column(
        children: <Widget>[
          NumberField(
            key: const Key("CardNumberKey"),
            controller: numberController,
            card: _card,
            onSaved: (String? value) =>
                _card!.number = CardUtils.getCleanedNumber(value),
            suffix: getCardIcon(),
          ),
          const SizedBox(
            height: 15.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: DateField(
                  key: const ValueKey("ExpiryKey"),
                  card: _card,
                  onSaved: (value) {
                    List<int> expiryDate = CardUtils.getExpiryDate(value);
                    _card!.expiryMonth = expiryDate[0];
                    _card!.expiryYear = expiryDate[1];
                  },
                ),
              ),
              const SizedBox(width: 15.0),
              Flexible(
                  child: CVCField(
                key: const Key("CVVKey"),
                card: _card,
                onSaved: (value) {
                  _card!.cvc = CardUtils.getCleanedNumber(value);
                },
              )),
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          AccentButton(
              key: const Key("PayButton"),
              onPressed: _validateInputs,
              text: widget.buttonText,
              showProgress: _validated),
        ],
      ),
    );
  }

  void _getCardTypeFrmNumber() {
    String input = CardUtils.getCleanedNumber(numberController.text);
    String cardType = _card!.getTypeForIIN(input);
    setState(() {
      _card!.type = cardType;
    });
  }

  void _validateInputs() {
    FocusScope.of(context).requestFocus(FocusNode());
    final FormState form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      widget.onValidated(_card);
      if (mounted) {
        setState(() => _validated = true);
      }
    } else {
      setState(() => _autoValidate = AutovalidateMode.always);
    }
  }

  Widget getCardIcon() {
    String img = "";
    var defaultIcon = Icon(
      Icons.credit_card,
      key: const Key("DefaultIssuerIcon"),
      size: 15.0,
      color: Colors.grey[600],
    );
    if (_card != null) {
      switch (_card!.type) {
        case CardType.masterCard:
          img = 'mastercard.png';
          break;
        case CardType.visa:
          img = 'visa.png';
          break;
        case CardType.verve:
          img = 'verve.png';
          break;
        case CardType.americanExpress:
          img = 'american_express.png';
          break;
        case CardType.discover:
          img = 'discover.png';
          break;
        case CardType.dinersClub:
          img = 'dinners_club.png';
          break;
        case CardType.jcb:
          img = 'jcb.png';
          break;
      }
    }
    Widget widget;
    if (img.isNotEmpty) {
      widget = Image.asset(
        'assets/images/$img',
        key: const Key("IssuerIcon"),
        height: 15,
        width: 30,
        package: 'flutter_paystack',
      );
    } else {
      widget = defaultIcon;
    }
    return widget;
  }
}

class WhiteButton extends _BaseButton {
  final bool flat;
  @override
  final IconData? iconData;
  final bool bold;

  WhiteButton({
    required VoidCallback? onPressed,
    String? text,
    Widget? child,
    this.flat = false,
    this.bold = true,
    this.iconData,
  }) : super(
          onPressed: onPressed,
          showProgress: false,
          text: text,
          child: child,
          iconData: iconData,
          textStyle: TextStyle(
              fontSize: 14.0,
              color: Colors.black87.withOpacity(0.8),
              fontWeight: bold ? FontWeight.bold : FontWeight.normal),
          color: Colors.white,
          borderSide: flat
              ? BorderSide.none
              : const BorderSide(color: Colors.grey, width: 0.5),
        );
}

class AccentButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool showProgress;

  const AccentButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.showProgress = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _BaseButton(
      onPressed: onPressed,
      showProgress: showProgress,
      color: Theme.of(context).accentColor,
      borderSide: BorderSide.none,
      textStyle: const TextStyle(
          fontSize: 14.0, color: Colors.white, fontWeight: FontWeight.bold),
      text: text,
    );
  }
}

class _BaseButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? text;
  final bool showProgress;
  final TextStyle textStyle;
  final Color color;
  final BorderSide borderSide;
  final IconData? iconData;
  final Widget? child;

  const _BaseButton({
    required this.onPressed,
    required this.showProgress,
    required this.text,
    required this.textStyle,
    required this.color,
    required this.borderSide,
    this.iconData,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(5.0));
    var textWidget;
    if (text != null) {
      textWidget = Text(
        text!,
        textAlign: TextAlign.center,
        style: textStyle,
      );
    }
    return Container(
        width: double.infinity,
        height: 50.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: color,
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: TextButton(
              onPressed: showProgress ? null : onPressed,
              child: showProgress
                  ? Container(
                      width: 20.0,
                      height: 20.0,
                      child: Theme(
                          data: Theme.of(context)
                              .copyWith(accentColor: Colors.white),
                          child: const CircularProgressIndicator(
                            strokeWidth: 2.0,
                          )),
                    )
                  : iconData == null
                      ? child == null
                          ? textWidget
                          : child!
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              iconData,
                              color: textStyle.color!.withOpacity(0.5),
                            ),
                            const SizedBox(width: 2.0),
                            textWidget,
                          ],
                        )),
        ));
  }
}

class CVCField extends BaseTextField {
  CVCField({
    Key? key,
    required PaymentCard? card,
    required FormFieldSetter<String> onSaved,
  }) : super(
          key: key,
          labelText: 'CVV',
          hintText: '123',
          onSaved: onSaved,
          validator: (String? value) => validateCVC(value, card),
          initialValue:
              card != null && card.cvc != null ? card.cvc.toString() : null,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(4),
          ],
        );

  static String? validateCVC(String? value, PaymentCard? card) {
    if (value == null || value.trim().isEmpty) return Strings.invalidCVC;

    return card!.validCVC(value) ? null : Strings.invalidCVC;
  }
}

class DateField extends BaseTextField {
  DateField({
    Key? key,
    required PaymentCard? card,
    required FormFieldSetter<String> onSaved,
  }) : super(
          key: key,
          labelText: 'CARD EXPIRY',
          hintText: 'MM/YY',
          validator: validateDate,
          initialValue: _getInitialExpiryMonth(card),
          onSaved: onSaved,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(4),
            CardMonthInputFormatter()
          ],
        );

  static String? _getInitialExpiryMonth(PaymentCard? card) {
    if (card == null) {
      return null;
    }
    if (card.expiryYear == null ||
        card.expiryMonth == null ||
        card.expiryYear == 0 ||
        card.expiryMonth == 0) {
      return null;
    } else {
      return '${card.expiryMonth}/${card.expiryYear}';
    }
  }

  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return Strings.invalidExpiry;
    }

    int year;
    int month;
    // The value contains a forward slash if the month and year has been
    // entered.
    if (value.contains(RegExp(r'(/)'))) {
      final date = CardUtils.getExpiryDate(value);
      month = date[0];
      year = date[1];
    } else {
      // Only the month was entered
      month = int.parse(value.substring(0, (value.length)));
      year = -1; // Lets use an invalid year intentionally
    }

    if (!CardUtils.isNotExpired(year, month)) {
      return Strings.invalidExpiry;
    }
    return null;
  }
}

class NumberField extends BaseTextField {
  NumberField(
      {Key? key,
      required PaymentCard? card,
      required TextEditingController? controller,
      required FormFieldSetter<String> onSaved,
      required Widget suffix})
      : super(
          key: key,
          labelText: 'CARD NUMBER',
          hintText: '0000 0000 0000 0000',
          controller: controller,
          onSaved: onSaved,
          suffix: suffix,
          validator: (String? value) => validateCardNum(value, card),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(19),
            CardNumberInputFormatter()
          ],
        );

  static String? validateCardNum(String? input, PaymentCard? card) {
    if (input == null || input.isEmpty) {
      return Strings.invalidNumber;
    }

    input = CardUtils.getCleanedNumber(input);

    return card!.validNumber(input) ? null : Strings.invalidNumber;
  }
}

class CardMonthInputFormatter extends TextInputFormatter {
  String? previousText;
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;

      if (nonZeroIndex % 2 == 0 &&
          ((!_isDeletion(previousText, text) && nonZeroIndex != 4) ||
              (nonZeroIndex != text.length))) {
        buffer.write('/');
      }
    }

    previousText = text;
    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: string.length));
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var string = Utils.addSpaces(text);
    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: string.length));
  }
}

bool _isDeletion(String? prevText, String newText) {
  if (prevText == null) {
    return false;
  }

  return prevText.length > newText.length;
}

class BaseTextField extends StatelessWidget {
  final Widget? suffix;
  final String? labelText;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final String? initialValue;

  const BaseTextField({
    Key? key,
    this.suffix,
    this.labelText,
    this.hintText,
    this.inputFormatters,
    this.onSaved,
    this.validator,
    this.controller,
    this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      inputFormatters: inputFormatters,
      onSaved: onSaved,
      validator: validator,
      maxLines: 1,
      initialValue: initialValue,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 14.0),
        suffixIcon: suffix == null
            ? null
            : Padding(
                padding: const EdgeInsetsDirectional.only(end: 12.0),
                child: suffix,
              ),
        errorStyle: const TextStyle(fontSize: 12.0),
        errorMaxLines: 3,
        isDense: true,
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 0.5)),
        focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).accentColor, width: 1.0)),
        hintText: hintText,
      ),
    );
  }
}

class OtpWidget extends StatefulWidget {
  final String? message;

  const OtpWidget({required this.message});

  @override
  _OtpWidgetState createState() => _OtpWidgetState();
}

class _OtpWidgetState extends BaseState<OtpWidget> {
  var _formKey = GlobalKey<FormState>();
  var _autoValidate = AutovalidateMode.disabled;
  String? _otp;
  var heightBox = const SizedBox(height: 20.0);

  @override
  Widget buildChild(BuildContext context) {
    return CustomAlertDialog(
      content: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Form(
            key: _formKey,
            autovalidateMode: _autoValidate,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/images/otp.png',
                    width: 30.0, package: 'flutter_paystack'),
                heightBox,
                Text(
                  widget.message!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                    fontSize: 15.0,
                  ),
                ),
                heightBox,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: OtpField(
                    onSaved: (String? value) => _otp = value,
                    borderColor: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                heightBox,
                AccentButton(
                  onPressed: _validateInputs,
                  text: 'Authorize',
                ),
                heightBox,
                WhiteButton(
                  onPressed: onCancelPress,
                  text: 'Cancel',
                  flat: true,
                  bold: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _validateInputs() {
    FocusScope.of(context).requestFocus(FocusNode());
    final FormState form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      Navigator.of(context).pop(_otp);
    } else {
      setState(() {
        _autoValidate = AutovalidateMode.disabled;
      });
    }
  }
}

class OtpField extends TextFormField {
  OtpField({FormFieldSetter<String>? onSaved, required Color borderColor})
      : super(
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.none,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontSize: 25.0,
          ),
          autofocus: true,
          maxLines: 1,
          onSaved: onSaved,
          validator: (String? value) => value!.isEmpty ? 'Enter OTP' : null,
          obscureText: false,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            isDense: true,
            hintText: 'ENTER',
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14.0),
            contentPadding: const EdgeInsets.all(10.0),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 0.5)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor, width: 1.0)),
          ),
        );
}

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  bool isProcessing = false;
  String confirmationMessage = 'Do you want to cancel payment?';
  bool alwaysPop = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context);

  Future<bool> _onWillPop() async {
    if (isProcessing) {
      return false;
    }

    var returnValue = getPopReturnValue();
    if (alwaysPop ||
        (returnValue != null &&
            (returnValue is CheckoutResponse && returnValue.status == true))) {
      Navigator.of(context).pop(returnValue);
      return false;
    }

    var text = Text(confirmationMessage);

    var dialog = Platform.isIOS
        ? CupertinoAlertDialog(
            content: text,
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text('Yes'),
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.pop(context, true); // Returning true to
                  // _onWillPop will pop again.
                },
              ),
              CupertinoDialogAction(
                child: const Text('No'),
                isDefaultAction: true,
                onPressed: () {
                  Navigator.pop(context,
                      false); // Pops the confirmation dialog but not the page.
                },
              ),
            ],
          )
        : AlertDialog(
            content: text,
            actions: <Widget>[
              TextButton(
                  child: const Text('NO'),
                  onPressed: () {
                    Navigator.of(context).pop(
                        false); // Pops the confirmation dialog but not the page.
                  }),
              TextButton(
                  child: const Text('YES'),
                  onPressed: () {
                    Navigator.of(context).pop(
                        true); // Returning true to _onWillPop will pop again.
                  })
            ],
          );

    bool exit = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) => dialog,
        ) ??
        false;

    if (exit) {
      Navigator.of(context).pop(returnValue);
    }
    return false;
  }

  void onCancelPress() async {
    bool close = await _onWillPop();
    if (close) {
      Navigator.of(context).pop(getPopReturnValue());
    }
  }

  getPopReturnValue() {
    return null;
  }
}

class PinField extends StatefulWidget {
  final ValueChanged<String>? onSaved;
  final int pinLength;

  const PinField({this.onSaved, this.pinLength = 4});

  @override
  State createState() => _PinFieldState();
}

class _PinFieldState extends State<PinField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          fontSize: 25.0,
          letterSpacing: 15.0,
        ),
        autofocus: true,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(widget.pinLength),
        ],
        obscureText: true,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          isDense: true,
          hintText: 'ENTER PIN',
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 14.0,
            letterSpacing: 0,
          ),
          contentPadding: const EdgeInsets.all(10.0),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 0.5)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.secondary, width: 1.0)),
        ),
        onChanged: (String value) {
          if (value.length == widget.pinLength) {
            widget.onSaved!(value);
          }
        },
      ),
    );
  }
}

class CheckoutResponse {
  /// A user readable message. If the transaction was not successful, this returns the
  /// cause of the error.
  String message;

  /// The card used for the payment. Will be null if the customer didn't use card
  /// payment
  PaymentCard? card;

  /// The bank account used for the payment. Will be null if the customer didn't use
  /// bank account as a means of  payment
  BankAccount? account;

  /// Transaction reference. Might be null for failed transaction transactions
  String? reference;

  /// The status of the transaction. A successful response returns true and false
  /// otherwise
  bool status;

  /// The means of payment. It may return [CheckoutMethod.bank] or [CheckoutMethod.card]
  CheckoutMethod method;

  /// If the transaction should be verified. See https://developers.paystack.co/v2.0/reference#verify-transaction.
  /// This is usually false for transactions that didn't reach Paystack before terminating
  ///
  /// It might return true regardless whether a transaction fails or not.
  bool verify;

  CheckoutResponse.defaults()
      : message = Strings.userTerminated,
        status = false,
        verify = false,
        method = CheckoutMethod.selectable;

  CheckoutResponse(
      {required this.message,
      required this.reference,
      required this.status,
      required this.method,
      required this.verify,
      this.card,
      this.account})
      : assert(card != null || account != null);

  @override
  String toString() {
    return 'CheckoutResponse{message: $message, card: $card, account: $account, reference: $reference, status: $status, method: $method, verify: $verify}';
  }
}

class CardUtils {
  static bool isWholeNumberPositive(String? value) {
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
  static bool hasMonthPassed(int? year, int? month) {
    if (year == null || month == null) return true;
    var now = DateTime.now();
    // The month has passed if:
    // 1. The year is in the past. In that case, we just assume that the month
    // has passed
    // 2. Card's month (plus another month) is more than current month.
    return hasYearPassed(year) ||
        convertYearTo4Digits(year) == now.year && (month < now.month + 1);
  }

  static bool isValidMonth(int? month) {
    return month != null && month > 0 && month < 13;
  }

  /// Returns true if [year] is has passed.
  /// It calls [convertYearTo4Digits] on [year] so two digits year will be
  /// prepended with  "20":
  ///
  ///     var v = hasYearPassed(94);
  ///     print(v); // false because 94 is converted to 2094, and 2094 is in the future
  static bool hasYearPassed(int? year) {
    int fourDigitsYear = convertYearTo4Digits(year)!;
    var now = DateTime.now();
    // The year has passed if the year we are currently is more than card's year
    return fourDigitsYear < now.year;
  }

  static bool isNotExpired(int? year, int? month) {
    if ((year == null || month == null) || (month > 12 || year > 2999)) {
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
  static int? convertYearTo4Digits(int? year) {
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
  static String concatenateCardFields(PaymentCard? card) {
    if (card == null) {
      throw CardException("Card cannot be null");
    }

    String? number = StringUtils.nullify(card.number);
    String? cvc = StringUtils.nullify(card.cvc);
    int expiryMonth = card.expiryMonth ?? 0;
    int expiryYear = card.expiryYear ?? 0;

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
  static List<int> getExpiryDate(String? value) {
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

/// The class for the Payment Card model. Has utility methods for validating
/// the card.
class PaymentCard {
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
  int? expiryMonth = 0;

  /// Expiry year
  int? expiryYear = 0;

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
  String getTypeForIIN(String? cardNumber) {
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

  PaymentCard(
      {required String? number,
      required String? cvc,
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

  PaymentCard.empty() {
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
        expiryMonth != null &&
        expiryYear != null &&
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
    return 'PaymentCard{_cvc: $_cvc, expiryMonth: $expiryMonth, expiryYear: '
        '$expiryYear, _type: $_type, _last4Digits: $_last4Digits , _number: '
        '$_number}';
  }
}

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

  bool hasStartingMatch(String? cardNumber);

  @override
  String toString();
}

class _Visa extends CardType {
  @override
  bool hasFullMatch(String? cardNumber) {
    return CardType.fullPatternVisa.hasMatch(cardNumber!);
  }

  @override
  bool hasStartingMatch(String? cardNumber) {
    return cardNumber!.startsWith(CardType.startingPatternVisa);
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
  bool hasStartingMatch(String? cardNumber) {
    return cardNumber!.startsWith(CardType.startingPatternMasterCard);
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
  bool hasStartingMatch(String? cardNumber) {
    return cardNumber!.startsWith(CardType.startingPatternAmericanExpress);
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
  bool hasStartingMatch(String? cardNumber) {
    return cardNumber!.startsWith(CardType.startingPatternDinersClub);
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
  bool hasStartingMatch(String? cardNumber) {
    return cardNumber!.startsWith(CardType.startingPatternDiscover);
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
  bool hasStartingMatch(String? cardNumber) {
    return cardNumber!.startsWith(CardType.startingPatternJCB);
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
  bool hasStartingMatch(String? cardNumber) {
    return cardNumber!.startsWith(CardType.startingPatternVerve);
  }

  @override
  String toString() {
    return CardType.verve;
  }
}

class Charge {
  PaymentCard? card;

  /// The email of the customer
  String? email;
  BankAccount? _account;

  /// Amount to pay in base currency. Must be a valid positive number
  int amount = 0;
  Map<String, dynamic>? _metadata;
  List<Map<String, dynamic>>? _customFields;
  bool _hasMeta = false;
  Map<String, String?>? _additionalParameters;

  /// The locale used for formatting amount in the UI prompt. Defaults to [Strings.nigerianLocale]
  String? locale;
  String? accessCode;
  String? plan;
  String? reference;

  /// ISO 4217 payment currency code (e.g USD). Defaults to [Strings.ngn].
  ///
  /// If you're setting this value, also set [locale] for better formatting.
  String? currency;
  int? transactionCharge;

  /// Who bears Paystack charges? [Bearer.Account] or [Bearer.SubAccount]
  Bearer? bearer;

  String? subAccount;

  Charge() {
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

  Map<String, String?>? get additionalParameters => _additionalParameters;

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

class Utils {
  static const MethodChannel methodChannel =
      MethodChannel('plugins.wilburt/flutter_paystack');

  static String getKeyErrorMsg(String keyType) {
    return 'Invalid $keyType key. You must use a valid $keyType key. Ensure that you '
        'have set a $keyType key. Check http://paystack.co for more';
  }

  static NumberFormat? _currencyFormatter;

  static setCurrencyFormatter(String? currency, String? locale) =>
      _currencyFormatter =
          NumberFormat.currency(locale: locale, name: '$currency\u{0020}');

  static String formatAmount(num amountInBase) {
    if (_currencyFormatter == null) throw "Currency formatter not initialized.";
    return _currencyFormatter!.format((amountInBase / 100));
  }

  /// Add double spaces after every 4th character
  static String addSpaces(String text) {
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write('  '); // Add double spaces.
      }
    }
    return buffer.toString();
  }
}

class StringUtils {
  static bool isEmpty(String? value) {
    return value == null || value.length < 1 || value.toLowerCase() == "null";
  }

  static bool isValidEmail(String? email) {
    if (isEmpty(email)) return false;
    RegExp regExp = RegExp(_emailRegex);
    return regExp.hasMatch(email!);
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

/// Holds data that's different on Android and iOS
class PlatformInfo {
  final String userAgent;
  final String paystackBuild;
  final String deviceId;

  static Future<PlatformInfo> fromMethodChannel(MethodChannel channel) async {
    // ignore: todo
    // TODO: Update for every new versions.
    //  And there should a better way to fucking do this
    const pluginVersion = "1.0.5";
    final platform = platforminfo.Platform.instance.operatingSystem;
    //final platform = Platform.operatingSystem;
    var mobilephoneinfo;
    // deviceInfo() async {
    //   Platform.isIOS
    //       ? mobilephoneinfo = await DeviceInfoPlugin().iosInfo
    //       : mobilephoneinfo = await DeviceInfoPlugin().androidInfo;
    // }

    String userAgent = "${platform}_Paystack_$pluginVersion";
    String deviceId = (Platform.isIOS || Platform.isAndroid)
        ? mobilephoneinfo.toString()
        : "FLUTTER_CLIENT";
    //await channel.invokeMethod('getDeviceId') ?? "";
    return PlatformInfo._(
      userAgent: userAgent,
      paystackBuild: pluginVersion,
      deviceId: deviceId,
    );
  }

  const PlatformInfo._({
    required String userAgent,
    required String paystackBuild,
    required String deviceId,
  })  : userAgent = userAgent,
        paystackBuild = paystackBuild,
        deviceId = deviceId;

  @override
  String toString() {
    return '[userAgent = $userAgent, paystackBuild = $paystackBuild, deviceId = $deviceId]';
  }
}

abstract class CardServiceContract {
  Future<TransactionApiResponse> chargeCard(Map<String, String?> fields);

  Future<TransactionApiResponse> validateCharge(Map<String, String?> fields);

  Future<TransactionApiResponse> reQueryTransaction(String? trans);
}

class CardService with BaseApiService implements CardServiceContract {
  @override
  Future<TransactionApiResponse> chargeCard(Map<String, String?> fields) async {
    var url = '$baseUrl/charge/mobile_charge';

    http.Response response =
        await http.post(url.toUri(), body: fields, headers: headers);
    var body = response.body;

    var statusCode = response.statusCode;

    switch (statusCode) {
      case HttpStatus.ok:
        Map<String, dynamic> responseBody = json.decode(body);
        return TransactionApiResponse.fromMap(responseBody);
      case HttpStatus.gatewayTimeout:
        throw ChargeException('Gateway timeout error');
      default:
        throw ChargeException(Strings.unKnownResponse);
    }
  }

  @override
  Future<TransactionApiResponse> validateCharge(
      Map<String, String?> fields) async {
    var url = '$baseUrl/charge/validate';

    http.Response response =
        await http.post(url.toUri(), body: fields, headers: headers);
    var body = response.body;

    var statusCode = response.statusCode;
    if (statusCode == HttpStatus.ok) {
      Map<String, dynamic> responseBody = json.decode(body);
      return TransactionApiResponse.fromMap(responseBody);
    } else {
      throw CardException('validate charge transaction failed with '
          'status code: $statusCode and response: $body');
    }
  }

  @override
  Future<TransactionApiResponse> reQueryTransaction(String? trans) async {
    var url = '$baseUrl/requery/$trans';

    http.Response response = await http.get(url.toUri(), headers: headers);
    var body = response.body;
    var statusCode = response.statusCode;
    if (statusCode == HttpStatus.ok) {
      Map<String, dynamic> responseBody = json.decode(body);
      return TransactionApiResponse.fromMap(responseBody);
    } else {
      throw ChargeException('requery transaction failed with status code: '
          '$statusCode and response: $body');
    }
  }
}

mixin BaseApiService {
  final Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
    HttpHeaders.userAgentHeader: PaystackPlugin.platformInfo.userAgent,
    HttpHeaders.acceptHeader: 'application/json',
    'X-Paystack-Build': PaystackPlugin.platformInfo.paystackBuild,
    'X-PAYSTACK-USER-AGENT':
        jsonEncode({'lang': Platform.isIOS ? 'objective-c' : 'kotlin'}),
    'bindings_version': PaystackPlugin.platformInfo.paystackBuild,
    'X-FLUTTER-USER-AGENT': PaystackPlugin.platformInfo.userAgent
  };
  final String baseUrl = 'https://standard.paystack.co';
}

abstract class BaseRequestBody {
  final fieldDevice = 'device';
  String? _device;

  BaseRequestBody() {
    _setDeviceId();
  }

  Map<String, String?> paramsMap();

  String? get device => _device;

  _setDeviceId() {
    String deviceId = PaystackPlugin.platformInfo.deviceId;
    _device = deviceId;
  }
}

class BankChargeRequestBody extends BaseRequestBody {
  String _accessCode;
  BankAccount _account;
  String? _birthday;
  String? _token;
  String? transactionId;

  BankChargeRequestBody(Charge charge)
      : _accessCode = charge.accessCode!,
        _account = charge.account!;

  Map<String, String?> tokenParams() => {fieldDevice: device, 'token': _token};

  @override
  Map<String, String?> paramsMap() {
    var map = {fieldDevice: device, 'account_number': account.number};
    map['birthday'] = _birthday;
    return map..removeWhere((key, value) => value == null || value.isEmpty);
  }

  set token(String value) => _token = value;

  set birthday(String value) => _birthday = value;

  BankAccount get account => _account;

  String get accessCode => _accessCode;
}

class TransactionApiResponse extends ApiResponse {
  String? reference;
  String? trans;
  String? auth;
  String? otpMessage;
  String? displayText;

  TransactionApiResponse.unknownServerResponse() {
    status = '0';
    message = 'Unknown server response';
  }

  TransactionApiResponse.fromMap(Map<String, dynamic> map) {
    reference = map['reference'];
    if (map.containsKey('trans')) {
      trans = map['trans'];
    } else if (map.containsKey('id')) {
      trans = map['id'].toString();
    }
    auth = map['auth'];
    otpMessage = map['otpmessage'];
    status = map['status'];
    message = map['message'];
    displayText =
        !map.containsKey('display_text') ? message : map['display_text'];

    if (status != null) {
      status = status!.toLowerCase();
    }

    if (auth != null) {
      auth = auth!.toLowerCase();
    }
  }

  TransactionApiResponse.fromAccessCodeVerification(Map<String, dynamic> map) {
    var data = map['data'];
    trans = data['id'].toString();
    status = data['transaction_status'];
    message = map['message'];
  }

  bool hasValidReferenceAndTrans() {
    return (reference != null) && (trans != null);
  }

  bool hasValidUrl() {
    if (otpMessage == null || otpMessage!.length == 0) {
      return false;
    }

    return RegExp(r'^https?://', caseSensitive: false).hasMatch(otpMessage!);
  }

  bool hasValidOtpMessage() {
    return otpMessage != null;
  }

  bool hasValidAuth() {
    return auth != null;
  }

  @override
  String toString() {
    return 'TransactionApiResponse{reference: $reference, trans: $trans, auth: $auth, '
        'otpMessage: $otpMessage, displayText: $displayText, message: $message, '
        'status: $status}';
  }
}

class ApiResponse {
  String? status;
  String? message;
}

abstract class BankServiceContract {
  Future<String?> getTransactionId(String? accessCode);

  Future<TransactionApiResponse> chargeBank(BankChargeRequestBody? requestBody);

  Future<TransactionApiResponse> validateToken(
      BankChargeRequestBody? requestBody, Map<String, String?> fields);

  Future<List<Bank>?>? fetchSupportedBanks();
}

class Bank {
  String? name;
  int? id;

  Bank(this.name, this.id);

  @override
  String toString() {
    return 'Bank{name: $name, id: $id}';
  }
}

class BankAccount {
  Bank? bank;
  String? number;

  BankAccount(this.bank, this.number);

  bool isValid() {
    if (number == null || number!.length < 10) {
      return false;
    }

    if (bank == null || bank!.id == null) {
      return false;
    }
    return true;
  }

  @override
  String toString() {
    return 'BankAccount{bank: $bank, number: $number}';
  }
}

class PaystackException implements Exception {
  String? message;

  PaystackException(this.message);

  @override
  String toString() {
    if (message == null) return Strings.unKnownError;
    return message!;
  }
}

class AuthenticationException extends PaystackException {
  AuthenticationException(String message) : super(message);
}

class CardException extends PaystackException {
  CardException(String message) : super(message);
}

class ChargeException extends PaystackException {
  ChargeException(String? message) : super(message);
}

class InvalidAmountException extends PaystackException {
  int amount = 0;

  InvalidAmountException(this.amount)
      : super('$amount is not a valid '
            'amount. only positive non-zero values are allowed.');
}

class InvalidEmailException extends PaystackException {
  String? email;

  InvalidEmailException(this.email) : super('$email  is not a valid email');
}

class PaystackSdkNotInitializedException extends PaystackException {
  PaystackSdkNotInitializedException(String message) : super(message);
}

class ProcessingException extends ChargeException {
  ProcessingException()
      : super(
            'A transaction is currently processing, please wait till it concludes before attempting a new charge.');
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

// class Bank {
//   String? name;
//   int? id;

//   Bank(this.name, this.id);

//   @override
//   String toString() {
//     return 'Bank{name: $name, id: $id}';
//   }
// }

// class BankAccount {
//   Bank? bank;
//   String? number;

//   BankAccount(this.bank, this.number);

//   bool isValid() {
//     if (number == null || number!.length < 10) {
//       return false;
//     }

//     if (bank == null || bank!.id == null) {
//       return false;
//     }
//     return true;
//   }

//   @override
//   String toString() {
//     return 'BankAccount{bank: $bank, number: $number}';
//   }
// }

extension MyString on String {
  Uri toUri() => Uri.parse(this);
}

// class BankService with BaseApiService implements BankServiceContract {
//   @override
//   Future<String?> getTransactionId(String? accessCode) async {
//     var url =
//         'https://api.paystack.co/transaction/verify_access_code/$accessCode';
//     try {
//       http.Response response = await http.get(url.toUri());
//       Map responseBody = jsonDecode(response.body);
//       bool? status = responseBody['status'];
//       if (response.statusCode == HttpStatus.ok && status!) {
//         return responseBody['data']['id'].toString();
//       }
//     } catch (e) {}
//     return null;
//   }

//   @override
//   Future<TransactionApiResponse> chargeBank(
//       BankChargeRequestBody? requestBody) async {
//     var url =
//         '$baseUrl/bank/charge_account/${requestBody!.account.bank!.id}/${requestBody.transactionId}';
//     return _getChargeFuture(url, fields: requestBody.paramsMap());
//   }

//   @override
//   Future<TransactionApiResponse> validateToken(
//       BankChargeRequestBody? requestBody, Map<String, String?> fields) async {
//     var url =
//         '$baseUrl/bank/validate_token/${requestBody!.account.bank!.id}/${requestBody.transactionId}';
//     return _getChargeFuture(url, fields: fields);
//   }

//   Future<TransactionApiResponse> _getChargeFuture(String url,
//       {var fields}) async {
//     http.Response response =
//         await http.post(url.toUri(), body: fields, headers: headers);
//     return _getResponseFuture(response);
//   }

//   TransactionApiResponse _getResponseFuture(http.Response response) {
//     var body = response.body;

//     Map<String, dynamic>? responseBody = json.decode(body);

//     var statusCode = response.statusCode;

//     if (statusCode == HttpStatus.ok) {
//       return TransactionApiResponse.fromMap(responseBody!);
//     } else {
//       throw new ChargeException(Strings.unKnownResponse);
//     }
//   }

//   @override
//   Future<List<Bank>?> fetchSupportedBanks() async {
//     return banksMemo!.runOnce(() async {
//       return await _fetchSupportedBanks();
//     });
//   }

//   Future<List<Bank>?> _fetchSupportedBanks() async {
//     const url =
//         'https://api.paystack.co/bank?gateway=emandate&pay_with_bank=true';
//     try {
//       http.Response response = await http.get(url.toUri());
//       Map<String, dynamic> body = json.decode(response.body);
//       var data = body['data'];
//       List<Bank> banks = [];
//       for (var bank in data) {
//         banks.add(new Bank(bank['name'], bank['id']));
//       }
//       return banks;
//     } catch (e) {}
//     return null;
//   }
// }

//AsyncMemoizer<List<Bank>?>? banksMemo = new AsyncMemoizer<List<Bank>?>();

class PaystackPlugin {
  bool _sdkInitialized = false;
  String _publicKey = "";
  static late PlatformInfo platformInfo;

  /// Initialize the Paystack object. It should be called as early as possible
  /// (preferably in initState() of the Widget.
  ///
  /// [publicKey] - your paystack public key. This is mandatory
  ///
  /// use [checkout] and you want this plugin to initialize the transaction for you.
  /// Please check [checkout] for more information
  ///
  initialize({required String publicKey}) async {
    assert(() {
      if (publicKey.isEmpty) {
        throw PaystackException('publicKey cannot be null or empty');
      }
      return true;
    }());

    if (sdkInitialized) return;

    _publicKey = publicKey;

    // Using cascade notation to build the platform specific info
    try {
      platformInfo = await PlatformInfo.fromMethodChannel(Utils.methodChannel);
      _sdkInitialized = true;
    } on PlatformException {
      rethrow;
    }
  }

  dispose() {
    _publicKey = "";
    _sdkInitialized = false;
  }

  bool get sdkInitialized => _sdkInitialized;

  String get publicKey {
    // Validate that the sdk has been initialized
    _validateSdkInitialized();
    return _publicKey;
  }

  void _performChecks() {
    //validate that sdk has been initialized
    _validateSdkInitialized();
    //check for null value, and length and starts with pk_
    if (_publicKey.isEmpty || !_publicKey.startsWith("pk_")) {
      throw AuthenticationException(Utils.getKeyErrorMsg('public'));
    }
  }

  /// Make payment by charging the user's card
  ///
  /// [context] - the widgets BuildContext
  ///
  /// [charge] - the charge object.

  Future<CheckoutResponse> chargeCard(BuildContext context,
      {required Charge charge}) {
    _performChecks();

    return _Paystack(publicKey).chargeCard(context: context, charge: charge);
  }

  /// Make payment using Paystack's checkout form. The plugin will handle the whole
  /// processes involved.
  ///
  /// [context] - the widget's BuildContext
  ///
  /// [charge] - the charge object.
  ///
  /// [method] - The payment method to use(card, bank). It defaults to
  /// [CheckoutMethod.selectable] to allow the user to select. For [CheckoutMethod.bank]
  ///  or [CheckoutMethod.selectable], it is
  /// required that you supply an access code to the [Charge] object passed to [charge].
  /// For [CheckoutMethod.card], though not recommended, passing a reference to the
  /// [Charge] object will do just fine.
  ///
  /// Notes:
  ///
  /// * You can also pass the [PaymentCard] object and we'll use it to prepopulate the
  /// card  fields if card payment is being used
  ///
  /// [fullscreen] - Whether to display the payment in a full screen dialog or not
  ///
  /// [logo] - The widget to display at the top left of the payment prompt.
  /// Defaults to an Image widget with Paystack's logo.
  ///
  /// [hideEmail] - Whether to hide the email from the user. When
  /// `false` and an email is passed to the [charge] object, the email
  /// will be displayed at the top right edge of the UI prompt. Defaults to
  /// `false`
  ///
  /// [hideAmount]  - Whether to hide the amount from the  payment prompt.
  /// When `false` the payment amount and currency is displayed at the
  /// top of payment prompt, just under the email. Also the payment
  /// call-to-action will display the amount, otherwise it will display
  /// "Continue". Defaults to `false`
  Future<CheckoutResponse> checkout(
    BuildContext context, {
    required Charge charge,
    CheckoutMethod method = CheckoutMethod.selectable,
    bool fullscreen = false,
    Widget? logo,
    bool hideEmail = false,
    bool hideAmount = false,
  }) async {
    return _Paystack(publicKey).checkout(
      context,
      charge: charge,
      method: method,
      fullscreen: fullscreen,
      logo: logo,
      hideAmount: hideAmount,
      hideEmail: hideEmail,
    );
  }

  _validateSdkInitialized() {
    if (!sdkInitialized) {
      throw PaystackSdkNotInitializedException(
          'Paystack SDK has not been initialized. The SDK has'
          ' to be initialized before use');
    }
  }
}

class _Paystack {
  final String publicKey;

  _Paystack(this.publicKey);

  Future<CheckoutResponse> chargeCard(
      {required BuildContext context, required Charge charge}) {
    return CardTransactionManager(
            service: CardService(),
            charge: charge,
            context: context,
            publicKey: publicKey)
        .chargeCard();
  }

  Future<CheckoutResponse> checkout(
    BuildContext context, {
    required Charge charge,
    required CheckoutMethod method,
    required bool fullscreen,
    bool hideEmail = false,
    bool hideAmount = false,
    Widget? logo,
  }) async {
    assert(() {
      _validateChargeAndKey(charge);
      switch (method) {
        case CheckoutMethod.card:
          if (charge.accessCode == null && charge.reference == null) {
            throw ChargeException(Strings.noAccessCodeReference);
          }
          break;
        case CheckoutMethod.bank:
        case CheckoutMethod.selectable:
          if (charge.accessCode == null) {
            throw ChargeException('Pass an accesscode');
          }
          break;
      }
      return true;
    }());

    CheckoutResponse? response = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => CheckoutWidget(
        publicKey: publicKey,
        bankService: BankService(),
        cardsService: CardService(),
        method: method,
        charge: charge,
        fullscreen: fullscreen,
        logo: logo,
        hideAmount: hideAmount,
        hideEmail: hideEmail,
      ),
    );
    return response ?? CheckoutResponse.defaults();
  }

  _validateChargeAndKey(Charge charge) {
    if (charge.amount.isNegative) {
      throw InvalidAmountException(charge.amount);
    }
    if (!StringUtils.isValidEmail(charge.email)) {
      throw InvalidEmailException(charge.email);
    }
  }
}

typedef OnTransactionChange<Transaction> = void Function(
    Transaction transaction);
typedef OnTransactionError<Object, Transaction> = void Function(
    Object e, Transaction transaction);

enum CheckoutMethod { card, bank, selectable }

class BankService with BaseApiService implements BankServiceContract {
  @override
  Future<String?> getTransactionId(String? accessCode) async {
    var url =
        'https://api.paystack.co/transaction/verify_access_code/$accessCode';
    try {
      http.Response response = await http.get(url.toUri());
      Map responseBody = jsonDecode(response.body);
      bool? status = responseBody['status'];
      if (response.statusCode == HttpStatus.ok && status!) {
        return responseBody['data']['id'].toString();
      }
    } catch (e) {}
    return null;
  }

  @override
  Future<TransactionApiResponse> chargeBank(
      BankChargeRequestBody? requestBody) async {
    var url =
        '$baseUrl/bank/charge_account/${requestBody!.account.bank!.id}/${requestBody.transactionId}';
    return _getChargeFuture(url, fields: requestBody.paramsMap());
  }

  @override
  Future<TransactionApiResponse> validateToken(
      BankChargeRequestBody? requestBody, Map<String, String?> fields) async {
    var url =
        '$baseUrl/bank/validate_token/${requestBody!.account.bank!.id}/${requestBody.transactionId}';
    return _getChargeFuture(url, fields: fields);
  }

  Future<TransactionApiResponse> _getChargeFuture(String url,
      {var fields}) async {
    http.Response response =
        await http.post(url.toUri(), body: fields, headers: headers);
    return _getResponseFuture(response);
  }

  TransactionApiResponse _getResponseFuture(http.Response response) {
    var body = response.body;

    Map<String, dynamic>? responseBody = json.decode(body);

    var statusCode = response.statusCode;

    if (statusCode == HttpStatus.ok) {
      return TransactionApiResponse.fromMap(responseBody!);
    } else {
      throw ChargeException(Strings.unKnownResponse);
    }
  }

  @override
  Future<List<Bank>?> fetchSupportedBanks() async {
    return banksMemo!.runOnce(() async {
      return await _fetchSupportedBanks();
    });
  }

  Future<List<Bank>?> _fetchSupportedBanks() async {
    const url =
        'https://api.paystack.co/bank?gateway=emandate&pay_with_bank=true';
    try {
      http.Response response = await http.get(url.toUri());
      Map<String, dynamic> body = json.decode(response.body);
      var data = body['data'];
      List<Bank> banks = [];
      for (var bank in data) {
        banks.add(Bank(bank['name'], bank['id']));
      }
      return banks;
    } catch (e) {}
    return null;
  }
}

AsyncMemoizer<List<Bank>?>? banksMemo = AsyncMemoizer<List<Bank>?>();
