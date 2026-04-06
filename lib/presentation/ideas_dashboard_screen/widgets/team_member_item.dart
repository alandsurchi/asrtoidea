import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import 'package:ai_idea_generator/domain/models/ideas_dashboard_model.dart';

class TeamMemberItem extends StatelessWidget {
  final TeamMemberModel? member;

  TeamMemberItem({Key? key, required this.member}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28.h,
      height: 30.h,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14.h)),
      child: CustomImageView(
        imagePath: member?.profileImage ?? '',
        height: 30.h,
        width: 28.h,
        fit: BoxFit.cover,
      ),
    );
  }
}
