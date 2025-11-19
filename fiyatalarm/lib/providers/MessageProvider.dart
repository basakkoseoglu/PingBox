import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiyatalarm/services/MessageService.dart';
import 'package:flutter/material.dart';

class MessageProvider extends ChangeNotifier {
  final MessageService _messageService = MessageService();

  Stream<QuerySnapshot>? _upcomingMessagesStream;
  Stream<QuerySnapshot>? get upcomingMessagesStream => _upcomingMessagesStream;

  Stream<QuerySnapshot>? _archiveMessagesStream;
  Stream<QuerySnapshot>? get archiveMessagesStream => _archiveMessagesStream;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void initializeStreams() {
    _upcomingMessagesStream = _messageService.getUpcomingMessages();
    _archiveMessagesStream = _messageService.getArchiveMessages();
    notifyListeners();
  }

  Future<bool> updateMessage({
    required String messageId,
    required String title,
    required String content,
    required DateTime sendAt,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _messageService.updateMessage(
        messageId,  
        title: title,
        content: content,
        sendAt: sendAt,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('Mesaj güncelleme hatası: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteMessage(String messageId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _messageService.deleteMessage(messageId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('Mesaj silme hatası: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> addMessage({
    required String title,
    required String content,
    required DateTime sendAt,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _messageService.addMessage(
        title: title,
        content: content,
        sendAt: sendAt,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('Mesaj ekleme hatası: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void refreshStreams() {
    initializeStreams();
  }
}