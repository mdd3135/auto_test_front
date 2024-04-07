class ScoreAnalysis {
  int homeworkId;
  String homeworkName;
  int userId;
  String userName;
  String createTime;
  int count;
  double gainedScore;
  double totalScore;
  int isComplete;

  ScoreAnalysis(
    this.homeworkId,
    this.homeworkName,
    this.userId,
    this.userName,
    this.createTime,
    this.count,
    this.gainedScore,
    this.totalScore,
    this.isComplete,
  );

  static ScoreAnalysis objToScoreAnalysis(Map<String, dynamic> map) {
    return ScoreAnalysis(
      map["homeworkId"],
      map["homeworkName"],
      map["userId"],
      map["userName"],
      map["createTime"],
      map["count"],
      map["gainedScore"],
      map["totalScore"],
      map["isComplete"],
    );
  }
}
