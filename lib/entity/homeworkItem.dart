class HomeworkItem {
  int id;
  int homeworkId;
  int itemId;

  HomeworkItem(
    this.id,
    this.homeworkId,
    this.itemId,
  );

  static HomeworkItem objToHomeworkItem(Map<String, dynamic> map) {
    return HomeworkItem(
      map["id"],
      map["homeworkId"],
      map["itemId"],
    );
  }
}
