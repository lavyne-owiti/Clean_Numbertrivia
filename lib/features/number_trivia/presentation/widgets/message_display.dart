import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class MessageDisplay extends StatelessWidget {
  final String message;

  const MessageDisplay({
    required this.message,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: Center(
        child: SingleChildScrollView(
          child: Text(
            message,
            style: const TextStyle(fontSize: 30),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}