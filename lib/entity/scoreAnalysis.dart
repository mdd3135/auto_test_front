class ScoreAnalysis {
  int homeworkId;
  String homeworkName;
  int count;
  double gainedScore;
  double totalScore;

  ScoreAnalysis(
    this.homeworkId,
    this.homeworkName,
    this.count,
    this.gainedScore,
    this.totalScore,
  );

  static ScoreAnalysis objToScoreAnalysis(Map<String, dynamic> map) {
    return ScoreAnalysis(
      map["homeworkId"],
      map["homeworkName"],
      map["count"],
      map["gainedScore"],
      map["totalScore"],
    );
  }
}
