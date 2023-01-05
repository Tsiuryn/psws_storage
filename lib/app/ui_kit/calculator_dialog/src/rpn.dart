import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

void main() async {
  var text = '2 + 2${RPN.sqrt}9';
  var list = await RPN.calculate(text);
  if (kDebugMode) {
    print(list);
  }
}

class RPN {
  static const plus = '+';
  static const minus = '-';
  static const multiply = '×';
  static const divide = '÷';
  static const exp = '^';
  static const percent = '%';
  static const bracketOpen = '(';
  static const bracketClose = ')';
  static const space = ' ';
  static const minusUnary = 'u-';
  static const sqrt = '√';

  static Future<String> calculate(String infix) async {
    double doubleResult = 0.0;
    try {
      final postfix = await _parse(infix);
      List<double> stack = [];
      for (var i = 0; i < postfix.length; ++i) {
        final el = postfix[i];
        switch (el) {
          case sqrt:
            {
              final a = stack.pop();
              final b = stack.pop();
              stack.push(pow(a, 1.0 / b));
              break;
            }
          case plus:
            {
              stack.push(stack.pop() + stack.pop());
              break;
            }
          case minus:
            {
              final b = stack.pop();
              final a = stack.pop();
              stack.push(a - b);
              break;
            }
          case minusUnary:
            {
              stack.push(-stack.pop());
              break;
            }
          case divide:
            {
              final b = stack.pop();
              final a = stack.pop();
              stack.push(a / b);
              break;
            }
          case multiply:
            {
              stack.push(stack.pop() * stack.pop());
              break;
            }
          case exp:
            {
              final a = stack.pop();
              final b = stack.pop();
              stack.push(pow(b, a));
              break;
            }
          case percent:
            {
              final a = stack.pop();
              final b = stack.pop();
              final nextPostfix = postfix[i + 1];
              switch (nextPostfix) {
                case plus:
                  {
                    final result = b + a * b / 100;
                    stack.push(result);
                    postfix.removeAt(i + 1);
                    break;
                  }
                case minus:
                  {
                    final result = b - a * b / 100;
                    stack.push(result);
                    postfix.removeAt(i + 1);
                    break;
                  }
                case divide:
                  {
                    final result = b * 100 / a;
                    stack.push(result);
                    postfix.removeAt(i + 1);
                    break;
                  }
                case multiply:
                  {
                    final result = a * b / 100;
                    stack.push(result);
                    postfix.removeAt(i + 1);
                    break;
                  }
              }

              break;
            }
          default:
            stack.push(double.parse(el));
        }
      }

      doubleResult = stack.pop();
    } catch (e) {
      return 'Invalid value';
    }

    return doubleResult.toString();
  }

  static Future<List<String>> _parse(String infix) async {
    List<String> postfix = [];
    List<String> stack = [];

    List<String> tokenizer = await _getTokens(infix);
    String prev = '';
    String curr = '';
    for (var element in tokenizer) {
      curr = element;
      if (curr == space) continue;
      if (_isFunction(curr))
        stack.push(curr);
      else if (_isDelimiter(curr)) {
        if (curr == bracketOpen)
          stack.push(curr);
        else if (curr == bracketClose) {
          while (stack.peek() != bracketOpen) {
            postfix.add(stack.pop());
          }
          stack.pop();
          if (stack.isNotEmpty && _isFunction(stack.peek())) {
            postfix.add(stack.pop());
          }
        } else {
          if (curr == minus && prev == '' || _isDelimiter(prev) && prev != bracketClose) {
            curr = minusUnary;
          } else {
            while (stack.isNotEmpty && _priority(curr) <= _priority(stack.peek())) {
              postfix.add(stack.pop());
            }
          }
          stack.push(curr);
        }
      } else {
        postfix.add(curr);
      }
      prev = curr;
    }

    while (stack.isNotEmpty) {
      postfix.add(stack.pop());
    }

    return postfix;
  }

  static const String _operators = '$plus$minus$multiply$divide$percent$exp$sqrt))';
  static const String _delimiters = '()$_operators';

  static bool _isDelimiter(String token) {
    if (token.length != 1) return false;
    for (var i = 0; i < _delimiters.length; ++i) {
      if (_delimiters[i] == token) return true;
    }
    return false;
  }

  static bool _isFunction(String token) {
    if (sqrt == token || exp == token) return true;

    return false;
  }

  static int _priority(String token) {
    switch (token) {
      case bracketOpen:
        return 1;
      case plus:
      case minus:
        return 2;
      case multiply:
      case divide:
        return 3;
      default:
        return 4;
    }
  }

  static Future<List<String>> _getTokens(String infix) async {
    final setDelimiters = _delimiters.runes.map((e) => String.fromCharCode(e)).toSet();

    final tokenizer = Tokenizer(setDelimiters);
    final stream = StreamController<String>();

    stream.add(infix);
    stream.close();

    return stream.stream.transform(tokenizer.streamTransformer).toList();
  }
}

extension ListStack on List {
  void push<T>(T char) {
    this.insert(0, char);
  }

  void put(String char) {
    if (char.isNotEmpty) {
      this.add(char);
    }
  }

  T pop<T>() {
    var symbol = this[0];
    if (this.length > 0) {
      this.removeAt(0);
    }
    return symbol;
  }

  String peek() {
    if (this.length > 0) {
      return this[0];
    } else
      return '';
  }
}

class Tokenizer {
  Set<String> delimiters = {' ', '\n'};

  late StreamTransformer<String, String> streamTransformer;

  Tokenizer([Set<String>? delimiters]) {
    this.delimiters.addAll(delimiters ?? {});

    streamTransformer = StreamTransformer.fromHandlers(
      handleData: (data, sink) {
        for (var token in tokenize(data)) {
          sink.add(token);
        }
      },
    );
  }

  Iterable<String> tokenize(String chunk) sync* {
    String _sequence = '';

    for (int i = 0; i < chunk.length; i++) {
      final char = chunk[i];

      if (delimiters.contains(char)) {
        if (_sequence.length > 0) yield _sequence;
        yield char;
        _sequence = '';
      } else {
        _sequence += char;
      }
    }

    if (_sequence.length > 0) yield _sequence;
  }
}
