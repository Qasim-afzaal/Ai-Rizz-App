import 'package:sparkd/core/enums/chat_type.dart';

class MessageModel {
  final String? message;
  final String messageId;
  final String? headline;
  final String? mainText;
  final MessageType messageType;
  final bool isReceived;
  final bool fileData;
  final bool isSparkdLine;

  MessageModel({
    this.headline,
    this.mainText,
    this.fileData = false,
    this.isSparkdLine = false,
    required this.message,
    required this.messageId,
    required this.messageType,
    required this.isReceived,
  });
}
