import 'package:flutter/material.dart';

import '../../core/app_export.dart';

class IdeaGenerationOnboardingScreen extends ConsumerStatefulWidget {
  IdeaGenerationOnboardingScreen({Key? key}) : super(key: key);

  @override
  IdeaGenerationOnboardingScreenState createState() =>
      IdeaGenerationOnboardingScreenState();
}

class IdeaGenerationOnboardingScreenState
    extends ConsumerState<IdeaGenerationOnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.white_A700,
        body: Container(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(top: 36.h),
              width: double.maxFinite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeadingSection(context),
                  _buildIllustrationSection(context),
                  _buildDescriptionSection(context),
                  _buildPageIndicatorSection(context),
                  _buildNextButtonSection(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeadingSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 36.h),
      child: Text(
        'Have An Idea ?',
        style: TextStyleHelper.instance.headline32MediumKarla.copyWith(
          height: 1.15,
        ),
      ),
    );
  }

  Widget _buildIllustrationSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 114.h),
      width: double.maxFinite,
      child: CustomImageView(
        imagePath: ImageConstant.imgTest1,
        height: 384.h,
        width: double.maxFinite,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildDescriptionSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40.h, left: 114.h, right: 114.h),
      child: Text(
        'try to get Our idea using AI to enhance your productivity ',
        textAlign: TextAlign.center,
        style: TextStyleHelper.instance.title16RegularKarla.copyWith(
          height: 1.12,
        ),
      ),
    );
  }

  Widget _buildPageIndicatorSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 68.h),
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          final isActive = index == 0;
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 4.h),
            height: 8.h,
            width: isActive ? 24.h : 8.h,
            decoration: BoxDecoration(
              color: isActive ? Color(0xFF007AFF) : appTheme.colorFFE0E0,
              borderRadius: BorderRadius.circular(4.0),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNextButtonSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 46.h, right: 26.h, bottom: 24.h),
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              NavigatorService.pushNamed(AppRoutes.welcomeOnboardingScreen);
            },
            child: Container(
              width: 56.h,
              height: 56.h,
              decoration: BoxDecoration(
                color: Color(0xFF1A1A2E),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF1A1A2E).withAlpha(89),
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: appTheme.whiteCustom,
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
