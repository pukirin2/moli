import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moli/bloc/chat/chat_bloc.dart';
import 'package:moli/model/chat/chat.dart';
import 'package:moli/screens/chat/bottom_selected_item_bar.dart';
import 'package:moli/screens/chat/fancy_button.dart';
import 'package:moli/screens/preview/image_preview_screen.dart';
import 'package:moli/screens/preview/video_preview_screen.dart';
import 'package:moli/screens/profile/delete_account_bottom.dart';
import 'package:moli/utils/app_res.dart';
import 'package:moli/utils/const_res.dart';
import 'package:moli/utils/custom/custom_widget.dart';
import 'package:moli/utils/extensions.dart';
import 'package:moli/utils/firebase_res.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(),
      child: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          ChatBloc chatBloc = context.read<ChatBloc>();
          var curentLocale = Localizations.localeOf(context).languageCode;
          return Scaffold(
            body: Column(
              children: [
                Stack(
                  children: [
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: chatBloc.timeStamp.isEmpty ? 1 : 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: SafeArea(
                          bottom: false,
                          child: Row(
                            children: [
                              CustomCircularInkWell(
                                onTap: () => Get.back(),
                                child: Container(
                                    height: 40,
                                    width: 55,
                                    padding: const EdgeInsets.all(5),
                                    child: Icon(
                                        Icons.arrow_back_ios_new_outlined,
                                        color: context.colorScheme.primary,
                                        size: 30)),
                              ),
                              ClipOval(
                                child: CachedNetworkImage(
                                    imageUrl:
                                        '${ConstRes.itemBaseUrl}${chatBloc.salonData?.images?[0].image ?? (chatBloc.conversation.user?.image ?? '')}',
                                    placeholder: (context, url) =>
                                        const Loading(),
                                    errorWidget: errorBuilderForImage,
                                    height: 45,
                                    width: 45,
                                    fit: BoxFit.cover),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      chatBloc.conversation.user?.username
                                              ?.capitalize ??
                                          '',
                                      style: context.bodyLarge!.copyWith(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      chatBloc.salonData?.salonAddress ??
                                          (chatBloc
                                                  .conversation.user?.address ??
                                              ''),
                                      style: context.bodyMedium!.copyWith(
                                          color: context.colorScheme.outline),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: chatBloc.timeStamp.isNotEmpty ? 1 : 0,
                      child: Visibility(
                        visible: chatBloc.timeStamp.isNotEmpty,
                        child: BottomSelectedItemBar(
                          onBackTap: chatBloc.onMsgDeleteBackTap,
                          selectedItemCount: chatBloc.timeStamp.length,
                          onItemDelete: () {
                            Get.bottomSheet(
                              ConfirmationBottomSheet(
                                title: chatBloc.timeStamp.length == 1
                                    ? AppLocalizations.of(context)!
                                        .deleteMessage
                                    : '${AppLocalizations.of(context)!.delete} ${chatBloc.timeStamp.length} ${AppLocalizations.of(context)!.messages}',
                                description: '',
                                buttonText:
                                    AppLocalizations.of(context)!.deleteForMe,
                                onButtonClick: chatBloc.onChatItemDelete,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: chatBloc.chatData.length,
                              reverse: true,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 5),
                              itemBuilder: (context, index) {
                                ChatMessage chatMessage =
                                    chatBloc.chatData[index];
                                bool chatIsFromReceiver =
                                    chatMessage.senderUser?.address != null &&
                                        chatMessage
                                            .senderUser!.address!.isNotEmpty;
                                bool selected = chatBloc.timeStamp
                                    .contains('${chatMessage.id}');
                                return InkWell(
                                  onTap: () {
                                    if (chatBloc.timeStamp.isNotEmpty) {
                                      chatBloc.onLongPress(chatMessage);
                                      return;
                                    }
                                    if (chatMessage.msgType ==
                                        FirebaseRes.image) {
                                      Get.to(
                                        ImagePreviewScreen(
                                          imageUrl: chatMessage.image,
                                        ),
                                      );
                                    } else if (chatMessage.msgType ==
                                        FirebaseRes.video) {
                                      Get.to(
                                        const VideoPreviewScreen(),
                                        arguments: chatMessage.video,
                                      );
                                    }
                                  },
                                  onLongPress: () {
                                    chatBloc.onLongPress(chatMessage);
                                  },
                                  overlayColor: WidgetStateProperty.all(
                                      Colors.transparent),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(100)),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    width: double.infinity,
                                    color: selected
                                        ? context.colorScheme.outlineVariant
                                        : Colors.transparent,
                                    child: Column(
                                      crossAxisAlignment: chatIsFromReceiver
                                          ? CrossAxisAlignment.start
                                          : CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: chatIsFromReceiver
                                                ? context
                                                    .colorScheme.outlineVariant
                                                    .withOpacity(.4)
                                                : context
                                                    .colorScheme.outlineVariant
                                                    .withOpacity(.4),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20)),
                                          ),
                                          clipBehavior: Clip.hardEdge,
                                          constraints: const BoxConstraints(
                                            maxWidth: 300,
                                          ),
                                          padding: const EdgeInsets.all(10),
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Column(
                                            crossAxisAlignment:
                                                chatIsFromReceiver
                                                    ? CrossAxisAlignment.start
                                                    : CrossAxisAlignment.end,
                                            children: [
                                              Visibility(
                                                visible: chatMessage.msgType ==
                                                        FirebaseRes.image ||
                                                    chatMessage.msgType ==
                                                        FirebaseRes.video,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  child: CachedNetworkImage(
                                                      imageUrl:
                                                          '${ConstRes.itemBaseUrl}${chatMessage.image}',
                                                      placeholder:
                                                          (context, url) =>
                                                              const Loading(),
                                                      errorWidget:
                                                          errorBuilderForImage,
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                              SizedBox(
                                                height: chatMessage.msgType ==
                                                            FirebaseRes.image ||
                                                        chatMessage.msgType ==
                                                            FirebaseRes.video
                                                    ? 5
                                                    : 0,
                                              ),
                                              Text(
                                                chatMessage.msg ?? '',
                                                style: context.bodyMedium!
                                                    .copyWith(
                                                  color: chatIsFromReceiver
                                                      ? context
                                                          .colorScheme.primary
                                                      : context.colorScheme
                                                          .outlineVariant,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          AppRes.formatDate(
                                              DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      int.parse(
                                                          chatMessage.id ??
                                                              '0')),
                                              locale: curentLocale),
                                          style: context.bodyMedium!.copyWith(
                                            color: context.colorScheme.outline,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 60,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: SafeArea(
                              top: false,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: chatBloc.msgController,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 20),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            borderSide: BorderSide.none),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        filled: true,
                                        fillColor: context
                                            .colorScheme.outlineVariant
                                            .withOpacity(.6),
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              chatBloc.onSendBtnTap();
                                            },
                                            icon: Icon(
                                              Icons.send,
                                              size: 24,
                                              color:
                                                  context.colorScheme.primary,
                                            )),
                                        border: InputBorder.none,
                                      ),
                                      style: context.bodyMedium!
                                          .copyWith(fontSize: 18),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 55,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        right: 15,
                        bottom: 3,
                        child: SafeArea(
                          top: false,
                          child: FancyButton(
                            onGalleryTap: () {
                              chatBloc.onImageTap(source: ImageSource.gallery);
                            },
                            onCameraTap: () {
                              chatBloc.onImageTap(source: ImageSource.camera);
                            },
                            onVideoTap: () {
                              chatBloc.onVideoTap();
                            },
                            isOpen: chatBloc.isOpen,
                            msgFocusNode: FocusNode(),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
