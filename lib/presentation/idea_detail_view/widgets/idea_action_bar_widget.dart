import 'package:flutter/material.dart';
import 'package:ai_idea_generator/domain/models/idea_detail_model.dart';

class IdeaActionBarWidget extends StatelessWidget {
  final IdeaDetailModel idea;
  final VoidCallback onLike;
  final VoidCallback onSave;
  final VoidCallback onEdit;
  final VoidCallback onShare;

  const IdeaActionBarWidget({
    Key? key,
    required this.idea,
    required this.onLike,
    required this.onSave,
    required this.onEdit,
    required this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final barColor = isDark ? const Color(0xFF1E1E2E) : Colors.white;
    final borderColor = isDark
        ? const Color(0xFF2A2A3E)
        : const Color(0xFFE8E8F4);

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: barColor,
        border: Border(top: BorderSide(color: borderColor, width: 1)),
      ),
      child: Row(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        children: [
          _buildActionChip(
            icon: idea.isLiked
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            label: '${idea.likeCount}',
            activeColor: const Color(0xFFFF3B30),
            isActive: idea.isLiked,
            onTap: onLike,
            isDark: isDark,
          ),
          const SizedBox(width: 10),
          _buildActionChip(
            icon: idea.isSaved
                ? Icons.bookmark_rounded
                : Icons.bookmark_border_rounded,
            label: idea.isSaved ? 'Saved' : 'Save',
            activeColor: isDark
                ? const Color(0xFF6A59F1)
                : const Color(0xFF1D00FF),
            isActive: idea.isSaved,
            onTap: onSave,
            isDark: isDark,
          ),
          const Spacer(),
          GestureDetector(
            onTap: onEdit,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1D00FF), Color(0xFF5B4BF5)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1D00FF).withAlpha(60),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.edit_rounded, color: Colors.white, size: 15),
                  const SizedBox(width: 6),
                  Text(
                    'Edit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionChip({
    required IconData icon,
    required String label,
    required Color activeColor,
    required bool isActive,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    final inactiveBg = isDark
        ? const Color(0xFF2A2A3E)
        : const Color(0xFFF4F4FA);
    final inactiveColor = isDark
        ? const Color(0xFF6B6B8A)
        : const Color(0xFF9E9EBE);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: isActive ? activeColor.withAlpha(20) : inactiveBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? activeColor.withAlpha(60) : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                icon,
                color: isActive ? activeColor : inactiveColor,
                size: 17,
                key: ValueKey(isActive),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isActive ? activeColor : inactiveColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
