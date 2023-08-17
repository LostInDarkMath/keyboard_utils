import 'dart:async';

import 'package:flutter/material.dart';

import 'package:keyboard_utils/keyboard_utils.dart';
import 'package:keyboard_utils/keyboard_listener.dart' as keyboard_listener;
import 'package:keyboard_utils/widgets.dart';

void main() => runApp(const MyApp());

// Sample Bloc
class KeyboardBloc {
  final _keyboardUtils = KeyboardUtils();
  final _streamController = StreamController<double>();
  Stream<double> get stream => _streamController.stream;

  KeyboardUtils get keyboardUtils => _keyboardUtils;

  int _idKeyboardListener = 0;

  void start() {
    _idKeyboardListener = _keyboardUtils.add(
        listener: keyboard_listener.KeyboardListener(willHideKeyboard: () {
<<<<<<< Updated upstream
      _streamController.sink.add(_keyboardUtils.keyboardHeight);
    }, willShowKeyboard: (double keyboardHeight) {
=======
      debugPrint('willHideKeyboard: ${_keyboardUtils.keyboardHeight}');
      _streamController.sink.add(_keyboardUtils.keyboardHeight);
    }, willShowKeyboard: (double keyboardHeight) {
          debugPrint('willShowKeyboard: $keyboardHeight');
          debugPrint('ratio: ${WidgetsBinding.instance.window.devicePixelRatio}');
          debugPrint('view padding: ${WidgetsBinding.instance.window.viewPadding}');
>>>>>>> Stashed changes
      _streamController.sink.add(keyboardHeight);
    }));
  }

  void dispose() {
    _keyboardUtils.unsubscribeListener(subscribingId: _idKeyboardListener);
    if (_keyboardUtils.canCallDispose()) {
      _keyboardUtils.dispose();
    }
    _streamController.close();
  }
}

// App
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _bloc = KeyboardBloc();

  @override
  void initState() {
    super.initState();

    _bloc.start();
  }

  Widget buildSampleUsingKeyboardAwareWidget() {
    return Center(
      child: Column(
        children: <Widget>[
          const TextField(),
          const TextField(
            keyboardType: TextInputType.number,
          ),
          const TextField(),
          const SizedBox(
            height: 30,
          ),
          KeyboardAware(
            builder: (context, keyboardConfig) {
              return Text('is keyboard open: ${keyboardConfig.isKeyboardOpen}\n'
                  'Height: ${keyboardConfig.keyboardHeight}');
            },
          ),
        ],
      ),
    );
  }

  Widget buildSampleUsingRawListener() {
    return Center(
      child: Column(
        children: <Widget>[
          const TextField(),
          const TextField(
            keyboardType: TextInputType.number,
          ),
          const TextField(),
          const SizedBox(
            height: 30,
          ),
          StreamBuilder<double>(
              stream: _bloc.stream,
              builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                return Text(
                    'is keyboard open: ${_bloc.keyboardUtils.isKeyboardOpen}\n'
                    'Height: ${_bloc.keyboardUtils.keyboardHeight}');
              }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Keyboard Utils Sample'),
        ),
        body: buildSampleUsingKeyboardAwareWidget(),
      ),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();

    super.dispose();
  }
}
