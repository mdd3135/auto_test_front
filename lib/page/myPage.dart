import 'dart:convert';

import 'package:auto_test_front/entity/user.dart';
import 'package:auto_test_front/status.dart';
import 'package:auto_test_front/widget/pwdModDialog.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(
          flex: 1,
          child: Text(""),
        ),
        Row(
          children: [
            const Text(
              "身份：",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Expanded(
              child: Text(""),
            ),
            Text(
              Status.user.type == 0 ? "学生" : "教师",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            const Text(
              "姓名：",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Expanded(
              child: Text(""),
            ),
            Text(
              Status.user.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            const Text(
              "学号：",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Expanded(
              child: Text(""),
            ),
            Text(
              Status.user.number == "" ? "无" : Status.user.number,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            const Text(
              "班级：",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Expanded(
              child: Text(""),
            ),
            Text(
              Status.user.classroom == "" ? "无" : Status.user.classroom,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Status.user.type == 0
            ? Row(
                children: [
                  const Text(
                    "成绩分析：",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Expanded(
                    child: Text(""),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "查看",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              )
            : const Text(""),
        const Expanded(
          flex: 3,
          child: Text(""),
        ),
        ElevatedButton(
          onPressed: () {
            onModifyPwdPressed();
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            child: const Text(
              "修改密码",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {
            onLogout();
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            child: const Text(
              "退出登录",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  onModifyPwdPressed() {
    showDialog(
      context: context,
      builder: (context) {
        return const PwdModDialog();
      },
    ).then((value) async {
      if (value["isModify"]) {
        BotToast.showLoading();
        await onModifyPwd(value["oldPwd"], value["newPwd"]);
        BotToast.closeAllLoading();
      }
    });
  }

  onModifyPwd(String oldPwd, String newPwd) async {
    String oldPwdSha256 = sha256.convert(utf8.encode(oldPwd)).toString();
    String newPwdSha256 = sha256.convert(utf8.encode(newPwd)).toString();
    var response = await http.post(
      Uri.parse("${Status.baseUrl}/modPwd"),
      body: {
        "name": Status.user.name,
        "oldPwd": oldPwdSha256,
        "newPwd": newPwdSha256,
      },
    );
    String bodyString = utf8.decode(response.bodyBytes);
    if (bodyString == "") {
      BotToast.showText(text: "修改密码失败");
    } else {
      var body = jsonDecode(bodyString);
      Status.user = User.objToUser(body);
      Status.user.pwd = "";
      Status.prefs.setString("pwd", "");
      BotToast.showText(text: "修改密码成功，请重新登录");
      Status.login = false;
    }
  }

  onLogout() {
    Status.login = false;
    setState(() {});
  }
}
