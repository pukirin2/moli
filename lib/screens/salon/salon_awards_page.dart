import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moli/bloc/salon/salon_details_bloc.dart';
import 'package:moli/model/user/salon.dart';
import 'package:moli/screens/salon/salon_details_page.dart';
import 'package:moli/utils/asset_res.dart';
import 'package:moli/utils/color_res.dart';
import 'package:moli/utils/extensions.dart';

class SalonAwardsPage extends StatelessWidget {
  const SalonAwardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    SalonDetailsBloc salonDetailsBloc = context.read<SalonDetailsBloc>();
    return ListView.builder(
      itemCount: salonDetailsBloc.salonData?.awards?.length ?? 0,
      shrinkWrap: true,
      padding: const EdgeInsets.all(0),
      itemBuilder: (context, index) {
        Awards? awards = salonDetailsBloc.salonData?.awards?[index];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          margin: const EdgeInsets.symmetric(vertical: 5),
          color: ColorRes.smokeWhite,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const RoundCornerWithImageWidget(
                image: AssetRes.icAwards,
                cornerRadius: 10,
                imagePadding: 7,
                bgColor: ColorRes.smokeWhite1,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      awards?.title ?? '',
                      style: context.bodyMedium!
                          .copyWith(fontWeight: FontWeight.w300)
                          .copyWith(
                            fontSize: 16,
                          ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'By ${awards?.awardBy ?? ''}',
                      style: context.bodyMedium!.copyWith(
                        color: context.colorScheme.primary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      awards?.description ?? '',
                      style: context.bodyMedium!.copyWith(
                        color: context.colorScheme.outline,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
