import 'package:flutter/material.dart';

class AiModelOption {
  const AiModelOption({
    required this.name,
    required this.label,
    required this.color,
    required this.icon,
  });

  final String name;
  final String label;
  final Color color;
  final IconData icon;
}

const String kDefaultAiModel = 'Gemini';

const List<AiModelOption> kAiModels = [
  AiModelOption(
    name: 'Gemini',
    label: 'Gemini',
    color: Color(0xFF1D00FF),
    icon: Icons.auto_awesome,
  ),
  AiModelOption(
    name: 'GPT-4',
    label: 'GPT-4',
    color: Color(0xFF10A37F),
    icon: Icons.psychology_rounded,
  ),
  AiModelOption(
    name: 'Claude',
    label: 'Claude',
    color: Color(0xFFD97706),
    icon: Icons.smart_toy_rounded,
  ),
  AiModelOption(
    name: 'Mercury',
    label: 'Mercury',
    color: Color(0xFF20B2AA),
    icon: Icons.search_rounded,
  ),
];
