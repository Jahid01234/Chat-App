class UserModel {
  final String uid;
  final String userName;
  final String email;
  final String profileImage;
  final String? liveId;
  final bool isLive;
  final DateTime? createdAt;

  UserModel({
    required this.uid,
    required this.userName,
    required this.email,
    required this.profileImage,
    this.liveId,
    this.isLive = false,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'userName': userName,
      'email': email,
      'photoURL': profileImage,
      'liveId': liveId,
      'isLive': isLive,
      'createdAt': createdAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      userName: map['userName'] ?? '',
      email: map['email'] ?? '',
      profileImage: map['photoURL'] ?? '',
      liveId: map['liveId'],
      isLive: map['isLive'] ?? false,
      createdAt: map['createdAt']?.toDate(),
    );
  }
}