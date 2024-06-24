// ignore: file_names
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class EditPinPage extends StatefulWidget {
  const EditPinPage({super.key});

  @override
  State<EditPinPage> createState() => _EditPinPageState();
}
class _EditPinPageState extends State<EditPinPage> {
  String enteredOldPin = '';
  String enteredNewPin = '';
  bool isPinVisible = false;
  final pinBox = Hive.box('pinBox');

  bool isEnteringOldPin = true;

  Widget numButton(int number) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (isEnteringOldPin && enteredOldPin.length < 4) {
              enteredOldPin += number.toString();
            } else if (!isEnteringOldPin && enteredNewPin.length < 4) {
              enteredNewPin += number.toString();
            }
            handlePinSubmission();
          });
        },
        child: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.blueGrey[700],
          child: Text(
            number.toString(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void handlePinSubmission() {
    if (isEnteringOldPin) {
      if (enteredOldPin.length == 4) {
        if (pinBox.get('pin') == enteredOldPin) {
          setState(() {
            isEnteringOldPin = false;
            enteredOldPin = '';
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Old Pin is incorrect'),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            enteredOldPin = '';
            enteredNewPin = '';
          });
        }
      }
    } else {
      if (enteredNewPin.length == 4) {
        pinBox.put('pin', enteredNewPin);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pin updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          enteredOldPin = '';
          enteredNewPin = '';
          isEnteringOldPin = true;
        });
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          physics: const BouncingScrollPhysics(),
          children: [
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'Edit Pin',
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.blue,
                              offset: Offset(5.0, 5.0),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isEnteringOldPin ? 'Old Pin:' : 'New Pin:',
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            4,
                            (index) => Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isEnteringOldPin
                                    ? index < enteredOldPin.length
                                        ? Colors.blue
                                        : Colors.white54
                                    : index < enteredNewPin.length
                                        ? Colors.blue
                                        : Colors.white54,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: isPinVisible &&
                                      ((isEnteringOldPin &&
                                              index < enteredOldPin.length) ||
                                          (!isEnteringOldPin &&
                                              index < enteredNewPin.length))
                                  ? Center(
                                      child: Text(
                                        isEnteringOldPin
                                            ? enteredOldPin[index]
                                            : enteredNewPin[index],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isPinVisible = !isPinVisible;
                      });
                    },
                    icon: Icon(
                      isPinVisible ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            Column(
              children: [
                for (var i = 0; i < 3; i++)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      3,
                      (index) => numButton(1 + 3 * i + index),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(width: 46),
                    numButton(0),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (isEnteringOldPin &&
                              enteredOldPin.isNotEmpty &&
                              enteredNewPin.isEmpty) {
                            enteredOldPin = enteredOldPin.substring(
                                0, enteredOldPin.length - 1);
                          } else if (!isEnteringOldPin &&
                              enteredNewPin.isNotEmpty) {
                            enteredNewPin = enteredNewPin.substring(
                                0, enteredNewPin.length - 1);
                          }
                        });
                      },
                      icon: const Icon(
                        Icons.backspace,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
