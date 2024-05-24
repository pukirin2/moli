import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:moli/model/user/salon.dart';
import 'package:moli/utils/asset_res.dart';
import 'package:moli/utils/color_res.dart';
import 'package:moli/utils/style_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

class AppLogo extends StatelessWidget {
  final Color? textColor;
  final double? textSize;

  const AppLogo({Key? key, this.textColor, this.textSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      AppLocalizations.of(context)!.appName.toUpperCase(),
      style: TextStyle(
          color: textColor ?? ColorRes.white,
          fontFamily: AssetRes.fnGilroyBlack,
          fontSize: textSize ?? 22,
          fontWeight: FontWeight.bold),
    );
  }
}

class OpenClosedStatusWidget extends StatefulWidget {
  final Color? bgDisable;
  final bool? salonIsOpen;
  final SalonData? salonData;

  const OpenClosedStatusWidget({
    Key? key,
    this.bgDisable,
    this.salonIsOpen,
    this.salonData,
  }) : super(key: key);

  @override
  State<OpenClosedStatusWidget> createState() => _OpenClosedStatusWidgetState();
}

class _OpenClosedStatusWidgetState extends State<OpenClosedStatusWidget> {
  bool isSalonOpen = false;

  void isSalonIsOpen(SalonData? salon) {
    int currentDay = DateTime.now().weekday;

    int todayTime = int.parse(
        '${DateTime.now().hour}${DateTime.now().minute < 10 ? '0${DateTime.now().minute}' : DateTime.now().minute}');
    if (salon?.satSunFrom == null ||
        salon?.satSunTo == null ||
        salon?.monFriFrom == null ||
        salon?.monFriTo == null) {
      isSalonOpen = false;
    }
    if (currentDay > 5) {
      isSalonOpen = int.parse('${salon?.satSunFrom}') < todayTime &&
          int.parse('${salon?.satSunTo}') > todayTime;
    } else {
      isSalonOpen = int.parse('${salon?.monFriFrom}') < todayTime &&
          int.parse('${salon?.monFriTo}') > todayTime;
    }
  }

  @override
  void initState() {
    isSalonIsOpen(widget.salonData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isSalonIsOpen(widget.salonData);
    return Container(
      decoration: BoxDecoration(
        color: isSalonOpen
            ? ColorRes.themeColor
            : widget.bgDisable ?? ColorRes.smokeWhite,
        borderRadius: const BorderRadius.all(
          Radius.circular(100),
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 8,
      ),
      child: Text(
        (isSalonOpen
                ? AppLocalizations.of(context)!.open
                : AppLocalizations.of(context)!.closed)
            .toUpperCase(),
        style: kLightWhiteTextStyle.copyWith(
          color: isSalonOpen ? ColorRes.white : ColorRes.empress,
          fontSize: 12,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class TitleWithSeeAllWidget extends StatelessWidget {
  final String title;
  final Function()? onTap;

  const TitleWithSeeAllWidget({
    Key? key,
    required this.title,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(children: [
          Expanded(child: Text(title, style: kSemiBoldTextStyle, maxLines: 3)),
          const Spacer(),
          CustomCircularInkWell(
              onTap: onTap,
              child: Text(AppLocalizations.of(context)!.seeAll,
                  style: kRegularEmpressTextStyle.copyWith(fontSize: 14)))
        ]));
  }
}

class CustomCircularInkWell extends StatelessWidget {
  final Widget? child;
  final Function()? onTap;

  const CustomCircularInkWell({Key? key, this.child, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      overlayColor: MaterialStateProperty.all(ColorRes.transparent),
      borderRadius: const BorderRadius.all(Radius.circular(100)),
      child: child,
    );
  }
}

class ToolBarWidget extends StatelessWidget {
  final String title;
  final Widget? child;

  const ToolBarWidget({
    Key? key,
    required this.title,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Image(
                  image: AssetImage(AssetRes.icBack),
                  height: 30,
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    title,
                    style: kBoldThemeTextStyle,
                  ),
                ),
                const Spacer(),
                child ?? const SizedBox()
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget loadingImage(context, child, loadingProgress) {
  if (loadingProgress == null) {
    return child;
  }
  return const LoadingImage();
}

Widget loadingImageTransParent(context, child, loadingProgress) {
  if (loadingProgress == null) {
    return child;
  }
  return const SizedBox();
}

Widget errorBuilderForImage(context, error, stackTrace) {
  return const ImageNotFound();
}

class ImageNotFound extends StatelessWidget {
  final Color? color;
  final Color? tintcolor;

  const ImageNotFound({
    super.key,
    this.color,
    this.tintcolor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color ?? ColorRes.smokeWhite,
      child: Center(
        child: Text(
          ':-('.toUpperCase(),
          style: kBoldThemeTextStyle.copyWith(
            color: tintcolor ?? ColorRes.smokeWhite1,
            fontSize: 50,
          ),
        ),
      ),
    );
  }
}

class ImageNotFoundOval extends StatelessWidget {
  final Color? color;
  final Color? tintcolor;
  final double? fontSize;

  const ImageNotFoundOval({
    super.key,
    this.color,
    this.tintcolor,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        color: color ?? ColorRes.smokeWhite,
        child: Center(
          child: Text(
            ':-('.toUpperCase(),
            style: kBoldThemeTextStyle.copyWith(
              color: tintcolor ?? ColorRes.smokeWhite1,
              fontSize: fontSize ?? 50,
            ),
          ),
        ),
      ),
    );
  }
}

class LoadingImage extends StatelessWidget {
  final Color? color;

  const LoadingImage({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color ?? ColorRes.smokeWhite,
      child: Center(
        child: Text(
          '...'.toUpperCase(),
          style: kBoldThemeTextStyle.copyWith(
            color: ColorRes.smokeWhite1,
            fontSize: 50,
          ),
        ),
      ),
    );
  }
}

class DataNotFound extends StatelessWidget {
  const DataNotFound({Key? key, this.color}) : super(key: key);
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Image(
            image: AssetImage(AssetRes.icNoData),
            width: 275,
          ),
        )
      ],
    );
  }
}

class LoadingData extends StatelessWidget {
  final Color? color;

  const LoadingData({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color ?? Colors.transparent,
      child: const Center(
          child: SpinKitCircle(color: ColorRes.themeColor, size: 30)

          // CircularProgressIndicator(
          //   color: ColorRes.themeColor,
          // ),
          ),
    );
  }
}

class Loading extends StatelessWidget {
  final Color? color;

  const Loading({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: color ?? ColorRes.smokeWhite,
        child: const Center(
            child: SpinKitCircle(color: ColorRes.themeColor, size: 30)));
  }
}
