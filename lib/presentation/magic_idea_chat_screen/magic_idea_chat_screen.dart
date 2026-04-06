import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/app_export.dart';
import 'package:ai_idea_generator/domain/models/magic_idea_chat_model.dart';
import './widgets/chat_item_widget.dart';
import 'notifier/magic_idea_chat_notifier.dart';

class MagicIdeaChatScreen extends ConsumerStatefulWidget {
  const MagicIdeaChatScreen({Key? key}) : super(key: key);

  @override
  MagicIdeaChatScreenState createState() => MagicIdeaChatScreenState();
}

class MagicIdeaChatScreenState extends ConsumerState<MagicIdeaChatScreen> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController messageController = TextEditingController();

  String _selectedModel = 'Gemini';

  final List<Map<String, dynamic>> _aiModels = [
    {
      'name': 'Gemini',
      'label': 'Gemini',
      'color': const Color(0xFF1D00FF),
      'icon': Icons.auto_awesome,
    },
    {
      'name': 'GPT-4',
      'label': 'GPT-4',
      'color': const Color(0xFF10A37F),
      'icon': Icons.psychology_rounded,
    },
    {
      'name': 'Claude',
      'label': 'Claude',
      'color': const Color(0xFFD97706),
      'icon': Icons.smart_toy_rounded,
    },
    {
      'name': 'Perplexity',
      'label': 'Perplexity',
      'color': const Color(0xFF20B2AA),
      'icon': Icons.search_rounded,
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF1A0080), const Color(0xFF0F0F1A)]
                : [const Color(0xFF1D00FF), const Color(0xFFFFFFFF)],
            stops: const [0.0, 0.65],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  _buildTopDecorativeRow(context),
                  SizedBox(height: 4.h),
                  _buildTitleRow(context),
                  SizedBox(height: 4.h),
                  _buildBottomDecorativeRow(context),
                  SizedBox(height: 20.h),
                  _buildNewChatButton(context),
                  SizedBox(height: 14.h),
                  _buildChatCard(context),
                  SizedBox(height: 24.h),
                  _buildPreviousChatsSection(context),
                  SizedBox(height: 120.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopDecorativeRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 60.h, top: 6.h),
          child: CustomImageView(
            imagePath: ImageConstant.imgIconMagicPencil,
            height: 34.h,
            width: 34.h,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 60.h),
          child: CustomImageView(
            imagePath: ImageConstant.imgIconMagicBrush,
            height: 34.h,
            width: 34.h,
          ),
        ),
      ],
    );
  }

  Widget _buildTitleRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: CustomImageView(
            imagePath: ImageConstant.imgIconTypePrompt,
            height: 34.h,
            width: 34.h,
          ),
        ),
        SizedBox(width: 16.h),
        Text(
          "Magic Idea",
          style: TextStyleHelper.instance.display38RegularLemon.copyWith(
            color: const Color(0xFFFFFFFF),
            height: 1.3,
          ),
        ),
        SizedBox(width: 10.h),
        Padding(
          padding: EdgeInsets.only(top: 20.h),
          child: CustomImageView(
            imagePath: ImageConstant.imgIconVoiceGen,
            height: 34.h,
            width: 34.h,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomDecorativeRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 50.h, bottom: 10.h),
          child: CustomImageView(
            imagePath: ImageConstant.imgIconAiGenerate,
            height: 34.h,
            width: 34.h,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 90.h),
          child: CustomImageView(
            imagePath: ImageConstant.imgIconGenerateB,
            height: 34.h,
            width: 34.h,
          ),
        ),
      ],
    );
  }

  Widget _buildNewChatButton(BuildContext context) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    final loc = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: _onNewChatTap,
      child: Row(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgEditContained,
            height: 22.h,
            width: 22.h,
          ),
          SizedBox(width: 8.h),
          Text(
            loc.newChat,
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            style: TextStyleHelper.instance.title13RegularLemon.copyWith(
              color: const Color(0xFFFFFFFF),
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImageConstant.imgRectangle29),
          fit: BoxFit.fill,
        ),
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Column(
        children: [_buildChatCardHeader(context), _buildChatInputArea(context)],
      ),
    );
  }

  Widget _buildChatCardHeader(BuildContext context) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    final loc = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.only(left: 18.h, right: 18.h, top: 18.h, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  loc.whatIdeaToday,
                  textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                  style: TextStyleHelper.instance.headline18RegularPoppins
                      .copyWith(color: const Color(0xFFFFFBFB), height: 1.15),
                ),
              ),
              SizedBox(width: 8.h),
              GestureDetector(
                onTap: () => _showModelPicker(context),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.h,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: const Color(0x3F000000),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    textDirection: isRtl
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    children: [
                      Icon(
                        _aiModels.firstWhere(
                              (m) => m['name'] == _selectedModel,
                              orElse: () => _aiModels[0],
                            )['icon']
                            as IconData,
                        size: 14.h,
                        color:
                            _aiModels.firstWhere(
                                  (m) => m['name'] == _selectedModel,
                                  orElse: () => _aiModels[0],
                                )['color']
                                as Color,
                      ),
                      SizedBox(width: 5.h),
                      Text(
                        _selectedModel,
                        style: TextStyleHelper.instance.title13MediumPoppins
                            .copyWith(
                              color: const Color(0xFF000000),
                              height: 1.5,
                            ),
                      ),
                      SizedBox(width: 6.h),
                      CustomImageView(
                        imagePath: ImageConstant.imgArrowdown,
                        height: 20.h,
                        width: 22.h,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: () => _onDesignTap(context),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF).withAlpha(220),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.auto_awesome,
                    color: const Color(0xFF6A59F1),
                    size: 16.h,
                  ),
                  SizedBox(width: 6.h),
                  Text(
                    loc.design,
                    style: TextStyleHelper.instance.title13SemiBoldPoppins
                        .copyWith(color: const Color(0xFF6A59F1)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showModelPicker(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? const Color(0xFF1E1E2E) : Colors.white;
    final handleColor = isDark
        ? const Color(0xFF2A2A3E)
        : const Color(0xFFE0E0E0);
    final titleColor = isDark ? Colors.white : const Color(0xFF000000);
    final subTextColor = isDark
        ? const Color(0xFF9E9E9E)
        : const Color(0xFF888888);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: sheetBg,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24.0),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.h,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: handleColor,
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                loc.chooseAiModel,
                style: TextStyleHelper.instance.title16SemiBoldPoppins.copyWith(
                  color: titleColor,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                loc.chooseAiModelDesc,
                style: TextStyleHelper.instance.title13LightPoppins.copyWith(
                  color: subTextColor,
                ),
              ),
              SizedBox(height: 16.h),
              ..._aiModels.map((model) {
                final bool isSelected = _selectedModel == model['name'];
                final cardBg = isSelected
                    ? (model['color'] as Color).withAlpha(20)
                    : (isDark
                          ? const Color(0xFF2A2A3E)
                          : const Color(0xFFF8F8F8));
                final cardBorder = isSelected
                    ? (model['color'] as Color)
                    : (isDark
                          ? const Color(0xFF3A3A5E)
                          : const Color(0xFFE8E8E8));
                return GestureDetector(
                  onTap: () {
                    final selectedName = model['name'] as String;
                    setState(() {
                      _selectedModel = selectedName;
                    });
                    ref.read(magicIdeaChatNotifier.notifier).updateAiModel(selectedName);
                    Navigator.pop(ctx);
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.h,
                      vertical: 14.h,
                    ),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(14.0),
                      border: Border.all(
                        color: cardBorder,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40.h,
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: (model['color'] as Color).withAlpha(25),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Icon(
                            model['icon'] as IconData,
                            color: model['color'] as Color,
                            size: 22.h,
                          ),
                        ),
                        SizedBox(width: 14.h),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                model['label'] as String,
                                style: TextStyleHelper
                                    .instance
                                    .title14SemiBoldPoppins
                                    .copyWith(
                                      color: isDark
                                          ? Colors.white
                                          : const Color(0xFF000000),
                                    ),
                              ),
                              Text(
                                _modelDescription(model['name'] as String, loc),
                                style: TextStyleHelper
                                    .instance
                                    .title13LightPoppins
                                    .copyWith(color: subTextColor),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle_rounded,
                            color: model['color'] as Color,
                            size: 20.h,
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  String _modelDescription(String modelName, AppLocalizations loc) {
    switch (modelName) {
      case 'Gemini':
        return loc.geminiDesc;
      case 'GPT-4':
        return loc.gpt4Desc;
      case 'Claude':
        return loc.claudeDesc;
      case 'Perplexity':
        return loc.perplexityDesc;
      default:
        return '';
    }
  }

  Widget _buildChatInputArea(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.only(left: 18.h, right: 18.h, top: 18.h, bottom: 0),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0x99FFFFFF),
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: TextField(
              controller: messageController,
              maxLines: 4,
              minLines: 3,
              style: TextStyleHelper.instance.title14LightPoppins.copyWith(
                color: const Color(0x5E000000),
              ),
              decoration: InputDecoration(
                hintText: loc.chatHint,
                hintStyle: TextStyleHelper.instance.title13LightPoppins
                    .copyWith(color: const Color(0x5E000000), height: 1.4),
                contentPadding: EdgeInsets.only(
                  left: 18.h,
                  right: 18.h,
                  top: 18.h,
                  bottom: 60.h,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 10.h),
            decoration: BoxDecoration(
              color: const Color(0xFF6A59F1),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24.0),
                bottomRight: Radius.circular(24.0),
              ),
              border: Border.all(color: const Color(0xB5FFFFFF), width: 2),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _onCameraTap,
                  child: Container(
                    width: 30.h,
                    height: 30.h,
                    padding: EdgeInsets.all(5.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: CustomImageView(
                      imagePath: ImageConstant.imgGroup98,
                      height: 20.h,
                      width: 20.h,
                    ),
                  ),
                ),
                SizedBox(width: 6.h),
                GestureDetector(
                  onTap: _onImagePickerTap,
                  child: Container(
                    width: 30.h,
                    height: 30.h,
                    padding: EdgeInsets.all(5.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: CustomImageView(
                      imagePath: ImageConstant.imgGroup99,
                      height: 20.h,
                      width: 20.h,
                    ),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: _onMicrophoneTap,
                  child: Container(
                    width: 30.h,
                    height: 30.h,
                    padding: EdgeInsets.all(5.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: CustomImageView(
                      imagePath: ImageConstant.imgMicLine,
                      height: 20.h,
                      width: 20.h,
                    ),
                  ),
                ),
                SizedBox(width: 6.h),
                GestureDetector(
                  onTap: _onSendMessage,
                  child: Container(
                    width: 70.h,
                    height: 30.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Center(
                      child: Text(
                        loc.save,
                        style: TextStyleHelper.instance.title13SemiBoldPoppins
                            .copyWith(color: const Color(0xFF6A59F1)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviousChatsSection(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(magicIdeaChatNotifier);
        final chatHistory = state.chatHistory ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.previousChats,
              style: TextStyleHelper.instance.title16SemiBoldPoppins.copyWith(
                color: isDark
                    ? const Color(0xFF6A59F1)
                    : const Color(0xFF1D00FF),
                height: 1.5,
              ),
            ),
            SizedBox(height: 14.h),
            if (chatHistory.isEmpty) ...[
              ChatItemWidget(
                chatModel: MagicIdeaChatModel(
                  title: "Create UI/UX App",
                  description:
                      "Health App help passions to get more healthy food",
                  status: "Thinking",
                  statusColor: const Color(0xFFFBD060),
                ),
                onTap: () => _onChatItemTap("ui_ux_chat"),
              ),
              SizedBox(height: 16.h),
              ChatItemWidget(
                chatModel: MagicIdeaChatModel(
                  title: "Create Business Idea",
                  description: "create A bank to withdraw money and send money",
                  status: "Done",
                  statusColor: const Color(0xFF1DE4A2),
                ),
                onTap: () => _onChatItemTap("business_idea_chat"),
              ),
            ] else ...[
              ...chatHistory.asMap().entries.map((entry) {
                final index = entry.key;
                final chat = entry.value;
                return Column(
                  children: [
                    ChatItemWidget(
                      chatModel: chat,
                      onTap: () => _onChatItemTap(chat.id ?? ''),
                    ),
                    if (index < chatHistory.length - 1) SizedBox(height: 16.h),
                  ],
                );
              }).toList(),
            ],
          ],
        );
      },
    );
  }

  void _onNewChatTap() {
    ref.read(magicIdeaChatNotifier.notifier).startNewChat();
    messageController.clear();
  }

  void _onDesignTap(BuildContext context) {
    if (ref.read(magicIdeaChatNotifier).isLoading ?? false) {
      return;
    }

    if (messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your idea first, then tap Design'),
          backgroundColor: Color(0xFF6A59F1),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    _onSendMessage();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Text('Generating idea with $_selectedModel...'),
          ],
        ),
        backgroundColor: const Color(0xFF6A59F1),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onSendMessage() {
    if (messageController.text.trim().isNotEmpty) {
      ref
          .read(magicIdeaChatNotifier.notifier)
          .sendMessage(messageController.text);
      messageController.clear();
    }
  }

  Future<void> _onCameraTap() async {
    if (ref.read(magicIdeaChatNotifier).isLoading ?? false) return;

    final cameraStatus = await Permission.camera.request();
    if (cameraStatus.isGranted) {
      try {
        final XFile? photo = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 80,
        );
        if (photo != null) {
          ref.read(magicIdeaChatNotifier.notifier).addImageToChat(photo.path);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Photo captured successfully'),
                backgroundColor: Color(0xFF6A59F1),
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Failed to capture photo'),
              backgroundColor: appTheme.redCustom,
            ),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Camera permission is required'),
            backgroundColor: appTheme.orangeCustom,
          ),
        );
      }
    }
  }

  Future<void> _onImagePickerTap() async {
    if (ref.read(magicIdeaChatNotifier).isLoading ?? false) return;

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) {
        ref.read(magicIdeaChatNotifier.notifier).addImageToChat(image.path);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Image selected successfully'),
              backgroundColor: Color(0xFF6A59F1),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to select image'),
            backgroundColor: appTheme.redCustom,
          ),
        );
      }
    }
  }

  Future<void> _onMicrophoneTap() async {
    if (ref.read(magicIdeaChatNotifier).isLoading ?? false) return;

    final microphoneStatus = await Permission.microphone.request();
    if (microphoneStatus.isGranted) {
      if (mounted) {
        ref.read(magicIdeaChatNotifier.notifier).addVoiceMessage("dummy_voice_path.m4a");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Voice note submitted!'),
            backgroundColor: Color(0xFF6A59F1),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Microphone permission is required'),
            backgroundColor: appTheme.orangeCustom,
          ),
        );
      }
    }
  }

  void _onChatItemTap(String chatId) {
    ref.read(magicIdeaChatNotifier.notifier).selectChat(chatId);
    final state = ref.read(magicIdeaChatNotifier);
    final chat = state.chatHistory?.firstWhere(
      (c) => c.id == chatId,
      orElse: () => MagicIdeaChatModel(title: 'Chat', description: ''),
    );
    if (chat == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        builder: (_, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEBEBFF),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            color: Color(0xFF1D00FF),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                chat.title ?? 'Chat',
                                style: TextStyleHelper
                                    .instance
                                    .title16SemiBoldPoppins
                                    .copyWith(color: const Color(0xFF000000)),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      (chat.statusColor ??
                                              const Color(0xFFFBD060))
                                          .withAlpha(30),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  chat.status ?? 'Processing',
                                  style: TextStyleHelper
                                      .instance
                                      .title12MediumPoppins
                                      .copyWith(
                                        color:
                                            chat.statusColor ??
                                            const Color(0xFFFBD060),
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(ctx),
                          icon: const Icon(
                            Icons.close,
                            color: Color(0xFF888888),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFFEEEEEE)),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F8FF),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFEBEBFF)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Idea',
                            style: TextStyleHelper
                                .instance
                                .title13SemiBoldPoppins
                                .copyWith(color: const Color(0xFF888888)),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            chat.description ?? '',
                            style: TextStyleHelper.instance.title14MediumSans
                                .copyWith(color: const Color(0xFF000000)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1D00FF), Color(0xFF6A59F1)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.auto_awesome,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'AI Response',
                                style: TextStyleHelper
                                    .instance
                                    .title13SemiBoldPoppins
                                    .copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          if (chat.status == "Thinking..." || chat.status == "Processing..." || chat.status == "Listening...")
                            Row(
                              children: [
                                SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Generating response...',
                                  style: TextStyleHelper.instance.title13LightPoppins.copyWith(color: Colors.white, fontStyle: FontStyle.italic),
                                )
                              ],
                            )
                          else if (chat.status == "Failed")
                            Text(
                              chat.errorMessage ?? 'Something went wrong.',
                              style: TextStyleHelper.instance.title13MediumPoppins.copyWith(color: const Color(0xFFFFB3B3)),
                            )
                          else
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (chat.aiModelUsed != null)
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withAlpha(40),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'Generated by ${chat.aiModelUsed}',
                                      style: TextStyleHelper.instance.title12MediumPoppins.copyWith(color: Colors.white),
                                    ),
                                  ),
                                Text(
                                  chat.aiResponse ?? 'No response generated.',
                                  style: TextStyleHelper.instance.title13LightPoppins.copyWith(
                                    color: Colors.white.withAlpha(240),
                                    height: 1.6,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Idea saved!'),
                                  backgroundColor: Color(0xFF1DE4A2),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1D00FF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.bookmark_outline,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Save Idea',
                                    style: TextStyleHelper
                                        .instance
                                        .title13SemiBoldPoppins
                                        .copyWith(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Continue in new chat'),
                                  backgroundColor: Color(0xFF6A59F1),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F0FF),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFF1D00FF).withAlpha(60),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.chat_bubble_outline,
                                    color: Color(0xFF1D00FF),
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Continue',
                                    style: TextStyleHelper
                                        .instance
                                        .title13SemiBoldPoppins
                                        .copyWith(
                                          color: const Color(0xFF1D00FF),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
