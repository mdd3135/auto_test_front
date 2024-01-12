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
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(40)),
              ),
              label: Text(
                "原密码",
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
              oldPwd = value;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(40)),
              ),
              label: Text(
                "新密码",
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
              newPwd = value;
            },
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(
            "取消",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop({"isModify": false});
          },
        ),
        TextButton(
          child: const Text(
            "确定",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
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
