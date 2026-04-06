import 'package:flutter/material.dart';

class IdeaAttachmentsWidget extends StatelessWidget {
  final List<String> attachments;

  const IdeaAttachmentsWidget({Key? key, required this.attachments})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    if (attachments.isEmpty) return const SizedBox();
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 0),
        reverse: isRtl,
        itemCount: attachments.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _showFullImage(context, attachments[index]),
            child: Hero(
              tag: 'attachment_$index',
              child: Container(
                width: 110,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(20),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    attachments[index],
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFFF0F0FF),
                      child: const Icon(
                        Icons.image_outlined,
                        color: Color(0xFF1D00FF),
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showFullImage(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () => Navigator.pop(ctx),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              url,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFFF0F0FF),
                height: 200,
                child: const Icon(
                  Icons.broken_image,
                  color: Color(0xFF1D00FF),
                  size: 40,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
