import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import '../models/game_session.dart';
import '../utils/constants.dart';

/// Provider for managing game sessions
class SessionProvider extends ChangeNotifier {
  GameSession? _currentSession;
  List<GameSession> _savedSessions = [];
  late SharedPreferences _prefs;
  bool _isInitialized = false;
  
  SessionProvider() {
    _initialize();
  }
  
  GameSession? get currentSession => _currentSession;
  List<GameSession> get savedSessions => List.unmodifiable(_savedSessions);
  bool get hasActiveSession => _currentSession != null;
  bool get isInitialized => _isInitialized;
  
  Future<void> _initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadSavedSessions();
    _isInitialized = true;
    notifyListeners();
  }
  
  /// Start a new game session
  void startNewSession() {
    final now = DateTime.now();
    _currentSession = GameSession(
      id: const Uuid().v4(),
      name: 'Oyun ${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute.toString().padLeft(2, '0')}',
      createdAt: now,
      updatedAt: now,
      rolls: [],
    );
    notifyListeners();
  }
  
  /// Add a roll to the current session
  void addRoll(List<int> diceValues) {
    if (_currentSession == null) return;
    
    final roll = DiceRoll(
      values: diceValues,
      timestamp: DateTime.now(),
    );
    
    _currentSession!.rolls.add(roll);
    _currentSession!.updatedAt = DateTime.now();
    notifyListeners();
  }
  
  /// Save current session
  Future<void> saveCurrentSession({String? customName}) async {
    if (_currentSession == null) return;
    
    if (customName != null && customName.isNotEmpty) {
      _currentSession!.name = customName;
    }
    
    // Add to saved sessions
    _savedSessions.insert(0, _currentSession!);
    
    // Limit saved sessions
    if (_savedSessions.length > AppConstants.maxSavedSessions) {
      _savedSessions = _savedSessions.take(AppConstants.maxSavedSessions).toList();
    }
    
    await _persistSessions();
    
    // Clear current session after saving
    _currentSession = null;
    notifyListeners();
  }
  
  /// Delete a saved session
  Future<void> deleteSession(String sessionId) async {
    _savedSessions.removeWhere((session) => session.id == sessionId);
    await _persistSessions();
    notifyListeners();
  }
  
  /// Load a saved session (make it current)
  void loadSession(String sessionId) {
    final session = _savedSessions.firstWhere((s) => s.id == sessionId);
    _currentSession = session;
    _savedSessions.removeWhere((s) => s.id == sessionId);
    notifyListeners();
  }
  
  /// Clear current session without saving
  void clearCurrentSession() {
    _currentSession = null;
    notifyListeners();
  }
  
  /// Rename a session
  Future<void> renameSession(String sessionId, String newName) async {
    final session = _savedSessions.firstWhere((s) => s.id == sessionId);
    session.name = newName;
    await _persistSessions();
    notifyListeners();
  }
  
  /// Load saved sessions from storage
  Future<void> _loadSavedSessions() async {
    final jsonString = _prefs.getString(AppConstants.storageKeySessions);
    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        _savedSessions = jsonList
            .map((json) => GameSession.fromJson(json))
            .toList();
      } catch (e) {
        debugPrint('Error loading sessions: $e');
        _savedSessions = [];
      }
    }
  }
  
  /// Persist sessions to storage
  Future<void> _persistSessions() async {
    final jsonList = _savedSessions.map((s) => s.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await _prefs.setString(AppConstants.storageKeySessions, jsonString);
  }
}
