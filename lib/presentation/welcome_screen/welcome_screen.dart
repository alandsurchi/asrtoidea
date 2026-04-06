import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import 'notifier/welcome_notifier.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  WelcomeScreen({Key? key}) : super(key: key);

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF1D00FF), Color(0xFFFFFFFF)],
            ),
          ),
          child: Consumer(
            builder: (context, ref, _) {
              ref.watch(welcomeNotifier); // Watch for rebuilds

              ref.listen(welcomeNotifier, (previous, current) {
                if (current.shouldNavigate ?? false) {
                  if (current.navigateToSignIn ?? false) {
                    NavigatorService.pushNamed(AppRoutes.loginScreen);
                  } else if (current.navigateToSignUp ?? false) {
                    NavigatorService.pushNamed(AppRoutes.signUpScreen);
                  }
                }
              });

              return SingleChildScrollView(
                child: Column(
                  children: [
                    _buildWelcomeSection(context),
                    _buildSignInButton(context),
                    _buildSignUpButton(context),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildWelcomeSection(BuildContext context) {
    final screenH = MediaQuery.sizeOf(context).height;
    final stackHeight = math.max(380.h, math.min(screenH * 0.52, 620.h));

    return SizedBox(
      width: double.maxFinite,
      height: stackHeight,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.fromLTRB(24.h, 36.h, 24.h, 16.h),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF5B4DFF),
                    Color(0xFF1D00FF),
                    Color(0xFF2A1ACC),
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 8.h),
                  Text(
                    'Welcome =)',
                    style: TextStyleHelper.instance.display36RegularJua
                        .copyWith(height: 1.2, color: const Color(0xFFFFFFFF)),
                  ),
                  SizedBox(height: 20.h),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 280.h),
                    child: Text(
                      'Hi there!\nwe\'re pleasure to see you to generate your Idea By using AI',
                      textAlign: TextAlign.center,
                      style: TextStyleHelper.instance.title16RegularJua
                          .copyWith(height: 1.35, color: const Color(0xFFFFFFFF)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              child: CustomImageView(
                imagePath: ImageConstant.imgIllustration,
                height: math.min(320.h, stackHeight * 0.55),
                width: double.maxFinite,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildSignInButton(BuildContext context) {
    return GestureDetector(
      onTap: () => onTapSignIn(context),
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(top: 32.h, left: 40.h, right: 40.h),
        height: 52.h,
        decoration: BoxDecoration(
          color: Color(0xFF1D00FF),
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF1D00FF).withAlpha(80),
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'Sign In',
            style: TextStyleHelper.instance.headline24MediumPoppins.copyWith(
              color: Color(0xFFFFFFFF),
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildSignUpButton(BuildContext context) {
    return GestureDetector(
      onTap: () => onTapSignUp(context),
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(
          top: 16.h,
          left: 40.h,
          right: 40.h,
          bottom: 42.h,
        ),
        height: 52.h,
        decoration: BoxDecoration(
          color: appTheme.transparentCustom,
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(color: Color(0xFF1D00FF), width: 1.5),
        ),
        child: Center(
          child: Text(
            'Sign Up',
            style: TextStyleHelper.instance.headline24MediumPoppins.copyWith(
              color: Color(0xFF1D00FF),
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  /// Handles Sign In button tap
  void onTapSignIn(BuildContext context) {
    ref.read(welcomeNotifier.notifier).navigateToSignIn();
  }

  /// Handles Sign Up button tap
  void onTapSignUp(BuildContext context) {
    ref.read(welcomeNotifier.notifier).navigateToSignUp();
  }
}
