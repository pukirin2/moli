import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:moli/bloc/nearbysalon/near_by_salon_bloc.dart';
import 'package:moli/model/user/salon.dart';
import 'package:moli/screens/fav/salon_screen.dart';
import 'package:moli/utils/asset_res.dart';
import 'package:moli/utils/color_res.dart';
import 'package:moli/utils/custom/custom_widget.dart';
import 'package:moli/utils/extensions.dart';

class NearBySalonScreen extends StatelessWidget {
  const NearBySalonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NearBySalonBloc(),
      child: Scaffold(
        body: BlocBuilder<NearBySalonBloc, NearBySalonState>(
          builder: (context, state) {
            NearBySalonBloc nearBySalonBloc = context.read<NearBySalonBloc>();
            return Column(
              children: [
                const TopBarOfTopRatedWidget(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SafeArea(
                          top: false,
                          child: ListView.builder(
                            itemCount: nearBySalonBloc.salons.length,
                            primary: false,
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            itemBuilder: (context, index) {
                              SalonData salonData =
                                  nearBySalonBloc.salons[index];
                              return ItemSalon(
                                salonData: salonData,
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class TopBarOfTopRatedWidget extends StatelessWidget {
  const TopBarOfTopRatedWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    NearBySalonBloc nearBySalonBloc = context.read<NearBySalonBloc>();
    return SizedBox(
      child: Stack(
        children: [
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Container(
              height: 500,
              color: ColorRes.smokeWhite,
            ),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
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
                Container(
                  decoration: const BoxDecoration(
                    // gradient: LinearGradient(
                    //   colors: [
                    //     // context.colorScheme.primary,
                    //     // context.colorScheme.primary,
                    //   ],
                    //   begin: Alignment(1, -1),
                    // ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(100),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
                  margin: const EdgeInsets.only(left: 5, right: 5),
                  child: Text(
                    AppLocalizations.of(context)!.nearBySalons,
                    style: context.bodyMedium!
                        .copyWith(fontWeight: FontWeight.w300)
                        .copyWith(
                          color: context.colorScheme.primary,
                          fontSize: 20,
                        ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: ColorRes.white,
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                    boxShadow: [
                      BoxShadow(
                        color: ColorRes.charcoal50.withOpacity(0.1),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  margin: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                    bottom: 10,
                    top: 20,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: AppLocalizations.of(context)!.search,
                      hintStyle: context.bodyMedium!.copyWith(
                        color: ColorRes.darkGray,
                      ),
                    ),
                    controller: nearBySalonBloc.nearBySalonEditingController,
                    textCapitalization: TextCapitalization.sentences,
                    style: context.bodyMedium!.copyWith(
                      color: ColorRes.charcoal50,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
