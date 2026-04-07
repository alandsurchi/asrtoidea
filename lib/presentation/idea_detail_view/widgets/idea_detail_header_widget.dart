import 'package:flutter/material.dart';
import 'package:ai_idea_generator/domain/models/idea_detail_model.dart';

class IdeaDetailHeaderWidget extends StatelessWidget {
  final IdeaDetailModel idea;
  final VoidCallback onBack;
  final VoidCallback onShare;
  final VoidCallback onMore;

  const IdeaDetailHeaderWidget({
    Key? key,
    required this.idea,
    required this.onBack,
    required this.onShare,
    required this.onMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1D00FF), Color(0xFF5B4BF5), Color(0xFF3D3AB8)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top nav row
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  GestureDetector(
                    onTap: onBack,
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(40),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isRtl
                            ? Icons.arrow_forward_ios_rounded
                            : Icons.arrow_back_ios_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                  // Right actions
                  Row(
                    textDirection: isRtl
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    children: [
                      GestureDetector(
                        onTap: onShare,
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(40),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.ios_share_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: onMore,
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(40),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.more_horiz_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Category + priority badges
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  _buildBadge(
                    idea.category,
                    Colors.white.withAlpha(50),
                    Colors.white,
                  ),
                  const SizedBox(width: 8),
                  _buildBadge(
                    idea.priority,
                    idea.priority.toLowerCase().contains('high')
                        ? const Color(0xFFFF3B30).withAlpha(200)
                        : const Color(0xFFFFB800).withAlpha(200),
                    Colors.white,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                idea.title,
                textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                  letterSpacing: -0.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 12),
            // Author + date row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundImage: (idea.creatorAvatar.trim().isNotEmpty)
                        ? NetworkImage(idea.creatorAvatar)
                        : null,
                    child: (idea.creatorAvatar.trim().isNotEmpty)
                        ? null
                        : const Icon(Icons.person, size: 14),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: isRtl
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          idea.creatorName.trim().isNotEmpty
                              ? idea.creatorName
                              : 'Unknown',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Created ${_formatCreatedDate(idea.createdDate)}',
                          style: TextStyle(
                            color: Colors.white.withAlpha(180),
                            fontSize: 11,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  String _formatCreatedDate(String value) {
    final raw = value.trim();
    if (raw.isEmpty) return 'Unknown';
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return raw;

    final month = _monthShort(parsed.month);
    return '$month ${parsed.day}, ${parsed.year}';
  }

  String _monthShort(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    if (month < 1 || month > 12) return 'Unknown';
    return months[month - 1];
  }

  Widget _buildBadge(String label, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
