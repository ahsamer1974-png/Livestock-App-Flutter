import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ChatBubbleWidget extends StatelessWidget {
  final String text;
  final String time;
  final bool isMine;

  const ChatBubbleWidget({
    Key? key,
    required this.text,
    required this.time,
    required this.isMine,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: isMine ? AppColors.primary : Colors.grey.shade200,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMine ? 16 : 0),
            bottomRight: Radius.circular(isMine ? 0 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: TextStyle(color: isMine ? Colors.white : Colors.black87, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(color: isMine ? Colors.white70 : Colors.black54, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}