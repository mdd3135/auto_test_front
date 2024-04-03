class Discussion {
  int id;
  int homeworkId;
  int userId;
  String content;
  int isTop;

  Discussion(
    this.id,
    this.homeworkId,
    this.userId,
    this.content,
    this.isTop,
  );

  static Discussion objToDiscussion(Map<String, dynamic> map) {
    return Discussion(
      map['id'],
      map["homeworkId"],
      map["userId"],
      map["content"],
      map["isTop"],
    );
  }
}
