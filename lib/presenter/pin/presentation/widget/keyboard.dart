import 'package:flutter/material.dart';

typedef KeyboardTapCallback = void Function(String text);

const _keyboardBottomPadding = 36.0;

@immutable
class KeyboardUIConfig {
  final TextStyle digitTextStyle;
  final Color splashColor;
  final Color digitFillColor;

  //Size for the keyboard can be define and provided from the app.
  //If it will not be provided the size will be adjusted to a screen size.
  final Size? keyboardSize;

  const KeyboardUIConfig({
    this.splashColor = Colors.grey,
    this.digitFillColor = Colors.transparent,
    this.digitTextStyle = const TextStyle(fontSize: 30, color: Colors.black),
    this.keyboardSize,
  });
}

class KeyboardKey {
  final VoidCallback onTap;
  final Widget child;

  KeyboardKey({required this.onTap, required this.child});
}

class Keyboard extends StatelessWidget {
  final KeyboardUIConfig keyboardUIConfig;
  final KeyboardTapCallback onKeyboardTap;
  final KeyboardKey? bottomLeftKey;
  final KeyboardKey? bottomRightKey;

  final List<String> digits = const [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '0',
  ];

  const Keyboard({
    Key? key,
    required this.keyboardUIConfig,
    required this.onKeyboardTap,
    this.bottomLeftKey,
    this.bottomRightKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => _buildKeyboard(context);

  Widget _buildKeyboard(BuildContext context) {
    var keyboardItems = List<dynamic>.from(digits);
    keyboardItems.insert(
      keyboardItems.length - 1,
      bottomLeftKey ?? const SizedBox(),
    );
    keyboardItems.add(bottomRightKey ?? const SizedBox());
    final screenSize = MediaQuery.of(context).size;
    final keyboardHeight = screenSize.height > screenSize.width
        ? screenSize.height / 2
        : screenSize.height - 80;
    final keyboardWidth = keyboardHeight * 3 / 4;
    final keyboardSize = keyboardUIConfig.keyboardSize != null
        ? keyboardUIConfig.keyboardSize!
        : Size(keyboardWidth, keyboardHeight);

    return Container(
      width: keyboardSize.width,
      height: keyboardSize.height,
      margin: const EdgeInsets.only(
        bottom: _keyboardBottomPadding,
      ),
      child: AlignedGrid(
        keyboardSize: keyboardSize,
        children: List.generate(keyboardItems.length, (index) {
          final item = keyboardItems[index];

          return item is String
              ? _buildKeyboardDigit(context: context, text: item)
              : item is KeyboardKey
                  ? _buildKeyboardKey(
                      child: item.child,
                      onTap: item.onTap,
                    )
                  : item;
        }),
      ),
    );
  }

  Widget _buildKeyboardKey({
    required Widget child,
    required VoidCallback onTap,
    Key? key,
  }) {
    return Container(
      margin: const EdgeInsets.all(4),
      child: ClipOval(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            key: key,
            splashColor: keyboardUIConfig.splashColor,
            onTap: onTap,
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _buildKeyboardDigit({
    required BuildContext context,
    required String text,
  }) {
    return _buildKeyboardKey(
      key: Key(text),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: keyboardUIConfig.digitFillColor,
        ),
        child: Center(
          child: Text(
            text,
            style:
                Theme.of(context).textTheme.headline6?.copyWith(fontSize: 30),
            semanticsLabel: text,
          ),
        ),
      ),
      onTap: () => onKeyboardTap(text),
    );
  }
}

class AlignedGrid extends StatelessWidget {
  final double runSpacing = 4;
  final double spacing = 4;
  final int listSize;
  final columns = 3;
  final List<Widget> children;
  final Size keyboardSize;

  const AlignedGrid({
    Key? key,
    required this.children,
    required this.keyboardSize,
  })  : listSize = children.length,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final primarySize = keyboardSize.width > keyboardSize.height
        ? keyboardSize.height
        : keyboardSize.width;
    final itemSize = (primarySize - runSpacing * (columns - 1)) / columns;

    return Wrap(
      runSpacing: runSpacing,
      spacing: spacing,
      alignment: WrapAlignment.center,
      children: children
          .map((item) => SizedBox(
                width: itemSize,
                height: itemSize,
                child: item,
              ))
          .toList(growable: false),
    );
  }
}
