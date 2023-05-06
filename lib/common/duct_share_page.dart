// ignore_for_file: must_be_immutable

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:text_editor/text_editor.dart';
import 'package:viewducts/app_theme/app_theme_constant.dart';
import 'package:viewducts/common/common.dart';
import 'package:viewducts/features/auth/controller/auth_controller.dart';
import 'package:viewducts/features/ducts/duct_controller.dart';
import 'package:viewducts/features/products/product_controller.dart';
import 'package:viewducts/helper/enum.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/newWidget/title_text.dart';

class DuctSharePage extends ConsumerStatefulWidget {
  DuctSharePage({
    super.key,
    required this.ductPostType,
    required this.currentUser,
    this.product,
    this.ductStory,
    this.isUpdating,
    this.editedDuct,
  });
  DuctStoryModel? ductStory;
  final DuctPostType ductPostType;
  final ViewductsUser currentUser;
  String? editedDuct;
  FeedModel? product;
  bool? isUpdating;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DuctSharePageState();
}

class _DuctSharePageState extends ConsumerState<DuctSharePage> {
  final fonts = [
    'OpenSans',
    'Billabong',
    // 'GrandHotel',
    // 'Oswald',
    // 'Quicksand',
    // 'BeautifulPeople',
    // 'BeautyMountains',
    // 'BiteChocolate',
    // 'BlackberryJam',
    // 'BunchBlossoms',
    // 'CinderelaRegular',
    // 'Countryside',
    // 'Halimun',
    // 'LemonJelly',
    // 'QuiteMagicalRegular',
    // 'Tomatoes',
    // 'TropicalAsianDemoRegular',
    // 'VeganStyle',
  ];
  TextStyle _textStyle = TextStyle(
    fontSize: 50,
    color: Colors.white,
    fontFamily: 'Billabong',
  );
  //String _text = '';
  TextAlign _textAlign = TextAlign.center;
  void ductNow({
    required int storyType,
  }) {
    if (widget.isUpdating == true) {
      ref.read(ductControllerProvider.notifier).updateduct(
          storyType: storyType,
          ductStory: widget.ductStory,
          // images: images,
          product: widget.product,
          text: widget.editedDuct,
          context: context,
          user: widget.currentUser);
    } else {
      ref.read(ductControllerProvider.notifier).ducting(
          storyType: storyType,
          // images: images,
          product: widget.product,
          text: widget.editedDuct,
          context: context,
          user: widget.currentUser);
    }
    //final user = ref.read(currentUserDetailsProvider).value!;

    Navigator.pop(context);
  }

  Widget _pageView({required DuctPostType ductPostType}) {
    switch (ductPostType) {
      case DuctPostType.text:
        return Container(
          decoration: BoxDecoration(
            color: Pallete.scafoldBacgroundColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(0),
              bottom: Radius.circular(0),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: CupertinoColors.darkBackgroundGray,
              ),
              child: TextEditor(
                backgroundColor: Pallete.scafoldBacgroundColor,
                fonts: fonts,
                text: widget.editedDuct.toString(),
                textStyle: _textStyle,
                textAlingment: _textAlign,
                decoration: EditorDecoration(
                  doneButton: Padding(
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
                            color: CupertinoColors.lightBackgroundGray),
                        padding: const EdgeInsets.all(5.0),
                        child: TitleText('Ducts')),
                  ),
                  fontFamily: Icon(Icons.title, color: Colors.white),
                  colorPalette: Icon(Icons.palette, color: Colors.white),
                  alignment: AlignmentDecoration(
                    left: Text(
                      'left',
                      style: TextStyle(color: Colors.white),
                    ),
                    center: Text(
                      'center',
                      style: TextStyle(color: Colors.white),
                    ),
                    right: Text(
                      'right',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                onEditCompleted: (style, align, text) {
                  setState(() {
                    widget.editedDuct = text;
                    _textStyle = style;
                    _textAlign = align;
                  });
                  ductNow(storyType: 0);
                  // Navigator.pop(context);
                },
              ),
            ),
          ),
          //color: backgroundColor,
        );

      case DuctPostType.image:
        return Container(
          color: CupertinoColors.black,
          alignment: Alignment.center,
          child: SizedBox(
            height: Get.height,
            width: Get.width,
          ),
        );

      case DuctPostType.video:
        return Container();

      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    var list = ref.watch(getProductProvider).value;
// generates a new Random object
    final _random = new Random();

// generate a random index based on the list length
// and use it to retrieve the element
    var randomProduct = list?[_random.nextInt(list.length)];
    if (widget.product == null) {
      setState(() {
        widget.product = randomProduct;
      });
    }
    return Scaffold(
      backgroundColor: Pallete.scafoldBacgroundColor,
      body: SafeArea(
          child: Stack(children: [
        _pageView(ductPostType: widget.ductPostType),
        Positioned(
            top: fullHeight(context) * 0.035,
            left: 45,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                CupertinoIcons.clear_circled,
                color: CupertinoColors.darkBackgroundGray,
              ),
            ))
      ])),
    );
  }
}
