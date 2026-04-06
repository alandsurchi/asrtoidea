import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../core/utils/validators.dart';
import 'notifier/sign_up_notifier.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends ConsumerState<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
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
              ref.watch(signUpNotifier); // Watch for rebuilds

              ref.listen(signUpNotifier, (previous, current) {
                if (current.isLoading ?? false) {}
                if (current.isSuccess ?? false) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Sign up successful!')),
                  );
                  NavigatorService.pushNamedAndRemoveUntil(
                    AppRoutes.mainShellScreen,
                  );
                }
                if (current.errorMessage?.isNotEmpty ?? false) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(current.errorMessage!)),
                  );
                }
              });

              return SingleChildScrollView(
                child: Container(
                  width: double.maxFinite,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: CustomImageView(
                          imagePath: ImageConstant.imgCircle6,
                          height: 344.h,
                          width: double.maxFinite,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 210.h,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 16.h),
                              child: CustomImageView(
                                imagePath: ImageConstant.imgFrontShapes,
                                height: 82.h,
                                width: 68.h,
                              ),
                            ),
                            Container(
                              width: 94.h,
                              height: 202.h,
                              child: Stack(
                                alignment: Alignment.centerRight,
                                children: [
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: CustomImageView(
                                      imagePath:
                                          ImageConstant.imgFrontShapes100x94,
                                      height: 100.h,
                                      width: double.maxFinite,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: CustomImageView(
                                      imagePath: ImageConstant.imgSaly16,
                                      height: 202.h,
                                      width: 70.h,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 92.h,
                        right: 0,
                        child: CustomImageView(
                          imagePath: ImageConstant.imgEllipse4270x296,
                          height: 270.h,
                          width: 296.h,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: CustomImageView(
                          imagePath: ImageConstant.imgEllipse5,
                          height: 296.h,
                          width: 204.h,
                        ),
                      ),
                      Positioned(
                        top: 92.h,
                        right: 0,
                        child: CustomImageView(
                          imagePath: ImageConstant.imgEllipse4,
                          height: 396.h,
                          width: 162.h,
                        ),
                      ),

                      // Main content
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 256.h),
                          _buildHeaderSection(context, isRtl),
                          SizedBox(height: 46.h),
                          _buildSignUpForm(context, ref, isRtl),
                          SizedBox(height: 46.h),
                          _buildLoginRedirect(context, isRtl),
                          SizedBox(height: 46.h),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildHeaderSection(BuildContext context, bool isRtl) {
    return Container(
      width: double.maxFinite,
      padding: isRtl
          ? EdgeInsets.only(right: 54.h)
          : EdgeInsets.only(left: 54.h),
      child: Column(
        crossAxisAlignment: isRtl
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(
            "Get Started Free",
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            style: TextStyleHelper.instance.display40SemiBoldPoppins.copyWith(
              color: Color(0xFFEFEFEF),
            ),
          ),
          SizedBox(height: 1.h),
          Padding(
            padding: isRtl
                ? EdgeInsets.only(right: 24.h)
                : EdgeInsets.only(left: 24.h),
            child: Text(
              "Free Forever. No Credit Card Needed",
              textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
              style: TextStyleHelper.instance.body14MediumPoppins.copyWith(
                color: Color(0xFFD1CBCB),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildSignUpForm(BuildContext context, WidgetRef ref, bool isRtl) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 56.h),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: isRtl
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            _buildEmailSection(context, ref, isRtl),
            SizedBox(height: 10.h),
            _buildNameSection(context, ref, isRtl),
            SizedBox(height: 10.h),
            _buildPasswordSection(context, ref, isRtl),
            SizedBox(height: 26.h),
            _buildSignUpButton(context, ref),
            SizedBox(height: 26.h),
            _buildSocialLoginSection(context, isRtl),
          ],
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildEmailSection(BuildContext context, WidgetRef ref, bool isRtl) {
    return Column(
      crossAxisAlignment: isRtl
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          "Email Adress",
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          style: TextStyleHelper.instance.body14MediumPoppins.copyWith(
            color: Color(0xFFFFFFFF),
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: Color(0x33FFFFFF),
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: Color(0xFFFFFFFF).withAlpha(153),
              width: 1.0,
            ),
          ),
          child: TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            style: TextStyleHelper.instance.body14MediumPoppins.copyWith(
              color: Color(0xFFFFFFFF),
            ),
            decoration: InputDecoration(
              hintText: "yourname@gmail.com",
              hintStyle: TextStyleHelper.instance.body14MediumPoppins.copyWith(
                color: Color(0xCCFFFFFF),
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.all(12.h),
                child: CustomImageView(
                  imagePath: ImageConstant.imgVectorWhiteA70016x18,
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
            validator: (value) => Validators.email(value),
            onChanged: (value) {
              ref.read(signUpNotifier.notifier).updateEmail(value);
            },
          ),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildNameSection(BuildContext context, WidgetRef ref, bool isRtl) {
    return Column(
      crossAxisAlignment: isRtl
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          "Your Name",
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          style: TextStyleHelper.instance.body14MediumPoppins.copyWith(
            color: Color(0xFFFFFFFF),
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          decoration: BoxDecoration(
            color: Color(0x33FFFFFF),
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: Color(0xFFFFFFFF).withAlpha(153),
              width: 1.0,
            ),
          ),
          child: TextFormField(
            controller: _nameController,
            keyboardType: TextInputType.text,
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            style: TextStyleHelper.instance.body14MediumPoppins.copyWith(
              color: Color(0xFFFFFFFF),
            ),
            decoration: InputDecoration(
              hintText: "@yourname",
              hintStyle: TextStyleHelper.instance.body14MediumPoppins.copyWith(
                color: Color(0xCCFFFFFF),
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.all(12.h),
                child: CustomImageView(
                  imagePath: ImageConstant.imgVector,
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
            validator: (value) => Validators.name(value),
            onChanged: (value) {
              ref.read(signUpNotifier.notifier).updateName(value);
            },
          ),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildPasswordSection(
    BuildContext context,
    WidgetRef ref,
    bool isRtl,
  ) {
    return Column(
      crossAxisAlignment: isRtl
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          "Password",
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          style: TextStyleHelper.instance.body14MediumPoppins.copyWith(
            color: Color(0xFFFFFFFF),
          ),
        ),
        SizedBox(height: 2.h),
        _SignUpPasswordField(
          controller: _passwordController,
          validator: (value) => Validators.password(value),
          onChanged: (value) {
            ref.read(signUpNotifier.notifier).updatePassword(value);
          },
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildSignUpButton(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signUpNotifier);

    return Container(
      width: double.maxFinite,
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
            : () => _onTapSignUp(context, ref),
        style: ElevatedButton.styleFrom(
          backgroundColor: appTheme.transparentCustom,
          shadowColor: appTheme.transparentCustom,
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 30.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: Text(
          state.isLoading ?? false ? "Signing Up..." : "Sign Up",
          style: TextStyleHelper.instance.headline24MediumPoppins.copyWith(
            color: Color(0xFFFFFFFF),
            height: 1.5,
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildSocialLoginSection(BuildContext context, bool isRtl) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(height: 1.h, color: Color(0xBFD9D9D9)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.h),
              child: Text(
                "Or continue with",
                textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                style: TextStyleHelper.instance.label11MediumPoppins.copyWith(
                  color: Color(0xFFFFFFFF),
                ),
              ),
            ),
            Expanded(
              child: Container(height: 1.h, color: Color(0xBFD9D9D9)),
            ),
          ],
        ),
        SizedBox(height: 18.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 56.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => _onTapGoogleLogin(context),
                child: CustomImageView(
                  imagePath: ImageConstant.imgButtons,
                  height: 44.h,
                  width: 58.h,
                ),
              ),
              GestureDetector(
                onTap: () => _onTapAppleLogin(context),
                child: CustomImageView(
                  imagePath: ImageConstant.imgButtonsWhiteA700,
                  height: 44.h,
                  width: 58.h,
                ),
              ),
              GestureDetector(
                onTap: () => _onTapFacebookLogin(context),
                child: CustomImageView(
                  imagePath: ImageConstant.imgButtonsBlue800,
                  height: 44.h,
                  width: 58.h,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildLoginRedirect(BuildContext context, bool isRtl) {
    return GestureDetector(
      onTap: () => _onTapLoginRedirect(context),
      child: RichText(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        text: TextSpan(
          children: [
            TextSpan(
              text: "Already have an account?",
              style: TextStyleHelper.instance.body14RegularPoppins.copyWith(
                color: Color(0xFF7F7F7F),
              ),
            ),
            TextSpan(
              text: " Log In",
              style: TextStyleHelper.instance.body14MediumPoppins.copyWith(
                color: Color(0xFF000000),
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Handles sign up button press
  void _onTapSignUp(BuildContext context, WidgetRef ref) {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(signUpNotifier.notifier).signUp(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      );
    }
  }

  /// Handles Google login
  void _onTapGoogleLogin(BuildContext context) {
    // Google sign-in implementation
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Google Sign-In pressed')));
  }

  /// Handles Apple login
  void _onTapAppleLogin(BuildContext context) {
    // Apple sign-in implementation
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Apple Sign-In pressed')));
  }

  /// Handles Facebook login
  void _onTapFacebookLogin(BuildContext context) {
    // Facebook sign-in implementation
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Facebook Sign-In pressed')));
  }

  /// Navigates to login screen
  void _onTapLoginRedirect(BuildContext context) {
    NavigatorService.pushNamed(AppRoutes.loginScreen);
  }
}

class _SignUpPasswordField extends StatefulWidget {
  const _SignUpPasswordField({
    Key? key,
    this.controller,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;

  @override
  State<_SignUpPasswordField> createState() => _SignUpPasswordFieldState();
}

class _SignUpPasswordFieldState extends State<_SignUpPasswordField> {
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
          hintText: "Strong",
          hintStyle: TextStyleHelper.instance.body14MediumPoppins.copyWith(
            color: Color(0xFF9EDAA1),
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
