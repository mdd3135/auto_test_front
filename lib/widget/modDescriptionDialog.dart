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
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            label: Text(
              "新的题目描述",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          textAlign: TextAlign.center,
          initialValue: description,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          onChanged: (value) {
            description = value;
          },
        ),
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
