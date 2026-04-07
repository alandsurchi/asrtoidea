import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/app_export.dart';
import 'package:ai_idea_generator/domain/models/magic_idea_chat_model.dart';
import './widgets/chat_bubble_widget.dart';
import 'notifier/magic_idea_chat_notifier.dart';
import 'ai_models.dart';
import '../main_shell_screen/main_shell_screen.dart';

class _PublishColorOption {
  final String label;
  final Color color;
  final String storageValue;

  const _PublishColorOption({
    required this.label,
    required this.color,
    required this.storageValue,
  });
}

class _PublishSelection {
  final String category;
  final String priority;
  final String status;
  final bool useSystemStatus;
  final String backgroundImage;

  const _PublishSelection({
    required this.category,
    required this.priority,
    required this.status,
    required this.useSystemStatus,
    required this.backgroundImage,
  });
}

const List<_PublishColorOption> _kPublishColorOptions = [
  _PublishColorOption(
    label: 'Ocean',
    color: Color(0xFF1D4ED8),
    storageValue: 'color:#1D4ED8',
  ),
  _PublishColorOption(
    label: 'Emerald',
    color: Color(0xFF047857),
    storageValue: 'color:#047857',
  ),
  _PublishColorOption(
    label: 'Sunset',
    color: Color(0xFFEA580C),
    storageValue: 'color:#EA580C',
  ),
  _PublishColorOption(
    label: 'Berry',
    color: Color(0xFF9D174D),
    storageValue: 'color:#9D174D',
  ),
  _PublishColorOption(
    label: 'Slate',
    color: Color(0xFF334155),
    storageValue: 'color:#334155',
  ),
  _PublishColorOption(
    label: 'Classic',
    color: Color(0xFF4E56E2),
    storageValue: 'assets/images/img_rectangle_29_250x400.png',
  ),
];

const List<String> _kPublishPriorityOptions = ['High', 'Medium', 'Low'];
const List<String> _kPublishStatusOptions = [
  'In Progress',
  'To-do',
  'Completed',
  'Generated',
];

class ActiveChatScreen extends ConsumerStatefulWidget {
  const ActiveChatScreen({Key? key}) : super(key: key);

  @override
  ActiveChatScreenState createState() => ActiveChatScreenState();
}

class ActiveChatScreenState extends ConsumerState<ActiveChatScreen> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 200,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Auto-scroll when state changes
    ref.listen(magicIdeaChatNotifier, (previous, next) {
      if (previous?.chatHistory != next.chatHistory) {
        Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
      }
    });

    final state = ref.watch(magicIdeaChatNotifier);
    final selectedModel = state.selectedAiModel ?? kDefaultAiModel;
    MagicIdeaChatModel? activeChat;
    if (state.currentChatId != null) {
      activeChat = state.chatHistory?.firstWhere(
        (c) => c.id == state.currentChatId,
        orElse: () => MagicIdeaChatModel(),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F0F1A) : const Color(0xFFFFFFFF),
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Column(
          children: [
            if (activeChat != null) _buildPublishPanel(context, activeChat),
            Expanded(
              child: activeChat != null && (activeChat.messages?.isNotEmpty ?? false)
                  ? ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 16.h),
                      itemCount: activeChat.messages!.length + ((state.isLoading ?? false) ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == activeChat!.messages!.length) {
                          // Typing indicator
                          return _buildTypingIndicator(isDark);
                        }
                        final msg = activeChat.messages![index];
                        return ChatBubbleWidget(message: msg);
                      },
                    )
                  : _buildEmptyState(context, selectedModel),
            ),
            _buildChatInputArea(context),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedModel =
        ref.watch(magicIdeaChatNotifier).selectedAiModel ?? kDefaultAiModel;
    return AppBar(
      backgroundColor: isDark ? const Color(0xFF1A0080) : const Color(0xFF1D00FF),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgIconTypePrompt,
            height: 24.h,
            width: 24.h,
            color: Colors.white,
          ),
          SizedBox(width: 8.h),
          Text(
            "Magic Idea Chat",
            style: TextStyleHelper.instance.title16SemiBoldPoppins.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.add_circle_outline, color: Colors.white),
          tooltip: 'New Chat',
          onPressed: () {
            ref.read(magicIdeaChatNotifier.notifier).startNewChat();
            messageController.clear();
          },
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(50.h),
        child: Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: GestureDetector(
            onTap: () => _showModelPicker(context),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(50),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    kAiModels
                        .firstWhere(
                          (m) => m.name == selectedModel,
                          orElse: () => kAiModels.first,
                        )
                        .icon,
                    size: 16.h,
                    color: Colors.white,
                  ),
                  SizedBox(width: 6.h),
                  Text(
                    selectedModel,
                    style: TextStyleHelper.instance.title13MediumPoppins.copyWith(color: Colors.white),
                  ),
                  SizedBox(width: 4.h),
                  const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 18),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String selectedModel) {
    final loc = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgIconAiGenerate,
            height: 60.h,
            width: 60.h,
            color: isDark ? Colors.white54 : Colors.black26,
          ),
          SizedBox(height: 16.h),
          Text(
            loc.whatIdeaToday,
            style: TextStyleHelper.instance.headline18SemiBoldPoppins.copyWith(
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Start chatting with $selectedModel to explore ideas.",
            style: TextStyleHelper.instance.body14RegularPoppins.copyWith(
              color: isDark ? Colors.white38 : Colors.black38,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 30.h,
            height: 30.h,
            decoration: BoxDecoration(
              color: const Color(0xFF6A59F1).withAlpha(40),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(Icons.auto_awesome, color: const Color(0xFF6A59F1), size: 16.h),
            ),
          ),
          SizedBox(width: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.h),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2A2A3E) : const Color(0xFFF3F3F3),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 12,
                  height: 12,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 8.h),
                Text(
                  "Thinking...",
                  style: TextStyleHelper.instance.title13LightPoppins.copyWith(
                    color: isDark ? Colors.white54 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPublishPanel(BuildContext context, MagicIdeaChatModel activeChat) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final template = activeChat.ideaTemplate;
    final ready = activeChat.readyToPublish ?? false;
    final published = activeChat.isPublished ?? false;
    final missingFields = activeChat.missingFields ?? const <String>[];
    final canPublish =
      ready && !published && !(ref.read(magicIdeaChatNotifier).isLoading ?? false);

    final title = _readTemplateText(template, const ['title', 'ideaTitle']);
    final summary =
        _readTemplateText(template, const ['solutionSummary', 'description']);
    final category = _readTemplateText(template, const ['category']);
    final priority = _readTemplateText(template, const ['priority']);
    final features = _readTemplateList(template, const ['keyFeatures', 'coreFeatures']);

    if ((template == null || template.isEmpty) && missingFields.isEmpty && !published) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.fromLTRB(16.h, 12.h, 16.h, 8.h),
      padding: EdgeInsets.all(14.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? const [Color(0xFF1E223F), Color(0xFF2A2F58)]
              : const [Color(0xFFF7F9FF), Color(0xFFEFF3FF)],
        ),
        borderRadius: BorderRadius.circular(14.h),
        border: Border.all(
          color: ready
              ? const Color(0xFF1DE4A2).withValues(alpha: 0.6)
              : const Color(0xFFFBD060).withValues(alpha: 0.6),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1D00FF).withValues(alpha: isDark ? 0.22 : 0.1),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      published
                          ? Icons.check_circle
                          : (ready
                              ? Icons.rocket_launch_rounded
                              : Icons.fact_check_outlined),
                      size: 18.h,
                      color: published
                          ? const Color(0xFF1DE4A2)
                          : (ready
                              ? const Color(0xFF1DE4A2)
                              : const Color(0xFFFBD060)),
                    ),
                    SizedBox(width: 8.h),
                    Expanded(
                      child: Text(
                        published
                            ? 'Published'
                            : (ready
                                ? 'Ready to Publish'
                                : 'Ed Discovery In Progress'),
                        style:
                            TextStyleHelper.instance.title14SemiBoldPoppins.copyWith(
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.h),
              ElevatedButton.icon(
                onPressed: canPublish ? () => _onPublishTap() : null,
                icon: const Icon(Icons.publish_rounded, size: 16),
                label: Text(
                  published ? 'Published' : 'Publish',
                  style: TextStyleHelper.instance.title12MediumPoppins,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D00FF),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                      isDark ? const Color(0xFF3A3F65) : const Color(0xFFD6DBEB),
                  disabledForegroundColor: isDark ? Colors.white38 : Colors.black38,
                  shape: const StadiumBorder(),
                  padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 8.h),
                  elevation: 0,
                  minimumSize: Size(0, 36.h),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          if (title.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              title,
              style: TextStyleHelper.instance.title15SemiBoldPoppins.copyWith(
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
          if (summary.isNotEmpty) ...[
            SizedBox(height: 6.h),
            Text(
              summary,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyleHelper.instance.title12RegularSans.copyWith(
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
          if (features.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Wrap(
              spacing: 6.h,
              runSpacing: 6.h,
              children: features.take(4).map((feature) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF2A2D46)
                        : const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(999.h),
                  ),
                  child: Text(
                    feature,
                    style: TextStyleHelper.instance.title12RegularSans.copyWith(
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          if (category.isNotEmpty || priority.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              [category, priority].where((e) => e.isNotEmpty).join(' • '),
              style: TextStyleHelper.instance.title13MediumPoppins.copyWith(
                color: isDark ? Colors.white54 : Colors.black45,
              ),
            ),
          ],
          if (!ready && missingFields.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              'Missing: ${missingFields.map(_humanizeField).join(', ')}',
              style: TextStyleHelper.instance.title12RegularSans.copyWith(
                color: isDark ? const Color(0xFFFFC06A) : const Color(0xFF9A5B00),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _readTemplateText(Map<String, dynamic>? template, List<String> keys) {
    if (template == null) return '';
    for (final key in keys) {
      final value = template[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return '';
  }

  List<String> _readTemplateList(Map<String, dynamic>? template, List<String> keys) {
    if (template == null) return const [];
    for (final key in keys) {
      final value = template[key];
      if (value is List) {
        final parsed = value
            .map((e) => e.toString().trim())
            .where((e) => e.isNotEmpty)
            .toList();
        if (parsed.isNotEmpty) return parsed;
      }
      if (value is String && value.trim().isNotEmpty) {
        final parsed = value
            .split(RegExp(r'[\n,;]'))
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
        if (parsed.isNotEmpty) return parsed;
      }
    }
    return const [];
  }

  String _humanizeField(String key) {
    final normalized = key.replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
      (m) => '${m.group(1)} ${m.group(2)}',
    );
    return normalized.replaceAll('_', ' ').trim();
  }

  Widget _buildChatInputArea(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: _onCameraTap,
              child: Container(
                padding: EdgeInsets.all(10.h),
                child: Icon(Icons.camera_alt_outlined, color: const Color(0xFF6A59F1), size: 24.h),
              ),
            ),
            GestureDetector(
              onTap: _onImagePickerTap,
              child: Container(
                padding: EdgeInsets.all(10.h),
                child: Icon(Icons.image_outlined, color: const Color(0xFF6A59F1), size: 24.h),
              ),
            ),
            Expanded(
              child: Container(
                constraints: BoxConstraints(maxHeight: 120.h),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2A2A3E) : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextField(
                  controller: messageController,
                  maxLines: null,
                  style: TextStyleHelper.instance.body14RegularPoppins.copyWith(
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  decoration: InputDecoration(
                    hintText: loc.chatHint,
                    hintStyle: TextStyleHelper.instance.title13LightPoppins.copyWith(
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.h),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.h),
            GestureDetector(
               onTap: _onSendMessage,
               child: Container(
                 width: 44.h,
                 height: 44.h,
                 decoration: const BoxDecoration(
                   color: Color(0xFF6A59F1),
                   shape: BoxShape.circle,
                 ),
                 child: const Center(
                   // Swapped from Save to Send Icon
                   child: Icon(Icons.send_rounded, color: Colors.white, size: 20),
                 ),
               ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSendMessage() {
    if (messageController.text.trim().isNotEmpty) {
      ref.read(magicIdeaChatNotifier.notifier).sendMessage(messageController.text);
      messageController.clear();
      Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
    }
  }

  MagicIdeaChatModel? _getCurrentChat() {
    final chatState = ref.read(magicIdeaChatNotifier);
    final currentChatId = chatState.currentChatId;
    if (currentChatId == null) return null;

    final found = chatState.chatHistory?.firstWhere(
      (chat) => chat.id == currentChatId,
      orElse: () => MagicIdeaChatModel(),
    );
    if (found == null || (found.id ?? '').isEmpty) return null;
    return found;
  }

  Future<_PublishSelection?> _showPublishOptionsSheet(
    MagicIdeaChatModel activeChat,
  ) async {
    final template = activeChat.ideaTemplate ?? const <String, dynamic>{};
    final suggestedCategory = _readTemplateText(template, const ['category']);
    final initialCategory =
        suggestedCategory.isEmpty ? 'General' : suggestedCategory;
    final categoryController = TextEditingController(text: initialCategory);

    String selectedPriority = _normalizePriorityLabel(
      _readTemplateText(template, const ['priority']),
    );
    String selectedStatus = _normalizeStatusLabel(
      _readTemplateText(template, const ['status', 'state']),
    );
    String selectedBackgroundImage = _resolveInitialBackground(
      _readTemplateText(
        template,
        const ['backgroundImage', 'cardColor', 'color'],
      ),
    );
    bool useSystemStatus = true;

    final selection = await showModalBottomSheet<_PublishSelection>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        final isDark = Theme.of(sheetContext).brightness == Brightness.dark;
        final titleColor = isDark ? Colors.white : const Color(0xFF000000);
        final subtitleColor =
            isDark ? const Color(0xFF9E9E9E) : const Color(0xFF666666);
        final sheetBg = isDark ? const Color(0xFF1E1E2E) : Colors.white;

        return StatefulBuilder(
          builder: (sheetContext, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: sheetBg,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                padding: EdgeInsets.fromLTRB(20.h, 14.h, 20.h, 20.h),
                child: SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 42.h,
                            height: 4.h,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF2A2A3E)
                                  : const Color(0xFFE0E0E0),
                              borderRadius: BorderRadius.circular(2.h),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Publish Options',
                          style: TextStyleHelper.instance.title16SemiBoldPoppins
                              .copyWith(color: titleColor),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Choose card color, category, importance, and status.',
                          style: TextStyleHelper.instance.title13LightPoppins
                              .copyWith(color: subtitleColor),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Card Color',
                          style: TextStyleHelper.instance.title13SemiBoldPoppins
                              .copyWith(color: titleColor),
                        ),
                        SizedBox(height: 8.h),
                        Wrap(
                          spacing: 8.h,
                          runSpacing: 8.h,
                          children: _kPublishColorOptions.map((option) {
                            final isSelected =
                                selectedBackgroundImage == option.storageValue;
                            return GestureDetector(
                              onTap: () {
                                setModalState(() {
                                  selectedBackgroundImage = option.storageValue;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.h,
                                  vertical: 8.h,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? option.color.withValues(alpha: 0.2)
                                      : (isDark
                                            ? const Color(0xFF2A2A3E)
                                            : const Color(0xFFF5F5FA)),
                                  borderRadius: BorderRadius.circular(12.h),
                                  border: Border.all(
                                    color: isSelected
                                        ? option.color
                                        : (isDark
                                              ? const Color(0xFF3A3A5E)
                                              : const Color(0xFFE3E3EE)),
                                    width: isSelected ? 1.4 : 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 14.h,
                                      height: 14.h,
                                      decoration: BoxDecoration(
                                        color: option.color,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(width: 6.h),
                                    Text(
                                      option.label,
                                      style: TextStyleHelper
                                          .instance
                                          .title12MediumPoppins
                                          .copyWith(color: titleColor),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 14.h),
                        Text(
                          'Category',
                          style: TextStyleHelper.instance.title13SemiBoldPoppins
                              .copyWith(color: titleColor),
                        ),
                        SizedBox(height: 8.h),
                        TextField(
                          controller: categoryController,
                          style: TextStyleHelper.instance.title14SemiBoldPoppins
                              .copyWith(color: titleColor),
                          decoration: InputDecoration(
                            hintText: 'Example: Design, Fintech, Health',
                            hintStyle: TextStyleHelper
                                .instance
                                .title13LightPoppins
                                .copyWith(color: subtitleColor),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.h,
                              vertical: 10.h,
                            ),
                            filled: true,
                            fillColor: isDark
                                ? const Color(0xFF2A2A3E)
                                : const Color(0xFFF5F5FA),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.h),
                              borderSide: BorderSide(
                                color: isDark
                                    ? const Color(0xFF3A3A5E)
                                    : const Color(0xFFE3E3EE),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.h),
                              borderSide: BorderSide(
                                color: isDark
                                    ? const Color(0xFF3A3A5E)
                                    : const Color(0xFFE3E3EE),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.h),
                              borderSide: const BorderSide(
                                color: Color(0xFF1D00FF),
                                width: 1.4,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 14.h),
                        Text(
                          'Importance',
                          style: TextStyleHelper.instance.title13SemiBoldPoppins
                              .copyWith(color: titleColor),
                        ),
                        SizedBox(height: 8.h),
                        Wrap(
                          spacing: 8.h,
                          runSpacing: 8.h,
                          children: _kPublishPriorityOptions.map((priority) {
                            return ChoiceChip(
                              label: Text(priority),
                              selected: selectedPriority == priority,
                              onSelected: (_) {
                                setModalState(() {
                                  selectedPriority = priority;
                                });
                              },
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 12.h),
                        SwitchListTile.adaptive(
                          contentPadding: EdgeInsets.zero,
                          value: useSystemStatus,
                          title: Text(
                            'System decides status',
                            style: TextStyleHelper
                                .instance
                                .title13SemiBoldPoppins
                                .copyWith(color: titleColor),
                          ),
                          subtitle: Text(
                            'Automatic mode uses AI state if available.',
                            style: TextStyleHelper
                                .instance
                                .title12RegularSans
                                .copyWith(color: subtitleColor),
                          ),
                          activeThumbColor: const Color(0xFF1D00FF),
                          activeTrackColor: const Color(0xFF1D00FF)
                              .withValues(alpha: 0.45),
                          onChanged: (value) {
                            setModalState(() {
                              useSystemStatus = value;
                            });
                          },
                        ),
                        if (!useSystemStatus) ...[
                          SizedBox(height: 6.h),
                          Wrap(
                            spacing: 8.h,
                            runSpacing: 8.h,
                            children: _kPublishStatusOptions.map((status) {
                              final displayLabel = status == 'In Progress'
                                  ? 'In Progress (Thinking)'
                                  : (status == 'Completed'
                                        ? 'Completed (Done)'
                                        : status);
                              return ChoiceChip(
                                label: Text(displayLabel),
                                selected: selectedStatus == status,
                                onSelected: (_) {
                                  setModalState(() {
                                    selectedStatus = status;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ],
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(sheetContext),
                                child: const Text('Cancel'),
                              ),
                            ),
                            SizedBox(width: 10.h),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  final category = categoryController.text
                                      .trim();
                                  Navigator.pop(
                                    sheetContext,
                                    _PublishSelection(
                                      category: category.isEmpty
                                          ? 'General'
                                          : category,
                                      priority: selectedPriority,
                                      status: selectedStatus,
                                      useSystemStatus: useSystemStatus,
                                      backgroundImage: selectedBackgroundImage,
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1D00FF),
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Publish'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    categoryController.dispose();
    return selection;
  }

  String _normalizePriorityLabel(String raw) {
    final value = raw.trim().toLowerCase();
    if (value.contains('high') ||
        value.contains('urgent') ||
        value.contains('critical')) {
      return 'High';
    }
    if (value.contains('low')) return 'Low';
    return 'Medium';
  }

  String _normalizeStatusLabel(String raw) {
    final value = raw.trim().toLowerCase();
    if (value.contains('in progress') ||
        value.contains('in process') ||
        value.contains('thinking') ||
        value.contains('ongoing')) {
      return 'In Progress';
    }
    if (value == 'todo' || value == 'to-do' || value == 'to do') {
      return 'To-do';
    }
    if (value.contains('done') ||
        value.contains('complete') ||
        value.contains('finished')) {
      return 'Completed';
    }
    if (value.contains('generated')) {
      return 'Generated';
    }
    return 'Generated';
  }

  String _resolveInitialBackground(String raw) {
    final value = raw.trim();
    if (value.isEmpty) return _kPublishColorOptions.first.storageValue;

    if (_kPublishColorOptions.any((option) => option.storageValue == value)) {
      return value;
    }

    if (value.toLowerCase().startsWith('color:')) {
      final normalized = _normalizeHexColor(value.substring('color:'.length));
      if (normalized != null) {
        return 'color:$normalized';
      }
    }

    final directHex = _normalizeHexColor(value);
    if (directHex != null) {
      return 'color:$directHex';
    }

    return _kPublishColorOptions.first.storageValue;
  }

  String? _normalizeHexColor(String value) {
    final cleaned = value.trim().replaceAll('#', '');
    if (!RegExp(r'^[0-9a-fA-F]{6}$').hasMatch(cleaned)) return null;
    return '#${cleaned.toUpperCase()}';
  }

  Future<void> _onPublishTap() async {
    final currentChat = _getCurrentChat();
    if (currentChat == null) return;

    final selection = await _showPublishOptionsSheet(currentChat);
    if (!mounted || selection == null) return;

    final isPublished = await ref
        .read(magicIdeaChatNotifier.notifier)
        .publishCurrentChat(
          selectedCategory: selection.category,
          selectedPriority: selection.priority,
          selectedStatus: selection.status,
          selectedBackgroundImage: selection.backgroundImage,
          useSystemStatus: selection.useSystemStatus,
        );
    if (!mounted || !isPublished) return;

    final shellState = MainShellScreen.shellKey.currentState;
    if (shellState != null) {
      MainShellScreen.goToTab(1);
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      return;
    }

    await NavigatorService.pushNamedAndRemoveUntil(AppRoutes.mainShellScreen);
    await Future<void>.delayed(const Duration(milliseconds: 30));
    MainShellScreen.goToTab(1);
  }

  Future<void> _onCameraTap() async {
    if (ref.read(magicIdeaChatNotifier).isLoading ?? false) return;

    final cameraStatus = await Permission.camera.request();
    if (cameraStatus.isGranted) {
      try {
        final XFile? photo = await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
        if (photo != null) {
          ref.read(magicIdeaChatNotifier.notifier).addImageToChat(photo.path);
        }
      } catch (e) {
        debugPrint('Failed to capture photo: $e');
      }
    }
  }

  Future<void> _onImagePickerTap() async {
    if (ref.read(magicIdeaChatNotifier).isLoading ?? false) return;
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (image != null) {
        ref.read(magicIdeaChatNotifier.notifier).addImageToChat(image.path);
      }
    } catch (e) {
      debugPrint('Failed to select image: $e');
    }
  }

  void _showModelPicker(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.chooseAiModel,
                style: TextStyleHelper.instance.title16SemiBoldPoppins.copyWith(
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 16.h),
              ...kAiModels.map((model) {
                final currentModel =
                    ref.read(magicIdeaChatNotifier).selectedAiModel ??
                    kDefaultAiModel;
                final isSelected = currentModel == model.name;
                return ListTile(
                  leading: Icon(model.icon, color: model.color),
                  title: Text(model.label, style: TextStyleHelper.instance.body14MediumPoppins),
                  trailing: isSelected ? Icon(Icons.check_circle, color: model.color) : null,
                  onTap: () {
                    ref.read(magicIdeaChatNotifier.notifier).updateAiModel(model.name);
                    Navigator.pop(ctx);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}
