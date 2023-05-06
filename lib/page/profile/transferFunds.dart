// ignore_for_file: invalid_use_of_visible_for_testing_member, dead_code

import 'dart:io';
import 'dart:async';
import 'package:minio/io.dart';
import 'package:minio/minio.dart';
import 'package:path/path.dart' as path;
import 'package:animated_custom_dropdown/custom_dropdown.dart';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aws_s3_client/flutter_aws_s3_client.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:viewducts/encryption/uploadDownloadFiles.dart';
import 'package:viewducts/widgets/frosted.dart';

import '../../helper/utility.dart';

class TransferFunds extends HookWidget {
  final String? currency;
  final String? currencyId;
  TransferFunds({Key? key, this.currency, this.currencyId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    File? selectedFil;

    bool isLoading = false;
    bool uploaded = false;
    const region = "us-east-1";
    const bucketId = "storage-viewduct";
    final selectedFile = useState(selectedFil);
    Future<String?> _upload(File? selectedFile) async {
      String? result;
      try {
        await AwsS3.uploadFile(
            accessKey: "I6AC8ZFJQ5Z75PC9HXLA",
            secretKey: "qdiwW0clT8558Ual2NT8IVcqq7kByFMLCBBkERuO",
            file: selectedFile!,
            bucket: bucketId,
            destDir: 'storage-viewduct',
            acl: ACL.private,
            region: region);
        final AwsS3Client s3client = AwsS3Client(
            region: region,
            host: "s3.wasabisys.com",
            bucketId: bucketId,
            accessKey: "I6AC8ZFJQ5Z75PC9HXLA",
            secretKey: "qdiwW0clT8558Ual2NT8IVcqq7kByFMLCBBkERuO");
        var dd1 = await s3client
            .buildSignedGetParams(
                key:
                    '${DateTime.now().toUtc().toString().replaceAll(RegExp(r'\.\d*Z$'), 'Z').replaceAll(RegExp(r'[:-]|\.\d{3}'), '').split(' ').join('T')}${path.extension(selectedFile.path)}')
            .uri;
        final minio = Minio(
            endPoint: 's3.wasabisys.com',
            accessKey: 'I6AC8ZFJQ5Z75PC9HXLA',
            secretKey: 'qdiwW0clT8558Ual2NT8IVcqq7kByFMLCBBkERuO',
            region: 'us-east-1');

        await minio.fPutObject(
            'storage-viewduct',
            '${DateTime.now().toUtc().toString().replaceAll(RegExp(r'\.\d*Z$'), 'Z').replaceAll(RegExp(r'[:-]|\.\d{3}'), '').split(' ').join('T')}${path.extension(selectedFile.path)}',
            selectedFile.path);
        // await minio.presignedUrl();
        // AwsS3PluginFlutter awsS3 = AwsS3PluginFlutter(
        //     awsFolderPath: "testing",
        //     file: selectedFile!,
        //     fileNameWithExt: DateTime.now().millisecondsSinceEpoch.toString(),
        //     region: Regions.US_EAST_1,
        //     AWSAccess: "I6AC8ZFJQ5Z75PC9HXLA",
        //     AWSSecret: "qdiwW0clT8558Ual2NT8IVcqq7kByFMLCBBkERuO",
        //     bucketName: bucketId);
        // result = await awsS3.uploadFile;

        // IAMCrediental iamCrediental = IAMCrediental();
        // iamCrediental.secretKey = "I6AC8ZFJQ5Z75PC9HXLA";
        // iamCrediental.secretId = "qdiwW0clT8558Ual2NT8IVcqq7kByFMLCBBkERuO";
        // iamCrediental.identity = "s3.wasabisys.com";
        // ImageData imageData = ImageData(
        //     DateTime.now().millisecondsSinceEpoch.toString(),
        //     selectedFile!.path,
        //     imageUploadFolder: "storage-viewduct");
        // result = await Aws3Bucket.upload(bucketId, AwsRegion.US_EAST_1,
        //     AwsRegion.US_EAST_1, imageData, iamCrediental);
        cprint('$dd1');

        // if (result.isNotEmpty) {
        //   ScaffoldMessenger.of(context)
        //       .showSnackBar(SnackBar(content: Text(result)));
        // } else {
        //   ScaffoldMessenger.of(context)
        //       .showSnackBar(SnackBar(content: Text("Something Went Wrong")));
        // }
        // return result;
      } catch (e) {
        cprint('$e');
      }
      return result;
    }

    final controller = useTextEditingController();
    final walletController = useTextEditingController();
    final controllCurrency = useState(useTextEditingController());
    final currncyState = useState(currency);
    final paymentState = useState('');
    final feeState = useState(0);
    feeState.value =
        int.tryParse('{controllCurrency.value.text}') ?? feeState.value;
    useEffect(
      () {
        return () {};
      },
      [controllCurrency.value, selectedFil],
    );
    return Container(
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 11),
                                blurRadius: 11,
                                color: Colors.black.withOpacity(0.06))
                          ],
                          borderRadius: BorderRadius.circular(18),
                          color: CupertinoColors.inactiveGray),
                      padding: const EdgeInsets.all(5.0),
                      child: Icon(CupertinoIcons.add_circled_solid)),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 11),
                                blurRadius: 11,
                                color: Colors.black.withOpacity(0.06))
                          ],
                          borderRadius: BorderRadius.circular(18),
                          color: CupertinoColors.white),
                      padding: const EdgeInsets.all(5.0),
                      child: const Text(
                        'Withdraw Funds',
                        style: TextStyle(fontWeight: FontWeight.w200),
                      )),
                ),
              ]),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {},
                  child: frostedYellow(Container(
                      width: Get.height * 0.45,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(0, 11),
                              blurRadius: 11,
                              color: Colors.black.withOpacity(0.06))
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  offset: const Offset(0, 11),
                                                  blurRadius: 11,
                                                  color: Colors.black
                                                      .withOpacity(0.06))
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(18),
                                          ),
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            currncyState.value == 'Euro'
                                                ? '€ 0.00'
                                                : currncyState.value == 'Pounds'
                                                    ? '£ 0.00'
                                                    : currncyState.value ==
                                                            'Naira'
                                                        ? '₦ 0.00'
                                                        : '$currencyId 0.00',
                                            style: TextStyle(
                                                fontSize: Get.height * 0.065,
                                                color:
                                                    CupertinoColors.activeGreen,
                                                fontWeight: FontWeight.w900),
                                          )),
                                    ),
                                  ]),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            offset: const Offset(0, 11),
                                            blurRadius: 11,
                                            color:
                                                Colors.black.withOpacity(0.06))
                                      ],
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    padding: const EdgeInsets.all(2.0),
                                    child: Center(
                                      child: Row(
                                        children: [
                                          Text(
                                            'DuctWallet Number:',
                                            style: TextStyle(
                                                color: CupertinoColors
                                                    .darkBackgroundGray,
                                                fontWeight: FontWeight.w900),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      offset:
                                                          const Offset(0, 11),
                                                      blurRadius: 11,
                                                      color: Colors.black
                                                          .withOpacity(0.06))
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                                color: CupertinoColors
                                                    .activeOrange),
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              '234567890',
                                              style: TextStyle(
                                                  color: CupertinoColors
                                                      .darkBackgroundGray,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              )
                            ]),
                      ))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(0, 11),
                            blurRadius: 11,
                            color: Colors.black.withOpacity(0.06))
                      ],
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.all(5.0),
                    child: const Text(
                      'DuctWallet to transfer from',
                      style: TextStyle(fontWeight: FontWeight.w200),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: Get.height * 0.5,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(0, 11),
                          blurRadius: 11,
                          color: Colors.black.withOpacity(0.06))
                    ],
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: CustomDropdown(
                      hintText: currncyState.value,
                      items: currency == 'Euro'
                          ? ['$currency', 'Pounds', 'Naira']
                          : currency == 'Pounds'
                              ? ['$currency', 'Euro', 'Naira']
                              : currency == 'Naira'
                                  ? ['$currency', 'Pounds', 'Euro']
                                  : [],
                      fillColor: CupertinoColors.systemYellow,
                      onChanged: (data) {
                        currncyState.value = data;
                      },
                      controller: controller),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(0, 11),
                            blurRadius: 11,
                            color: Colors.black.withOpacity(0.06))
                      ],
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.all(5.0),
                    child: const Text(
                      'Amount to transfer',
                      style: TextStyle(fontWeight: FontWeight.w200),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.withOpacity(.3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    child: TextField(
                      controller: controllCurrency.value,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        icon: Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    offset: const Offset(0, 11),
                                    blurRadius: 11,
                                    color: Colors.black.withOpacity(0.06))
                              ],
                              borderRadius: BorderRadius.circular(18),
                              color: CupertinoColors.white),
                          padding: const EdgeInsets.all(5.0),
                          child: Text('${currncyState.value}',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        fillColor: CupertinoColors.systemYellow,
                        border: InputBorder.none,
                        hintText: "0.00",
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(0, 11),
                            blurRadius: 11,
                            color: Colors.black.withOpacity(0.06))
                      ],
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.all(5.0),
                    child: const Text(
                      'Amount recipient will receive',
                      style: TextStyle(fontWeight: FontWeight.w200),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Container(
                    width: Get.height * 0.5,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(0, 11),
                              blurRadius: 11,
                              color: Colors.black.withOpacity(0.06))
                        ],
                        borderRadius: BorderRadius.circular(10),
                        color: CupertinoColors.systemYellow),
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            Container(
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        offset: const Offset(0, 11),
                                        blurRadius: 11,
                                        color: Colors.black.withOpacity(0.06))
                                  ],
                                  borderRadius: BorderRadius.circular(18),
                                  color: CupertinoColors.white),
                              padding: const EdgeInsets.all(5.0),
                              child: Text('${currncyState.value}',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Text(
                                controllCurrency.value.text.isEmpty
                                    ? ' 0.00'
                                    : ' ${controllCurrency.value.text.trim()}',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ]),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          offset: const Offset(0, 11),
                                          blurRadius: 11,
                                          color: Colors.black.withOpacity(0.06))
                                    ],
                                    borderRadius: BorderRadius.circular(18),
                                    color: CupertinoColors.activeOrange),
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  'Fee:${controllCurrency.value.text.trim()}',
                                  style: TextStyle(fontWeight: FontWeight.w200),
                                )),
                          ),
                        ])),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: Get.height * 0.5,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(0, 11),
                          blurRadius: 11,
                          color: Colors.black.withOpacity(0.06))
                    ],
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: CustomDropdown(
                      hintText: 'Select Receiver Channel',
                      items: ['DuctWallet', 'Bank Account'],
                      fillColor: CupertinoColors.systemYellow,
                      onChanged: (data) {
                        paymentState.value = data;
                      },
                      controller: walletController),
                ),
              ),
              paymentState.value == 'DuctWallet'
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: Get.height * 0.6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.withOpacity(.3),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                          child: TextField(
                            controller: controllCurrency.value,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              icon: Container(
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          offset: const Offset(0, 11),
                                          blurRadius: 11,
                                          color: Colors.black.withOpacity(0.06))
                                    ],
                                    borderRadius: BorderRadius.circular(18),
                                    color: CupertinoColors.white),
                                padding: const EdgeInsets.all(5.0),
                                child: Text('DuctWallet',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              fillColor: CupertinoColors.systemYellow,
                              border: InputBorder.none,
                              hintText: "Add Receiver Wallet number",
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              Center(
                child: selectedFile.value != null
                    ? Image.file(selectedFile.value!)
                    : GestureDetector(
                        onTap: () async {
                          XTypeGroup typeGroup = XTypeGroup(
                            extensions: <String>['jpg', 'png', 'mp4'],
                          );

                          if (Platform.isMacOS || Platform.isWindows) {
                            final file = await openFile(
                                acceptedTypeGroups: <XTypeGroup>[typeGroup]);
                            selectedFile.value = File(file!.path);
                          } else {
                            PickedFile? file = await ImagePicker.platform
                                .pickImage(
                                    source: ImageSource.gallery,
                                    imageQuality: 50);
                            selectedFile.value = File(file!.path);
                          }

                          ;
                        },
                        child: Icon(
                          Icons.add,
                          size: 30,
                        ),
                      ),
              ),
              Container(
                child: !isLoading
                    ? FloatingActionButton(
                        backgroundColor: uploaded ? Colors.green : Colors.blue,
                        child: Icon(
                          uploaded ? Icons.delete : Icons.arrow_upward,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          if (selectedFile.value != null) {
                            _upload(selectedFile.value);
                          } else {}
                        },
                      )
                    : null,
              )
            ]),
      ),
    );
  }
}
