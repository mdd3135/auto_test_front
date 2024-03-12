import 'package:auto_test_front/entity/itemBank.dart';
import 'package:flutter/material.dart';

class CompleteChoice extends StatefulWidget {
  const CompleteChoice({super.key, required this.itemBank});

  final ItemBank itemBank;

  @override
  State<CompleteChoice> createState() => _CompleteChoiceState();
}

class _CompleteChoiceState extends State<CompleteChoice> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
