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
  initState(){
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
      content: TextFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40)),
          ),
          label: Text(
            "新班级",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        textAlign: TextAlign.center,
        initialValue: classroom,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        onChanged: (value) {
          classroom = value;
        },
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
              "classroom": classroom,
            });
          },
        ),
      ],
    );
  }
}