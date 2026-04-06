import 'package:flutter/material.dart';
import '../../../theme/text_style_helper.dart';
import '../../../core/utils/size_utils.dart';

class IdeaDetailBottomSheet extends StatefulWidget {
  final String title;
  final String category;
  final String status;
  final String description;
  final String author;
  final String timeAgo;
  final Color cardColor;
  final int likeCount;
  final int commentCount;
  final bool isLiked;
  final bool isSaved;

  const IdeaDetailBottomSheet({
    Key? key,
    required this.title,
    required this.category,
    required this.status,
    required this.description,
    required this.author,
    required this.timeAgo,
    required this.cardColor,
    this.likeCount = 0,
    this.commentCount = 0,
    this.isLiked = false,
    this.isSaved = false,
  }) : super(key: key);

  @override
  State<IdeaDetailBottomSheet> createState() => _IdeaDetailBottomSheetState();
}

class _IdeaDetailBottomSheetState extends State<IdeaDetailBottomSheet> {
  bool _isLiked = false;
  bool _isSaved = false;
  int _likeCount = 0;
  final TextEditingController _commentController = TextEditingController();
  final List<Map<String, String>> _comments = [
    {
      'author': 'Sara K.',
      'text': 'This is a brilliant idea! Love the concept.',
      'time': '2h ago',
    },
    {
      'author': 'Mike R.',
      'text': 'Would love to see this implemented.',
      'time': '4h ago',
    },
  ];

  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;
    _isSaved = widget.isSaved;
    _likeCount = widget.likeCount;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _addComment() {
    if (_commentController.text.trim().isEmpty) return;
    setState(() {
      _comments.insert(0, {
        'author': 'You',
        'text': _commentController.text.trim(),
        'time': 'Just now',
      });
      _commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF0F0F1A),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.all(20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: widget.cardColor.withAlpha(64),
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                color: widget.cardColor.withAlpha(128),
                              ),
                            ),
                            child: Text(
                              widget.category,
                              style: TextStyleHelper
                                  .instance
                                  .title12MediumPoppins
                                  .copyWith(color: widget.cardColor),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            widget.timeAgo,
                            style: TextStyleHelper.instance.title12MediumPoppins
                                .copyWith(color: Colors.white38),
                          ),
                        ],
                      ),
                      SizedBox(height: 14.h),
                      Text(
                        widget.title,
                        style: TextStyleHelper
                            .instance
                            .headline20SemiBoldPoppins
                            .copyWith(color: Colors.white),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          const Icon(
                            Icons.person_outline,
                            color: Colors.white38,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.author,
                            style: TextStyleHelper.instance.title13MediumPoppins
                                .copyWith(color: Colors.white54),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      // Description
                      Container(
                        padding: EdgeInsets.all(16.h),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(13),
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Text(
                          widget.description,
                          style: TextStyleHelper.instance.body14RegularPoppins
                              .copyWith(color: Colors.white70, height: 1.6),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      // Action row
                      Row(
                        children: [
                          _buildActionButton(
                            icon: _isLiked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            label: '$_likeCount',
                            color: _isLiked
                                ? const Color(0xFFFF6B6B)
                                : Colors.white54,
                            onTap: () => setState(() {
                              _isLiked = !_isLiked;
                              _likeCount += _isLiked ? 1 : -1;
                            }),
                          ),
                          SizedBox(width: 12.h),
                          _buildActionButton(
                            icon: Icons.chat_bubble_outline,
                            label: '${_comments.length}',
                            color: Colors.white54,
                            onTap: () {},
                          ),
                          const Spacer(),
                          _buildActionButton(
                            icon: _isSaved
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            label: _isSaved ? 'Saved' : 'Save',
                            color: _isSaved
                                ? const Color(0xFFD4AF37)
                                : Colors.white54,
                            onTap: () => setState(() => _isSaved = !_isSaved),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      // Comments section
                      Text(
                        'Comments',
                        style: TextStyleHelper.instance.title16SemiBoldPoppins
                            .copyWith(color: Colors.white),
                      ),
                      SizedBox(height: 12.h),
                      // Comment input
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(18),
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(color: Colors.white12),
                              ),
                              child: TextField(
                                controller: _commentController,
                                style: TextStyleHelper
                                    .instance
                                    .body14RegularPoppins
                                    .copyWith(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Add a comment...',
                                  hintStyle: TextStyleHelper
                                      .instance
                                      .body14RegularPoppins
                                      .copyWith(color: Colors.white30),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 14.h,
                                    vertical: 10.h,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.h),
                          GestureDetector(
                            onTap: _addComment,
                            child: Container(
                              padding: EdgeInsets.all(10.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFF7C3AED),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: const Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      // Comments list
                      ..._comments.map((c) => _buildCommentItem(c)).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: color.withAlpha(26),
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(color: color.withAlpha(77)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyleHelper.instance.title13MediumPoppins.copyWith(
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentItem(Map<String, String> comment) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(13),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                comment['author'] ?? '',
                style: TextStyleHelper.instance.title13SemiBoldPoppins.copyWith(
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Text(
                comment['time'] ?? '',
                style: TextStyleHelper.instance.title12MediumPoppins.copyWith(
                  color: Colors.white38,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            comment['text'] ?? '',
            style: TextStyleHelper.instance.body14RegularPoppins.copyWith(
              color: Colors.white60,
            ),
          ),
        ],
      ),
    );
  }
}
