
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:ticket_resell/models/chat.dart';
import 'package:ticket_resell/models/message.dart';
import 'package:ticket_resell/models/notification.dart';
import 'package:ticket_resell/models/user_profile.dart';
import 'package:ticket_resell/services/auth_service.dart';
import 'package:ticket_resell/utils.dart';

class DatabaseService {
  final GetIt _getIt = GetIt.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  late AuthService _authService;

  CollectionReference? _usersCollection;
  CollectionReference? _chatsCollection;
  CollectionReference? _notificationsCollection;

  DatabaseService() {
    _authService = _getIt.get<AuthService>();
    _setupCollectionReferences();
  }

  void _setupCollectionReferences() {
    _usersCollection =
        _firebaseFirestore.collection('users').withConverter<UserProfile>(
              fromFirestore: (snapshots, _) => UserProfile.fromJson(
                snapshots.data()!,
              ),
              toFirestore: (userProfile, _) => userProfile.toJson(),
            );
    _chatsCollection =
        _firebaseFirestore.collection('chats').withConverter<Chat>(
            fromFirestore: (snapshots, _) => Chat.fromJson(
                  snapshots.data()!,
                ),
            toFirestore: (chat, _) => chat.toJson());
    _notificationsCollection =
        _firebaseFirestore.collection('notifications').withConverter<NotificationModel>(
            fromFirestore: (snapshots, _) => NotificationModel.fromJson(
              snapshots.data()!,
              snapshots.id,
            ),
            toFirestore: (notification, _) => notification.toJson());
  }

  Future<void> createUserProfile({required UserProfile userProfile}) async {
    await _usersCollection?.doc(userProfile.uid).set(userProfile);
  }

  Stream<QuerySnapshot<UserProfile>> getUserProfiles(String uid) {
    return _usersCollection
        ?.where("uid", isNotEqualTo: uid)
        .snapshots() as Stream<QuerySnapshot<UserProfile>>;
  }

  Stream<QuerySnapshot<UserProfile>> getUserProfile(String uid) {
    return _usersCollection
        ?.where("uid", isEqualTo: uid)
        .snapshots() as Stream<QuerySnapshot<UserProfile>>;
  }


  Future<bool> checkChatExists(String uid1, String uid2) async {
    String chatID = generateChatID(uid1: uid1, uid2: uid2);
    final result = await _chatsCollection?.doc(chatID).get();
    if (result != null) {
      return result.exists;
    }
    return false;
  }

  Future<void> createNewChat(String uid1, String uid2) async {
    String chatID = generateChatID(uid1: uid1, uid2: uid2);
    final docRef = _chatsCollection!.doc(chatID);
    final chat = Chat(
      id: chatID,
      participants: [uid1, uid2],
      messages: [],
    );
    await docRef.set(chat);
  }

  Future<void> sendChatMessage(
      String uid1, String uid2, Message message) async {
    String chatID = generateChatID(uid1: uid1, uid2: uid2);
    final docRef = _chatsCollection!.doc(chatID);
    await docRef.update(
      {
        "messages": FieldValue.arrayUnion(
          [
            message.toJson(),
          ],
        ),
      },
    );
  }

  Stream<DocumentSnapshot<Chat>> getChatData(String uid1, String uid2) {
    String chatID = generateChatID(uid1: uid1, uid2: uid2);
    return _chatsCollection?.doc(chatID).snapshots()
        as Stream<DocumentSnapshot<Chat>>;
  }

  Future<void> updateMessageReadStatus(String currentUserId, String otherUserId, Message message) async {
    try {
      String chatID = generateChatID(uid1: currentUserId, uid2: otherUserId);

      final chatDoc = _firebaseFirestore.collection('chats').doc(chatID);

      final chatSnapshot = await chatDoc.get();
      final chatData = chatSnapshot.data() as Map<String, dynamic>;

      List<dynamic> messages = chatData['messages'];

      // Tìm vị trí của tin nhắn cần cập nhật
      int messageIndex = messages.indexWhere((m) => m['sentAt'] == message.sentAt && m['senderID'] == message.senderID);

      if (messageIndex != -1) {
        // Cập nhật trạng thái isRead cho tin nhắn ở vị trí đó
        messages[messageIndex]['isRead'] = true;

        // Cập nhật lại mảng messages trong Firestore
        await chatDoc.update({
          'messages': messages,
        });
      } else {
        print("Message not found!");
      }
    } catch (e) {
      print("Failed to update message read status: $e");
    }
  }

  Future<void> addNotification(NotificationModel notification) async {
    await _notificationsCollection?.add(notification);
  }


  Stream<QuerySnapshot<NotificationModel>> getNotifications(String receiverId) {
    return _notificationsCollection!
        .where('receiverId', isEqualTo: receiverId)
        .orderBy('timestamp', descending: true)
        .snapshots() as Stream<QuerySnapshot<NotificationModel>>;
  }




  Future<void> markNotificationAsRead(String notificationId) async {
    await _notificationsCollection?.doc(notificationId).update({
      'isRead': true,
    });
  }



}
