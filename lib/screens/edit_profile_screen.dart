import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:moli/bloc/edit/edit_profile_bloc.dart';
import 'package:moli/screens/login/email_registration_screen.dart';
import 'package:moli/screens/main/main_screen.dart';
import 'package:moli/utils/asset_res.dart';
import 'package:moli/utils/color_res.dart';
import 'package:moli/utils/const_res.dart';
import 'package:moli/utils/custom/custom_widget.dart';
import 'package:moli/utils/style_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => EditProfileBloc(),
        child: Scaffold(body: BlocBuilder<EditProfileBloc, EditProfileState>(
            builder: (context, state) {
          EditProfileBloc editProfileBloc = context.read<EditProfileBloc>();
          var a = editProfileBloc.imageUrl?.isEmpty ?? true;
          // print(a);

          return Column(children: [
            Container(
                color: ColorRes.smokeWhite,
                width: double.infinity,
                padding: const EdgeInsets.only(bottom: 15),
                child: SafeArea(
                    bottom: false,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomCircularInkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Icon(Icons.arrow_back_rounded,
                                    size: 30, color: ColorRes.themeColor)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              AppLocalizations.of(context)!.editProfile,
                              style: kBoldThemeTextStyle,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                              width: 120,
                              height: 120,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: ColorRes.themeColor,
                              ),
                              padding: const EdgeInsets.all(1),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  child: Stack(children: [
                                    editProfileBloc.imageFile != null
                                        ? Image(
                                            height: double.infinity,
                                            width: double.infinity,
                                            image: FileImage(
                                              editProfileBloc.imageFile ??
                                                  File('path'),
                                            ),
                                            fit: BoxFit.cover,
                                            loadingBuilder: loadingImage,
                                            errorBuilder: errorBuilderForImage)
                                        : a
                                            ? Image(
                                                height: double.infinity,
                                                width: double.infinity,
                                                image: FileImage(
                                                    editProfileBloc.imageFile ??
                                                        File('path')),
                                                fit: BoxFit.cover,
                                                loadingBuilder: loadingImage,
                                                errorBuilder:
                                                    errorBuilderForImage)
                                            : SizedBox(
                                                height: double.infinity,
                                                width: double.infinity,
                                                child: CachedNetworkImage(
                                                    imageUrl:
                                                        '${ConstRes.itemBaseUrl}${editProfileBloc.imageUrl}',
                                                    placeholder:
                                                        (context, url) =>
                                                            const Loading(),
                                                    errorWidget:
                                                        errorBuilderForImage,
                                                    fit: BoxFit.cover)),
                                    Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Align(
                                            alignment: Alignment.bottomRight,
                                            child: BgRoundImageWidget(
                                                image: AssetRes.icEdit,
                                                onTap: () {
                                                  editProfileBloc.add(
                                                      ImageSelectClickEvent());
                                                },
                                                height: 30,
                                                width: 30,
                                                imagePadding: 5,
                                                bgColor: ColorRes.charcoal50)))
                                  ])))
                        ]))),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWithTextFieldSmokeWhiteWidget(
                          title: AppLocalizations.of(context)!.fullName,
                          controller: editProfileBloc.fullNameTextController),
                      const SizedBox(height: 20),
                      Text(AppLocalizations.of(context)!.phoneNumberOptional,
                          style: kLightWhiteTextStyle.copyWith(
                              color: ColorRes.black, fontSize: 16)),
                      const SizedBox(height: 5),
                      Container(
                        decoration: BoxDecoration(
                            color: ColorRes.smokeWhite,
                            borderRadius: BorderRadius.circular(10)),
                        child: Stack(
                          children: [
                            Container(
                                width: Get.width / 4,
                                height: 50,
                                decoration: const BoxDecoration(
                                    color: ColorRes.nero,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10)))),
                            InternationalPhoneNumberInput(
                              textFieldController:
                                  editProfileBloc.phoneNumberTextController,
                              onInputChanged: (PhoneNumber number) {
                                editProfileBloc.salonPhone =
                                    '${number.dialCode} ${number.parseNumber()}';
                              },
                              countrySelectorScrollControlled: true,
                              selectorConfig: const SelectorConfig(
                                selectorType:
                                    PhoneInputSelectorType.BOTTOM_SHEET,
                                leadingPadding: 7,
                                trailingSpace: true,
                                showFlags: true,
                                useEmoji: true,
                              ),
                              selectorTextStyle:
                                  kRegularEmpressTextStyle.copyWith(
                                color: ColorRes.white,
                                fontSize: 18,
                                overflow: TextOverflow.ellipsis,
                              ),
                              textStyle: kRegularEmpressTextStyle.copyWith(
                                color: ColorRes.charcoal50,
                              ),
                              cursorColor: ColorRes.themeColor,
                              keyboardAction: TextInputAction.done,
                              initialValue: PhoneNumber(
                                  dialCode: editProfileBloc.dailCode,
                                  isoCode: PhoneNumber.getISO2CodeByPrefix(
                                      editProfileBloc.dailCode)),
                              formatInput: true,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      signed: false),
                              inputDecoration: const InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(left: 5),
                                isCollapsed: false,
                                counterText: "",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: SafeArea(
                    top: false,
                    child: SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: TextButton(
                            style: kButtonThemeStyle,
                            onPressed: () {
                              editProfileBloc.add(SubmitEditProfileEvent());
                            },
                            child: Text(AppLocalizations.of(context)!.submit,
                                style: kRegularWhiteTextStyle)))))
          ]);
        })));
  }
}
