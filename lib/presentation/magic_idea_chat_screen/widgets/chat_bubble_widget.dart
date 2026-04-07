import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../domain/models/magic_idea_chat_model.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatBubbleWidget extends StatelessWidget {
  final ChatMessage message;

  const ChatBubbleWidget({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isUser = message.isUser;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) _buildAvatar(isDark),
          if (!isUser) SizedBox(width: 8.h),
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.h),
              decoration: BoxDecoration(
                color: isUser 
                    ? const Color(0xFF6A59F1) 
                    : (isDark ? const Color(0xFF2A2A3E) : const Color(0xFFF3F3F3)),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isUser ? 20 : 0),
                  bottomRight: Radius.circular(isUser ? 0 : 20),
                ),
              ),
              child: isUser
                  ? Text(
                      message.text,
                      style: TextStyleHelper.instance.body14MediumPoppins.copyWith(
                        color: Colors.white,
                      ),
                    )
                  : MarkdownBody(
                      data: message.text,
                      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                        p: TextStyleHelper.instance.body14RegularPoppins.copyWith(
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
            ),
          ),
          if (isUser) SizedBox(width: 8.h),
          if (isUser) _buildUserAvatar(isDark),
        ],
      ),
    );
  }

  Widget _buildAvatar(bool isDark) {
    return Container(
      width: 30.h,
      height: 30.h,
      decoration: BoxDecoration(
        color: const Color(0xFF6A59F1).withAlpha(40),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          Icons.auto_awesome,
          color: const Color(0xFF6A59F1),
          size: 16.h,
        ),
      ),
    );
  }

  Widget _buildUserAvatar(bool isDark) {
    return Container(
      width: 30.h,
      height: 30.h,
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(50),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          Icons.person,
          color: isDark ? Colors.white70 : Colors.black54,
          size: 18.h,
        ),
      ),
    );
  }
}
