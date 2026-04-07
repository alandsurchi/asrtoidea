import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../core/utils/validators.dart';
import 'notifier/login_notifier.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF1D00FF), Color(0xFFFFFFFF)],
            ),
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopSection(context, isRtl),
                  SizedBox(height: 24.h),
                  _buildBottomSection(context, isRtl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget - Top section with background and welcome text
  Widget _buildTopSection(BuildContext context, bool isRtl) {
    return SizedBox(
      width: double.infinity,
      height: 582.h,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Background image
          CustomImageView(
            imagePath: ImageConstant.imgCircle6,
            width: double.infinity,
            height: 344.h,
            alignment: Alignment.topCenter,
          ),
          // Welcome text section
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: isRtl
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome Back!",
                  textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                  style: TextStyleHelper.instance.display40SemiBoldPoppins
                      .copyWith(height: 1.5, color: Color(0xFFEFEFEF)),
                ),
                Text(
                  "welcome back we missed you",
                  textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                  style: TextStyleHelper.instance.body14MediumPoppins.copyWith(
                    height: 1.6,
                    color: Color(0xFFDEDEDE),
                  ),
                ),
                SizedBox(height: 36.h),
                _buildLoginForm(context, isRtl),
              ],
            ),
          ),
          // Decorative shapes
          Positioned(
            left: isRtl ? null : 0.h,
            right: isRtl ? 0.h : null,
            top: 211.h,
            child: CustomImageView(
              imagePath: ImageConstant.imgFrontShapes,
              width: 68.h,
              height: 82.h,
            ),
          ),
          Positioned(
            right: isRtl ? null : 0.h,
            left: isRtl ? 0.h : null,
            top: 211.h,
            child: SizedBox(
              width: 94.h,
              height: 202.h,
              child: Stack(
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.imgFrontShapes100x94,
                    width: 94.h,
                    height: 100.h,
                    alignment: Alignment.bottomCenter,
                  ),
                  CustomImageView(
                    imagePath: ImageConstant.imgSaly16,
                    width: 70.h,
                    height: 202.h,
                    alignment: isRtl
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                  ),
                ],
              ),
            ),
          ),
          // Right decorative element
          Positioned(
            right: isRtl ? null : 0.h,
            left: isRtl ? 0.h : null,
            top: 93.h,
            child: CustomImageView(
              imagePath: ImageConstant.imgEllipse4,
              width: 162.h,
              height: 396.h,
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget - Login form
  Widget _buildLoginForm(BuildContext context, bool isRtl) {
    return Consumer(
      builder: (context, ref, _) {
        ref.watch(loginNotifier); // Watch for loading state changes

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 62.h),
          child: Column(
            crossAxisAlignment: isRtl
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: [
              // Username field
              Column(
                crossAxisAlignment: isRtl
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    "Email or Username",
                    textDirection: isRtl
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    style: TextStyleHelper.instance.body14MediumPoppins
                        .copyWith(color: Color(0xFFFFFFFF)),
                  ),
                  SizedBox(height: 8.h),
                  _buildTextField(
                    controller: _usernameController,
                    hintText: "Email or Username",
                    leftIcon: ImageConstant.imgVector,
                    keyboardType: TextInputType.text,
                    validator: (value) =>
                      Validators.required(value, label: 'Email or username'),
                    onChanged: (value) =>
                        ref.read(loginNotifier.notifier).updateUsername(value),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              // Password field
              Column(
                crossAxisAlignment: isRtl
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    "Password",
                    textDirection: isRtl
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    style: TextStyleHelper.instance.body14MediumPoppins
                        .copyWith(color: Color(0xFFFFFFFF)),
                  ),
                  SizedBox(height: 2.h),
                  _buildPasswordField(
                    controller: _passwordController,
                    validator: (value) => Validators.password(value),
                    onChanged: (value) =>
                        ref.read(loginNotifier.notifier).updatePassword(value),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              // Forgot password link
              GestureDetector(
                onTap: () => _onTapForgotPassword(context),
                child: Text(
                  "Forgot Password?",
                  textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                  style: TextStyleHelper.instance.label11MediumPoppins.copyWith(
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController? controller,
    required String hintText,
    required String leftIcon,
    required TextInputType keyboardType,
    required String? Function(String?)? validator,
    required Function(String) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0x33FFFFFF),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Color(0xFFFFFFFF).withAlpha(153), width: 1.0),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        onChanged: onChanged,
        style: TextStyleHelper.instance.body14MediumPoppins.copyWith(
          color: Color(0xFFFFFFFF),
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyleHelper.instance.body14MediumPoppins.copyWith(
            color: Color(0xCCFFFFFF),
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.all(12.h),
            child: CustomImageView(
              imagePath: leftIcon,
              height: 16.h,
              width: 16.h,
              fit: BoxFit.contain,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 14.h,
            horizontal: 14.h,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          filled: false,
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController? controller,
    required String? Function(String?)? validator,
    required Function(String) onChanged,
  }) {
    return _PasswordFieldWidget(
      controller: controller,
      validator: validator,
      onChanged: onChanged,
    );
  }

  /// Section Widget - Bottom section with sign in and social login
  Widget _buildBottomSection(BuildContext context, bool isRtl) {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(loginNotifier);

        // Listen for state changes
        ref.listen(loginNotifier, (previous, current) {
          if (current.isLoginSuccess ?? false) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Login successful!'),
                backgroundColor: appTheme.greenCustom,
              ),
            );
            // Navigate to main shell after successful login
            NavigatorService.pushNamedAndRemoveUntil(AppRoutes.mainShellScreen);
          }
          if (current.loginError != null && current.loginError!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(current.loginError!),
                backgroundColor: appTheme.redCustom,
              ),
            );
          }
        });

        return SizedBox(
          width: 382.h,
          height: 310.h,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              // Bottom decorative image
              Positioned(
                left: isRtl ? null : 0.h,
                right: isRtl ? 0.h : null,
                bottom: 15.h,
                child: CustomImageView(
                  imagePath: ImageConstant.imgEllipse5,
                  width: 204.h,
                  height: 296.h,
                ),
              ),
              // Main content
              Column(
                crossAxisAlignment: isRtl
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
                children: [
                  // Sign In button
                  Container(
                    width: 266.h,
                    margin: isRtl
                        ? EdgeInsets.only(left: 26.h)
                        : EdgeInsets.only(right: 26.h),
                    decoration: BoxDecoration(
                      color: Color(0xFF1D00FF),
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF1D00FF).withAlpha(102),
                          blurRadius: 20.h,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: state.isLoading ?? false
                          ? null
                          : () => _onTapSignIn(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appTheme.transparentCustom,
                        shadowColor: appTheme.transparentCustom,
                        padding: EdgeInsets.symmetric(
                          vertical: 14.h,
                          horizontal: 30.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: Text(
                        state.isLoading ?? false ? "Signing In..." : "Sign In",
                        style: TextStyleHelper.instance.headline24MediumPoppins
                            .copyWith(color: Color(0xFFFFFFFF), height: 1.5),
                      ),
                    ),
                  ),
                  SizedBox(height: 22.h),
                  // Or continue with section
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 10.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1.h,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xBFD9D9D9), Color(0xBFD9D9D9)],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.h),
                          child: Text(
                            "Or continue with",
                            textDirection: isRtl
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            style: TextStyleHelper.instance.label11MediumPoppins
                                .copyWith(color: Color(0xFFFFFFFF)),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1.h,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xBFD9D9D9), Color(0xBFD9D9D9)],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 22.h),
                  // Social login buttons
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 52.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () => _onTapGoogleLogin(context),
                          child: CustomImageView(
                            imagePath: ImageConstant.imgButtons,
                            width: 58.h,
                            height: 44.h,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _onTapAppleLogin(context),
                          child: CustomImageView(
                            imagePath: ImageConstant.imgButtonsWhiteA700,
                            width: 58.h,
                            height: 44.h,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _onTapFacebookLogin(context),
                          child: CustomImageView(
                            imagePath: ImageConstant.imgButtonsBlue800,
                            width: 58.h,
                            height: 44.h,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 22.h),
                  // Sign up link
                  Container(
                    padding: isRtl
                        ? EdgeInsets.only(left: 62.h)
                        : EdgeInsets.only(right: 62.h),
                    child: GestureDetector(
                      onTap: () => _onTapJoin(context),
                      child: RichText(
                        textDirection: isRtl
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Don't have an account?",
                              style: TextStyleHelper
                                  .instance
                                  .body14RegularPoppins
                                  .copyWith(color: Color(0xFF7F7F7F)),
                            ),
                            TextSpan(
                              text: " ",
                              style: TextStyleHelper
                                  .instance
                                  .body14MediumPoppins
                                  .copyWith(color: Color(0xFF000000)),
                            ),
                            TextSpan(
                              text: "Join",
                              style: TextStyleHelper
                                  .instance
                                  .body14MediumPoppins
                                  .copyWith(
                                    color: Color(0xFF000000),
                                    decoration: TextDecoration.underline,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }


  /// Navigation and action methods
  void _onTapSignIn(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(loginNotifier.notifier).signIn(
        _usernameController.text,
        _passwordController.text,
      );
    }
  }

  void _onTapForgotPassword(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Forgot password functionality will be implemented'),
        backgroundColor: appTheme.blueCustom,
      ),
    );
  }

  void _onTapGoogleLogin(BuildContext context) {
    ref.read(loginNotifier.notifier).signInWithGoogle();
  }

  void _onTapAppleLogin(BuildContext context) {
    ref.read(loginNotifier.notifier).signInWithApple();
  }

  void _onTapFacebookLogin(BuildContext context) {
    ref.read(loginNotifier.notifier).signInWithFacebook();
  }

  void _onTapJoin(BuildContext context) {
    NavigatorService.pushNamed(AppRoutes.signUpScreen);
  }
}

class _PasswordFieldWidget extends StatefulWidget {
  const _PasswordFieldWidget({
    Key? key,
    this.controller,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;

  @override
  State<_PasswordFieldWidget> createState() => _PasswordFieldWidgetState();
}

class _PasswordFieldWidgetState extends State<_PasswordFieldWidget> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0x33FFFFFF),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Color(0xFFFFFFFF).withAlpha(153), width: 1.0),
      ),
      child: TextFormField(
        controller: widget.controller,
        obscureText: !_isVisible,
        keyboardType: TextInputType.visiblePassword,
        validator: widget.validator,
        onChanged: widget.onChanged,
        style: TextStyleHelper.instance.body14MediumPoppins.copyWith(
          color: Color(0xFFFFFFFF),
        ),
        decoration: InputDecoration(
          hintText: "Password",
          hintStyle: TextStyleHelper.instance.body14MediumPoppins.copyWith(
            color: Color(0xCCFFFFFF),
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.all(12.h),
            child: CustomImageView(
              imagePath: ImageConstant.imgVectorWhiteA700,
              height: 16.h,
              width: 16.h,
              fit: BoxFit.contain,
            ),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _isVisible
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: Color(0xCCFFFFFF),
              size: 18.h,
            ),
            onPressed: () => setState(() => _isVisible = !_isVisible),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 14.h,
            horizontal: 14.h,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          filled: false,
        ),
      ),
    );
  }
}
