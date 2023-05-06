import 'package:flutter/material.dart';
import 'package:viewducts/widgets/frosted.dart';

import '../../../constants.dart';
import 'chart.dart';
import 'storage_info_card.dart';

class StarageDetails extends StatelessWidget {
  const StarageDetails({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return frostedBlueGray(
      Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: const BoxDecoration(
          //color: secondaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Storage Details",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: defaultPadding),
            const Chart(),
            StorageInfoCard(
              svgSrc: "assets/icons/Documents.svg",
              title: "Documents Files",
              amountOfFiles: Container(),
              numOfFiles: Container(),
            ),
            StorageInfoCard(
              svgSrc: "assets/icons/media.svg",
              title: "Media Files",
              amountOfFiles: Container(),
              numOfFiles: Container(),
            ),
            StorageInfoCard(
              svgSrc: "assets/icons/folder.svg",
              title: "Other Files",
              amountOfFiles: Container(),
              numOfFiles: Container(),
            ),
            StorageInfoCard(
              svgSrc: "assets/icons/unknown.svg",
              title: "Unknown",
              amountOfFiles: Container(),
              numOfFiles: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
