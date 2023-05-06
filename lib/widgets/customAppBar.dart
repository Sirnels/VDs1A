// ignore_for_file: file_names

import 'package:flutter/material.dart';

import 'package:viewducts/helper/theme.dart';

import 'customWidgets.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {Key? key,
      this.leading,
      this.title,
      this.actions,
      this.scaffoldKey,
      this.icon,
      this.onActionPressed,
      this.textController,
      this.isBackButton = false,
      this.isCrossButton = false,
      this.submitButtonText,
      this.isSubmitDisable = true,
      this.isbootomLine = true,
      this.onSearchChanged})
      : super(key: key);

  final List<Widget>? actions;
  final Size appBarHeight = const Size.fromHeight(56.0);
  final int? icon;
  final bool isBackButton;
  final bool isbootomLine;
  final bool isCrossButton;
  final bool isSubmitDisable;
  final Widget? leading;
  final Function? onActionPressed;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final String? submitButtonText;
  final TextEditingController? textController;
  final Widget? title;
  final ValueChanged<String>? onSearchChanged;

  @override
  Size get preferredSize => appBarHeight;

  Widget _searchField() {
    return Container(
        height: 50,
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: TextField(
          onChanged: onSearchChanged,
          controller: textController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 0, style: BorderStyle.none),
              borderRadius: BorderRadius.all(
                Radius.circular(25.0),
              ),
            ),
            hintText: 'Search..',
            fillColor: AppColor.extraLightGrey,
            filled: true,
            focusColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          ),
        ));
  }

  List<Widget> _getActionButtons(BuildContext context) {
    return <Widget>[
      submitButtonText != null
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: customInkWell(
                context: context,
                radius: BorderRadius.circular(40),
                onPressed: () {
                  if (onActionPressed != null) onActionPressed!();
                },
                child: Container(
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  decoration: BoxDecoration(
                    color: !isSubmitDisable
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).primaryColor.withAlpha(150),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    submitButtonText!,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
              ),
            )
          : icon == null
              ? Container()
              : IconButton(
                  onPressed: () {
                    if (onActionPressed != null) onActionPressed!();
                  },
                  icon: customIcon(context,
                      icon: icon!,
                      istwitterIcon: true,
                      iconColor: AppColor.primary,
                      size: 25),
                )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.grey),
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Container(), //  isBackButton
      //     ? BackButton()
      //     : isCrossButton
      //         ? IconButton(
      //             icon: Icon(Icons.close),
      //             onPressed: () {
      //               Navigator.pop(context);
      //             },
      //           )
      //         : Material(
      //             elevation: 10,
      //             borderRadius: BorderRadius.circular(100),
      //             child: frostedOrange(
      //               _getUserAvatar(context),
      //             ),
      //           ),
      title: title ?? _searchField(),
      actions: _getActionButtons(context),
      // bottom: PreferredSize(
      //   child: Container(
      //     color: isbootomLine
      //         ? Colors.grey.shade200
      //         : Theme.of(context).backgroundColor,
      //     height: 1.0,
      //   ),
      //   preferredSize: Size.fromHeight(0.0),
      // ),
    );
  }
}
