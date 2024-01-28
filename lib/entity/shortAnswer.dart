class ShortAnswer {
  int id;
  String content;
  String answer;
  String analysis;
  int itemId;

  ShortAnswer(
    this.id,
    this.content,
    this.answer,
    this.analysis,
    this.itemId,
  );

  static ShortAnswer objToShortAnswer(Map<String, dynamic> map) {
    return ShortAnswer(
      map["id"],
      map["content"],
      map["answer"],
      map["analysis"],
      map["itemId"],
    );
  }
}
