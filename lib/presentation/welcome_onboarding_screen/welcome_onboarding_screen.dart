import 'package:flutter/material.dart';

import '../../core/app_export.dart';

class WelcomeOnboardingScreen extends ConsumerStatefulWidget {
  WelcomeOnboardingScreen({Key? key}) : super(key: key);

  @override
  WelcomeOnboardingScreenState createState() => WelcomeOnboardingScreenState();
}

class WelcomeOnboardingScreenState
    extends ConsumerState<WelcomeOnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.white_A700,
        body: Container(
          width: double.maxFinite,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.only(top: 36.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 165.h,
                          margin: EdgeInsets.only(left: 38.h),
                          child: Text(
                            'Wanna start one ?',
                            style: TextStyleHelper
                                .instance
                                .headline32MediumKarla
                                .copyWith(height: 1.16),
                          ),
                        ),
                        SizedBox(height: 72.h),
                        CustomImageView(
                          imagePath: ImageConstant.imgIllustration,
                          height: 426.h,
                          width: double.maxFinite,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 40.h),
                        Container(
                          width: 212.h,
                          margin: EdgeInsets.symmetric(horizontal: 114.h),
                          child: Text(
                            'try to get Our idea using AI to enhance your productivity ',
                            textAlign: TextAlign.center,
                            style: TextStyleHelper.instance.title16RegularKarla
                                .copyWith(height: 1.12),
                          ),
                        ),
                        SizedBox(height: 68.h),
                        _buildPagerIndicator(),
                        SizedBox(height: 46.h),
                        _buildNextButton(),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPagerIndicator() {
    return Container(
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          final isActive = index == 1;
          return Container(
            width: isActive ? 24.h : 8.h,
            height: 8.h,
            margin: EdgeInsets.symmetric(horizontal: 4.h),
            decoration: BoxDecoration(
              color: isActive ? Color(0xFF007AFF) : appTheme.colorFFE0E0,
              borderRadius: BorderRadius.circular(4.0),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNextButton() {
    return Container(
      margin: EdgeInsets.only(right: 26.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              NavigatorService.pushNamed(
                AppRoutes.ideaCreationOnboardingScreen,
              );
            },
            child: Container(
              width: 56.h,
              height: 56.h,
              decoration: BoxDecoration(
                color: appTheme.whiteCustom,
                shape: BoxShape.circle,
                border: Border.all(color: Color(0xFF1A1A2E), width: 2.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(31),
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: Color(0xFF1A1A2E),
                  size: 24.h,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
