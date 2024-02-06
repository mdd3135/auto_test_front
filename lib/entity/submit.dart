class Submit {
  int id;
  int userId;
  int homeworkId;

  Submit(
    this.id,
    this.userId,
    this.homeworkId,
  );

  static Submit objToSubmit(Map<String, dynamic> map) {
    return Submit(
      map["id"],
      map["userId"],
      map["homeworkId"],
    );
  }
}
