class LeaderboardEntry {
  const LeaderboardEntry({
    required this.uid,
    required this.displayName,
    required this.score,
    this.photoUrl,
    this.updatedAt,
  });

  final String uid;
  final String displayName;
  final int score;
  final String? photoUrl;
  final DateTime? updatedAt;

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      uid: json['uid'] as String,
      displayName: json['displayName'] as String? ?? 'Player',
      score: json['score'] as int? ?? 0,
      photoUrl: json['photoUrl'] as String?,
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'displayName': displayName,
      'score': score,
      'photoUrl': photoUrl,
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
