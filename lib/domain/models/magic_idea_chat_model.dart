import '../../../core/app_export.dart';
import 'package:flutter/material.dart';

/// This class is used in the [magic_idea_chat_screen_initial_page] screen.

class ChatMessage extends Equatable {
  const ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
  });

  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'isUser': isUser,
        'timestamp': timestamp.toIso8601String(),
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json['id'] as String,
        text: json['text'] as String,
        isUser: json['isUser'] as bool,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );

  @override
  List<Object?> get props => [id, text, isUser, timestamp];
}

// ignore_for_file: must_be_immutable
class MagicIdeaChatModel extends Equatable {
  MagicIdeaChatModel({
    this.title,
    this.description,
    this.status,
    this.statusColor,
    this.imagePath,
    this.voicePath,
    this.id,
    this.aiModelUsed,
    this.errorMessage,
    this.timestamp,
    this.messages,
    this.readyToPublish,
    this.isPublished,
    this.missingFields,
    this.ideaTemplate,
  }) {
    title = title ?? "";
    description = description ?? "";
    status = status ?? "Thinking";
    id = id ?? "";
    aiModelUsed = aiModelUsed;
    errorMessage = errorMessage;
    timestamp = timestamp ?? DateTime.now();
    messages = messages ?? [];
    readyToPublish = readyToPublish ?? false;
    isPublished = isPublished ?? false;
    missingFields = missingFields ?? [];
    ideaTemplate = ideaTemplate;
  }

  String? title;
  String? description;
  String? status;
  Color? statusColor;
  String? imagePath;
  String? voicePath;
  String? id;
  String? aiModelUsed;
  String? errorMessage;
  DateTime? timestamp;
  List<ChatMessage>? messages;
  bool? readyToPublish;
  bool? isPublished;
  List<String>? missingFields;
  Map<String, dynamic>? ideaTemplate;

  MagicIdeaChatModel copyWith({
    String? title,
    String? description,
    String? status,
    Color? statusColor,
    String? imagePath,
    String? voicePath,
    String? id,
    String? aiModelUsed,
    String? errorMessage,
    DateTime? timestamp,
    List<ChatMessage>? messages,
    bool? readyToPublish,
    bool? isPublished,
    List<String>? missingFields,
    Map<String, dynamic>? ideaTemplate,
  }) {
    return MagicIdeaChatModel(
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      statusColor: statusColor ?? this.statusColor,
      imagePath: imagePath ?? this.imagePath,
      voicePath: voicePath ?? this.voicePath,
      id: id ?? this.id,
      aiModelUsed: aiModelUsed ?? this.aiModelUsed,
      errorMessage: errorMessage ?? this.errorMessage,
      timestamp: timestamp ?? this.timestamp,
      messages: messages ?? this.messages,
      readyToPublish: readyToPublish ?? this.readyToPublish,
      isPublished: isPublished ?? this.isPublished,
      missingFields: missingFields ?? this.missingFields,
      ideaTemplate: ideaTemplate ?? this.ideaTemplate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'statusColor': statusColor?.toARGB32(),
      'imagePath': imagePath,
      'voicePath': voicePath,
      'aiModelUsed': aiModelUsed,
      'errorMessage': errorMessage,
      'timestamp': timestamp?.toIso8601String(),
      'messages': messages?.map((m) => m.toJson()).toList(),
      'readyToPublish': readyToPublish,
      'isPublished': isPublished,
      'missingFields': missingFields,
      'ideaTemplate': ideaTemplate,
    };
  }

  factory MagicIdeaChatModel.fromJson(Map<String, dynamic> json) {
    final rawTemplate = json['ideaTemplate'];
    final parsedTemplate = rawTemplate is Map
        ? rawTemplate.map((key, value) => MapEntry(key.toString(), value))
        : null;

    return MagicIdeaChatModel(
      id: json['id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      status: json['status'] as String?,
      statusColor: json['statusColor'] != null ? Color(json['statusColor'] as int) : null,
      imagePath: json['imagePath'] as String?,
      voicePath: json['voicePath'] as String?,
      aiModelUsed: json['aiModelUsed'] as String?,
      errorMessage: json['errorMessage'] as String?,
      timestamp: json['timestamp'] != null ? DateTime.tryParse(json['timestamp'] as String) : null,
      messages: json['messages'] != null
          ? (json['messages'] as List).map((e) => ChatMessage.fromJson(e as Map<String, dynamic>)).toList()
          : [],
        readyToPublish: json['readyToPublish'] as bool?,
        isPublished: json['isPublished'] as bool?,
        missingFields: (json['missingFields'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
        ideaTemplate: parsedTemplate,
    );
  }

  @override
  List<Object?> get props => [
    title,
    description,
    status,
    statusColor,
    imagePath,
    voicePath,
    id,
    aiModelUsed,
    errorMessage,
    timestamp,
    messages,
    readyToPublish,
    isPublished,
    missingFields,
    ideaTemplate,
  ];
}
