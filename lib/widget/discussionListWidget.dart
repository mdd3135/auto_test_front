import 'dart:async';

import 'package:flutter/material.dart';

class DiscussionListWidget extends StatefulWidget {
  const DiscussionListWidget({
    super.key,
    required this.length,
    required this.discussionList,
  });
  final int length;
  final List<Widget> discussionList;

  @override
  State<DiscussionListWidget> createState() => _DiscussionListWidgetState();
}

class _DiscussionListWidgetState extends State<DiscussionListWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
