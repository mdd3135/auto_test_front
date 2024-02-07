import 'package:auto_test_front/widget/myAppBar.dart';
import 'package:flutter/material.dart';

class AddHomeworkPage extends StatefulWidget {
  const AddHomeworkPage({super.key});

  @override
  State<AddHomeworkPage> createState() => _AddHomeworkPageState();
}

class _AddHomeworkPageState extends State<AddHomeworkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar().build(
        context,
        "添加作业",
        null,
      ),
    );
  }
}
