class User {
  int id;
  String name;
  String number;
  String pwd;
  String classroom;
  int type;

  User(
    this.id,
    this.name,
    this.number,
    this.pwd,
    this.classroom,
    this.type,
  );
  static User objToUser(Map<String, dynamic> map) {
    return User(
      map["id"],
      map["name"],
      map["number"],
      map["pwd"],
      map["classroom"],
      map["type"],
    );
  }
}
