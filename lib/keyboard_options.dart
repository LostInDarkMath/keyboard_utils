class KeyboardOptions {
  KeyboardOptions({
    required this.isKeyboardOpen,
    required this.keyboardHeight,
  });

  final bool isKeyboardOpen;
  final double keyboardHeight;

  KeyboardOptions.fromJson(Map<String, dynamic> json):
    isKeyboardOpen = json['isKeyboardOpen'] as bool,
    keyboardHeight = (json['keyboardHeight'] as num).toDouble();

  Map<String, dynamic> toJson() => <String, dynamic>{
    'isKeyboardOpen': isKeyboardOpen,
    'keyboardHeight': keyboardHeight,
  };
}
