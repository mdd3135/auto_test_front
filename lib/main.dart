import 'dart:async';

import 'package:auto_test_front/page/homePage.dart';
import 'package:auto_test_front/page/loginPage.dart';
import 'package:auto_test_front/status.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  } catch (e) {}

  Status.prefs = await SharedPreferences.getInstance();
  int? colorId = Status.prefs.getInt("colorId");
  bool? isDark = Status.prefs.getBool("isDark");
  Status.colorId = colorId ?? Status.colorId;
  Status.isDark = isDark ?? Status.isDark;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyMaterialApp();
  }
}

class MyMaterialApp extends StatefulWidget {
  const MyMaterialApp({super.key});

  @override
  State<MyMaterialApp> createState() => _MyMaterialAppState();
}

class _MyMaterialAppState extends State<MyMaterialApp> {
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late Color seedColor;
    if (Status.colorId == 0) {
      seedColor = Colors.red;
    } else if (Status.colorId == 1) {
      seedColor = Colors.purple;
    } else if (Status.colorId == 2) {
      seedColor = Colors.blue;
    } else if (Status.colorId == 3) {
      seedColor = Colors.cyan;
    } else if (Status.colorId == 4) {
      seedColor = Colors.teal;
    } else if (Status.colorId == 5) {
      seedColor = Colors.green;
    } else if (Status.colorId == 6) {
      seedColor = Colors.orange;
    }
    return MaterialApp(
      title: '自动批改的在线测试系统',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Status.isDark ? Brightness.dark : Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const MainPage(),
      debugShowCheckedModeBanner: false,
      navigatorObservers: [BotToastNavigatorObserver()],
      builder: BotToastInit(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowManager.maximize();
    if (Status.login == false) {
      return const LoginPage();
    } else {
      return const HomePage();
    }
  }
}
