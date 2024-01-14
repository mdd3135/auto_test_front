class Completion {
  int id;
  String content;
  String answer;
  String analysis;

  Completion(this.id, this.content, this.answer, this.analysis);

  static Completion objToCompletion(Map<String, dynamic> map) {
    return Completion(
      map["id"],
      map["content"],
      map["answer"],
      map["analysis"],
    );
  }
}
