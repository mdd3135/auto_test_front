import 'package:auto_test_front/widget/myTextStyle.dart';
import 'package:flutter/material.dart';

class ModDescriptionDialog extends StatefulWidget {
  const ModDescriptionDialog({super.key, required this.description});

  final String description;

  @override
  State<ModDescriptionDialog> createState() => _ModDescriptionDialogState();
}

class _ModDescriptionDialogState extends State<ModDescriptionDialog> {
  String description = "";

  @override
  void initState() {
    super.initState();
    description = widget.description;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "修改题目描述",
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      content: Container(
        margin: const EdgeInsets.only(top: 10),
        child: TextFormField(
          decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            label: Text(
              "新的题目描述",
              style: MyTextStyle.textStyle,
            ),
          ),
          textAlign: TextAlign.center,
          initialValue: description,
          style: MyTextStyle.textStyle,
          onChanged: (value) {
            description = value;
          },
        ),
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
            Navigator.of(context).pop(
              {
                "isModify": true,
                "description": description,
              },
            );
          },
        ),
      ],
    );
  }
}
