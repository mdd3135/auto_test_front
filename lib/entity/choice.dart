class Choice {
  String content;
  String options;
  String answer;
  String analysis;
  int isMultiple;
  int itemId;

  Choice(
    this.content,
    this.options,
    this.answer,
    this.analysis,
    this.isMultiple,
    this.itemId,
  );

  static Choice objToChoice(Map<String, dynamic> map) {
    return Choice(
      map["content"],
      map["options"],
      map["answer"],
      map["analysis"],
      map["isMultiple"],
      map["itemId"],
    );
  }
}
