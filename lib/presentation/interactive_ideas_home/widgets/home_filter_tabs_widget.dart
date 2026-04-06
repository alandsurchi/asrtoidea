import 'package:flutter/material.dart';
import '../../../theme/text_style_helper.dart';
import '../../../core/utils/size_utils.dart';

class HomeFilterTabsWidget extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const HomeFilterTabsWidget({
    Key? key,
    required this.selectedIndex,
    required this.onTabSelected,
  }) : super(key: key);

  static const List<Map<String, dynamic>> _tabs = [
    {'label': 'All', 'count': 24},
    {'label': 'In Progress', 'count': 10},
    {'label': 'To-do', 'count': 8},
    {'label': 'Completed', 'count': 6},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_tabs.length, (i) {
          final tab = _tabs[i];
          final isSelected = selectedIndex == i;
          return GestureDetector(
            onTap: () => onTabSelected(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              margin: EdgeInsets.only(right: 8.h),
              padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF1D00FF)
                    : const Color(0xFFF0F0FF),
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF1D00FF).withAlpha(77),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tab['label'] as String,
                    style: TextStyleHelper.instance.title13MediumPoppins
                        .copyWith(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF666688),
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                  ),
                  const SizedBox(width: 5),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withAlpha(64)
                          : const Color(0xFFDDDDFF),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      '${tab['count']}',
                      style: TextStyleHelper.instance.title12MediumPoppins
                          .copyWith(
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF1D00FF),
                          ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
