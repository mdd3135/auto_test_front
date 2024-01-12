import 'package:auto_test_front/entity/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Status {
  static bool login = false;
  static User user = User(0, "", "", "", "", 0);
  static String baseUrl = "http://127.0.0.1:8085";
  static int pageId = 0; //0设置，1学生管理，2题库，3作业，4我的
  static int colorId = 2;
  static bool isDark = false;
  static bool isRememberMe = false;
  static late SharedPreferences prefs;
}
