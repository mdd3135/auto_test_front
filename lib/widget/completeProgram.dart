import 'package:auto_test_front/entity/itemBank.dart';
import 'package:flutter/material.dart';

class CompleteProgram extends StatefulWidget {
  const CompleteProgram({super.key, required this.itemBank});

  final ItemBank itemBank;

  @override
  State<CompleteProgram> createState() => _CompleteProgramState();
}

class _CompleteProgramState extends State<CompleteProgram> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}