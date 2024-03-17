import 'package:auto_test_front/widget/myAppBar.dart';
import 'package:flutter/material.dart';

class FavoriteDetailPage extends StatefulWidget {
  const FavoriteDetailPage({super.key});

  @override
  State<FavoriteDetailPage> createState() => _FavoriteDetailPageState();
}

class _FavoriteDetailPageState extends State<FavoriteDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar().build(context, "收藏的题目", null),
    );
  }
}
