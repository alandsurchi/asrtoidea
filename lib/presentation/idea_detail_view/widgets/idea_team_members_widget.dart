import 'package:flutter/material.dart';

class IdeaTeamMembersWidget extends StatelessWidget {
  final List<String> teamMembers;

  const IdeaTeamMembersWidget({Key? key, required this.teamMembers})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    final roles = [
      'Lead Designer',
      'Developer',
      'Product Manager',
      'UX Researcher',
    ];
    final names = ['Sarah Chen', 'Alex Kim', 'Marcus J.', 'Priya P.'];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: teamMembers.asMap().entries.map((entry) {
        final index = entry.key;
        return _buildMemberChip(
          context,
          entry.value,
          names[index % names.length],
          roles[index % roles.length],
          isRtl,
        );
      }).toList(),
    );
  }

  Widget _buildMemberChip(
    BuildContext context,
    String avatarUrl,
    String name,
    String role,
    bool isRtl,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8E8F4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(avatarUrl),
            onBackgroundImageError: (_, __) {},
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: isRtl
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: const Color(0xFF2D2D3A),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                role,
                style: TextStyle(color: const Color(0xFF9E9EBE), fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
