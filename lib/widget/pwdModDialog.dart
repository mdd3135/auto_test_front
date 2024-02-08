import 'package:auto_test_front/widget/myTextStyle.dart';
import 'package:flutter/material.dart';

class PwdModDialog extends StatefulWidget {
  const PwdModDialog({super.key});

  @override
  State<PwdModDialog> createState() => _PwdModDialogState();
}

class _PwdModDialogState extends State<PwdModDialog> {
  @override
  Widget build(BuildContext context) {
    String oldPwd = "";
    String newPwd = "";
    return AlertDialog(
      title: const Text(
        "修改密码",
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          TextFormField(
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              label: Text(
                "原密码",
                style: MyTextStyle.textStyle,
              ),
            ),
            obscureText: true,
            textAlign: TextAlign.center,
            style: MyTextStyle.textStyle,
            onChanged: (value) {
              oldPwd = value;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              label: Text(
                "新密码",
                style: MyTextStyle.textStyle,
              ),
            ),
            obscureText: true,
            textAlign: TextAlign.center,
            style: MyTextStyle.textStyle,
            onChanged: (value) {
              newPwd = value;
            },
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            "取消",
            style: MyTextStyle.textStyle,
          ),
          onPressed: () {
            Navigator.of(context).pop({"isModify": false});
          },
        ),
        TextButton(
          child: Text(
            "确定",
            style: MyTextStyle.textStyle,
          ),
          onPressed: () {
            Navigator.of(context).pop({
              "isModify": true,
              "oldPwd": oldPwd,
              "newPwd": newPwd,
            });
          },
        ),
      ],
    );
  }
}
