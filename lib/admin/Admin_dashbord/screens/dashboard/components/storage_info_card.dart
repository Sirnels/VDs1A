import 'package:flutter/material.dart';

import '../../../constants.dart';

class StorageInfoCard extends StatelessWidget {
  const StorageInfoCard({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.amountOfFiles,
    required this.numOfFiles,
    this.textStyle,
  }) : super(key: key);
  final TextStyle? textStyle;
  final String title, svgSrc;
  final Widget amountOfFiles, numOfFiles;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: defaultPadding),
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: primaryColor.withOpacity(0.15)),
        borderRadius: const BorderRadius.all(
          Radius.circular(defaultPadding),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 20,
            width: 20,
            child: Image.asset(svgSrc),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    style: textStyle ?? const TextStyle(color: Colors.white70),
                    overflow: TextOverflow.ellipsis,
                  ),
                  numOfFiles,
                ],
              ),
            ),
          ),
          amountOfFiles,
        ],
      ),
    );
  }
}

class StorageInfoCards extends StatelessWidget {
  const StorageInfoCards({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.amountOfFiles,
    required this.numOfFiles,
    this.textStyle,
  }) : super(key: key);
  final TextStyle? textStyle;
  final Widget title;
  final String svgSrc;
  final Widget amountOfFiles, numOfFiles;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: defaultPadding),
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: primaryColor.withOpacity(0.15)),
        borderRadius: const BorderRadius.all(
          Radius.circular(defaultPadding),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 20,
            width: 20,
            child: Image.asset(svgSrc),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title,
                  numOfFiles,
                ],
              ),
            ),
          ),
          amountOfFiles,
        ],
      ),
    );
  }
}
