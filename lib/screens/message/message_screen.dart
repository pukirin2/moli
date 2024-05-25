import 'package:moli/bloc/messageuser/message_user_bloc.dart';
import 'package:moli/screens/main/main_screen.dart';
import 'package:moli/screens/message/messages_list_widget.dart';
import 'package:moli/utils/color_res.dart';
import 'package:moli/utils/custom/custom_widget.dart';
import 'package:moli/utils/style_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MessageScreen extends StatelessWidget {
  final Function()? onMenuClick;

  const MessageScreen({Key? key, this.onMenuClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MessageUserBloc(),
      child: Column(
        children: [
          Container(
            color: ColorRes.themeColor5,
            padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 15),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  BgRoundIconWidget(
                    icon: Icons.menu_open_sharp,
                    onTap: onMenuClick,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    AppLocalizations.of(context)!.messages,
                    style: kLightWhiteTextStyle.copyWith(
                      fontSize: 20,
                      color: ColorRes.themeColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          BlocBuilder<MessageUserBloc, MessageUserState>(
            builder: (context, state) {
              return Expanded(
                child: state is MessageUserInitial
                    ? const LoadingData()
                    : Column(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: ColorRes.smokeWhite,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                            ),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: AppLocalizations.of(context)!.search,
                                hintStyle: kRegularTextStyle.copyWith(
                                  color: ColorRes.darkGray,
                                ),
                              ),
                              style: kRegularTextStyle.copyWith(
                                color: ColorRes.charcoal50,
                              ),
                              onChanged: (value) {
                                context
                                    .read<MessageUserBloc>()
                                    .filterData(value);
                              },
                            ),
                          ),
                          const MessagesListWidget(),
                        ],
                      ),
              );
            },
          ),
        ],
      ),
    );
  }
}
