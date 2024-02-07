import 'dart:async';

import 'package:auto_test_front/page/myPage.dart';
import 'package:auto_test_front/page/problemSetPage.dart';
import 'package:auto_test_front/page/settingPage.dart';
import 'package:auto_test_front/page/stuManPage.dart';
import 'package:auto_test_front/page/homeworkPage.dart';
import 'package:auto_test_front/status.dart';
import 'package:auto_test_front/widget/myAppBar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    String appTitle = "自动批改的在线测试系统——";
    if (Status.user.type == 0) {
      appTitle += "学生端";
    } else {
      appTitle += "教师端";
    }
    return Scaffold(
      appBar: const MyAppBar().build(
        context,
        appTitle,
        const Icon(Icons.checklist),
      ),
      body: Row(
        children: [
          NavigationRail(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            indicatorColor: Theme.of(context).colorScheme.background,
            minExtendedWidth: 200,
            unselectedLabelTextStyle: TextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.onBackground,
              fontWeight: FontWeight.w500,
            ),
            selectedLabelTextStyle: TextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
            extended: true,
            destinations: [
              const NavigationRailDestination(
                icon: Icon(Icons.settings),
                label: Text('设置'),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.people),
                label: const Text('学生管理'),
                disabled: Status.user.type == 0 ? true : false,
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.article),
                label: const Text('题库'),
                disabled: Status.user.type == 0 ? true : false,
              ),
              const NavigationRailDestination(
                icon: Icon(Icons.edit_document),
                label: Text('作业'),
              ),
              const NavigationRailDestination(
                icon: Icon(Icons.person),
                label: Text('我的'),
              ),
            ],
            selectedIndex: Status.pageId,
            onDestinationSelected: (value) {
              Status.pageId = value;
              setState(() {});
            },
          ),
          const Expanded(
            child: Center(
              child: GeneratorPage(),
            ),
          ),
        ],
      ),
    );
  }
}

class GeneratorPage extends StatefulWidget {
  const GeneratorPage({super.key});

  @override
  State<GeneratorPage> createState() => _GeneratorPageState();
}

class _GeneratorPageState extends State<GeneratorPage> {
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
      const Duration(milliseconds: 100),
      (timer) {
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Status.pageId == 0) {
      return const SizedBox(
        width: 400,
        child: SettingPage(),
      );
    } else if (Status.pageId == 1) {
      return const StuManPage();
    } else if (Status.pageId == 2) {
      return const ProblemSetPage();
    } else if (Status.pageId == 3) {
      return const HomeworkPage();
    } else if (Status.pageId == 4) {
      return const SizedBox(
        width: 400,
        child: MyPage(),
      );
    }
    return const SettingPage();
  }
}
