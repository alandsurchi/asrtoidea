import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import 'package:ai_idea_generator/domain/models/project_filter_tab_model.dart';

class ProjectFilterTabItem extends StatelessWidget {
  final ProjectFilterTabModel model;
  final bool isSelected;
  final VoidCallback? onTap;

  ProjectFilterTabItem({
    Key? key,
    required this.model,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF25282C) : Color(0xFFEBEBFF),
          borderRadius: BorderRadius.circular(18.h),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              model.title ?? '',
              style: TextStyleHelper.instance.title12MediumSFProText.copyWith(
                color: isSelected ? Color(0xFFFFFFFF) : Color(0xFF282828),
              ),
            ),
            SizedBox(width: 8.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.h, vertical: 2.h),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFFFBCA62) : Color(0xFFEBEBFF),
                borderRadius: BorderRadius.circular(10.h),
              ),
              child: Text(
                '${model.count ?? 0}',
                style: TextStyleHelper.instance.title12MediumSFProText.copyWith(
                  color: Color(0xFF25282C),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
