import 'dart:convert';
import 'dart:ui';

import 'package:auto_test_front/entity/user.dart';
import 'package:auto_test_front/status.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:window_manager/window_manager.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    bool? isRememberMe = Status.prefs.getBool("isRememberMe");
    Status.isRememberMe = isRememberMe ?? Status.isRememberMe;
    if (Status.isRememberMe) {
      String? name = Status.prefs.getString("name");
      String? pwd = Status.prefs.getString("pwd");
      Status.user = User(0, name ?? "", "", pwd ?? "", "", 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    String name = "";
    String pwd = "";
    if (Status.isRememberMe) {
      name = Status.user.name;
      pwd = Status.user.pwd;
    }
    // double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            // constraints: const BoxConstraints(maxWidth: 400),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/loginBackground.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
              child: SizedBox(
                width: 600,
                height: height,
              ),
            ),
          ),
          Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.only(left: 40, right: 40),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background.withOpacity(0.5),
            ),
            child: Column(
              children: [
                const SizedBox(height: 40, child: Text("")),
                Text(
                  "自动批改的在线测试系统",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.8),
                  ),
                ),
                const Expanded(child: Text("")),
                TextFormField(
                  initialValue: name,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    label: Text(
                      "用户名",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  onChanged: (value) {
                    name = value;
                  },
                ),
                const SizedBox(height: 40, child: Text("")),
                TextFormField(
                  initialValue: pwd,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    label: Text(
                      "密码",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  obscureText: true,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  onChanged: (value) {
                    pwd = value;
                  },
                ),
                const Expanded(flex: 3, child: Text("")),
                ElevatedButton(
                  onPressed: () {
                    onLoginPressed(name, pwd);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      "登录",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    windowManager.close();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      "退出",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                  child: Text(""),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  onLoginPressed(String name, String pwd) async {
    BotToast.showLoading();
    String pwdSha256 = sha256.convert(utf8.encode(pwd)).toString();
    var response = await http.post(
      Uri.parse("${Status.baseUrl}/login"),
      body: {"name": name, "pwd": pwdSha256},
    );
    String bodyString = utf8.decode(response.bodyBytes);
    BotToast.closeAllLoading();
    if (bodyString == "") {
      BotToast.showText(text: "登录失败，请检查用户名和密码");
    } else {
      var body = jsonDecode(bodyString);
      Status.user = User.objToUser(body);
      Status.user.pwd = pwd;
      BotToast.showText(
        text:
            "登录成功，欢迎${Status.user.name}${Status.user.type == 0 ? "同学" : "老师"}",
      );
      if (Status.isRememberMe) {
        Status.prefs.setString("name", Status.user.name);
        Status.prefs.setString("pwd", Status.user.pwd);
      }
      Status.login = true;
    }
  }
}
