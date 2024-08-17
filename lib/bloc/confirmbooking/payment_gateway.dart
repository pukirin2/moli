// import 'dart:convert';

// import 'package:moli/model/user/salon_user.dart';
// import 'package:moli/service/api_service.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:flutter_paypal/flutter_paypal.dart';
// // import 'package:flutter_paystack/flutter_paystack.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:flutterwave_standard/flutterwave.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:uuid/uuid.dart';

// String email = 'test@gmail.com';
// String address = 'Test Location';
// String pinCode = '395005';
// String city = 'TESTING';
// String countryCode = 'IN';
// String state = 'Gujarat';

// class StripePayment {
//   Map<String, dynamic>? paymentIntent;

//   Future<void> makePayment(
//       {required String amount,
//       required String authKey,
//       UserData? user,
//       required String currency,
//       required Function(String error) onError,
//       required Function(Map value) onSuccess}) async {
//     try {
//       paymentIntent = await ApiService().createPaymentIntent(
//           amount: amount, currency: currency, authKey: authKey);
//       // STEP 2: Initialize Payment Sheet
//       await Stripe.instance
//           .initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//           paymentIntentClientSecret: paymentIntent!['client_secret'],
//           setupIntentClientSecret: paymentIntent!['client_secret'],
//           style: ThemeMode.dark,
//           merchantDisplayName:
//               user?.fullname ?? AppLocalizations.of(Get.context!)!.unknown,
//         ),
//       )
//           .then((value) async {
//         //STEP 3: Display Payment sheet
//         await Stripe.instance.presentPaymentSheet().then((value) {
//           onSuccess(paymentIntent ?? {});
//         }).onError((error, stackTrace) {
//           onError('Payment Failed');
//         }).catchError((e) {
//           onError('Payment Failed');
//         });
//       }).onError((error, stackTrace) {});
//     } catch (err) {
//       throw Exception(err);
//     }
//   }
// }

// class RazorPayPayment {
//   void makePayment({
//     required String amount,
//     required String authKey,
//     required String currency,
//     UserData? user,
//     required Function(PaymentFailureResponse response)
//         handlePaymentErrorResponse,
//     required Function(PaymentSuccessResponse response)
//         handlePaymentSuccessResponse,
//     required Function(ExternalWalletResponse response)
//         handleExternalWalletSelected,
//   }) {
//     Razorpay razorpay = Razorpay();
//     var options = {
//       'key': authKey,
//       'amount': calculateAmount(amount),
//       'currency': currency,
//       'name': AppLocalizations.of(Get.context!)!.appName,
//       'description': 'Add Coin to wallet',
//       'retry': {'enabled': true, 'max_count': 1},
//       'send_sms_hash': true,
//       'prefill': {'contact': user?.identity ?? '', 'email': email},
//       'external': {
//         'wallets': [
//           'paytm',
//         ]
//       }
//     };

//     razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
//     razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
//     razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
//     razorpay.open(options);
//   }
// }

// calculateAmount(String amount) {
//   final calculateAmount = (int.parse(amount)) * 100;
//   return calculateAmount.toString();
// }

// class PaystackPayment {
//   // var plugin = PaystackPlugin();

//   void makePayment(
//       {required String amount,
//       UserData? user,
//       required String publicKey,
//       required String currency,
//       required String authKey,
//       required Function(String response) onSuccess}) async {
//     // await plugin.initialize(publicKey: publicKey);
//     // _getAccessCodeFrmInitialization(authKey: authKey, amount: amount).then(
//     //   (value) async {
//     //     Charge charge = Charge()
//     //       ..amount = int.parse(calculateAmount(amount))
//     //       ..accessCode = value?.data?.accessCode
//     //       ..email = email
//     //       ..currency = currency;

//     //     await plugin
//     //         .checkout(
//     //       Get.context!,
//     //       method: CheckoutMethod.selectable,

//     //       // Defaults to CheckoutMethod.selectable
//     //       charge: charge,
//     //       fullscreen: true,
//     //       hideEmail: true,
//     //       logo: Text(AppLocalizations.of(Get.context!)!.appName),
//     //     )
//     //         .then(
//     //       (value) async {
//     //         await http.get(
//     //           Uri.parse(
//     //               'https://api.paystack.co/transaction/verify/${value.reference}'),
//     //           headers: {'Authorization': 'Bearer $authKey'},
//     //         ).then(
//     //           (value) {
//     //             onSuccess(value.body);
//     //           },
//     //         );
//     //       },
//     //     );
//     //   },
//     // );
//   }

//   Future<PaystackResponse?> _getAccessCodeFrmInitialization(
//       {required String authKey, required String amount}) async {
//     http.Response response = await http.post(
//       Uri.parse('https://api.paystack.co/transaction/initialize'),
//       headers: {'Authorization': 'Bearer $authKey'},
//       body: {
//         "email": email,
//         "amount": amount,
//       },
//     );
//     return PaystackResponse.fromJson(jsonDecode(response.body));
//   }
// }

// class PaypalPayment {
//   void makePayment({
//     UserData? user,
//     required String clientId,
//     required String authKey,
//     required String amount,
//     required String currency,
//     required Function(Map param) onSuccess,
//     required Function(dynamic error) onError,
//     required Function(dynamic param) onCancel,
//   }) {
//     Get.to(
//       () => UsePaypal(
//         sandboxMode: true,
//         clientId: clientId,
//         secretKey: authKey,
//         returnURL: "https://retrytech.com/",
//         cancelURL: "https://retrytech.com/",
//         transactions: [
//           {
//             "amount": {
//               "total": amount,
//               "currency": currency,
//               "details": {
//                 "subtotal": amount,
//                 "shipping": '0',
//                 "shipping_discount": 0
//               }
//             },
//             "description": "The payment transaction description.",
//             "item_list": {
//               "items": [
//                 {
//                   "name": "Coin Wallet",
//                   "quantity": 1,
//                   "price": amount,
//                   "currency": currency
//                 }
//               ],
//               // shipping address is not required though
//               "shipping_address": {
//                 "recipient_name": user?.fullname ??
//                     AppLocalizations.of(Get.context!)!.unknown,
//                 "line1": address,
//                 "line2": "",
//                 "city": city,
//                 "country_code": countryCode,
//                 "postal_code": pinCode,
//                 "phone": '+00000000',
//                 "state": state
//               },
//             }
//           }
//         ],
//         note: "Contact us for any questions on your order.",
//         onSuccess: onSuccess,
//         onError: onError,
//         onCancel: onCancel,
//       ),
//     );
//   }
// }

// class FlutterwavePayment {
//   void makePayment({
//     UserData? user,
//     required String amount,
//     required String publishKey,
//     required String currency,
//     required Function(ChargeResponse param) onSuccess,
//     required Function(dynamic error) onError,
//   }) async {
//     final Customer customer = Customer(
//         email: email,
//         name: user?.fullname ?? AppLocalizations.of(Get.context!)!.unknown,
//         phoneNumber: user?.identity ?? '');

//     final Flutterwave flutterwave = Flutterwave(
//       context: Get.context!,
//       publicKey: publishKey,
//       currency: currency,
//       redirectUrl: 'https://facebook.com',
//       txRef: const Uuid().v1(),
//       amount: amount,
//       customer: customer,
//       paymentOptions: "card, payattitude, barter, bank transfer, ussd",
//       customization: Customization(title: "Wallet Payment"),
//       isTestMode: true,
//       // style: FlutterwaveStyle(
//       //   buttonColor: ColorRes.themeColor,
//       //   buttonTextStyle: kRegularTextStyle,
//       //   appBarColor: ColorRes.smokeWhite,
//       //   appBarTitleTextStyle: kBoldWhiteTextStyle.copyWith(
//       //     color: ColorRes.charcoal,
//       //   ),
//       // ),
//     );
//     flutterwave.charge().then((value) {
//       if (value.success == true) {
//         onSuccess(value);
//       } else {
//         onError(AppLocalizations.of(Get.context!)!.paymentFailed);
//       }
//     }).onError((error, stackTrace) {
//       onError(AppLocalizations.of(Get.context!)!.paymentFailed);
//     });
//   }
// }

// class PaystackResponse {
//   PaystackResponse({
//     bool? status,
//     String? message,
//     Data? data,
//   }) {
//     _status = status;
//     _message = message;
//     _data = data;
//   }

//   PaystackResponse.fromJson(dynamic json) {
//     _status = json['status'];
//     _message = json['message'];
//     _data = json['data'] != null ? Data.fromJson(json['data']) : null;
//   }

//   bool? _status;
//   String? _message;
//   Data? _data;

//   PaystackResponse copyWith({
//     bool? status,
//     String? message,
//     Data? data,
//   }) =>
//       PaystackResponse(
//         status: status ?? _status,
//         message: message ?? _message,
//         data: data ?? _data,
//       );

//   bool? get status => _status;

//   String? get message => _message;

//   Data? get data => _data;

//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['status'] = _status;
//     map['message'] = _message;
//     if (_data != null) {
//       map['data'] = _data?.toJson();
//     }
//     return map;
//   }
// }

// class Data {
//   Data({
//     String? authorizationUrl,
//     String? accessCode,
//     String? reference,
//   }) {
//     _authorizationUrl = authorizationUrl;
//     _accessCode = accessCode;
//     _reference = reference;
//   }

//   Data.fromJson(dynamic json) {
//     _authorizationUrl = json['authorization_url'];
//     _accessCode = json['access_code'];
//     _reference = json['reference'];
//   }

//   String? _authorizationUrl;
//   String? _accessCode;
//   String? _reference;

//   Data copyWith({
//     String? authorizationUrl,
//     String? accessCode,
//     String? reference,
//   }) =>
//       Data(
//         authorizationUrl: authorizationUrl ?? _authorizationUrl,
//         accessCode: accessCode ?? _accessCode,
//         reference: reference ?? _reference,
//       );

//   String? get authorizationUrl => _authorizationUrl;

//   String? get accessCode => _accessCode;

//   String? get reference => _reference;

//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['authorization_url'] = _authorizationUrl;
//     map['access_code'] = _accessCode;
//     map['reference'] = _reference;
//     return map;
//   }
// }
