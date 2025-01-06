import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psws_storage/habit/domain/entity/habit.dart';

import '../util/constants.dart';

class MyResultBox extends StatelessWidget {
  final List<Habit>? list;

  const MyResultBox({
    super.key,
    this.list,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 4,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
      contentPadding: EdgeInsets.zero,
      content: Container(
        height: list == null ? resultDialogHeightEmpty : resultDialogHeightFull,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(32)),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: list == null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(resultDialogEmpty),
                      Text(
                        '😥',
                        style: TextStyle(fontSize: 32),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      ...list!.map((e) => ListTile(
                            title: Text(e.title, style: textStyle),
                            trailing: Text(
                              e.completed ? cool : bad,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ))
                    ],
                  ),
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            dialogBtnOk,
            style: TextStyle(fontSize: 24),
          ),
        ),
      ],
    );
  }
}

const cool = '✅';
const bad = '❌';
const textStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
);
