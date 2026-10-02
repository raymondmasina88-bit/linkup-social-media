import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable {
  final String notificationId;
  final String userId;
  final String type; // 'like', 'comment', 'reply', 'share', 'friendRequest', 'follow'
  final String senderId;
  final String? postId;
  final String? commentId;
  final DateTime createdAt;
  final bool read;

  const NotificationModel({
    required this.notificationId,
    required this.userId,
    required this.type,
    required this.senderId,
    this.postId,
    this.commentId,
    required this.createdAt,
    this.read = false,
  });

  @override
  List<Object?> get props => [
    notificationId,
    userId,
    type,
    senderId,
    postId,
    commentId,
    createdAt,
    read,
  ];

  // Convert Firestore document to NotificationModel
  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      notificationId: doc.id,
      userId: data['userId'] ?? '',
      type: data['type'] ?? '',
      senderId: data['senderId'] ?? '',
      postId: data['postId'],
      commentId: data['commentId'],
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      read: data['read'] ?? false,
    );
  }

  // Convert NotificationModel to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'type': type,
      'senderId': senderId,
      'postId': postId,
      'commentId': commentId,
      'createdAt': createdAt,
      'read': read,
    };
  }

  // Create a copy with modified fields
  NotificationModel copyWith({
    String? notificationId,
    String? userId,
    String? type,
    String? senderId,
    String? postId,
    String? commentId,
    DateTime? createdAt,
    bool? read,
  }) {
    return NotificationModel(
      notificationId: notificationId ?? this.notificationId,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      senderId: senderId ?? this.senderId,
      postId: postId ?? this.postId,
      commentId: commentId ?? this.commentId,
      createdAt: createdAt ?? this.createdAt,
      read: read ?? this.read,
    );
  }
}
