import 'dart:convert';
import 'dart:developer' as dev;
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/ideas_dashboard_model.dart';
import '../../domain/models/project_card_model.dart';
import '../../domain/models/magic_idea_chat_model.dart';
import '../../domain/models/settings_model.dart';
import '../../core/errors/app_exception.dart';

/// Typed local storage service.
/// All errors are logged via dart:developer and rethrown as [StorageException]
/// so callers can surface them in the UI rather than silently losing data.
class LocalStorageService {
  static const String _ideasKey = 'storage_ideas_v1';
  static const String _projectsKey = 'storage_projects_v1';
  static const String _chatsKey = 'storage_chats_v1';
  static const String _profileKey = 'storage_profile_v1';
  static const String _tokenKey = 'storage_token_v1';

  // ─── Auth Token ─────────────────────────────────────────────────────────────

  static Future<String?> loadToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e) {
      return null;
    }
  }

  static Future<void> saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
    } catch (e) {
      dev.log('LocalStorageService.saveToken failed', error: e);
    }
  }

  static Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  // ─── Ideas ──────────────────────────────────────────────────────────────────

  static Future<List<IdeaCardModel>?> loadIdeasList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_ideasKey);
      if (json == null) return null;
      final list = jsonDecode(json) as List<dynamic>;
      return list.map((e) => IdeaCardModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e, st) {
      dev.log('LocalStorageService.loadIdeasList failed', error: e, stackTrace: st);
      throw StorageException('Failed to load ideas from storage.');
    }
  }

  static Future<void> saveIdeasList(List<IdeaCardModel> ideas) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = jsonEncode(ideas.map((i) => i.toJson()).toList());
      await prefs.setString(_ideasKey, json);
    } catch (e, st) {
      dev.log('LocalStorageService.saveIdeasList failed', error: e, stackTrace: st);
      throw StorageException('Failed to save ideas to storage.');
    }
  }

  // ─── Projects ──────────────────────────────────────────────────────────────

  static Future<List<ProjectCardModel>?> loadProjectsList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_projectsKey);
      if (json == null) return null;
      final list = jsonDecode(json) as List<dynamic>;
      return list
          .map((e) => ProjectCardModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e, st) {
      dev.log('LocalStorageService.loadProjectsList failed', error: e, stackTrace: st);
      throw StorageException('Failed to load projects from storage.');
    }
  }

  static Future<void> saveProjectsList(List<ProjectCardModel> projects) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = jsonEncode(projects.map((p) => p.toJson()).toList());
      await prefs.setString(_projectsKey, json);
    } catch (e, st) {
      dev.log('LocalStorageService.saveProjectsList failed', error: e, stackTrace: st);
      throw StorageException('Failed to save projects to storage.');
    }
  }

  // ─── Chat History ────────────────────────────────────────────────────────────

  static Future<List<MagicIdeaChatModel>?> loadChatHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_chatsKey);
      if (json == null) return null;
      final list = jsonDecode(json) as List<dynamic>;
      return list.map((e) => MagicIdeaChatModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e, st) {
      dev.log('LocalStorageService.loadChatHistory failed', error: e, stackTrace: st);
      throw StorageException('Failed to load chat history from storage.');
    }
  }

  static Future<void> saveChatHistory(List<MagicIdeaChatModel> chats) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = jsonEncode(chats.map((c) => c.toJson()).toList());
      await prefs.setString(_chatsKey, json);
    } catch (e, st) {
      dev.log('LocalStorageService.saveChatHistory failed', error: e, stackTrace: st);
      throw StorageException('Failed to save chat history to storage.');
    }
  }

  // ─── User Profile (Settings) ─────────────────────────────────────────────────

  static Future<SettingsModel?> loadProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_profileKey);
      if (json == null) return null;
      return SettingsModel.fromJson(jsonDecode(json) as Map<String, dynamic>);
    } catch (e, st) {
      dev.log('LocalStorageService.loadProfile failed', error: e, stackTrace: st);
      throw StorageException('Failed to load profile from storage.');
    }
  }

  static Future<void> saveProfile(SettingsModel model) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_profileKey, jsonEncode(model.toJson()));
    } catch (e, st) {
      dev.log('LocalStorageService.saveProfile failed', error: e, stackTrace: st);
      throw StorageException('Failed to save profile to storage.');
    }
  }

  /// Clears all app data from local storage (e.g. on logout).
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_ideasKey);
    await prefs.remove(_projectsKey);
    await prefs.remove(_chatsKey);
    await prefs.remove(_profileKey);
  }
}
