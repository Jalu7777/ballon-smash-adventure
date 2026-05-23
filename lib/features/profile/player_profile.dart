class PlayerProfile {
  const PlayerProfile({
    required this.uid,
    required this.displayName,
    this.email,
    this.photoUrl,
    this.bestScore = 0,
    this.totalScore = 0,
    this.gamesPlayed = 0,
    this.updatedAt,
  });

  final String uid;
  final String displayName;
  final String? email;
  final String? photoUrl;
  final int bestScore;
  final int totalScore;
  final int gamesPlayed;
  final DateTime? updatedAt;

  PlayerProfile copyWith({
    String? displayName,
    String? email,
    String? photoUrl,
    int? bestScore,
    int? totalScore,
    int? gamesPlayed,
    DateTime? updatedAt,
  }) {
    return PlayerProfile(
      uid: uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      bestScore: bestScore ?? this.bestScore,
      totalScore: totalScore ?? this.totalScore,
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory PlayerProfile.fromJson(Map<String, dynamic> json) {
    return PlayerProfile(
      uid: json['uid'] as String,
      displayName: json['displayName'] as String? ?? 'Player',
      email: json['email'] as String?,
      photoUrl: json['photoUrl'] as String?,
      bestScore: json['bestScore'] as int? ?? 0,
      totalScore: json['totalScore'] as int? ?? 0,
      gamesPlayed: json['gamesPlayed'] as int? ?? 0,
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
      'bestScore': bestScore,
      'totalScore': totalScore,
      'gamesPlayed': gamesPlayed,
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
