import 'package:auto_test_front/widget/myTextStyle.dart';
import 'package:flutter/material.dart';

class ResetPwdDialog extends StatefulWidget {
  const ResetPwdDialog({super.key});

  @override
  State<ResetPwdDialog> createState() => _ResetPwdDialogState();
}

class _ResetPwdDialogState extends State<ResetPwdDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "提示",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        "是否要重置该学生密码为学号",
        style: MyTextStyle.textStyle,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(
            "取消",
            style: MyTextStyle.textStyle,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text(
            "确定",
            style: MyTextStyle.textStyle,
          ),
        )
      ],
    );
  }
}
