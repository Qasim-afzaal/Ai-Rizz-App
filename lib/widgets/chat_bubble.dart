import 'dart:io';

import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:sparkd/core/components/app_image.dart';
import 'package:sparkd/core/constants/imports.dart';

class ChatBubble extends StatelessWidget {
  ChatBubble({super.key, required this.chatItem, this.regenerate,this.disablebutton});
   String? disablebutton="";
  final MessageModel chatItem;
  void Function()? regenerate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: chatItem.mainText != null
              ? CrossAxisAlignment.center
              : chatItem.isReceived
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
          children: [
            if (chatItem.mainText != null) ...[
              Center(
                child: Text(
                  chatItem.mainText!,
                  style: context.titleLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ] else ...[
              if (chatItem.headline != null)
                Text(
                  chatItem.headline!,
                  style: context.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ).paddingOnly(left: 12, bottom: 4),
              chatItem.isReceived
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: _Container(
                            chatItem: chatItem,
                          ),
                        ),
                        GestureDetector(
                            onTap: () async {
                              await Clipboard.setData(
                                  ClipboardData(text: chatItem.message!));
                              Fluttertoast.showToast(
                                msg: "Copied to clipboard",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            },
                            child: Assets.icons.copy.svg().paddingAll(8)),
                       if ((chatItem.headline != null || chatItem.isSparkdLine) && 
                            (disablebutton == null || disablebutton!.isEmpty)) ...[
                          GestureDetector(
                              onTap: regenerate,
                              child: Assets.icons.restartAgain
                                  .svg()
                                  .paddingAll(8)
                                  .marginOnly(bottom: 2)),
                        ],
                      ],
                    ).marginOnly(
                      bottom: 15, right: chatItem.headline == null ? 50 : 0)
                  : _Container(chatItem: chatItem)
                      .marginOnly(bottom: 15, left: 50),
            ]
          ],
        ),
      ],
    );
  }
}

class _Container extends StatelessWidget {
  const _Container({super.key, required this.chatItem});

  final MessageModel chatItem;

  @override
  Widget build(BuildContext context) {
    String message = chatItem.message!;
    if (message.toLowerCase().startsWith('ai dating coach')) {
      message = message.replaceFirst(
          RegExp(r'Ai [dD]ating Coach', caseSensitive: false), 'Sparkd Coach');
    }

    return Container(
      padding:
          EdgeInsets.all(chatItem.messageType == MessageType.image ? 12 : 12),
      decoration: BoxDecoration(
        color: chatItem.isReceived
            ? context.chatBubbleColor
            : context.primary.withOpacity(0.1),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: Radius.circular(chatItem.isReceived ? 4 : 16),
          bottomRight: Radius.circular(chatItem.isReceived ? 16 : 4),
        ),
      ),
      child: chatItem.messageType == MessageType.text
          ? Text(
              message,
              style: context.bodyLarge?.copyWith(
                fontWeight: FontWeight.w400,
              ),
            )
          : chatItem.messageType == MessageType.image
              ? chatItem.fileData
                  ? AppImage.file(file: File(chatItem.message!))
                  : AppImage.network(imageUrl: chatItem.message!)
              : SizedBox(),
    );
  }
}
