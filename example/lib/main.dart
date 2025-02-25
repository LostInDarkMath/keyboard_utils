import 'dart:async';

import 'package:flutter/material.dart';

import 'package:keyboard_utils/keyboard_utils.dart';
import 'package:keyboard_utils/keyboard_listener.dart' as keyboard_listener;
import 'package:keyboard_utils/widgets.dart';

void main() => runApp(MyApp());

// Sample Bloc
class KeyboardBloc {
  KeyboardUtils _keyboardUtils = KeyboardUtils();
  StreamController<double> _streamController = StreamController<double>();
  Stream<double> get stream => _streamController.stream;

  KeyboardUtils get keyboardUtils => _keyboardUtils;

  int _idKeyboardListener;

  void start() {
    _idKeyboardListener = _keyboardUtils.add(
        listener: keyboard_listener.KeyboardListener(willHideKeyboard: () {
      print('willHideKeyboard: ${_keyboardUtils.keyboardHeight}');
      _streamController.sink.add(_keyboardUtils.keyboardHeight);
    }, willShowKeyboard: (double keyboardHeight) {
      print('willShowKeyboard: $keyboardHeight');
      print('ratio: ${WidgetsBinding.instance.window.devicePixelRatio}');
      print('view padding: ${WidgetsBinding.instance.window.viewPadding}');
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
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  KeyboardBloc _bloc = KeyboardBloc();

  @override
  void initState() {
    super.initState();

    _bloc.start();
  }

  Widget buildSampleUsingKeyboardAwareWidget() {
    return Center(
      child: Column(
        children: <Widget>[
          TextField(),
          TextField(
            keyboardType: TextInputType.number,
          ),
          TextField(),
          SizedBox(
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
          TextField(),
          TextField(
            keyboardType: TextInputType.number,
          ),
          TextField(),
          SizedBox(
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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Keyboard Utils Sample'),
        ),
        body: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  buildSampleUsingKeyboardAwareWidget(),
                  Expanded(child: Container()),
                  Container(
                    height: 10.0,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
            StreamBuilder<double>(
              stream: _bloc.stream,
              builder: (context, snapshot) => Offstage(
                offstage: !_bloc.keyboardUtils.isKeyboardOpen,
                child: SizedBox(
                  height: _bloc.keyboardUtils.keyboardHeight + 30, // TODO where does this offset came from?
                  child: Container(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
