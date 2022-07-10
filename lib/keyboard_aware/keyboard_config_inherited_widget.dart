import 'package:flutter/material.dart';
import 'package:keyboard_utils/keyboard_options.dart';

class KeyboardConfigInheritedWidget extends InheritedWidget {
  const KeyboardConfigInheritedWidget({
    this.keyboardConfig,
    required Widget child,
    Key? key,
  }) : super(child: child, key: key);

  final KeyboardOptions? keyboardConfig;

  @override
  bool updateShouldNotify(KeyboardConfigInheritedWidget oldWidget) {
    return keyboardConfig != oldWidget.keyboardConfig;
  }

  static KeyboardConfigInheritedWidget? of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<KeyboardConfigInheritedWidget>();
}
