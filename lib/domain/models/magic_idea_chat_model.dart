import '../../../core/app_export.dart';
import 'package:flutter/material.dart';

/// This class is used in the [magic_idea_chat_screen_initial_page] screen.

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
    this.aiResponse,
    this.aiModelUsed,
    this.errorMessage,
    this.timestamp,
  }) {
    title = title ?? "";
    description = description ?? "";
    status = status ?? "Thinking";
    id = id ?? "";
    aiResponse = aiResponse;
    aiModelUsed = aiModelUsed;
    errorMessage = errorMessage;
    timestamp = timestamp ?? DateTime.now();
  }

  String? title;
  String? description;
  String? status;
  Color? statusColor;
  String? imagePath;
  String? voicePath;
  String? id;
  String? aiResponse;
  String? aiModelUsed;
  String? errorMessage;
  DateTime? timestamp;

  MagicIdeaChatModel copyWith({
    String? title,
    String? description,
    String? status,
    Color? statusColor,
    String? imagePath,
    String? voicePath,
    String? id,
    String? aiResponse,
    String? aiModelUsed,
    String? errorMessage,
    DateTime? timestamp,
  }) {
    return MagicIdeaChatModel(
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      statusColor: statusColor ?? this.statusColor,
      imagePath: imagePath ?? this.imagePath,
      voicePath: voicePath ?? this.voicePath,
      id: id ?? this.id,
      aiResponse: aiResponse ?? this.aiResponse,
      aiModelUsed: aiModelUsed ?? this.aiModelUsed,
      errorMessage: errorMessage ?? this.errorMessage,
      timestamp: timestamp ?? this.timestamp,
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
      'aiResponse': aiResponse,
      'aiModelUsed': aiModelUsed,
      'errorMessage': errorMessage,
      'timestamp': timestamp?.toIso8601String(),
    };
  }

  factory MagicIdeaChatModel.fromJson(Map<String, dynamic> json) {
    return MagicIdeaChatModel(
      id: json['id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      status: json['status'] as String?,
      statusColor: json['statusColor'] != null ? Color(json['statusColor'] as int) : null,
      imagePath: json['imagePath'] as String?,
      voicePath: json['voicePath'] as String?,
      aiResponse: json['aiResponse'] as String?,
      aiModelUsed: json['aiModelUsed'] as String?,
      errorMessage: json['errorMessage'] as String?,
      timestamp: json['timestamp'] != null ? DateTime.tryParse(json['timestamp'] as String) : null,
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
    aiResponse,
    aiModelUsed,
    errorMessage,
    timestamp,
  ];
}
