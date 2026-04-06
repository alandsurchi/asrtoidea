import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ai_idea_generator/domain/models/idea_detail_model.dart';

class IdeaCommentSectionWidget extends StatefulWidget {
  final List<CommentModel> comments;
  final String commentText;
  final String? replyingToId;
  final String replyText;
  final Function(String) onCommentChanged;
  final VoidCallback onAddComment;
  final Function(String) onToggleCommentLike;
  final Function(String?) onSetReplyingTo;
  final Function(String) onReplyTextChanged;
  final Function(String) onAddReply;

  const IdeaCommentSectionWidget({
    Key? key,
    required this.comments,
    required this.commentText,
    required this.replyingToId,
    required this.replyText,
    required this.onCommentChanged,
    required this.onAddComment,
    required this.onToggleCommentLike,
    required this.onSetReplyingTo,
    required this.onReplyTextChanged,
    required this.onAddReply,
  }) : super(key: key);

  @override
  State<IdeaCommentSectionWidget> createState() =>
      _IdeaCommentSectionWidgetState();
}

class _IdeaCommentSectionWidgetState extends State<IdeaCommentSectionWidget> {
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _replyController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        crossAxisAlignment: isRtl
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFF1D00FF).withAlpha(18),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.chat_bubble_outline_rounded,
                  color: Color(0xFF1D00FF),
                  size: 14,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Comments',
                style: GoogleFonts.dmSans(
                  color: const Color(0xFF1A1A2E),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF1D00FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${widget.comments.length}',
                  style: GoogleFonts.dmSans(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Comment input
          Row(
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(
                  'https://i.pravatar.cc/150?img=3',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE8E8F4)),
                  ),
                  child: Row(
                    textDirection: isRtl
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          textDirection: isRtl
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          onChanged: widget.onCommentChanged,
                          decoration: InputDecoration(
                            hintText: 'Add a comment...',
                            hintStyle: GoogleFonts.dmSans(
                              color: const Color(0xFFB0B0C8),
                              fontSize: 13,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 11,
                            ),
                          ),
                          style: GoogleFonts.dmSans(
                            fontSize: 13,
                            color: const Color(0xFF2D2D3A),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _showEmojiPicker(context),
                        child: const Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Text('😊', style: TextStyle(fontSize: 17)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  widget.onAddComment();
                  _commentController.clear();
                },
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1D00FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Comments list
          ...widget.comments
              .map((comment) => _buildCommentItem(context, comment, isRtl))
              .toList(),
        ],
      ),
    );
  }

  void _showEmojiPicker(BuildContext context) {
    final emojis = ['😊', '👍', '🔥', '💡', '🎉', '❤️', '👏', '🚀'];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add Reaction',
              style: GoogleFonts.dmSans(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              children: emojis
                  .map(
                    (emoji) => GestureDetector(
                      onTap: () {
                        final newText = _commentController.text + emoji;
                        _commentController.text = newText;
                        widget.onCommentChanged(newText);
                        Navigator.pop(ctx);
                      },
                      child: Text(emoji, style: const TextStyle(fontSize: 28)),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentItem(
    BuildContext context,
    CommentModel comment,
    bool isRtl,
  ) {
    final isReplyingToThis = widget.replyingToId == comment.id;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: isRtl
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(comment.authorAvatar),
                onBackgroundImageError: (_, __) {},
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: isRtl
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: isRtl
                              ? const Radius.circular(14)
                              : const Radius.circular(4),
                          topRight: isRtl
                              ? const Radius.circular(4)
                              : const Radius.circular(14),
                          bottomLeft: const Radius.circular(14),
                          bottomRight: const Radius.circular(14),
                        ),
                        border: Border.all(color: const Color(0xFFE8E8F4)),
                      ),
                      child: Column(
                        crossAxisAlignment: isRtl
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            comment.authorName,
                            textDirection: isRtl
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            style: GoogleFonts.dmSans(
                              color: const Color(0xFF1D00FF),
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            comment.content,
                            textDirection: isRtl
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            style: GoogleFonts.dmSans(
                              color: const Color(0xFF2D2D3A),
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      textDirection: isRtl
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      children: [
                        Text(
                          comment.timeAgo,
                          style: GoogleFonts.dmSans(
                            color: const Color(0xFFB0B0C8),
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(width: 14),
                        GestureDetector(
                          onTap: () => widget.onToggleCommentLike(comment.id),
                          child: Row(
                            children: [
                              Icon(
                                comment.isLiked
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                color: comment.isLiked
                                    ? const Color(0xFFFF3B30)
                                    : const Color(0xFFB0B0C8),
                                size: 13,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                '${comment.likes}',
                                style: GoogleFonts.dmSans(
                                  color: const Color(0xFFB0B0C8),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        GestureDetector(
                          onTap: () => widget.onSetReplyingTo(
                            isReplyingToThis ? null : comment.id,
                          ),
                          child: Text(
                            isReplyingToThis ? 'Cancel' : 'Reply',
                            style: GoogleFonts.dmSans(
                              color: const Color(0xFF1D00FF),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Reply input
          if (isReplyingToThis)
            Padding(
              padding: EdgeInsets.only(
                left: isRtl ? 0 : 42,
                right: isRtl ? 42 : 0,
                top: 8,
              ),
              child: Row(
                textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE8E8F4)),
                      ),
                      child: TextField(
                        controller: _replyController,
                        textDirection: isRtl
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        onChanged: widget.onReplyTextChanged,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Write a reply...',
                          hintStyle: GoogleFonts.dmSans(
                            color: const Color(0xFFB0B0C8),
                            fontSize: 12,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                        ),
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          color: const Color(0xFF2D2D3A),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      widget.onAddReply(comment.id);
                      _replyController.clear();
                    },
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1D00FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          // Replies
          if (comment.replies.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(
                left: isRtl ? 0 : 42,
                right: isRtl ? 42 : 0,
                top: 8,
              ),
              child: Column(
                children: comment.replies
                    .map(
                      (reply) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          textDirection: isRtl
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 13,
                              backgroundImage: NetworkImage(reply.authorAvatar),
                              onBackgroundImageError: (_, __) {},
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0F0FF),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: isRtl
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      reply.authorName,
                                      textDirection: isRtl
                                          ? TextDirection.rtl
                                          : TextDirection.ltr,
                                      style: GoogleFonts.dmSans(
                                        color: const Color(0xFF1D00FF),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      reply.content,
                                      textDirection: isRtl
                                          ? TextDirection.rtl
                                          : TextDirection.ltr,
                                      style: GoogleFonts.dmSans(
                                        color: const Color(0xFF2D2D3A),
                                        fontSize: 12,
                                        height: 1.4,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      textDirection: isRtl
                                          ? TextDirection.rtl
                                          : TextDirection.ltr,
                                      children: [
                                        Text(
                                          reply.timeAgo,
                                          style: GoogleFonts.dmSans(
                                            color: const Color(0xFFB0B0C8),
                                            fontSize: 10,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Icon(
                                          reply.isLiked
                                              ? Icons.favorite_rounded
                                              : Icons.favorite_border_rounded,
                                          color: reply.isLiked
                                              ? const Color(0xFFFF3B30)
                                              : const Color(0xFFB0B0C8),
                                          size: 11,
                                        ),
                                        const SizedBox(width: 3),
                                        Text(
                                          '${reply.likes}',
                                          style: GoogleFonts.dmSans(
                                            color: const Color(0xFFB0B0C8),
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
