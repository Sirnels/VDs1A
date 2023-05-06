import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final double radius;
  const Loader({
    Key? key,
    this.radius = 10.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: CupertinoActivityIndicator(
      color: CupertinoColors.systemYellow,
      radius: radius,
    ));
  }
}

class LoaderAll extends StatelessWidget {
  const LoaderAll({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: CupertinoActivityIndicator(
      color: CupertinoColors.darkBackgroundGray,
    ));
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Loader(),
    );
  }
}
