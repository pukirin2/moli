// import 'package:moli/bloc/wallet/wallet_bloc.dart';
// import 'package:moli/model/user/salon_user.dart';
// import 'package:moli/model/wallet/wallet_statement.dart';
// import 'package:moli/screens/payment/recharge_wallet_sheet.dart';
// import 'package:moli/screens/wallet/withdraw_screen.dart';
// import 'package:moli/utils/app_res.dart';
// import 'package:moli/utils/asset_res.dart';
// import 'package:moli/utils/color_res.dart';
// import 'package:moli/utils/custom/custom_widget.dart';
// import 'package:moli/utils/style_res.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:get/get.dart';

// class WalletScreen extends StatelessWidget {
//   const WalletScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => WalletBloc(),
//       child: Scaffold(
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               color: ColorRes.smokeWhite,
//               width: double.infinity,
//               padding: const EdgeInsets.only(bottom: 10),
//               child: SafeArea(
//                 bottom: false,
//                 child: ToolBarWidget(
//                   title: AppLocalizations.of(context)!.wallet,
//                 ),
//               ),
//             ),
//             Container(
//               margin: const EdgeInsets.all(20),
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 borderRadius: const BorderRadius.all(Radius.circular(10)),
//                 gradient: LinearGradient(
//                   colors: [
//                     context.colorScheme.primary,
//                     context.colorScheme.primary.withOpacity(0.9),
//                     context.colorScheme.primary.withOpacity(0.8),
//                     context.colorScheme.primary.withOpacity(0.6),
//                   ],
//                 ),
//               ),
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//               child: BlocBuilder<WalletBloc, WalletState>(
//                 builder: (context, state) {
//                   SalonUser? salon = context.read<WalletBloc>().salonUser;
//                   return Row(
//                     children: [
//                       Text(
//                         '${AppRes.currency}${salon?.data?.wallet ?? 0}',
//                         style: context.bodyMedium.copyWith(
//                           fontSize: 28,
//                           color: ColorRes.white,
//                           letterSpacing: 1,
//                         ),
//                       ),
//                       const Spacer(),
//                       TextButton(
//                         onPressed: () {
//                           Get.bottomSheet(const RechargeWalletSheet())
//                               .then((value) {
//                             context
//                                 .read<WalletBloc>()
//                                 .add(FetchSalonDataEvent());
//                           });
//                         },
//                         style: ButtonStyle(
//                           backgroundColor: MaterialStateProperty.all(
//                             ColorRes.white.withOpacity(0.2),
//                           ),
//                           shape: MaterialStateProperty.all(
//                             const RoundedRectangleBorder(
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(5)),
//                             ),
//                           ),
//                           overlayColor:
//                               MaterialStateProperty.all(ColorRes.transparent),
//                         ),
//                         child: Text(
//                           AppLocalizations.of(context)!.add,
//                           style: kRegularWhiteTextStyle,
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 15,
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           Get.to(const WithDrawScreen())?.then((value) {
//                             context
//                                 .read<WalletBloc>()
//                                 .add(FetchSalonDataEvent());
//                           });
//                         },
//                         style: ButtonStyle(
//                           backgroundColor: MaterialStateProperty.all(
//                               ColorRes.white.withOpacity(.2)),
//                           shape: MaterialStateProperty.all(
//                             RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                           ),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                           child: Text(
//                             AppLocalizations.of(context)!.withdraw,
//                             style: kRegularWhiteTextStyle.copyWith(
//                               fontSize: 16,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 25, bottom: 15),
//               child: Text(
//                 AppLocalizations.of(context)!.statement,
//                 style: context.bodyMedium.copyWith(
//                   color: ColorRes.titleText,
//                 ),
//               ),
//             ),
//             Expanded(
//               child: SafeArea(
//                 top: false,
//                 child: BlocBuilder<WalletBloc, WalletState>(
//                   builder: (context, state) {
//                     WalletBloc walletBloc = context.read<WalletBloc>();
//                     return state is! WalletStatementDataFoundState
//                         ? const LoadingData()
//                         : walletBloc.walletStatements.isEmpty
//                             ? const DataNotFound()
//                             : ListView.builder(
//                                 controller: walletBloc.scrollController,
//                                 padding: const EdgeInsets.all(0),
//                                 itemCount: walletBloc.walletStatements.length,
//                                 itemBuilder: (context, index) {
//                                   WalletStatementData? walletStatement =
//                                       walletBloc.walletStatements[index];
//                                   return ItemWalletStatement(
//                                     walletStatementData: walletStatement,
//                                   );
//                                 },
//                               );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ItemWalletStatement extends StatelessWidget {
//   final WalletStatementData walletStatementData;

//   const ItemWalletStatement({Key? key, required this.walletStatementData})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(top: 2),
//       color: AppRes.getColorOfWalletByType(walletStatementData.crOrDr ?? 0)
//           .withOpacity(.1),
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
//       child: Row(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               color: AppRes.getColorOfWalletByType(
//                   walletStatementData.crOrDr ?? 0),
//               borderRadius: BorderRadius.circular(100),
//             ),
//             height: 30,
//             width: 30,
//             child: Center(
//               child: Image(
//                 height: 30,
//                 width: walletStatementData.crOrDr == 0 ? 12 : 20,
//                 image: AssetImage(
//                   walletStatementData.crOrDr == 0
//                       ? AssetRes.icMinus
//                       : AssetRes.icPlus,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(
//             width: 15,
//           ),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       '${walletStatementData.transactionId} - ',
//                       style: context.bodyMedium!.copyWith(fontWeight: FontWeight.w300).copyWith(
//                         fontSize: 14,
//                         color: ColorRes.empress,
//                       ),
//                     ),
//                     Text(
//                       AppRes.getStringOfWalletByType(
//                           walletStatementData.type ?? 0),
//                       style: context.bodyMedium.copyWith(
//                         color: AppRes.getColorOfWalletByType(
//                             walletStatementData.crOrDr ?? 0),
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 5,
//                 ),
//                 Text(
//                   AppRes.formatDate(
//                       AppRes.parseDate(walletStatementData.createdAt ?? '')),
//                   style: context.bodyMedium.copyWith(
//                     fontSize: 14,
//                     color: ColorRes.empress,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Text(
//             '${AppRes.getPlusOrMinusOfWalletByType(walletStatementData.crOrDr ?? 0)}\$${walletStatementData.amount}',
//             style: context.bodyMedium!.copyWith(                                              fontWeight: FontWeight.bold).copyWith(
//               fontSize: 18,
//               color: ColorRes.empress,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
