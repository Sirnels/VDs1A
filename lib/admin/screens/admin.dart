// ignore_for_file: unused_field, deprecated_member_use, body_might_complete_normally_nullable, invalid_use_of_visible_for_testing_member

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:appwrite/appwrite.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:viewducts/admin/db/electronicsCategory.dart';
import 'package:viewducts/admin/db/fashionCategories.dart';
import 'package:viewducts/admin/db/groceriesCategory.dart';
import 'package:viewducts/admin/db/product.dart';
import 'package:viewducts/admin/db/section.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/state/feedState.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/frosted.dart';
import '../db/childrenCategory.dart';
import '../db/type.dart';

enum Page { dashboard, manage }

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  final Page _selectedPage = Page.dashboard;
  MaterialColor active = Colors.red;
  final FeedState _feedState = FeedState();
  MaterialColor notActive = Colors.grey;
  TextEditingController ch1ldrenCategoryController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController sectionController = TextEditingController();
  TextEditingController farmCategoryController = TextEditingController();
  TextEditingController housingCategoryController = TextEditingController();
  TextEditingController booksCategoryController = TextEditingController();
  TextEditingController groceriesCategoryController = TextEditingController();
  TextEditingController carsCategoryController = TextEditingController();
  TextEditingController electronicsCategoryController = TextEditingController();
  TextEditingController fashionCategoryController = TextEditingController();
  final GlobalKey<FormState> _childrenCategoryFormKey = GlobalKey();
  final GlobalKey<FormState> _farmCategoryFormKey = GlobalKey();
  final GlobalKey<FormState> _booksCategoryFormKey = GlobalKey();
  final GlobalKey<FormState> _housingCategoryFormKey = GlobalKey();
  final GlobalKey<FormState> _groceriesCategoryFormKey = GlobalKey();
  final GlobalKey<FormState> _fashionCategoryFormKey = GlobalKey();
  final GlobalKey<FormState> _electronicsCategoryFormKey = GlobalKey();
  final GlobalKey<FormState> _carsCategoryFormKey = GlobalKey();
  final GlobalKey<FormState> _typeFormKey = GlobalKey();
  final GlobalKey<FormState> _sectionFormKey = GlobalKey();
  final TypeService _typeService = TypeService();
  final ChildrenCategoryService _childrenCategoryService =
      ChildrenCategoryService();
  final ProductService _productService = ProductService();
  final SectionService _sectionService = SectionService();
  final ElctronicsCategoryService _electronicsCategoryService =
      ElctronicsCategoryService();
  final FashionCategoryService _fashionCategoryService =
      FashionCategoryService();
  final GroceryCategoryService _groceryCategoryService =
      GroceryCategoryService();
  File? _image;

  Future<Directory> getTempDir() async {
    return Directory.systemTemp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _loadScreen());
  }

  Widget _loadScreen() {
    return ListView(
      children: <Widget>[
        SizedBox(
          width: Get.width,
          height: Get.width * 0.2,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                //color: Colors.white,
                icon: const Icon(CupertinoIcons.back),
              ),
              Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(10),
                child: frostedOrange(
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blueGrey[50],
                        gradient: LinearGradient(
                          colors: [
                            Colors.yellow.withOpacity(0.1),
                            Colors.white60.withOpacity(0.2),
                            Colors.orange.withOpacity(0.3)
                          ],
                          // begin: Alignment.topCenter,
                          // end: Alignment.bottomCenter,
                        )),
                    child: Row(
                      children: [
                        Material(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(100),
                          child: CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.transparent,
                            child: Image.asset('assets/delicious.png'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 3),
                          child: customTitleText('ViewDucts'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // ListTile(
        //   leading: Icon(Icons.add),
        //   title: Text(
        //     "Add product",
        //     //style: TextStyle(color: Colors.white70),
        //   ),
        //   onTap: () {
        //     _navigateTo("AddProduct");
        //   },
        // ),
        // Divider(),
        ListTile(
          leading: const Icon(Icons.change_history),
          title: const Text(
            "Products list",
            ////style: TextStyle(color: Colors.white70),
          ),
          onTap: () {
            _productService.getProductList();
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.add_circle),
          title: const Text(
            "Add Childrencategory",
            //  //style: TextStyle(color: Colors.white70),
          ),
          onTap: () {
            _childrenCategoryAlert();
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.category),
          title: const Text(
            "Childen Category list",
            // //style: TextStyle(color: Colors.white70),
          ),
          onTap: () {
            _childrenCategoryService.getChildrenCategories();
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.add_circle_outline),
          title: const Text(
            "Add type",
            ////style: TextStyle(color: Colors.white70),
          ),
          onTap: () {
            _typeAlert();
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.library_books),
          title: const Text(
            "type list",
            // //style: TextStyle(color: Colors.white70),
          ),
          onTap: () {
            _typeService.getTypes();
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.add_circle_outline),
          title: const Text(
            "Add Section",
            // //style: TextStyle(color: Colors.white70),
          ),
          onTap: () {
            _sectionAlert();
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.library_books),
          title: const Text(
            "Section list",
            ////style: TextStyle(color: Colors.white70),
          ),
          onTap: () {
            _sectionService.getSections();
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.add_circle_outline),
          title: const Text(
            "Add Fashion Category",
            ////style: TextStyle(color: Colors.white70),
          ),
          onTap: () {
            _fashionCategoryAlert();
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.library_books),
          title: const Text(
            "Fashion Category list",
            ////style: TextStyle(color: Colors.white70),
          ),
          onTap: () {
            _fashionCategoryService.getFashionCategories();
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.add_circle),
          title: const Text(
            "Add Electronics category",
            ////style: TextStyle(color: Colors.white70),
          ),
          onTap: () {
            _electronicsCategoryAlert();
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.category),
          title: const Text(
            "Electronics Category list",
            // //style: TextStyle(color: Colors.white70),
          ),
          onTap: () {
            _electronicsCategoryService.getElectronicsCategories();
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.add_circle),
          title: const Text(
            "Add Groceries category",
            ////style: TextStyle(color: Colors.white70),
          ),
          onTap: () {
            _groceriesCategoryAlert();
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.category),
          title: const Text(
            "Grocery Category list",
            // //style: TextStyle(color: Colors.white70),
          ),
          onTap: () {
            _groceryCategoryService.getGroceriesCategories();
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.add_circle),
          title: const Text(
            "Add Farm category",
            ////style: TextStyle(color: Colors.white70),
          ),
          onTap: () {
            _farmCategoryAlert();
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.category),
          title: const Text(
            "Farm Category list",
            //style: TextStyle(color: Colors.white70),
          ),
          onTap: () {
            _feedState.getFarmCategories();
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.add_circle),
          title: const Text(
            "Add Books category",
            //style: TextStyle(color: Colors.white70),
          ),
          onTap: () {
            _booksCategoryAlert();
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.category),
          title: const Text(
            "Books Category list",
            //style: TextStyle(color: Colors.white70),
          ),
          onTap: () {
            _feedState.getBooksCategories();
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.add_circle),
          title: const Text(
            "Add Housing category",
            //style: TextStyle(color: Colors.white70),
          ),
          onTap: () {
            _housingCategoryAlert();
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.category),
          title: const Text(
            "Housing Category list",
            //style: TextStyle(color: Colors.white70),
          ),
          onTap: () {
            _feedState.getHousingCategories();
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.add_circle),
          title: const Text(
            "Add Cars category",
            //style: TextStyle(color: Colors.white70),
          ),
          onTap: () {
            _carsCategoryAlert();
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.category),
          title: const Text(
            "Housing Category list",
            //style: TextStyle(color: Colors.white70),
          ),
          onTap: () {
            _feedState.getCarsCategories();
          },
        ),
        const Divider(),
      ],
    );
    //     break;
    //   default:
    //     return Container();
    // }
  }

  void _childrenCategoryAlert() {
    var alert = AlertDialog(
      content: SizedBox(
        height: fullWidth(context) * 0.4,
        width: fullWidth(context) * 0.6,
        child: Form(
          key: _childrenCategoryFormKey,
          child: Column(
            children: [
              _image == null
                  ? GestureDetector(
                      onTap: () async {
                        XTypeGroup typeGroup = XTypeGroup(
                          extensions: <String>['jpg', 'png'],
                        );
                        Navigator.maybePop(context);
                        if (Platform.isMacOS ||
                            Platform.isWindows ||
                            Platform.isLinux ||
                            Platform.isIOS ||
                            kIsWeb) {
                          final file = await openFile(
                              acceptedTypeGroups: <XTypeGroup>[typeGroup]);
                          setState(() {
                            _image = File(file!.path);
                          });
                        } else {
                          PickedFile? file = await ImagePicker.platform
                              .pickImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 50);
                          setState(() {
                            _image = File(file!.path);
                          });
                        }
                      },
                      child: Center(
                        child: customTitleText('Tap to Add image'),
                      ))
                  : GestureDetector(
                      onTap: () async {
                        Navigator.maybePop(context);
                        PickedFile? file = await ImagePicker().getImage(
                            source: ImageSource.gallery, imageQuality: 50);
                        setState(() {
                          _image = File(file!.path);
                        });
                      },
                      child: Container(
                        height: fullWidth(context) * 0.2,
                        width: fullWidth(context) * 0.2,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          image: DecorationImage(
                              image: FileImage(_image!), fit: BoxFit.cover),
                        ),
                      ),
                    ),
              TextFormField(
                controller: ch1ldrenCategoryController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'category cannot be empty';
                  }
                },
                decoration: const InputDecoration(hintText: "add category"),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () async {
              if (_image != null) {
                EasyLoading.show(status: 'uploading');
                Storage storage = Storage(clientConnect());
                await storage
                    .createFile(
                        bucketId: productBucketId,
                        fileId: "unique()",
                        permissions: [
                          Permission.read(Role.users()),
                        ],
                        file: InputFile(path: _image?.path))
                    .then((storageFilePath) {
                  _childrenCategoryService.createChildrenCategory(
                      ch1ldrenCategoryController.text, storageFilePath.$id);
                });
                EasyLoading.dismiss();
                // await feedState.uploadFile(_image!).then((imagePath) {
                //   if (imagePath != null) {
                //     _childrenCategoryService.createChildrenCategory(
                //         ch1ldrenCategoryController.text, imagePath);
                //   }
                //  });
              }
              setState(() {
                _image = null;
              });

//          Fluttertoast.showToast(msg: 'category created');
              Navigator.pop(context);
            },
            child: const Text('ADD')),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('CANCEL')),
      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }

  void _carsCategoryAlert() {
    var alert = AlertDialog(
      content: SizedBox(
        height: fullWidth(context) * 0.4,
        width: fullWidth(context) * 0.6,
        child: Form(
          key: _carsCategoryFormKey,
          child: Column(
            children: [
              _image == null
                  ? GestureDetector(
                      onTap: () async {
                        XTypeGroup typeGroup = XTypeGroup(
                          extensions: <String>['jpg', 'png'],
                        );
                        Navigator.maybePop(context);
                        if (Platform.isMacOS ||
                            Platform.isWindows ||
                            Platform.isLinux ||
                            Platform.isIOS ||
                            kIsWeb) {
                          final file = await openFile(
                              acceptedTypeGroups: <XTypeGroup>[typeGroup]);
                          setState(() {
                            _image = File(file!.path);
                          });
                        } else {
                          PickedFile? file = await ImagePicker.platform
                              .pickImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 50);
                          setState(() {
                            _image = File(file!.path);
                          });
                        }
                      },
                      child: Center(
                        child: customTitleText('Tap to Add image'),
                      ))
                  : GestureDetector(
                      onTap: () async {
                        Navigator.maybePop(context);
                        PickedFile? file = await ImagePicker().getImage(
                            source: ImageSource.gallery, imageQuality: 50);
                        setState(() {
                          _image = File(file!.path);
                        });
                      },
                      child: Container(
                        height: fullWidth(context) * 0.2,
                        width: fullWidth(context) * 0.2,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          image: DecorationImage(
                              image: FileImage(_image!), fit: BoxFit.cover),
                        ),
                      ),
                    ),
              TextFormField(
                controller: carsCategoryController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'category cannot be empty';
                  }
                },
                decoration: const InputDecoration(hintText: "add category"),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () async {
              if (_image != null) {
                EasyLoading.show(status: 'uploading');
                Storage storage = Storage(clientConnect());
                await storage
                    .createFile(
                        bucketId: productBucketId,
                        fileId: "unique()",
                        permissions: [
                          Permission.read(Role.users()),
                        ],
                        file: InputFile(path: _image?.path))
                    .then((storageFilePath) {
                  _feedState.createCarsCategory(
                      carsCategoryController.text, storageFilePath.$id);
                });
                EasyLoading.dismiss();
                // await feedState.uploadFile(_image!).then((imagePath) {
                //   if (imagePath != null) {
                //     _childrenCategoryService.createChildrenCategory(
                //         ch1ldrenCategoryController.text, imagePath);
                //   }
                //  });
              }
              setState(() {
                _image = null;
              });

//          Fluttertoast.showToast(msg: 'category created');
              Navigator.pop(context);
            },
            child: const Text('ADD')),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('CANCEL')),
      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }

  void _farmCategoryAlert() {
    var alert = AlertDialog(
      content: SizedBox(
        height: fullWidth(context) * 0.4,
        width: fullWidth(context) * 0.6,
        child: Form(
          key: _farmCategoryFormKey,
          child: Column(
            children: [
              _image == null
                  ? GestureDetector(
                      onTap: () async {
                        XTypeGroup typeGroup = XTypeGroup(
                          extensions: <String>['jpg', 'png'],
                        );
                        Navigator.maybePop(context);
                        if (Platform.isMacOS ||
                            Platform.isWindows ||
                            Platform.isLinux ||
                            Platform.isIOS ||
                            kIsWeb) {
                          final file = await openFile(
                              acceptedTypeGroups: <XTypeGroup>[typeGroup]);
                          setState(() {
                            _image = File(file!.path);
                          });
                        } else {
                          PickedFile? file = await ImagePicker.platform
                              .pickImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 50);
                          setState(() {
                            _image = File(file!.path);
                          });
                        }
                      },
                      child: Center(
                        child: customTitleText('Tap to Add image'),
                      ))
                  : GestureDetector(
                      onTap: () async {
                        Navigator.maybePop(context);
                        PickedFile? file = await ImagePicker().getImage(
                            source: ImageSource.gallery, imageQuality: 50);
                        setState(() {
                          _image = File(file!.path);
                        });
                      },
                      child: Container(
                        height: fullWidth(context) * 0.2,
                        width: fullWidth(context) * 0.2,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          image: DecorationImage(
                              image: FileImage(_image!), fit: BoxFit.cover),
                        ),
                      ),
                    ),
              TextFormField(
                controller: farmCategoryController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'category cannot be empty';
                  }
                },
                decoration: const InputDecoration(hintText: "add category"),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () async {
              if (_image != null) {
                EasyLoading.show(status: 'uploading');
                Storage storage = Storage(clientConnect());
                await storage
                    .createFile(
                        bucketId: productBucketId,
                        fileId: "unique()",
                        permissions: [
                          Permission.read(Role.users()),
                        ],
                        file: InputFile(path: _image?.path))
                    .then((storageFilePath) {
                  _feedState.createFarmCategory(
                      farmCategoryController.text, storageFilePath.$id);
                });
                EasyLoading.dismiss();
                // await feedState.uploadFile(_image!).then((imagePath) {
                //   if (imagePath != null) {
                //     _feedState.createFarmCategory(
                //         farmCategoryController.text, imagePath);
                //   }
                // });
              }
              setState(() {
                _image = null;
              });

//          Fluttertoast.showToast(msg: 'category created');
              Navigator.pop(context);
            },
            child: const Text('ADD')),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('CANCEL')),
      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }

  void _housingCategoryAlert() {
    var alert = AlertDialog(
      content: SizedBox(
        height: fullWidth(context) * 0.4,
        width: fullWidth(context) * 0.6,
        child: Form(
          key: _housingCategoryFormKey,
          child: Column(
            children: [
              _image == null
                  ? GestureDetector(
                      onTap: () async {
                        XTypeGroup typeGroup = XTypeGroup(
                          extensions: <String>['jpg', 'png'],
                        );
                        Navigator.maybePop(context);
                        if (Platform.isMacOS ||
                            Platform.isWindows ||
                            Platform.isLinux ||
                            Platform.isIOS ||
                            kIsWeb) {
                          final file = await openFile(
                              acceptedTypeGroups: <XTypeGroup>[typeGroup]);
                          setState(() {
                            _image = File(file!.path);
                          });
                        } else {
                          PickedFile? file = await ImagePicker.platform
                              .pickImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 50);
                          setState(() {
                            _image = File(file!.path);
                          });
                        }
                      },
                      //   Navigator.maybePop(context);
                      //   PickedFile? file = await ImagePicker().getImage(
                      //       source: ImageSource.gallery, imageQuality: 50);
                      //   setState(() {
                      //     _image = File(file!.path);
                      //   });
                      // },
                      child: Center(
                        child: customTitleText('Tap to Add image'),
                      ))
                  : GestureDetector(
                      onTap: () async {
                        Navigator.maybePop(context);
                        PickedFile? file = await ImagePicker().getImage(
                            source: ImageSource.gallery, imageQuality: 50);
                        setState(() {
                          _image = File(file!.path);
                        });
                      },
                      child: Container(
                        height: fullWidth(context) * 0.2,
                        width: fullWidth(context) * 0.2,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          image: DecorationImage(
                              image: FileImage(_image!), fit: BoxFit.cover),
                        ),
                      ),
                    ),
              TextFormField(
                controller: housingCategoryController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'category cannot be empty';
                  }
                },
                decoration: const InputDecoration(hintText: "add category"),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () async {
              if (_image != null) {
                EasyLoading.show(status: 'uploading');
                Storage storage = Storage(clientConnect());
                await storage
                    .createFile(
                        bucketId: productBucketId,
                        fileId: "unique()",
                        permissions: [
                          Permission.read(Role.users()),
                        ],
                        file: InputFile(path: _image?.path))
                    .then((storageFilePath) {
                  _feedState.createHousingCategory(
                      housingCategoryController.text, storageFilePath.$id);
                });
                EasyLoading.dismiss();
                // await feedState.uploadFile(_image!).then((imagePath) {
                //   if (imagePath != null) {
                //     _feedState.createHousingCategory(
                //         housingCategoryController.text, imagePath);
                //   }
                // });
              }
              setState(() {
                _image = null;
              });

//          Fluttertoast.showToast(msg: 'category created');
              Navigator.pop(context);
            },
            child: const Text('ADD')),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('CANCEL')),
      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }

  void _booksCategoryAlert() {
    var alert = AlertDialog(
      content: SizedBox(
        height: fullWidth(context) * 0.4,
        width: fullWidth(context) * 0.6,
        child: Form(
          key: _farmCategoryFormKey,
          child: Column(
            children: [
              _image == null
                  ? GestureDetector(
                      onTap: () async {
                        XTypeGroup typeGroup = XTypeGroup(
                          extensions: <String>['jpg', 'png'],
                        );
                        Navigator.maybePop(context);
                        if (Platform.isMacOS ||
                            Platform.isWindows ||
                            Platform.isLinux ||
                            Platform.isIOS ||
                            kIsWeb) {
                          final file = await openFile(
                              acceptedTypeGroups: <XTypeGroup>[typeGroup]);
                          setState(() {
                            _image = File(file!.path);
                          });
                        } else {
                          PickedFile? file = await ImagePicker.platform
                              .pickImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 50);
                          setState(() {
                            _image = File(file!.path);
                          });
                        }
                      },
                      child: Center(
                        child: customTitleText('Tap to Add image'),
                      ))
                  : GestureDetector(
                      onTap: () async {
                        Navigator.maybePop(context);
                        PickedFile? file = await ImagePicker().getImage(
                            source: ImageSource.gallery, imageQuality: 50);
                        setState(() {
                          _image = File(file!.path);
                        });
                      },
                      child: Container(
                        height: fullWidth(context) * 0.2,
                        width: fullWidth(context) * 0.2,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          image: DecorationImage(
                              image: FileImage(_image!), fit: BoxFit.cover),
                        ),
                      ),
                    ),
              TextFormField(
                controller: booksCategoryController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'category cannot be empty';
                  }
                  return value;
                },
                decoration: const InputDecoration(hintText: "add category"),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () async {
              if (_image != null) {
                EasyLoading.show(status: 'uploading');
                Storage storage = Storage(clientConnect());
                await storage
                    .createFile(
                        bucketId: productBucketId,
                        fileId: "unique()",
                        permissions: [
                          Permission.read(Role.users()),
                        ],
                        file: InputFile(path: _image?.path))
                    .then((storageFilePath) {
                  _feedState.createBooksCategory(
                      booksCategoryController.text, storageFilePath.$id);
                });
                EasyLoading.dismiss();
                // await feedState.uploadFile(_image!).then((imagePath) {
                //   if (imagePath != null) {
                //     _feedState.createBooksCategory(
                //         booksCategoryController.text, imagePath);
                //   }
                // });
              }
              setState(() {
                _image = null;
              });

//          Fluttertoast.showToast(msg: 'category created');
              Navigator.pop(context);
            },
            child: const Text('ADD')),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('CANCEL')),
      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }

  void _fashionCategoryAlert() {
    var alert = AlertDialog(
      content: SizedBox(
        height: fullWidth(context) * 0.4,
        width: fullWidth(context) * 0.6,
        child: Form(
          key: _fashionCategoryFormKey,
          child: Column(
            children: [
              _image == null
                  ? GestureDetector(
                      onTap: () async {
                        XTypeGroup typeGroup = XTypeGroup(
                          extensions: <String>['jpg', 'png'],
                        );
                        Navigator.maybePop(context);
                        if (Platform.isMacOS ||
                            Platform.isWindows ||
                            Platform.isLinux ||
                            Platform.isIOS ||
                            kIsWeb) {
                          final file = await openFile(
                              acceptedTypeGroups: <XTypeGroup>[typeGroup]);
                          setState(() {
                            _image = File(file!.path);
                          });
                        } else {
                          PickedFile? file = await ImagePicker.platform
                              .pickImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 50);
                          setState(() {
                            _image = File(file!.path);
                          });
                        }
                      },
                      child: Center(
                        child: customTitleText('Tap to Add image'),
                      ))
                  : GestureDetector(
                      onTap: () async {
                        Navigator.maybePop(context);
                        PickedFile? file = await ImagePicker().getImage(
                            source: ImageSource.gallery, imageQuality: 50);
                        setState(() {
                          _image = File(file!.path);
                        });
                      },
                      child: Container(
                        height: fullWidth(context) * 0.2,
                        width: fullWidth(context) * 0.2,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          image: DecorationImage(
                              image: FileImage(_image!), fit: BoxFit.cover),
                        ),
                      ),
                    ),
              TextFormField(
                controller: fashionCategoryController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'category cannot be empty';
                  }
                  return value;
                },
                decoration: const InputDecoration(hintText: "add category"),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () async {
              if (_image != null) {
                EasyLoading.show(status: 'uploading');
                Storage storage = Storage(clientConnect());
                await storage
                    .createFile(
                        bucketId: productBucketId,
                        fileId: "unique()",
                        permissions: [
                          Permission.read(Role.users()),
                        ],
                        file: InputFile(path: _image?.path))
                    .then((storageFilePath) {
                  _fashionCategoryService.createFashionCategory(
                      fashionCategoryController.text, storageFilePath.$id);
                });
                EasyLoading.dismiss();
                // await feedState.uploadFile(_image!).then((imagePath) {
                //   if (imagePath != null) {
                //     _fashionCategoryService.createFashionCategory(
                //         fashionCategoryController.text, imagePath);
                //   }
                // });
              }
              setState(() {
                _image = null;
              });

//          Fluttertoast.showToast(msg: 'category created');
              Navigator.pop(context);
            },
            child: const Text('ADD')),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('CANCEL')),
      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }

  void _groceriesCategoryAlert() {
    var alert = AlertDialog(
      content: SizedBox(
        height: fullWidth(context) * 0.4,
        width: fullWidth(context) * 0.6,
        child: Form(
          key: _groceriesCategoryFormKey,
          child: Column(
            children: [
              _image == null
                  ? GestureDetector(
                      onTap: () async {
                        XTypeGroup typeGroup = XTypeGroup(
                          extensions: <String>['jpg', 'png'],
                        );
                        Navigator.maybePop(context);
                        if (Platform.isMacOS ||
                            Platform.isWindows ||
                            Platform.isLinux ||
                            Platform.isIOS ||
                            kIsWeb) {
                          final file = await openFile(
                              acceptedTypeGroups: <XTypeGroup>[typeGroup]);
                          setState(() {
                            _image = File(file!.path);
                          });
                        } else {
                          PickedFile? file = await ImagePicker.platform
                              .pickImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 50);
                          setState(() {
                            _image = File(file!.path);
                          });
                        }
                      },
                      child: Center(
                        child: customTitleText('Tap to Add image'),
                      ))
                  : GestureDetector(
                      onTap: () async {
                        Navigator.maybePop(context);
                        PickedFile? file = await ImagePicker().getImage(
                            source: ImageSource.gallery, imageQuality: 50);
                        setState(() {
                          _image = File(file!.path);
                        });
                      },
                      child: Container(
                        height: fullWidth(context) * 0.2,
                        width: fullWidth(context) * 0.2,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          image: DecorationImage(
                              image: FileImage(_image!), fit: BoxFit.cover),
                        ),
                      ),
                    ),
              TextFormField(
                controller: groceriesCategoryController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'category cannot be empty';
                  }
                  return value;
                },
                decoration: const InputDecoration(hintText: "add category"),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () async {
              if (_image != null) {
                EasyLoading.show(status: 'uploading');
                Storage storage = Storage(clientConnect());
                await storage
                    .createFile(
                        bucketId: productBucketId,
                        fileId: "unique()",
                        permissions: [
                          Permission.read(Role.users()),
                        ],
                        file: InputFile(path: _image?.path))
                    .then((storageFilePath) {
                  _groceryCategoryService.createGroceriesCategory(
                      groceriesCategoryController.text, storageFilePath.$id);
                });
                EasyLoading.dismiss();
                // await feedState.uploadFile(_image!).then((imagePath) {
                //   if (imagePath != null) {
                //     _groceryCategoryService.createGroceriesCategory(
                //         groceriesCategoryController.text, imagePath);
                //   }
                // });
              }
              setState(() {
                _image = null;
              });
//          Fluttertoast.showToast(msg: 'type added');
              Navigator.pop(context);
            },
            child: const Text('ADD')),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('CANCEL')),
      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }

  void _electronicsCategoryAlert() {
    var alert = AlertDialog(
      content: SizedBox(
        height: fullWidth(context) * 0.4,
        width: fullWidth(context) * 0.6,
        child: Form(
          key: _electronicsCategoryFormKey,
          child: Column(
            children: [
              _image == null
                  ? GestureDetector(
                      onTap: () async {
                        XTypeGroup typeGroup = XTypeGroup(
                          extensions: <String>['jpg', 'png'],
                        );
                        Navigator.maybePop(context);
                        if (kIsWeb) {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles();

                          if (result != null) {
                            _image = File(result.files.single.name.toString());
                            cprint('${_image?.path}');
                          } else {
                            // User canceled the picker
                          }

                          // final ImagePicker _picker = ImagePicker();
                          // final XFile? file = await _picker.pickImage(
                          //     source: ImageSource.gallery);
                          // // PickedFile? file = await ImagePicker.platform
                          // //     .pickImage(
                          // //         source: ImageSource.gallery,
                          // //         imageQuality: 50);
                          // setState(() {
                          //   _image = File(file!.path);
                          //   cprint('${_image?.path}');
                          // });
                        } else if (Platform.isMacOS ||
                            Platform.isWindows ||
                            Platform.isLinux ||
                            Platform.isIOS) {
                          final file = await openFile(
                              acceptedTypeGroups: <XTypeGroup>[typeGroup]);

                          setState(() {
                            _image = File(file!.path);
                          });
                          cprint('${_image?.path}');
                        } else {
                          PickedFile? file = await ImagePicker.platform
                              .pickImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 50);
                          setState(() {
                            _image = File(file!.path);
                          });
                        }
                      },
                      child: Center(
                        child: customTitleText('Tap to Add image'),
                      ))
                  : GestureDetector(
                      onTap: () async {
                        Navigator.maybePop(context);
                        PickedFile? file = await ImagePicker().getImage(
                            source: ImageSource.gallery, imageQuality: 50);
                        setState(() {
                          _image = File(file!.path);
                        });
                      },
                      child: Container(
                        height: fullWidth(context) * 0.2,
                        width: fullWidth(context) * 0.2,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          image: DecorationImage(
                              image: FileImage(_image!), fit: BoxFit.cover),
                        ),
                      ),
                    ),
              TextFormField(
                controller: electronicsCategoryController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'category cannot be empty';
                  }
                  return value;
                },
                decoration: const InputDecoration(hintText: "add category"),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () async {
              if (_image != null) {
                EasyLoading.show(status: 'uploading');
                String? pathImage =
                    '${DateTime.now().toUtc().toString().replaceAll(RegExp(r'\.\d*Z$'), 'Z').replaceAll(RegExp(r'[:-]|\.\d{3}'), '').split(' ').join('T')}${path.extension(_image!.path)}';
                Storage storage = Storage(clientConnect());
                await storage
                    .createFile(
                        bucketId: productBucketId,
                        fileId: "unique()",
                        permissions: [
                          Permission.read(Role.users()),
                        ],
                        file:
                            InputFile(path: _image!.path, filename: pathImage))
                    .then((storageFilePath) {
                  _electronicsCategoryService.createElectronicsCategory(
                      electronicsCategoryController.text, storageFilePath.$id);
                });
                EasyLoading.dismiss();
                // await feedState.uploadFile(_image!).then((imagePath) {
                //   if (imagePath != null) {
                //     _electronicsCategoryService.createElectronicsCategory(
                //         electronicsCategoryController.text, imagePath);
                //   }
                // });
              }
              setState(() {
                _image = null;
              });
//          Fluttertoast.showToast(msg: 'type added');
              Navigator.pop(context);
            },
            child: const Text('ADD')),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('CANCEL')),
      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }

  void _typeAlert() {
    var alert = AlertDialog(
      backgroundColor: Color(0xFFF3BB1C),
      content: frostedYellow(
        SizedBox(
          height: fullWidth(context) * 0.4,
          width: fullWidth(context) * 0.6,
          child: Form(
            key: _typeFormKey,
            child: TextFormField(
              controller: typeController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'type cannot be empty';
                }
                return value;
              },
              decoration: const InputDecoration(hintText: "add type"),
            ),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              _typeService.createType(typeController.text);
//          Fluttertoast.showToast(msg: 'type added');
              Navigator.pop(context);
            },
            child: const Text('ADD')),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('CANCEL')),
      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }

  void _sectionAlert() {
    var alert = AlertDialog(
      content: Form(
        key: _sectionFormKey,
        child: TextFormField(
          controller: sectionController,
          validator: (value) {
            if (value!.isEmpty) {
              return 'section cannot be empty';
            }
            return value;
          },
          decoration: const InputDecoration(hintText: "add section"),
        ),
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () async {
              _sectionService.createSection(
                sectionController.text,
              );
              setState(() {
                _image = null;
              });
//          Fluttertoast.showToast(msg: 'type added');
              Navigator.pop(context);
            },
            child: const Text('ADD')),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('CANCEL')),
      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }
}
