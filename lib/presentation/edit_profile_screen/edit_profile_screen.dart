import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_floating_text_field.dart';
import '../../widgets/custom_icon_button.dart';
import '../settings_screen/notifier/settings_notifier.dart';
import './notifier/edit_profile_notifier.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  EditProfileScreen({Key? key}) : super(key: key);

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers live here (stateful widget), NOT in Riverpod state
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _nickNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeProfile();
    });
  }

  Future<void> _initializeProfile() async {
    final settingsState = ref.read(settingsNotifier);
    await ref
        .read(editProfileNotifier.notifier)
        .initialize(settingsState.settingsModel);
    if (!mounted) return;
    _syncControllersFromState();
  }

  void _syncControllersFromState() {
    final profileState = ref.read(editProfileNotifier);
    final model = profileState.editProfileModel;
    _fullNameController.text = model?.fullName ?? '';
    _nickNameController.text = model?.nickName ?? '';
    _emailController.text = model?.email ?? '';
    _phoneController.text = model?.phone ?? '';
    _addressController.text = model?.address ?? '';
    _jobController.text = model?.job ?? '';
  }

  @override
  void dispose() {
    // Proper cleanup — guaranteed to happen once
    _fullNameController.dispose();
    _nickNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _jobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Form(
          key: _formKey,
          child: Consumer(
            builder: (context, ref, _) {
              final state = ref.watch(editProfileNotifier);

              ref.listen(editProfileNotifier, (previous, current) {
                if (current.isSuccess == true && previous?.isSuccess != true) {
                  _syncControllersFromState();
                  ref.read(settingsNotifier.notifier).reloadProfile();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Profile updated successfully'),
                      backgroundColor: appTheme.greenCustom,
                    ),
                  );
                }

                if (current.errorMessage != null && previous?.errorMessage != current.errorMessage) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(current.errorMessage!),
                      backgroundColor: appTheme.redCustom,
                    ),
                  );
                }
              });

              if (state.isLoading ?? false) {
                return const Center(child: CircularProgressIndicator());
              }

              return Container(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                      top: 16.h,
                      left: 18.h,
                      right: 18.h,
                    ),
                    child: Column(
                      spacing: 30.h,
                      children: [
                        _buildProfileHeader(context, state),
                        _buildFormFields(context, state),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, EditProfileState state) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    return Container(
      width: double.maxFinite,
      height: 288.h,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: 20.h),
              width: 176.h,
              height: 176.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE4E7EF), width: 2.h),
                color: const Color(0xFFF4F6FB),
              ),
              child: ClipOval(
                child: _buildProfileAvatar(state),
              ),
            ),
          ),
          Align(
            alignment: isRtl ? Alignment.topRight : Alignment.topLeft,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 40.h,
                height: 40.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Icon(
                  isRtl
                      ? Icons.arrow_forward_ios_rounded
                      : Icons.arrow_back_ios_new_rounded,
                  color: const Color(0xFF000000),
                  size: 18.h,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: 8.h),
              child: Text(
                'Edit Profile',
                style: TextStyleHelper.instance.headline24SemiBoldPoppins
                    .copyWith(height: 1.5, color: const Color(0xFF000000)),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 34.h,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 142.h),
                  child: CustomIconButton(
                    iconPath: ImageConstant.imgGroup358,
                    size: 28,
                    backgroundColor: const Color(0xFF1869FF),
                    borderRadius: BorderRadius.circular(14.h),
                    padding: EdgeInsets.all(2.h),
                    onTap: () => _onTapProfilePhoto(context),
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  child: CustomFloatingTextField(
                    labelText: 'Full Name',
                    suffixIconPath: ImageConstant.imgEdit2line,
                    controller: _fullNameController,
                    validator: (value) => _validateFullName(value),
                    onChanged: (value) =>
                        ref.read(editProfileNotifier.notifier).updateFullName(value),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields(BuildContext context, EditProfileState state) {
    return Column(
      spacing: 30.h,
      children: [
        CustomFloatingTextField(
          labelText: 'Nick Name',
          suffixIconPath: ImageConstant.imgEdit2line,
          controller: _nickNameController,
          validator: (value) => _validateNickName(value),
          onChanged: (value) =>
              ref.read(editProfileNotifier.notifier).updateNickName(value),
        ),
        CustomFloatingTextField(
          labelText: 'Email',
          suffixIconPath: ImageConstant.imgMail01,
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (value) => _validateEmail(value),
          onChanged: (value) =>
              ref.read(editProfileNotifier.notifier).updateEmail(value),
        ),
        CustomFloatingTextField(
          labelText: 'Phone',
          suffixIconPath: ImageConstant.imgIcon,
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          validator: (value) => _validatePhone(value),
          onChanged: (value) =>
              ref.read(editProfileNotifier.notifier).updatePhone(value),
        ),
        CustomFloatingTextField(
          labelText: 'Address',
          suffixIconPath: ImageConstant.imgMarker03,
          controller: _addressController,
          validator: (value) => _validateAddress(value),
          onChanged: (value) =>
              ref.read(editProfileNotifier.notifier).updateAddress(value),
        ),
        CustomFloatingTextField(
          labelText: 'Job',
          suffixIconPath: ImageConstant.imgLuggage04,
          controller: _jobController,
          validator: (value) => _validateJob(value),
          onChanged: (value) =>
              ref.read(editProfileNotifier.notifier).updateJob(value),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 32.h),
          width: double.maxFinite,
          height: 56.h,
          child: ElevatedButton(
            onPressed: () => _onTapSaveProfile(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1D00FF),
              foregroundColor: appTheme.whiteCustom,
              elevation: 4,
              shadowColor: const Color(0xFF1D00FF).withAlpha(102),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            child: Text(
              'Submit',
              style: TextStyleHelper.instance.title16SemiBoldSans.copyWith(
                color: appTheme.whiteCustom,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileAvatar(EditProfileState state) {
    final imagePath = state.editProfileModel?.profileImagePath?.trim() ?? '';
    if (imagePath.isNotEmpty) {
      return CustomImageView(
        imagePath: imagePath,
        width: 176.h,
        height: 176.h,
        fit: BoxFit.cover,
      );
    }

    final initials = _extractInitials(
      state.editProfileModel?.fullName,
      state.editProfileModel?.email,
    );

    return Container(
      width: 176.h,
      height: 176.h,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFDEE4FF), Color(0xFFC8D2FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Text(
        initials,
        style: TextStyleHelper.instance.headline24SemiBoldPoppins.copyWith(
          color: const Color(0xFF1D2B53),
        ),
      ),
    );
  }

  String _extractInitials(String? fullName, String? email) {
    final name = fullName?.trim() ?? '';
    if (name.isNotEmpty) {
      final parts = name
          .split(RegExp(r'\s+'))
          .where((part) => part.isNotEmpty)
          .toList();
      if (parts.length >= 2) {
        return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
      }
      return parts.first[0].toUpperCase();
    }

    final trimmedEmail = email?.trim() ?? '';
    if (trimmedEmail.isNotEmpty) {
      return trimmedEmail[0].toUpperCase();
    }

    return '?';
  }

  String? _validateFullName(String? value) {
    if (value?.isEmpty == true) return 'Full name is required';
    if (value!.trim().length < 2) return 'Full name must be at least 2 characters';
    return null;
  }

  String? _validateNickName(String? value) {
    if (value?.isEmpty == true) return 'Nick name is required';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value?.isEmpty == true) return 'Email is required';
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value!)) return 'Invalid email format';
    return null;
  }

  String? _validatePhone(String? value) {
    if (value?.isEmpty == true) return 'Phone number is required';
    if (!RegExp(r'^\+?[0-9\s\-\(\)]+$').hasMatch(value!)) return 'Invalid phone number format';
    return null;
  }

  String? _validateAddress(String? value) {
    if (value?.isEmpty == true) return 'Address is required';
    return null;
  }

  String? _validateJob(String? value) {
    if (value?.isEmpty == true) return 'Job is required';
    return null;
  }

  void _onTapProfilePhoto(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return Container(
          height: 150.h,
          padding: EdgeInsets.all(16.h),
          child: Column(
            children: [
              Text('Select Profile Photo',
                  style: TextStyleHelper.instance.headline18SemiBoldSans),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(ctx);
                      _capturePhotoFromCamera();
                    },
                    child: Column(children: [
                      Icon(Icons.camera_alt, size: 40.h),
                      SizedBox(height: 8.h),
                      const Text('Camera'),
                    ]),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(ctx);
                      _selectPhotoFromGallery();
                    },
                    child: Column(children: [
                      Icon(Icons.photo_library, size: 40.h),
                      SizedBox(height: 8.h),
                      const Text('Gallery'),
                    ]),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _capturePhotoFromCamera() async {
    final cameraPermission = await Permission.camera.request();
    if (cameraPermission.isGranted) {
      final ImagePicker picker = ImagePicker();
      final XFile? photo = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      if (photo != null) {
        ref.read(editProfileNotifier.notifier).updateProfileImage(photo.path);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Camera permission is required to capture photo'),
          backgroundColor: appTheme.redCustom,
        ),
      );
    }
  }

  void _selectPhotoFromGallery() async {
    final storagePermission = await Permission.photos.request();
    if (storagePermission.isGranted) {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      if (image != null) {
        ref.read(editProfileNotifier.notifier).updateProfileImage(image.path);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Storage permission is required to select photo'),
          backgroundColor: appTheme.redCustom,
        ),
      );
    }
  }

  void _onTapSaveProfile(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(editProfileNotifier.notifier).saveProfile();
    }
  }
}
