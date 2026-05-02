class Rating {
  int? id;
  int ratedUserId;
  String ratedUserName;
  int ratedByUserId;
  String ratedByUserName;
  int rideId;
  int score;
  String? comment;
  DateTime createdAt;

  Rating({
    this.id,
    required this.ratedUserId,
    required this.ratedUserName,
    required this.ratedByUserId,
    required this.ratedByUserName,
    required this.rideId,
    required this.score,
    this.comment,
    required this.createdAt,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id'],
      ratedUserId: json['ratedUserId'] ?? 0,
      ratedUserName: json['ratedUserName'] ?? '',
      ratedByUserId: json['ratedByUserId'] ?? 0,
      ratedByUserName: json['ratedByUserName'] ?? '',
      rideId: json['rideId'] ?? 0,
      score: json['score'] ?? 0,
      comment: json['comment'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}