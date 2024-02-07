import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class MyAppBar {
  const MyAppBar();

  PreferredSizeWidget build(
    BuildContext context,
    String title,
    Icon? leadding,
  ) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      leading: leadding,
      actions: [
        IconButton(
          onPressed: () {
            windowManager.minimize();
          },
          icon: const Icon(Icons.remove),
        ),
        const SizedBox(
          width: 10,
        ),
        IconButton(
          onPressed: () {
            windowManager.close();
          },
          icon: const Icon(Icons.close),
        ),
        const SizedBox(
          width: 10,
        ),
      ],
    );
  }
}
