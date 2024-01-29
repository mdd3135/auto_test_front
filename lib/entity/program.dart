class Program {
  int id;
  String content;
  String answer;
  String analysis;
  String input;
  String output;
  String language;
  int itemId;

  Program(
    this.id,
    this.content,
    this.answer,
    this.analysis,
    this.input,
    this.output,
    this.language,
    this.itemId,
  );

  static Program objToProgram(Map<String, dynamic> map) {
    return Program(
      map["id"],
      map["content"],
      map["answer"],
      map["analysis"],
      map["input"],
      map["output"],
      map["language"],
      map["itemId"],
    );
  }
}
