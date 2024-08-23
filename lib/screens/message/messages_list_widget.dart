import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:moli/bloc/messageuser/message_user_bloc.dart';
import 'package:moli/model/chat/chat.dart';
import 'package:moli/screens/chat/chat_screen.dart';
import 'package:moli/utils/app_res.dart';
import 'package:moli/utils/asset_res.dart';
import 'package:moli/utils/const_res.dart';
import 'package:moli/utils/custom/custom_widget.dart';
import 'package:moli/utils/extensions.dart';

class MessagesListWidget extends StatelessWidget {
  const MessagesListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessageUserBloc, MessageUserState>(
      builder: (context, state) {
        MessageUserBloc messageUserBloc = context.read<MessageUserBloc>();
        return Expanded(
          child: messageUserBloc.userList.isEmpty
              ? const DataNotFound()
              : ListView.builder(
                  padding: const EdgeInsets.all(0),
                  itemCount: messageUserBloc.userList.length,
                  itemBuilder: (context, index) {
                    Conversation conversation = messageUserBloc.userList[index];
                    return ItemMessagesUsers(
                      conversation: conversation,
                    );
                  },
                ),
        );
      },
    );
  }
}

class ItemMessagesUsers extends StatelessWidget {
  const ItemMessagesUsers({
    super.key,
    required this.conversation,
  });
  final Conversation conversation;

  @override
  Widget build(BuildContext context) {
    return CustomCircularInkWell(
      onTap: () {
        Get.to(() => const ChatScreen(), arguments: [
          conversation,
          context.read<MessageUserBloc>().userData
        ]);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            ClipOval(
              child: FadeInImage.assetNetwork(
                width: 55,
                height: 55,
                fit: BoxFit.cover,
                image: '${ConstRes.itemBaseUrl}${conversation.user?.image}',
                imageErrorBuilder: (context, error, stackTrace) {
                  return ClipOval(
                    child: Container(
                      height: 55,
                      width: 55,
                      padding:
                          const EdgeInsets.only(top: 12, left: 5, right: 5),
                      color: Colors.white,
                      child: const Center(
                        child: Image(
                          image: AssetImage(AssetRes.icProfile),
                        ),
                      ),
                    ),
                  );
                },
                placeholderErrorBuilder: (context, error, stackTrace) {
                  return ClipOval(
                    child: Container(
                      height: 55,
                      width: 55,
                      padding:
                          const EdgeInsets.only(top: 12, left: 5, right: 5),
                      color: Colors.white,
                      child: const Center(
                        child: Image(
                          image: AssetImage(AssetRes.icProfile),
                        ),
                      ),
                    ),
                  );
                },
                placeholder: '1',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conversation.user?.username ?? '',
                    style: context.bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    conversation.lastMsg ?? '',
                    style: context.bodyMedium!.copyWith(
                      color: context.colorScheme.outline,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                  visible: (conversation.user?.msgCount ?? 0) >= 1,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                    height: 26,
                    width: 26,
                    child: Center(
                      child: Text(
                        '${conversation.user?.msgCount}',
                        maxLines: 1,
                        style: context.bodyMedium!.copyWith(fontSize: 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  AppRes.timeAgo(DateTime.fromMillisecondsSinceEpoch(
                      int.parse(conversation.time ?? '0'))),
                  style: context.bodyMedium!.copyWith(
                    color: context.colorScheme.outline,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
