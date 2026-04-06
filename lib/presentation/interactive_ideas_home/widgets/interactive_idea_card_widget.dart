import 'package:flutter/material.dart';
import '../../../theme/text_style_helper.dart';
import '../../../core/utils/size_utils.dart';

class InteractiveIdeaCardWidget extends StatefulWidget {
  final String title;
  final String category;
  final String status;
  final String timeAgo;
  final Color cardColor;
  final String? imageUrl;
  final int likeCount;
  final int commentCount;
  final bool isLiked;
  final bool isSaved;
  final VoidCallback? onTap;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onSave;

  const InteractiveIdeaCardWidget({
    Key? key,
    required this.title,
    required this.category,
    required this.status,
    required this.timeAgo,
    required this.cardColor,
    this.imageUrl,
    this.likeCount = 0,
    this.commentCount = 0,
    this.isLiked = false,
    this.isSaved = false,
    this.onTap,
    this.onLike,
    this.onComment,
    this.onSave,
  }) : super(key: key);

  @override
  State<InteractiveIdeaCardWidget> createState() =>
      _InteractiveIdeaCardWidgetState();
}

class _InteractiveIdeaCardWidgetState extends State<InteractiveIdeaCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _likeController;
  late Animation<double> _likeScale;
  bool _isLiked = false;
  bool _isSaved = false;
  int _likeCount = 0;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;
    _isSaved = widget.isSaved;
    _likeCount = widget.likeCount;
    _likeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _likeScale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _likeController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _likeController.dispose();
    super.dispose();
  }

  void _handleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });
    _likeController.forward(from: 0);
    widget.onLike?.call();
  }

  void _handleSave() {
    setState(() {
      _isSaved = !_isSaved;
    });
    widget.onSave?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 14.h),
        decoration: BoxDecoration(
          color: widget.cardColor,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: widget.cardColor.withAlpha(89),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.imageUrl != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
                child: Image.network(
                  widget.imageUrl!,
                  height: 140.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 140.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          widget.cardColor.withAlpha(204),
                          widget.cardColor,
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.lightbulb_outline,
                      color: Colors.white54,
                      size: 48,
                    ),
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.all(16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildChip(widget.category, Colors.white24),
                      const SizedBox(width: 8),
                      _buildStatusChip(widget.status),
                      const Spacer(),
                      Text(
                        widget.timeAgo,
                        style: TextStyleHelper.instance.title12MediumPoppins
                            .copyWith(color: Colors.white60),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    widget.title,
                    style: TextStyleHelper.instance.title16SemiBoldPoppins
                        .copyWith(color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 14.h),
                  Row(
                    children: [
                      // Like button
                      ScaleTransition(
                        scale: _likeScale,
                        child: GestureDetector(
                          onTap: _handleLike,
                          child: Row(
                            children: [
                              Icon(
                                _isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: _isLiked
                                    ? const Color(0xFFFF6B6B)
                                    : Colors.white70,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$_likeCount',
                                style: TextStyleHelper
                                    .instance
                                    .title12MediumPoppins
                                    .copyWith(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 16.h),
                      // Comment button
                      GestureDetector(
                        onTap: widget.onComment,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.chat_bubble_outline,
                              color: Colors.white70,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.commentCount}',
                              style: TextStyleHelper
                                  .instance
                                  .title12MediumPoppins
                                  .copyWith(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // Save button
                      GestureDetector(
                        onTap: _handleSave,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: Icon(
                            _isSaved ? Icons.bookmark : Icons.bookmark_border,
                            key: ValueKey(_isSaved),
                            color: _isSaved
                                ? const Color(0xFFD4AF37)
                                : Colors.white70,
                            size: 22,
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
      ),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Text(
        label,
        style: TextStyleHelper.instance.title12MediumPoppins.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    switch (status.toLowerCase()) {
      case 'completed':
        chipColor = const Color(0xFF1DE4A2);
        break;
      case 'in progress':
        chipColor = const Color(0xFFFBD060);
        break;
      case 'generated':
        chipColor = const Color(0xFF7C3AED);
        break;
      default:
        chipColor = Colors.white38;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: chipColor.withAlpha(64),
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: chipColor.withAlpha(153), width: 1),
      ),
      child: Text(
        status,
        style: TextStyleHelper.instance.title12MediumPoppins.copyWith(
          color: chipColor,
        ),
      ),
    );
  }
}
