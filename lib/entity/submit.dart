class Submit {
  int id;
  int userId;
  int homeworkId;
  int itemId;
  int type;
  String createTime;

  Submit(
    this.id,
    this.userId,
    this.homeworkId,
    this.itemId,
    this.type,
    this.createTime,
  );

  static Submit objToSubmit(Map<String, dynamic> map) {
    return Submit(
      map["id"],
      map["userId"],
      map["homeworkId"],
      map["itemId"],
      map["type"],
      map["createTime"],
    );
  }
}
