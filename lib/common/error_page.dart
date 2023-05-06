import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  final String error;
  final errorCode;
  const ErrorText({
    super.key,
    required this.error,
    this.errorCode,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          width: 200,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0, 11),
                    blurRadius: 11,
                    color:
                        CupertinoColors.lightBackgroundGray.withOpacity(0.06))
              ],
              borderRadius: BorderRadius.circular(5),
              color: CupertinoColors.systemRed),
          padding: const EdgeInsets.all(5.0),
          child: Text(error)),
    );
  }
}

class ErrorPage extends StatelessWidget {
  final String error;
  const ErrorPage({
    super.key,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ErrorText(error: error),
    );
  }
}
