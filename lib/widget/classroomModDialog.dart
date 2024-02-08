import 'package:auto_test_front/widget/myTextStyle.dart';
import 'package:flutter/material.dart';

class ClassroomModDialog extends StatefulWidget {
  const ClassroomModDialog({super.key, required this.classroom});

  final String classroom;

  @override
  State<ClassroomModDialog> createState() => _ClassroomModDialogState();
}

class _ClassroomModDialogState extends State<ClassroomModDialog> {
  String classroom = "";

  @override
  initState() {
    super.initState();
    classroom = widget.classroom;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "修改班级",
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
              "新班级",
              style: MyTextStyle.textStyle
            ),
          ),
          textAlign: TextAlign.center,
          initialValue: classroom,
          style: MyTextStyle.textStyle,
          onChanged: (value) {
            classroom = value;
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
            Navigator.of(context).pop({
              "isModify": true,
              "classroom": classroom,
            });
          },
        ),
      ],
    );
  }
}
