class Homework {
  int id;
  String createTime;
  String startTime;
  String deadline;
  String homeworkName;
  int count;

  Homework(
    this.id,
    this.createTime,
    this.startTime,
    this.deadline,
    this.homeworkName,
    this.count,
  );

  static Homework objToHomework(Map<String, dynamic> map) {
    return Homework(
      map["id"],
      map["createTime"],
      map["startTime"],
      map["deadline"],
      map["homeworkName"],
      map["count"],
    );
  }
}
