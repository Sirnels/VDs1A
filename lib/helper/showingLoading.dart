// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

showLoading() {
  Get.defaultDialog(
      title: "ViewDucting...",
      content: const CircularProgressIndicator(),
      // barrierDismissible: false,
      backgroundColor: Colors.grey.shade100);
}

dismissLoadingWidget() {
  Get.back();
}
