class Result {
  int id;
  int submitId;
  int itemId;
  double score;
  String feedback;

  Result(
    this.id,
    this.submitId,
    this.itemId,
    this.score,
    this.feedback,
  );

  static Result objToResult(Map<String, dynamic> mp) {
    return Result(
      mp["id"],
      mp["submitId"],
      mp["itemId"],
      mp["score"],
      mp["feedback"],
    );
  }
}
