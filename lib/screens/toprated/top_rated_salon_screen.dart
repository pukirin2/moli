import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:moli/bloc/topratedsalon/top_rated_salon_bloc.dart';
import 'package:moli/model/user/salon.dart';
import 'package:moli/screens/fav/salon_screen.dart';
import 'package:moli/utils/asset_res.dart';
import 'package:moli/utils/color_res.dart';
import 'package:moli/utils/custom/custom_widget.dart';
import 'package:moli/utils/extensions.dart';

class TopRatedSalonScreen extends StatelessWidget {
  const TopRatedSalonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TopRatedSalonBloc(),
      child: Scaffold(
        body: BlocBuilder<TopRatedSalonBloc, TopRatedSalonState>(
          builder: (context, state) {
            TopRatedSalonBloc topRatedSalonBloc =
                context.read<TopRatedSalonBloc>();
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
                            itemCount: topRatedSalonBloc.salons.length,
                            primary: false,
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            itemBuilder: (context, index) {
                              SalonData salonData =
                                  topRatedSalonBloc.salons[index];
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
    TopRatedSalonBloc topRatedSalonBloc = context.read<TopRatedSalonBloc>();
    return SizedBox(
      child: Stack(
        children: [
          Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Container(height: 500, color: ColorRes.smokeWhite)),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Image(
                            image: AssetImage(AssetRes.icBack), height: 30))),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [ColorRes.pancho, ColorRes.fallow],
                      begin: Alignment(1, -1),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(100),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
                  margin: const EdgeInsets.only(left: 15, right: 5),
                  child: Text(
                    AppLocalizations.of(context)!.topRated.toUpperCase(),
                    style: context.bodyMedium!.copyWith(
                      color: ColorRes.white,
                      fontSize: 14,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                  // child: Text(
                  //   'Offering best Massage services',
                  //   style: context.bodyMedium.copyWith(
                  //     color: context.colorScheme.outline,
                  //     fontSize: 18,
                  //   ),
                  // ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: ColorRes.white,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(100)),
                      boxShadow: [
                        BoxShadow(
                            color: ColorRes.black.withOpacity(0.2),
                            blurRadius: 10)
                      ]),
                  margin: const EdgeInsets.only(
                      left: 15, right: 15, bottom: 10, top: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: AppLocalizations.of(context)!.search,
                      hintStyle: context.bodyMedium!.copyWith(
                        color: ColorRes.darkGray,
                      ),
                    ),
                    controller: topRatedSalonBloc.searchController,
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
