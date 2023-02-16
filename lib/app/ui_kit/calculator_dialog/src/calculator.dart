//package imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'buttons.dart';
import 'rpn.dart';

//widget import

class CalculatorResult {
  final String userInput;
  final String answer;

  const CalculatorResult({
    required this.userInput,
    required this.answer,
  });
}

class CalculatorDialog extends StatefulWidget {
  const CalculatorDialog({Key? key}) : super(key: key);

  @override
  State<CalculatorDialog> createState() => _CalculatorDialogState();
}

class _CalculatorDialogState extends State<CalculatorDialog> {
  var userInput = '';

  var answer = '';

  bool hasOperand = false;

  bool divByZero = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (divByZero) {
      divByZero = false;
    }
  }

// Array of button
  final List<String> buttons = [
    '7',
    '8',
    '9',
    RPN.divide,
    '4',
    '5',
    '6',
    RPN.multiply,
    '1',
    '2',
    '3',
    RPN.minus,
    '00',
    '0',
    '.',
    RPN.plus,
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      content: StatefulBuilder(
        builder: (ctx, setState) => Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16))),
          width: 200,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      flex: 70,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(20),
                            alignment: Alignment.centerRight,
                            child: Text(
                              userInput,
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Container(
                                    padding: const EdgeInsets.all(15),
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      answer,
                                      maxLines: 1,
                                      style: const TextStyle(
                                          fontSize: 30,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (divByZero)
                            const Text(
                              "Can't divide by zero!",
                              style: TextStyle(color: Colors.red),
                            ),
                          if (double.tryParse(answer) != null &&
                              double.parse(answer) >= 10000000000)
                            const Text(
                              "Amount must be less than 10,000,000,000!",
                              style: TextStyle(color: Colors.red),
                            )
                        ],
                      ),
                    ),
                    const VerticalDivider(
                      indent: 20,
                      endIndent: 20,
                      thickness: 2,
                      color: Colors.grey,
                    ),
                    Expanded(
                      flex: 21,
                      child: IconButton(
                        onPressed: () async {
                          //handle case of backspace on empty before removal
                          if (userInput.isEmpty) return;
                          userInput =
                              userInput.substring(0, userInput.length - 1);
                          //handle case of backspace on empty after removal
                          if (userInput.isEmpty) {
                            answer = "";
                          } else if (!isOperator(
                              userInput[userInput.length - 1])) {
                            await solve();
                          }
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.backspace_outlined,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border.symmetric(
                    horizontal: BorderSide(
                      color: Colors.grey,
                      width: 2,
                    ),
                  ),
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: buttons.length,
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4),
                  itemBuilder: (BuildContext context, int index) => MyButton(
                    onPressed: () async {
                      await calculator(buttons[index]);
                      setState(() {});
                    },
                    buttonText: buttons[index],
                    color:
                        isOperator(buttons[index]) ? Colors.grey : Colors.white,
                    textColor: isOperator(buttons[index])
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "CANCEL",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              userInput = '';
              answer = '0';
              divByZero = false;
            });
          },
          child: const Text(
            "CLEAR",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(
                context,
                CalculatorResult(
                  userInput: userInput,
                  answer: answer,
                ));
          },
          child: const Text(
            "DONE",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
      actionsAlignment: MainAxisAlignment.spaceEvenly,
    );
  }

  bool isOperator(String x) {
    if (x == RPN.divide ||
        x == RPN.multiply ||
        x == RPN.minus ||
        x == RPN.plus ||
        x == '=') {
      return true;
    }
    return false;
  }

  Future<void> calculator(String btnText) async {
    divByZero = false;
    //handling of consecutive operator error
    if (isOperator(btnText) &&
        (userInput == "" || isOperator(userInput[userInput.length - 1]))) {
      return;
    }
    //handling errors related to decimal
    if (btnText == ".") {
      if (userInput != "") {
        String lastEl = userInput[userInput.length - 1];
        if (lastEl == ".") {
          return;
        } else if (isOperator(lastEl)) {
          userInput = "${userInput}0.";
          if (lastEl == "/") {
            divByZero = true;
          }
          return;
        }
      } else {
        userInput = "${userInput}0.";
        return;
      }
    }

    userInput = userInput + btnText;

    if (isOperator(btnText)) {
      hasOperand = true;
    } else if (hasOperand) {
      await solve();
    } else {
      answer = userInput;
    }
  }

  Future<void> solve() async {
    divByZero = false;
    String finalUserInput = userInput;

    final result = await RPN.calculate(finalUserInput);

    answer = _updateResult(double.parse(result));
    if (answer == "Infinity") {
      divByZero = true;
      answer = "";
    }
  }

  String _updateResult(double result) {
    return NumberFormat.decimalPattern().format(result);
  }
}
