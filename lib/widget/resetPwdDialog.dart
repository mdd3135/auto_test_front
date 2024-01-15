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
      content: const Text(
        "是否要重置该学生密码",
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text(
            "取消",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text(
            "确定",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
        )
      ],
    );
  }
}
