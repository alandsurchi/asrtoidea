import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import 'package:ai_idea_generator/domain/models/magic_idea_chat_model.dart';

class ChatItemWidget extends StatelessWidget {
  final MagicIdeaChatModel chatModel;
  final VoidCallback? onTap;

  const ChatItemWidget({Key? key, required this.chatModel, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 12.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: isRtl ? Alignment.centerRight : Alignment.centerLeft,
            end: isRtl ? Alignment.centerLeft : Alignment.centerRight,
            colors: [Color(0xFF3B1FCC), Color(0xFF6A59F1)],
          ),
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: isRtl
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    chatModel.title ?? "",
                    textDirection: isRtl
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    style: TextStyleHelper.instance.title16SemiBoldPoppins
                        .copyWith(color: Color(0xFFFFFFFF), height: 1.5),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    chatModel.description ?? "",
                    textDirection: isRtl
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    style: TextStyleHelper.instance.label11SemiBoldPoppins
                        .copyWith(color: Color(0xCCFFFFFF), height: 1.55),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.h),
            Container(
              width: 10.h,
              height: 10.h,
              margin: isRtl
                  ? EdgeInsets.only(left: 4.h, top: 2.h)
                  : EdgeInsets.only(right: 4.h, top: 2.h),
              decoration: BoxDecoration(
                color: chatModel.statusColor ?? Color(0xFFFBD060),
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            Text(
              chatModel.status ?? "",
              textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
              style: TextStyleHelper.instance.label11SemiBoldPoppins.copyWith(
                color: Color(0xFFFFFFFF),
                height: 1.55,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
