class ItemBank {
  int id;
  int questionId;
  String createTime;
  int type;
  double score;
  String description;

  ItemBank(
    this.id,
    this.questionId,
    this.createTime,
    this.type,
    this.score,
    this.description,
  );

  static ItemBank objToItemBank(Map<String, dynamic> map) {
    return ItemBank(
      map["id"],
      map["questionId"],
      map["createTime"],
      map["type"],
      map["score"],
      map["description"],
    );
  }
}
