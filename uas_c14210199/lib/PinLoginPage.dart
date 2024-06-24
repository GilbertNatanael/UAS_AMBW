// ignore: file_names
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uas_c14210199/notePage.dart';

class Pinloginpage extends StatefulWidget {
  const Pinloginpage({super.key});

  @override
  State<Pinloginpage> createState() => _PinCodeWidgetState();
}

class _PinCodeWidgetState extends State<Pinloginpage> {
  String enteredPin = '';
  bool isPinVisible = false;
  bool isCreatingPin = false;
  final pinBox = Hive.box('pinBox');

  @override
  void initState() {
    super.initState();
    if (pinBox.get('pin') == null) {
      setState(() {
        isCreatingPin = true;
      });
    }
  }

  Widget numButton(int number) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (enteredPin.length < 4) {
              enteredPin += number.toString();
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
    if (enteredPin.length == 4) {
      if (isCreatingPin) {
        pinBox.put('pin', enteredPin);
        setState(() {
          isCreatingPin = false;
          enteredPin = '';
        });
      } else {
        if (pinBox.get('pin') == enteredPin) {
          setState(() {
            enteredPin = '';
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Notepage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Pin is incorrect'),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            enteredPin = '';
          });
        }
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
                  Text(
                    isCreatingPin ? 'Create Your Pin' : 'Enter Your Pin',
                    style: const TextStyle(
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
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      4,
                      (index) {
                        return Container(
                          margin: const EdgeInsets.all(8.0),
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index < enteredPin.length
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
                          child: isPinVisible && index < enteredPin.length
                              ? Center(
                                  child: Text(
                                    enteredPin[index],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : null,
                        );
                      },
                    ),
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
                          if (enteredPin.isNotEmpty) {
                            enteredPin =
                                enteredPin.substring(0, enteredPin.length - 1);
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
