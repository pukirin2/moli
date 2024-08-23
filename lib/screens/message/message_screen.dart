import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moli/bloc/messageuser/message_user_bloc.dart';
import 'package:moli/screens/main/main_screen.dart';
import 'package:moli/screens/message/messages_list_widget.dart';
import 'package:moli/utils/custom/custom_widget.dart';
import 'package:moli/utils/extensions.dart';

class MessageScreen extends StatelessWidget {
  final Function()? onMenuClick;

  const MessageScreen({super.key, this.onMenuClick});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MessageUserBloc(),
      child: Column(
        children: [
          Container(
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
                    style: context.bodyMedium!.copyWith(
                      fontSize: 20,
                      color: context.colorScheme.primary,
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
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                filled: true,
                                fillColor: context.colorScheme.outlineVariant
                                    .withOpacity(.6),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100),
                                    borderSide: BorderSide.none),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100),
                                    borderSide: BorderSide.none),
                                hintText: AppLocalizations.of(context)!.search,
                                hintStyle: context.bodyMedium!.copyWith(
                                    color: context.colorScheme.outline),
                              ),
                              style: context.bodyMedium!
                                  .copyWith(color: context.colorScheme.outline),
                              onChanged: (value) {
                                context
                                    .read<MessageUserBloc>()
                                    .filterData(value);
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
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
