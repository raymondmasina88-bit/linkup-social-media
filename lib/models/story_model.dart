import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class StoryModel extends Equatable {
  final String storyId;
  final String userId;
  final String mediaUrl;
  final String mediaType; // 'image' or 'video'
  final DateTime createdAt;
  final DateTime expiresAt;
  final List<String> viewers; // List of user IDs who viewed the story

  const StoryModel({
    required this.storyId,
    required this.userId,
    required this.mediaUrl,
    this.mediaType = 'image',
    required this.createdAt,
    required this.expiresAt,
    this.viewers = const [],
  });

  @override
  List<Object?> get props => [
    storyId,
    userId,
    mediaUrl,
    mediaType,
    createdAt,
    expiresAt,
    viewers,
  ];

  // Check if story has expired
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  // Convert Firestore document to StoryModel
  factory StoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StoryModel(
      storyId: doc.id,
      userId: data['userId'] ?? '',
      mediaUrl: data['mediaUrl'] ?? '',
      mediaType: data['mediaType'] ?? 'image',
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      expiresAt: data['expiresAt'] != null
          ? (data['expiresAt'] as Timestamp).toDate()
          : DateTime.now().add(const Duration(hours: 24)),
      viewers: List<String>.from(data['viewers'] ?? []),
    );
  }

  // Convert StoryModel to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'mediaUrl': mediaUrl,
      'mediaType': mediaType,
      'createdAt': createdAt,
      'expiresAt': expiresAt,
      'viewers': viewers,
    };
  }

  // Create a copy with modified fields
  StoryModel copyWith({
    String? storyId,
    String? userId,
    String? mediaUrl,
    String? mediaType,
    DateTime? createdAt,
    DateTime? expiresAt,
    List<String>? viewers,
  }) {
    return StoryModel(
      storyId: storyId ?? this.storyId,
      userId: userId ?? this.userId,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      mediaType: mediaType ?? this.mediaType,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      viewers: viewers ?? this.viewers,
    );
  }
}
