// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:viewducts/admin/Admin_dashbord/constants.dart';
import 'package:viewducts/state/stateController.dart';

class CloudStorageInfo {
  final String? svgSrc, title, totalStorage;
  final int? numOfFiles, percentage;
  final Color? color;
  final Function? ontap;

  CloudStorageInfo({
    this.svgSrc,
    this.title,
    this.totalStorage,
    this.numOfFiles,
    this.percentage,
    this.color,
    this.ontap,
  });
}

List demoMyFiles = [
  CloudStorageInfo(
      title: "Users",
      numOfFiles: searchState.userlist?.length,
      svgSrc: "assets/user.png",
      totalStorage: searchState.userlist?.length.toString(),
      color: primaryColor,
      percentage: 35,
      ontap: () {}),
  CloudStorageInfo(
      title: "Orders",
      numOfFiles: 1328,
      svgSrc: "assets/groceries.png",
      totalStorage: "2.9GB",
      color: const Color(0xFFFFA113),
      percentage: 35,
      ontap: () {}),
  CloudStorageInfo(
      title: "Add Product",
      numOfFiles: 1328,
      svgSrc: "assets/shopping-bag.png",
      totalStorage: "1GB",
      color: const Color(0xFFA4CDFF),
      percentage: 10,
      ontap: () {}),
  CloudStorageInfo(
      title: "Proccessing Orders",
      numOfFiles: 5328,
      svgSrc: "assets/carts.png",
      totalStorage: "",
      color: const Color(0xFF007EE5),
      percentage: 78,
      ontap: () {}),
  CloudStorageInfo(
      title: "Market Category",
      numOfFiles: 5328,
      svgSrc: "assets/carts.png",
      totalStorage: "7.3GB",
      color: const Color(0xFF007EE5),
      percentage: 78,
      ontap: () {}),
  CloudStorageInfo(
      title: "Staff",
      numOfFiles: 5328,
      svgSrc: "assets/home 1.png",
      totalStorage: "7.3GB",
      color: const Color(0xFF007EE5),
      percentage: 78,
      ontap: () {}),
  CloudStorageInfo(
      title: "Payment Request",
      numOfFiles: 5328,
      svgSrc: "assets/user.png",
      totalStorage: "7.3GB",
      color: const Color(0xFF007EE5),
      percentage: 78,
      ontap: () {}),
];
