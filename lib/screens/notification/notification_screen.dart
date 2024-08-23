import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moli/bloc/notification/notification_bloc.dart';
import 'package:moli/model/notification/notification.dart';
import 'package:moli/utils/color_res.dart';
import 'package:moli/utils/custom/custom_widget.dart';
import 'package:moli/utils/extensions.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationBloc(),
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ToolBarWidget(
              title: AppLocalizations.of(context)!.notifications,
            ),
            BlocBuilder<NotificationBloc, NotificationState>(
              builder: (context, state) {
                NotificationBloc notificationBloc =
                    context.read<NotificationBloc>();
                return state is NotificationInitial
                    ? const Expanded(
                        child: LoadingData(
                          color: ColorRes.white,
                        ),
                      )
                    : notificationBloc.notifications.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                              controller: notificationBloc.scrollController,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              itemCount: notificationBloc.notifications.length,
                              itemBuilder: (context, index) {
                                Data notificationData =
                                    notificationBloc.notifications[index];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      notificationData.title ?? '',
                                      style: context.bodyMedium!.copyWith(
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      notificationData.description ?? '',
                                      style: context.bodyMedium!.copyWith(
                                        color: context.colorScheme.outline,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      color: context.colorScheme.outline,
                                      height: 0.2,
                                    ),
                                  ],
                                );
                              },
                            ),
                          )
                        : const Expanded(
                            child: Center(
                              child: DataNotFound(),
                            ),
                          );
              },
            ),
          ],
        ),
      ),
    );
  }
}
