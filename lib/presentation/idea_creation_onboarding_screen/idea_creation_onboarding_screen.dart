import 'package:flutter/material.dart';

import '../../core/app_export.dart';

class IdeaCreationOnboardingScreen extends ConsumerStatefulWidget {
  IdeaCreationOnboardingScreen({Key? key}) : super(key: key);

  @override
  IdeaCreationOnboardingScreenState createState() =>
      IdeaCreationOnboardingScreenState();
}

class IdeaCreationOnboardingScreenState
    extends ConsumerState<IdeaCreationOnboardingScreen> {
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
                      children: [
                        _buildHeaderText(context),
                        _buildIllustrationImage(context),
                        _buildDescriptionText(context),
                        _buildPageIndicator(context),
                        _buildNextButton(context),
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

  Widget _buildHeaderText(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(left: 38.h),
      child: Row(
        children: [
          SizedBox(
            width: 184.h,
            child: Text(
              "Let's create our Idea ...",
              style: TextStyleHelper.instance.headline32MediumKarla.copyWith(
                height: 1.16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIllustrationImage(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(top: 70.h),
      child: CustomImageView(
        imagePath: ImageConstant.imgCaitiao101cai,
        height: 400.h,
        width: double.maxFinite,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildDescriptionText(BuildContext context) {
    return Container(
      width: 211.h,
      margin: EdgeInsets.only(top: 68.h),
      child: Text(
        "try to get Our idea using AI to enhance your productivity ",
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: TextStyleHelper.instance.title16RegularKarla.copyWith(
          height: 1.12,
        ),
      ),
    );
  }

  Widget _buildPageIndicator(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 70.h),
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          final isActive = index == 2;
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

  Widget _buildNextButton(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(top: 46.h, right: 26.h, bottom: 24.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              NavigatorService.pushNamed(AppRoutes.welcomeScreen);
            },
            child: Container(
              height: 52.h,
              padding: EdgeInsets.symmetric(horizontal: 28.h),
              decoration: BoxDecoration(
                color: Color(0xFF1A56DB),
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF1A56DB).withAlpha(89),
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Get Started',
                    style: TextStyleHelper.instance.title16SemiBoldSans
                        .copyWith(
                          color: appTheme.whiteCustom,
                          letterSpacing: 0.3,
                        ),
                  ),
                  SizedBox(width: 8.h),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: appTheme.whiteCustom,
                    size: 20.h,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
