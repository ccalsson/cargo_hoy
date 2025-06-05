import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<Map<String, dynamic>> _messages = [];
  final bool _isLoading = false;

  List<Map<String, dynamic>> get messages => _messages;
  bool get isLoading => _isLoading;

  Stream<List<Map<String, dynamic>>> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => doc.data())
              .toList();
        });
  }

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
  }) async {
    try {
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
        'senderId': senderId,
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Actualizar último mensaje en la colección de chats
      await _firestore
          .collection('chats')
          .doc(chatId)
          .update({
        'lastMessage': text,
        'lastMessageTimestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createChat({
    required String user1Id,
    required String user2Id,
    required String loadId,
  }) async {
    try {
      final chatId = '${user1Id}_${user2Id}_$loadId';
      
      await _firestore.collection('chats').doc(chatId).set({
        'participants': [user1Id, user2Id],
        'loadId': loadId,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return chatId;
    } catch (e) {
      rethrow;
    }
  }
} 