import 'package:auto_test_front/status.dart';
import 'package:auto_test_front/widget/myTextStyle.dart';
import 'package:auto_test_front/widget/themeDropdownbtn.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        const Expanded(flex: 1, child: Text("")),
        Row(
          children: [
            Expanded(
              child: Text(
                "深色模式",
                style: MyTextStyle.textStyle,
              ),
            ),
            Switch(
              value: Status.isDark,
              onChanged: (value) {
                onDarkChanged(value);
              },
            )
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Text(
                "主题选择",
                style: MyTextStyle.textStyle,
              ),
            ),
            const ThemeDropDownbtn(),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Text(
                "记住我",
                style: MyTextStyle.textStyle,
              ),
            ),
            Switch(
              value: Status.isRememberMe,
              onChanged: (value) {
                onRememberMe(value);
              },
            )
          ],
        ),
        const Expanded(flex: 3, child: Text("")),
        ElevatedButton(
          onPressed: () {
            onAbout();
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Text(
              "关于系统",
              style: MyTextStyle.textStyle,
            ),
          ),
        ),
        const SizedBox(height: 40)
      ],
    );
  }

  onDarkChanged(bool value) {
    Status.isDark = value;
    Status.prefs.setBool("isDark", value);
    setState(() {});
  }

  onRememberMe(bool value) {
    Status.isRememberMe = value;
    Status.prefs.setBool("isRememberMe", value);
    Status.prefs.setString("name", Status.user.name);
    Status.prefs.setString("pwd", Status.user.pwd);
    setState(() {});
  }

  onAbout() {
    showAboutDialog(
      context: context,
      applicationName: "基于自动批改的在线测试系统",
      applicationVersion: "1.0",
      applicationIcon: const Icon(Icons.auto_awesome),
      children: [
        const Text(
          "毛旦旦的毕业设计，使用Spring Boot构建后端，使用MySQL数据库，使用Flutter构建客户端",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}
