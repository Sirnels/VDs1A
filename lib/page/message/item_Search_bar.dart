// ignore_for_file: use_key_in_widget_constructors, file_names, unused_local_variable

import 'dart:io';
import 'dart:ui';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/chatModel.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/frosted.dart';

typedef QueryListItemBuilder<T> = Widget Function(T item);
typedef OnItemSelected<T> = void Function(T item);
typedef SelectedItemBuilder<T> = Widget Function(
  T item,
  VoidCallback deleteSelectedItem,
);
typedef QueryBuilder<T> = List<T> Function(
  String query,
  List<T> list,
);
typedef TextFieldBuilder = Widget Function(
  TextEditingController controller,
  FocusNode focus,
);

class SearchWidgetBar<T> extends StatefulWidget {
  const SearchWidgetBar({
    @required this.dataList,
    @required this.popupListItemBuilder,
    @required this.selectedItemBuilder,
    @required this.queryBuilder,
    Key? key,
    this.onItemSelected,
    this.hideSearchBoxWhenItemSelected = false,
    this.listContainerHeight,
    this.noItemsFoundWidget,
    this.textFieldBuilder,
  }) : super(key: key);

  final List<T>? dataList;
  final QueryListItemBuilder<T>? popupListItemBuilder;
  final SelectedItemBuilder<T>? selectedItemBuilder;
  final bool? hideSearchBoxWhenItemSelected;
  final double? listContainerHeight;
  final QueryBuilder<T>? queryBuilder;
  final TextFieldBuilder? textFieldBuilder;
  final Widget? noItemsFoundWidget;

  final OnItemSelected<T>? onItemSelected;

  @override
  MySingleChoiceSearchState<T> createState() => MySingleChoiceSearchState<T>();
}

class MySingleChoiceSearchState<T> extends State<SearchWidgetBar<T>> {
  final _controller = TextEditingController();
  List<T>? _list;
  List<T>? _tempList;
  bool? isFocused;
  FocusNode? _focusNode;
  ValueNotifier<T>? notifier;
  bool? isRequiredCheckFailed;
  Widget? textField;
  OverlayEntry? overlayEntry;
  bool showTextBox = false;
  double? listContainerHeight;
  final LayerLink _layerLink = LayerLink();
  final double textBoxHeight = 48;
  final TextEditingController textController = TextEditingController();
  //T? item;
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    _tempList = <T>[];
    //notifier = ValueNotifier(item!);
    _focusNode = FocusNode();
    isFocused = false;
    _list = List<T>.from(widget.dataList!);
    _tempList!.addAll(_list!);
    _focusNode!.addListener(() {
      if (!_focusNode!.hasFocus) {
        _controller.clear();
        if (overlayEntry != null) {
          overlayEntry!.remove();
        }
        overlayEntry = null;
      } else {
        _tempList!
          ..clear()
          ..addAll(_list!);
        if (overlayEntry == null) {
          onTap();
        } else {
          overlayEntry!.markNeedsBuild();
        }
      }
    });
    _controller.addListener(() {
      final text = _controller.text;
      if (text.trim().isNotEmpty) {
        _tempList!.clear();
        final filterList = widget.queryBuilder!(text, widget.dataList!);
        // ignore: unnecessary_null_comparison
        if (filterList == null) {
          throw Exception(
            "Filtered List cannot be null. Pass empty list instead",
          );
        }
        _tempList!.addAll(filterList);
        if (overlayEntry == null) {
          onTap();
        } else {
          overlayEntry!.markNeedsBuild();
        }
      } else {
        _tempList!
          ..clear()
          ..addAll(_list!);
        if (overlayEntry == null) {
          onTap();
        } else {
          overlayEntry!.markNeedsBuild();
        }
      }
    });
    KeyboardVisibilityNotification().addNewListener(
      onChange: (visible) {
        if (!visible) {
          _focusNode!.unfocus();
        }
      },
    );
  }

  @override
  void didUpdateWidget(SearchWidgetBar<T> oldWidget) {
    if (oldWidget.dataList != widget.dataList) {
      init();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    listContainerHeight =
        widget.listContainerHeight ?? MediaQuery.of(context).size.height / 4;
    textField = widget.textFieldBuilder != null
        ? widget.textFieldBuilder!(_controller, _focusNode!)
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: CupertinoSearchTextField(
              controller: _controller,
              focusNode: _focusNode,
            )
            // TextField(
            //   controller: _controller,
            //   focusNode: _focusNode,
            //   style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            //   decoration: InputDecoration(
            //     enabledBorder: const OutlineInputBorder(
            //       borderSide: BorderSide(
            //         color: Color(0x4437474F),
            //       ),
            //     ),
            //     focusedBorder: OutlineInputBorder(
            //       borderSide: BorderSide(
            //         color: Theme.of(context).primaryColor,
            //       ),
            //     ),
            //     suffixIcon: Icon(Icons.search),
            //     border: InputBorder.none,
            //     hintText: "Search here...",
            //     contentPadding: const EdgeInsets.only(
            //       left: 16,
            //       right: 20,
            //       top: 14,
            //       bottom: 14,
            //     ),
            //   ),
            // ),
            );

    final column = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (widget.hideSearchBoxWhenItemSelected! && notifier!.value != null)
          const SizedBox(height: 0)
        else
          CompositedTransformTarget(
            link: _layerLink,
            child: textField,
          ),
        if (notifier?.value != null)
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.all(Radius.circular(4)),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: widget.selectedItemBuilder!(
              notifier!.value,
              onDeleteSelectedItem,
            ),
          ),
      ],
    );
    return column;
  }

  void onDropDownItemTap(T item) {
    if (overlayEntry != null) {
      overlayEntry!.remove();
    }
    overlayEntry = null;
    _controller.clear();
    _focusNode!.unfocus();
    setState(() {
      notifier?.value = item;
      isFocused = false;
      isRequiredCheckFailed = false;
    });
    if (widget.onItemSelected != null) {
      widget.onItemSelected!(item);
    }
  }

//  final RenderBox textFieldRenderBox = context.findRenderObject();
//     final RenderBox overlay = Overlay.of(context).context.findRenderObject();
//     final width = textFieldRenderBox.size.width;
//     final position = RelativeRect.fromRect(
//       Rect.fromPoints(
//         textFieldRenderBox.localToGlobal(
//           textFieldRenderBox.size.topLeft(Offset.zero),
//           ancestor: overlay,
//         ),
//         textFieldRenderBox.localToGlobal(
//           textFieldRenderBox.size.topRight(Offset.zero),
//           ancestor: overlay,
//         ),
//       ),
//       Offset.zero & overlay.size,
//     );
  // final _key = GlobalKey().currentContext!.findRenderObject().;
  void onTap() {
    final RenderBox? textFieldRenderBox =
        context.findRenderObject() as RenderBox?;

    //_key.currentContext!.findRenderObject() as RenderObject;
    final RenderBox? overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox?;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        textFieldRenderBox!.localToGlobal(
          textFieldRenderBox.size.topLeft(Offset.zero),
          ancestor: overlay,
        ),
        textFieldRenderBox.localToGlobal(
          textFieldRenderBox.size.topRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay!.size,
    );
    overlayEntry = OverlayEntry(
      builder: (context) {
        final height = MediaQuery.of(context).size.height;
        return Positioned(
          left: position.left,
          width: Get.width * .8,
          child: CompositedTransformFollower(
            offset: Offset(
              0,
              height - position.bottom < listContainerHeight!
                  ? (textBoxHeight + 6.0)
                  : -(listContainerHeight! - 8.0),
            ),
            showWhenUnlinked: false,
            link: _layerLink,
            child: Container(
              height: listContainerHeight,
              width: Get.width * .8,
              padding: const EdgeInsets.only(top: 5, bottom: 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blueGrey[50],
                gradient: LinearGradient(
                  colors: [
                    Colors.grey.withOpacity(0.1),
                    Colors.grey.withOpacity(0.2),
                    Colors.grey.withOpacity(0.1)
                    // Color(0xfffbfbfb),
                    // Color(0xfff7f7f7),
                  ],
                  // begin: Alignment.topCenter,
                  // end: Alignment.bottomCenter,
                ),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: _tempList!.isNotEmpty
                  ? Scrollbar(
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        separatorBuilder: (context, index) => const Divider(
                          height: 1,
                        ),
                        itemBuilder: (context, index) => Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => onDropDownItemTap(_tempList![index]),
                            child: widget.popupListItemBuilder!(
                              _tempList!.elementAt(index),
                            ),
                          ),
                        ),
                        itemCount: _tempList!.length,
                      ),
                    )
                  : widget.noItemsFoundWidget != null
                      ? Center(
                          child: widget.noItemsFoundWidget,
                        )
                      : const NoItemFound(),
            ),
          ),
        );
      },
    );
    Overlay.of(context).insert(overlayEntry!);
  }

  void onDeleteSelectedItem() {
    //T? item;
    setState(() => notifier!.value);
    if (widget.onItemSelected != null) {
      widget.onItemSelected!(notifier!.value);
    }
  }

  @override
  void dispose() {
    if (overlayEntry != null) {
      overlayEntry!.remove();
    }
    overlayEntry = null;
    super.dispose();
  }
}

class NoItemFound extends StatelessWidget {
  final String title;
  final IconData icon;

  const NoItemFound({
    this.title = "No data found",
    this.icon = Icons.folder_open,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 24, color: Colors.grey[900]!.withOpacity(0.7)),
            const SizedBox(width: 10.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[900]!.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A base class to handle the subscribing events
class KeyboardVisibilitySubscriber {
  /// Called when a keyboard visibility event occurs
  /// Is only called when the state changes
  /// The [visible] parameter reflects the new visibility
  final Function(bool visible)? onChange;

  /// Called when the keyboard appears
  final Function? onShow;

  /// Called when the keyboard closes
  final Function? onHide;

  /// Constructs a new [KeyboardVisibilitySubscriber]
  KeyboardVisibilitySubscriber({this.onChange, this.onShow, this.onHide});
}

/// The notification class that handles all information
class KeyboardVisibilityNotification {
  EventChannel? _keyboardVisibilityStream;
  // =
  //     EventChannel('flutter_keyboard_visibility');
  static final Map<int, KeyboardVisibilitySubscriber> _list =
      <int, KeyboardVisibilitySubscriber>{};
  static StreamSubscription? _keyboardVisibilitySubscription;
  static int _currentIndex = 0;

  /// The current state of the keyboard visibility. Can be used without subscribing
  bool isKeyboardVisible = false;

  /// Constructs a new [KeyboardVisibilityNotification]
  KeyboardVisibilityNotification() {
    _keyboardVisibilitySubscription ??= _keyboardVisibilityStream
        ?.receiveBroadcastStream()
        .listen(onKeyboardEvent);
  }

  /// Internal function to handle native code channel communication
  void onKeyboardEvent(dynamic arg) {
    isKeyboardVisible = (arg as int) == 1;

    // send a message to all subscribers notifying them about the new state
    _list.forEach((subscriber, s) {
      try {
        if (s.onChange != null) {
          s.onChange!(isKeyboardVisible);
        }
        if ((s.onShow != null) && isKeyboardVisible) {
          s.onShow!();
        }
        if ((s.onHide != null) && !isKeyboardVisible) {
          s.onHide!();
        }
      } catch (_) {}
    });
  }

  /// Subscribe to a keyboard visibility event
  /// [onChange] is called when a change of the visibility occurs
  /// [onShow] is called when the keyboard appears
  /// [onHide] is called when the keyboard disappears
  /// Returns a subscribing id that can be used to unsubscribe
  int addNewListener(
      {Function(bool)? onChange, Function? onShow, Function? onHide}) {
    _list[_currentIndex] = KeyboardVisibilitySubscriber(
        onChange: onChange, onShow: onShow, onHide: onHide);
    return _currentIndex++;
  }

  /// Subscribe to a keyboard visibility event using a subscribing class [subscriber]
  /// Returns a subscribing id that can be used to unsubscribe
  int addNewSubscriber(KeyboardVisibilitySubscriber subscriber) {
    _list[_currentIndex] = subscriber;
    return _currentIndex++;
  }

  /// Unsubscribe from the keyboard visibility events
  /// [subscribingId] has to contain an id previously returned on add
  void removeListener(int subscribingId) {
    _list.remove(subscribingId);
  }

  /// Internal function to clear class on dispose
  dispose() {
    if (_list.isEmpty) {
      _keyboardVisibilitySubscription?.cancel().catchError((e) {});
      _keyboardVisibilitySubscription = null;
    }
  }
}

/// A rectangular border with rounded corners.
///
/// Typically used with [ShapeDecoration] to draw a box with a rounded
/// rectangle for which each side/corner has different specifications such as color, width....
///
///
/// See also:
///
///  * [CustomRoundedRectangleBorder], which is similar to this class, but with less options to controll the appearance of each side/corner.
///  * [BorderSide], which is used to describe each side of the box.
///  * [Border], which, when used with [BoxDecoration], can also
///    describe a rounded rectangle.
class CustomRoundedRectangleBorder extends ShapeBorder {
  /// Creates a custom rounded rectangle border.
  /// Custom meaning that every single side/corner is controlled individually
  /// which grants the possibility to leave out borders, give each border a different color...
  ///
  /// The arguments must not be null.
  const CustomRoundedRectangleBorder({
    this.leftSide,
    this.rightSide,
    this.topSide,
    this.bottomSide,
    this.topLeftCornerSide,
    this.topRightCornerSide,
    this.bottomLeftCornerSide,
    this.bottomRightCornerSide,
    this.borderRadius = BorderRadius.zero,
  });

  /// The style for the left side border.
  final BorderSide? leftSide;

  /// The style for the right side border.
  final BorderSide? rightSide;

  /// The style for the top side border.
  final BorderSide? topSide;

  /// The style for the bottom side border.
  final BorderSide? bottomSide;

  /// The style for the top left corner side border.
  final BorderSide? topLeftCornerSide;

  /// The style for the top right corner side border.
  final BorderSide? topRightCornerSide;

  /// The style for the bottom left corner side border.
  final BorderSide? bottomLeftCornerSide;

  /// The style for the bottom right corner side border.
  final BorderSide? bottomRightCornerSide;

  double get biggestWidth => max(
      max(
          max(
              max(
                  max(
                      max(max(topSide?.width ?? 0.0, rightSide?.width ?? 0.0),
                          bottomSide?.width ?? 0.0),
                      leftSide?.width ?? 0.0),
                  bottomRightCornerSide?.width ?? 0.0),
              bottomLeftCornerSide?.width ?? 0.0),
          topRightCornerSide?.width ?? 0.0),
      topLeftCornerSide?.width ?? 0.0);

  /// The radii for each corner.
  final BorderRadius borderRadius;

  @override
  EdgeInsetsGeometry get dimensions {
    return EdgeInsets.all(biggestWidth);
  }

  @override
  ShapeBorder scale(double t) {
    return CustomRoundedRectangleBorder(
      topSide: topSide?.scale(t),
      leftSide: leftSide?.scale(t),
      bottomSide: bottomSide?.scale(t),
      rightSide: bottomSide?.scale(t),
      topLeftCornerSide: topLeftCornerSide?.scale(t),
      topRightCornerSide: topRightCornerSide?.scale(t),
      bottomLeftCornerSide: bottomLeftCornerSide?.scale(t),
      bottomRightCornerSide: bottomRightCornerSide?.scale(t),
      borderRadius: borderRadius * t,
    );
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is CustomRoundedRectangleBorder) {
      return CustomRoundedRectangleBorder(
        topSide:
            topSide == null ? null : BorderSide.lerp(a.topSide!, topSide!, t),
        leftSide: leftSide == null
            ? null
            : BorderSide.lerp(a.leftSide!, leftSide!, t),
        bottomSide: bottomSide == null
            ? null
            : BorderSide.lerp(a.bottomSide!, bottomSide!, t),
        rightSide: rightSide == null
            ? null
            : BorderSide.lerp(a.rightSide!, rightSide!, t),
        topLeftCornerSide: topLeftCornerSide == null
            ? null
            : BorderSide.lerp(a.topLeftCornerSide!, topLeftCornerSide!, t),
        topRightCornerSide: topRightCornerSide == null
            ? null
            : BorderSide.lerp(a.topRightCornerSide!, topRightCornerSide!, t),
        bottomLeftCornerSide: bottomLeftCornerSide == null
            ? null
            : BorderSide.lerp(
                a.bottomLeftCornerSide!, bottomLeftCornerSide!, t),
        bottomRightCornerSide: bottomRightCornerSide == null
            ? null
            : BorderSide.lerp(
                a.bottomRightCornerSide!, bottomRightCornerSide!, t),
        borderRadius: BorderRadius.lerp(a.borderRadius, borderRadius, t)!,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is CustomRoundedRectangleBorder) {
      return CustomRoundedRectangleBorder(
        topSide:
            topSide == null ? null : BorderSide.lerp(topSide!, b.topSide!, t),
        leftSide: leftSide == null
            ? null
            : BorderSide.lerp(leftSide!, b.leftSide!, t),
        bottomSide: bottomSide == null
            ? null
            : BorderSide.lerp(bottomSide!, b.bottomSide!, t),
        rightSide: rightSide == null
            ? null
            : BorderSide.lerp(rightSide!, b.rightSide!, t),
        topLeftCornerSide: topLeftCornerSide == null
            ? null
            : BorderSide.lerp(topLeftCornerSide!, b.topLeftCornerSide!, t),
        topRightCornerSide: topRightCornerSide == null
            ? null
            : BorderSide.lerp(topRightCornerSide!, b.topRightCornerSide!, t),
        bottomLeftCornerSide: bottomLeftCornerSide == null
            ? null
            : BorderSide.lerp(
                bottomLeftCornerSide!, b.bottomLeftCornerSide!, t),
        bottomRightCornerSide: bottomRightCornerSide == null
            ? null
            : BorderSide.lerp(
                bottomRightCornerSide!, b.bottomRightCornerSide!, t),
        borderRadius: BorderRadius.lerp(borderRadius, b.borderRadius, t)!,
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(borderRadius
          .resolve(textDirection)
          .toRRect(rect)
          .deflate(biggestWidth));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(borderRadius.resolve(textDirection).toRRect(rect));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    Paint? paint;

    paint = createPaintForBorder(topLeftCornerSide);
    if (borderRadius.topLeft.x != 0.0 && paint != null) {
      canvas.drawArc(
        rectForCorner(
            topLeftCornerSide?.width, rect.topLeft, borderRadius.topLeft, 1, 1),
        pi / 2 * 2,
        pi / 2,
        false,
        paint,
      );
    }

    paint = createPaintForBorder(topSide);
    if (paint != null) {
      canvas.drawLine(
          rect.topLeft +
              Offset(
                  borderRadius.topLeft.x +
                      (borderRadius.topLeft.x == 0
                          ? (leftSide?.width ?? 0.0)
                          : 0.0),
                  (topSide?.width ?? 0.0) / 2),
          rect.topRight +
              Offset(-borderRadius.topRight.x, (topSide?.width ?? 0.0) / 2),
          paint);
    }

    paint = createPaintForBorder(topRightCornerSide);
    if (borderRadius.topRight.x != 0.0 && paint != null) {
      canvas.drawArc(
        rectForCorner(topRightCornerSide?.width, rect.topRight,
            borderRadius.topRight, -1, 1),
        pi / 2 * 3,
        pi / 2,
        false,
        paint,
      );
    }

    paint = createPaintForBorder(rightSide);
    if (paint != null) {
      canvas.drawLine(
          rect.topRight +
              Offset(
                  -1 * (rightSide?.width ?? 0.0) / 2,
                  borderRadius.topRight.y +
                      (borderRadius.topRight.x == 0
                          ? (topSide?.width ?? 0.0)
                          : 0.0)),
          rect.bottomRight +
              Offset(-1 * (rightSide?.width ?? 0.0) / 2,
                  -borderRadius.bottomRight.y),
          paint);
    }

    paint = createPaintForBorder(bottomRightCornerSide);
    if (borderRadius.bottomRight.x != 0.0 && paint != null) {
      canvas.drawArc(
        rectForCorner(bottomRightCornerSide?.width, rect.bottomRight,
            borderRadius.bottomRight, -1, -1),
        pi / 2 * 0,
        pi / 2,
        false,
        paint,
      );
    }

    paint = createPaintForBorder(bottomSide);
    if (paint != null) {
      canvas.drawLine(
          rect.bottomRight +
              Offset(
                  -borderRadius.bottomRight.x -
                      (borderRadius.bottomRight.x == 0
                          ? (rightSide?.width ?? 0.0)
                          : 0.0),
                  -1 * (bottomSide?.width ?? 0.0) / 2),
          rect.bottomLeft +
              Offset(borderRadius.bottomLeft.x,
                  -1 * (bottomSide?.width ?? 0.0) / 2),
          paint);
    }

    paint = createPaintForBorder(bottomLeftCornerSide);
    if (borderRadius.bottomLeft.x != 0.0 && paint != null) {
      canvas.drawArc(
        rectForCorner(bottomLeftCornerSide?.width, rect.bottomLeft,
            borderRadius.bottomLeft, 1, -1),
        pi / 2 * 1,
        pi / 2,
        false,
        paint,
      );
    }

    paint = createPaintForBorder(leftSide);
    if (paint != null) {
      canvas.drawLine(
          rect.bottomLeft +
              Offset(
                  (leftSide?.width ?? 0.0) / 2,
                  -borderRadius.bottomLeft.y -
                      (borderRadius.bottomLeft.x == 0
                          ? (bottomSide?.width ?? 0.0)
                          : 0.0)),
          rect.topLeft +
              Offset((leftSide?.width ?? 0.0) / 2, borderRadius.topLeft.y),
          paint);
    }
  }

  Rect rectForCorner(
      double? sideWidth, Offset offset, Radius radius, num signX, num signY) {
    sideWidth ??= 0.0;
    double d = sideWidth / 2;
    double borderRadiusX = radius.x - d;
    double borderRadiusY = radius.y - d;
    Rect rect = Rect.fromPoints(
        offset + Offset(signX.sign * d, signY.sign * d),
        offset +
            Offset(signX.sign * d, signY.sign * d) +
            Offset(signX.sign * 2 * borderRadiusX,
                signY.sign * 2 * borderRadiusY));

    return rect;
  }

  Paint? createPaintForBorder(BorderSide? side) {
    if (side == null) return null;

    return Paint()
      ..style = PaintingStyle.stroke
      ..color = side.color
      ..strokeWidth = side.width;
  }
}

typedef OnTap = void Function(int index, String value);
typedef SubmitResults = void Function(
    String searchText, List<String> searchResults);

///Class for adding AutoSearchInput to your project
class AdvancedSearch extends StatefulWidget {
  ///List of data that can be searched through for the results
  final List<String> data;

  ///The max number of elements to be displayed when the TextField is clicked
  final int maxElementsToDisplay;

  ///The color of text which actually appears in the results for which the text
  ///is typed
  final Color? selectedTextColor;

  ///The color of text which actually appears in the results for the
  ///remaining text
  final Color? unSelectedTextColor;

  ///Color of the border when the TextField is enabled
  final Color? enabledBorderColor;

  ///Color of the border when the TextField is disabled
  final Color? disabledBorderColor;

  ///Color of the border when the TextField is being integrated with
  final Color? focusedBorderColor;

  ///Color of the cursor
  final Color? cursorColor;

  ///Border Radius of the TextField and the resultant elements
  final double borderRadius;

  ///Font Size for both the text in the TextField and the results
  final double fontSize;

  ///Height of a single item in the resultant list
  final double singleItemHeight;

  ///Number of items to be shown when the TextField is tapped
  final int itemsShownAtStart;

  ///Hint text to show inside the TextField
  final String hintText;

  ///Boolean to set autoCorrect
  final bool autoCorrect;

  ///Boolean to set whether the TextField is enabled
  final bool enabled;

  ///onSubmitted function
  final SubmitResults? onSubmitted;

  ///Function to call when a certain item is clicked
  /// Takes in a parameter of the item which was clicked
  final OnTap onItemTap;

  /// Callback to be called when the user clears his search
  final Function onSearchClear;

  /// Function to be called on editing the text field
  final SubmitResults? onEditingProgress;

  /// Text Inout Background Color
  final Color? inputTextFieldBgColor;

  ///List Background Color
  final Color searchResultsBgColor;

  final SearchMode searchMode;

  final bool caseSensitive;

  final int minLettersForSearch;

  final Color borderColor;

  final Color hintTextColor;

  final bool clearSearchEnabled;

  final bool showListOfResults;

  final bool hideHintOnTextInputFocus;

  final double verticalPadding;

  final double horizontalPadding;

  const AdvancedSearch({
    required this.data,
    required this.maxElementsToDisplay,
    required this.onItemTap,
    required this.onSearchClear,
    this.selectedTextColor,
    this.unSelectedTextColor,
    this.enabledBorderColor,
    this.disabledBorderColor,
    this.focusedBorderColor,
    this.cursorColor,
    this.borderRadius = 10.0,
    this.fontSize = 14.0,
    this.singleItemHeight = 45.0,
    this.itemsShownAtStart = 10,
    this.hintText = 'Enter a name',
    this.autoCorrect = false,
    this.enabled = true,
    this.onSubmitted,
    this.onEditingProgress,
    this.inputTextFieldBgColor,
    this.searchResultsBgColor = Colors.white,
    this.searchMode = SearchMode.CONTAINS,
    this.caseSensitive = false,
    this.minLettersForSearch = 0,
    this.borderColor = const Color(0xFFFAFAFA),
    this.hintTextColor = Colors.grey,
    this.clearSearchEnabled = true,
    this.showListOfResults = true,
    this.hideHintOnTextInputFocus = false,
    this.verticalPadding = 10,
    this.horizontalPadding = 10,
  });

  @override
  _AdvancedSearchState createState() => _AdvancedSearchState();
}

class _AdvancedSearchState extends State<AdvancedSearch> {
  List<String> results = [];
  bool isItemClicked = false;
  String lastSubmittedText = "";
  String? hintText;

  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(onSearchTextChanges);

    hintText = widget.hintText;
    KeyboardVisibilityNotification().addNewListener(
      onChange: (visible) {
        if (!visible) {
          setState(() {
            if (!visible) {
              sendSubmitResults(_textEditingController.text);
              FocusScope.of(context).unfocus();
              if (widget.hideHintOnTextInputFocus) {
                setState(() {
                  hintText = widget.hintText;
                });
              }
            } else {
              if (widget.hideHintOnTextInputFocus) {
                setState(() {
                  hintText = "";
                });
              }
            }
          });
        }
      },
    );
    //  var keyboardVisibilityController = KeyboardVisibilityController();

    // Subscribe
    // keyboardVisibilityController.onChange.listen((bool visible) {
    //   setState(() {
    //     if (!visible) {
    //       if (_textEditingController.text != null) {
    //         sendSubmitResults(_textEditingController.text);
    //       }
    //       FocusScope.of(context).unfocus();
    //       if (widget.hideHintOnTextInputFocus) {
    //         setState(() {
    //           hintText = widget.hintText;
    //         });
    //       }
    //     } else {
    //       if (widget.hideHintOnTextInputFocus) {
    //         setState(() {
    //           hintText = "";
    //         });
    //       }
    //     }
    //   });
    // });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Widget _getRichText(String result) {
    String textSelected = "";
    String textBefore = "";
    String textAfter = "";
    try {
      String lowerCaseResult =
          widget.caseSensitive ? result : result.toLowerCase();
      String lowerCaseSearchText = widget.caseSensitive
          ? _textEditingController.text
          : _textEditingController.text.toLowerCase();
      textSelected = result.substring(
          lowerCaseResult.indexOf(lowerCaseSearchText),
          lowerCaseResult.indexOf(lowerCaseSearchText) +
              lowerCaseSearchText.length);
      String loserCaseTextSelected =
          widget.caseSensitive ? textSelected : textSelected.toLowerCase();
      textBefore =
          result.substring(0, lowerCaseResult.indexOf(loserCaseTextSelected));
      if (lowerCaseResult.indexOf(loserCaseTextSelected) + textSelected.length <
          result.length) {
        textAfter = result.substring(
            lowerCaseResult.indexOf(loserCaseTextSelected) +
                textSelected.length,
            result.length);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return Container(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: _textEditingController.text.isNotEmpty
            ? TextSpan(
                children: [
                  if (_textEditingController.text.isNotEmpty)
                    TextSpan(
                      text: textBefore,
                      style: TextStyle(
                        fontSize: widget.fontSize,
                        color: widget.unSelectedTextColor ?? Colors.grey[500],
                      ),
                    ),
                  TextSpan(
                    text: textSelected,
                    style: TextStyle(
                      fontSize: widget.fontSize,
                      color: widget.selectedTextColor ?? Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: textAfter,
                    style: TextStyle(
                      fontSize: widget.fontSize,
                      color: widget.unSelectedTextColor ?? Colors.grey[500],
                    ),
                  )
                ],
              )
            : TextSpan(
                text: result,
                style: TextStyle(
                  fontSize: widget.fontSize,
                  color: widget.unSelectedTextColor ?? Colors.grey[500],
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLtr = Directionality.of(context) == TextDirection.ltr;
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: widget.inputTextFieldBgColor,
              borderRadius: results.isEmpty || isItemClicked
                  ? BorderRadius.all(
                      Radius.circular(widget.borderRadius),
                    )
                  : BorderRadius.only(
                      topLeft: Radius.circular(widget.borderRadius),
                      topRight: Radius.circular(widget.borderRadius),
                    ),
            ),
            child: Stack(
              children: [
                CupertinoSearchTextField(
                  autocorrect: widget.autoCorrect,
                  enabled: widget.enabled,
                  placeholder: 'Search ViewDucts',
                  // onEditingComplete: () {
                  //   sendSubmitResults(_textEditingController.text);
                  //   FocusScope.of(context).unfocus();
                  // },
                  onSubmitted: (value) {
                    sendSubmitResults(_textEditingController.text);
                    FocusScope.of(context).unfocus();
                  },
                  onTap: () {
                    setState(() {
                      isItemClicked = false;
                    });
                  },
                  controller: _textEditingController,
                  // decoration: InputDecoration(
                  //   hintText: hintText,
                  //   hintStyle: TextStyle(
                  //     color: widget.hintTextColor,
                  //   ),
                  //   contentPadding: EdgeInsets.symmetric(
                  //       vertical: widget.verticalPadding,
                  //       horizontal: widget.horizontalPadding),
                  //   disabledBorder: OutlineInputBorder(
                  //     borderSide: BorderSide(
                  //         color: widget.disabledBorderColor != null
                  //             ? widget.disabledBorderColor!
                  //             : Colors.grey[300]!),
                  //     borderRadius: BorderRadius.all(
                  //       Radius.circular(widget.borderRadius),
                  //     ),
                  //   ),
                  //   enabledBorder: OutlineInputBorder(
                  //     borderSide: BorderSide(
                  //       color: widget.enabledBorderColor != null
                  //           ? widget.enabledBorderColor!
                  //           : Colors.grey[300]!,
                  //     ),
                  //     borderRadius: BorderRadius.all(
                  //       Radius.circular(widget.borderRadius),
                  //     ),
                  //   ),
                  //   focusedBorder: OutlineInputBorder(
                  //     borderSide: BorderSide(
                  //         color: widget.focusedBorderColor != null
                  //             ? widget.focusedBorderColor!
                  //             : Colors.grey[300]!),
                  //     borderRadius: results.length == 0 || isItemClicked
                  //         ? BorderRadius.all(
                  //             Radius.circular(widget.borderRadius),
                  //           )
                  //         : BorderRadius.only(
                  //             topLeft: Radius.circular(widget.borderRadius),
                  //             topRight: Radius.circular(widget.borderRadius),
                  //           ),
                  //   ),
                  // ),
                  style: TextStyle(
                    fontSize: widget.fontSize,
                  ),
                  // cursorColor: widget.cursorColor != null
                  //     ? widget.cursorColor
                  //     : Colors.grey[600],
                ),
                widget.clearSearchEnabled &&
                        _textEditingController.text.isNotEmpty
                    ? Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        left: 0,
                        child: Align(
                          alignment: isLtr
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: InkWell(
                            onTap: () {
                              if (_textEditingController.text.isEmpty) {
                                return;
                              }
                              setState(() {
                                _textEditingController.clear();
                                widget.onSearchClear();
                                isItemClicked = true;
                              });
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(
                                Icons.close,
                                size: 20,
                                color: _textEditingController.text.isEmpty
                                    ? Colors.grey[300]
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
          ),
          if (!isItemClicked && widget.showListOfResults)
            SizedBox(
              height: results.length * widget.singleItemHeight,
              child: _textEditingController.text == ''
                  ? Container()
                  : ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            String value = results[index];
                            widget.onItemTap(widget.data.indexOf(value), value);
                            _textEditingController.text = value;
                            _textEditingController.selection =
                                TextSelection.fromPosition(
                              TextPosition(
                                offset: value.length,
                              ),
                            );

                            setState(() {
                              isItemClicked = true;
                            });
                            // _textEditingController.text = "";
                            FocusScope.of(context).unfocus();
                          },
                          child: Container(
                            height: widget.singleItemHeight,
                            padding: const EdgeInsets.all(8.0),
                            child: _getRichText(results[index]),
                            decoration: ShapeDecoration(
                              color: widget.searchResultsBgColor,
                              shape: CustomRoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(
                                    index == (results.length - 1)
                                        ? widget.borderRadius
                                        : 0.0,
                                  ),
                                  bottomRight: Radius.circular(
                                    index == (results.length - 1)
                                        ? widget.borderRadius
                                        : 0.0,
                                  ),
                                ),
                                leftSide: BorderSide(color: widget.borderColor),
                                bottomLeftCornerSide:
                                    BorderSide(color: widget.borderColor),
                                rightSide:
                                    BorderSide(color: widget.borderColor),
                                bottomRightCornerSide:
                                    BorderSide(color: widget.borderColor),
                                bottomSide:
                                    BorderSide(color: widget.borderColor),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
        ],
      ),
    );
  }

  void onSearchTextChanges() {
    if (lastSubmittedText == _textEditingController.text &&
        isItemClicked == true) {
      setState(() {
        isItemClicked = false;
      });
      return;
    }
    setState(() {
      isItemClicked = false;
    });
    if (_textEditingController.text.length < widget.minLettersForSearch) {
      setState(() {
        results = [];
      });
    } else {
      String searchText = widget.caseSensitive
          ? _textEditingController.text
          : _textEditingController.text.toLowerCase();
      switch (widget.searchMode) {
        case SearchMode.STARTING_WITH:
          setState(() {
            results = widget.data
                .where(
                  (element) =>
                      (widget.caseSensitive ? element : element.toLowerCase())
                          .startsWith(searchText),
                )
                .toList();
          });
          break;
        case SearchMode.CONTAINS:
          setState(() {
            results = widget.data
                .where(
                  (element) =>
                      (widget.caseSensitive ? element : element.toLowerCase())
                          .contains(searchText),
                )
                .toList();
          });
          break;
        case SearchMode.EXACT_MATCH:
          setState(() {
            results = widget.data
                .where(
                  (element) =>
                      (widget.caseSensitive
                          ? element
                          : element.toLowerCase()) ==
                      searchText,
                )
                .toList();
          });
          break;
      }
      setState(() {
        if (results.length > widget.maxElementsToDisplay) {
          results = results.sublist(0, widget.maxElementsToDisplay);
        }
      });
    }
    // now send the latest updates
    if (widget.onEditingProgress != null) {
      widget.onEditingProgress!(_textEditingController.text, results);
    }
  }

  void sendSubmitResults(value) {
    try {
      if (lastSubmittedText == value) {
        setState(() {
          results = [];
        });
        return; // Nothing new to Submit
      }
      lastSubmittedText = value;
      setState(() {
        isItemClicked = true;
      });
      if (lastSubmittedText == "") {
        widget.onSearchClear();
      } else {
        widget.onSubmitted!(lastSubmittedText, results);
      }
      setState(() {
        results = [];
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
}

enum SearchMode {
  // ignore: constant_identifier_names
  STARTING_WITH,
  // ignore: constant_identifier_names
  CONTAINS,
  // ignore: constant_identifier_names
  EXACT_MATCH,
}

class DuctFocusedMenuItem {
  Color? backgroundColor;
  Widget title;
  Icon? trailingIcon;
  Function onPressed;

  DuctFocusedMenuItem(
      {this.backgroundColor,
      required this.title,
      this.trailingIcon,
      required this.onPressed});
}

class DuctMenuHolder extends StatefulWidget {
  final Widget child;
  final ChatMessage? chat;
  final double? menuItemExtent;
  final double? menuWidth;
  final String? msgkey;
  final String? reciverId;
  final List<DuctFocusedMenuItem> menuItems;
  final bool? animateMenuItems;
  final BoxDecoration? menuBoxDecoration;
  final Function onPressed;
  final Duration? duration;
  final double? blurSize;
  final Color? blurBackgroundColor;
  final double? bottomOffsetHeight;
  final double? menuOffset;

  /// Open with tap insted of long press.
  final bool openWithTap;

  const DuctMenuHolder(
      {Key? key,
      required this.child,
      required this.onPressed,
      required this.menuItems,
      this.chat,
      this.duration,
      this.menuBoxDecoration,
      this.menuItemExtent,
      this.animateMenuItems,
      this.blurSize,
      this.blurBackgroundColor,
      this.menuWidth,
      this.bottomOffsetHeight,
      this.menuOffset,
      this.openWithTap = false,
      this.msgkey,
      this.reciverId})
      : super(key: key);

  @override
  _DuctMenuHolderState createState() => _DuctMenuHolderState();
}

class _DuctMenuHolderState extends State<DuctMenuHolder> {
  GlobalKey containerKey = GlobalKey();
  Offset childOffset = const Offset(0, 0);
  Size? childSize;

  getOffset() {
    RenderBox renderBox =
        containerKey.currentContext!.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    setState(() {
      childOffset = Offset(offset.dx, offset.dy);
      childSize = size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        key: containerKey,
        onTap: () async {
          widget.onPressed();
          if (widget.openWithTap) {
            await openMenu(context);
          }
        },
        onLongPress: () async {
          if (!widget.openWithTap) {
            await openMenu(context);
          }
        },
        child: widget.child);
  }

  Future openMenu(BuildContext context) async {
    getOffset();
    await Navigator.push(
        context,
        PageRouteBuilder(
            transitionDuration:
                widget.duration ?? const Duration(milliseconds: 100),
            pageBuilder: (context, animation, secondaryAnimation) {
              animation = Tween(begin: 0.0, end: 1.0).animate(animation);
              return FadeTransition(
                  opacity: animation,
                  child: DuctFocusedMenuDetails(
                    chat: widget.chat,
                    msgkey: widget.msgkey,
                    reciverId: widget.reciverId,
                    itemExtent: widget.menuItemExtent,
                    menuBoxDecoration: widget.menuBoxDecoration,
                    child: widget.child,
                    childOffset: childOffset,
                    childSize: childSize,
                    menuItems: widget.menuItems,
                    blurSize: widget.blurSize,
                    menuWidth: widget.menuWidth,
                    blurBackgroundColor: widget.blurBackgroundColor,
                    animateMenu: widget.animateMenuItems ?? true,
                    bottomOffsetHeight: widget.bottomOffsetHeight ?? 0,
                    menuOffset: widget.menuOffset ?? 0,
                  ));
            },
            fullscreenDialog: true,
            opaque: false));
  }
}

class DuctFocusedMenuDetails extends StatelessWidget {
  final String? msgkey;
  final String? reciverId;
  final ChatMessage? chat;
  final List<DuctFocusedMenuItem> menuItems;
  final BoxDecoration? menuBoxDecoration;
  final Offset childOffset;
  final double? itemExtent;
  final Size? childSize;
  final Widget child;
  final bool animateMenu;
  final double? blurSize;
  final double? menuWidth;
  final Color? blurBackgroundColor;
  final double? bottomOffsetHeight;
  final double? menuOffset;

  const DuctFocusedMenuDetails(
      {Key? key,
      required this.menuItems,
      this.chat,
      required this.child,
      required this.childOffset,
      required this.childSize,
      required this.menuBoxDecoration,
      required this.itemExtent,
      required this.animateMenu,
      required this.blurSize,
      required this.blurBackgroundColor,
      required this.menuWidth,
      this.bottomOffsetHeight,
      this.menuOffset,
      this.msgkey,
      this.reciverId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final maxMenuHeight = size.height * 0.45;
    final listHeight = menuItems.length * (itemExtent ?? 50.0);

    final maxMenuWidth = menuWidth ?? (size.width * 0.70);
    final menuHeight = listHeight < maxMenuHeight ? listHeight : maxMenuHeight;
    final leftOffset = (childOffset.dx + maxMenuWidth) < size.width
        ? childOffset.dx
        : (childOffset.dx - maxMenuWidth + childSize!.width);
    final topOffset = (childOffset.dy + menuHeight + childSize!.height) <
            size.height - bottomOffsetHeight!
        ? childOffset.dy + childSize!.height + menuOffset!
        : childOffset.dy - menuHeight - menuOffset!;
    final bottomOffset = (childOffset.dy + menuHeight + childSize!.height) <
            size.height - bottomOffsetHeight!
        ? childOffset.dy -
            childSize!.height +
            (Get.height * 0.1) * 4 +
            menuOffset!
        : childOffset.dy + menuHeight - Get.width * 0.2 + menuOffset!;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: blurSize ?? 4, sigmaY: blurSize ?? 4),
                child: Container(
                  color: (blurBackgroundColor ?? Colors.grey).withOpacity(0.7),
                ),
              )),
          Positioned(
            top: topOffset,
            left: leftOffset,
            child: TweenAnimationBuilder(
              duration: const Duration(milliseconds: 200),
              builder: (BuildContext context, dynamic value, Widget? child) {
                return Transform.scale(
                  scale: value,
                  alignment: Alignment.center,
                  child: child,
                );
              },
              tween: Tween(begin: 0.0, end: 1.0),
              child: frostedWhite(
                Container(
                  width: maxMenuWidth,
                  height: menuHeight,
                  decoration: menuBoxDecoration ??
                      const BoxDecoration(
                        color: Colors.white54,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        // boxShadow: [
                        //   const BoxShadow(
                        //       // color: Colors.black38,
                        //       blurRadius: 10,
                        //       spreadRadius: 1)
                        //]
                      ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    child: ListView.builder(
                      itemCount: menuItems.length,
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        DuctFocusedMenuItem item = menuItems[index];
                        Widget listItem = GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              item.onPressed();
                            },
                            child: Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(bottom: 1),
                                color:
                                    item.backgroundColor ?? Colors.transparent,
                                height: itemExtent ?? 50.0,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 14),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      item.title,
                                      if (item.trailingIcon != null) ...[
                                        item.trailingIcon!
                                      ]
                                    ],
                                  ),
                                )));
                        if (animateMenu) {
                          return TweenAnimationBuilder(
                              builder: (context, dynamic value, child) {
                                return Transform(
                                  transform: Matrix4.rotationX(1.5708 * value),
                                  alignment: Alignment.bottomCenter,
                                  child: child,
                                );
                              },
                              tween: Tween(begin: 1.0, end: 0.0),
                              duration: Duration(milliseconds: index * 200),
                              child: listItem);
                        } else {
                          return listItem;
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              top: childOffset.dy,
              left: childOffset.dx,
              child: AbsorbPointer(
                  absorbing: true,
                  child: SizedBox(
                      width: childSize!.width,
                      height: childSize!.height,
                      child: child))),
          // Positioned(
          //   top: bottomOffset,
          //   left: leftOffset,
          //   child: SizedBox(
          //     height: Get.height * 0.165,
          //     // width: Get.width * 0.6,
          //     child: Stack(
          //       children: [
          //         frostedWhite(
          //           Container(
          //             height: Get.height * 0.06,
          //             //width: Get.width * 0.5,
          //             decoration: BoxDecoration(
          //               boxShadow: [
          //                 BoxShadow(
          //                     offset: const Offset(0, 11),
          //                     blurRadius: 11,
          //                     color: Colors.black.withOpacity(0.06))
          //               ],
          //               borderRadius: BorderRadius.circular(5),
          //               color: Colors.black54,
          //             ),

          //             padding: const EdgeInsets.all(8),
          //             child: Row(
          //               children: [
          //                 GestureDetector(
          //                   onTap: () async {
          //                     Navigator.pop(context);
          //                     await SQLHelper.addReaction(
          //                       chat,
          //                       0,
          //                       authState.userId!,
          //                     );
          //                     chatState.chatMessage.value =
          //                         await SQLHelper.findLocalMessages(
          //                             chat!.chatlistKey.toString());
          //                     await chatState.onMessageUpdate(
          //                         chat, msgkey, authState.userId, reciverId, 0);
          //                   },
          //                   child: Image.asset(
          //                     'assets/heartlove.png',
          //                     height: Get.height * 0.07,
          //                   ),
          //                 ),
          //                 SizedBox(
          //                   width: Get.width * 0.07,
          //                 ),
          //                 GestureDetector(
          //                   onTap: () async {
          //                     Navigator.pop(context);
          //                     await SQLHelper.addReaction(
          //                       chat,
          //                       3,
          //                       authState.userId!,
          //                     );
          //                     chatState.chatMessage.value =
          //                         await SQLHelper.findLocalMessages(
          //                             chat!.chatlistKey.toString());
          //                     await chatState.onMessageUpdate(
          //                         chat, msgkey, authState.userId, reciverId, 3);
          //                   },
          //                   child: Image.asset(
          //                     'assets/happy.png',
          //                     height: Get.height * 0.07,
          //                   ),
          //                 ),
          //                 SizedBox(
          //                   width: Get.width * 0.07,
          //                 ),
          //                 GestureDetector(
          //                   onTap: () async {
          //                     Navigator.pop(context);
          //                     await SQLHelper.addReaction(
          //                       chat,
          //                       2,
          //                       authState.userId!,
          //                     );
          //                     chatState.chatMessage.value =
          //                         await SQLHelper.findLocalMessages(
          //                             chat!.chatlistKey.toString());
          //                     await chatState.onMessageUpdate(
          //                         chat, msgkey, authState.userId, reciverId, 2);
          //                   },
          //                   child: Image.asset(
          //                     'assets/delicious.png',
          //                     height: Get.height * 0.07,
          //                   ),
          //                 ),
          //                 SizedBox(
          //                   width: Get.width * 0.07,
          //                 ),
          //                 GestureDetector(
          //                   onTap: () async {
          //                     Navigator.pop(context);
          //                     await SQLHelper.addReaction(
          //                       chat,
          //                       1,
          //                       authState.userId!,
          //                     );
          //                     chatState.chatMessage.value =
          //                         await SQLHelper.findLocalMessages(
          //                             chat!.chatlistKey.toString());
          //                     await chatState.onMessageUpdate(
          //                         chat, msgkey, authState.userId, reciverId, 1);
          //                   },
          //                   child: Image.asset(
          //                     'assets/like  (1).png',
          //                     height: Get.height * 0.07,
          //                   ),
          //                 ),
          //                 SizedBox(
          //                   width: Get.width * 0.07,
          //                 ),
          //                 GestureDetector(
          //                   onTap: () async {
          //                     Navigator.pop(context);
          //                     await SQLHelper.addReaction(
          //                       chat,
          //                       4,
          //                       authState.userId!,
          //                     );
          //                     chatState.chatMessage.value =
          //                         await SQLHelper.findLocalMessages(
          //                             chat!.chatlistKey.toString());
          //                     await chatState.onMessageUpdate(
          //                         chat, msgkey, authState.userId, reciverId, 4);
          //                   },
          //                   child: Image.asset(
          //                     'assets/sad.png',
          //                     height: Get.height * 0.07,
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}

class ViewDuctMenuHolder extends StatefulWidget {
  final Widget child;
  final double? menuItemExtent;
  final double? menuWidth;
  final List<DuctFocusedMenuItem> menuItems;
  final bool? animateMenuItems;
  final BoxDecoration? menuBoxDecoration;
  final Function onPressed;
  final Duration? duration;
  final double? blurSize;
  final Color? blurBackgroundColor;
  final double? bottomOffsetHeight;
  final double? menuOffset;

  /// Open with tap insted of long press.
  final bool openWithTap;

  const ViewDuctMenuHolder(
      {Key? key,
      required this.child,
      required this.onPressed,
      required this.menuItems,
      this.duration,
      this.menuBoxDecoration,
      this.menuItemExtent,
      this.animateMenuItems,
      this.blurSize,
      this.blurBackgroundColor,
      this.menuWidth,
      this.bottomOffsetHeight,
      this.menuOffset,
      this.openWithTap = false})
      : super(key: key);

  @override
  _ViewDuctMenuHolderState createState() => _ViewDuctMenuHolderState();
}

class _ViewDuctMenuHolderState extends State<ViewDuctMenuHolder> {
  GlobalKey containerKey = GlobalKey();
  Offset childOffset = const Offset(0, 0);
  Size? childSize;

  getOffset() {
    RenderBox renderBox =
        containerKey.currentContext!.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    setState(() {
      childOffset = Offset(offset.dx, offset.dy);
      childSize = size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        key: containerKey,
        onTap: () async {
          widget.onPressed();
          if (!widget.openWithTap) {
            await openMenu(context);
          }
        },
        onLongPress: () async {
          if (widget.openWithTap) {
            await openMenu(context);
          }
        },
        child: widget.child);
  }

  Future openMenu(BuildContext context) async {
    getOffset();
    await Navigator.push(
        context,
        PageRouteBuilder(
            transitionDuration:
                widget.duration ?? const Duration(milliseconds: 100),
            pageBuilder: (context, animation, secondaryAnimation) {
              animation = Tween(begin: 0.0, end: 1.0).animate(animation);
              return FadeTransition(
                  opacity: animation,
                  child: ViewDuctFocusedMenuDetails(
                    itemExtent: widget.menuItemExtent,
                    menuBoxDecoration: widget.menuBoxDecoration,
                    child: widget.child,
                    childOffset: childOffset,
                    childSize: childSize,
                    menuItems: widget.menuItems,
                    blurSize: widget.blurSize,
                    menuWidth: widget.menuWidth,
                    blurBackgroundColor: widget.blurBackgroundColor,
                    animateMenu: widget.animateMenuItems ?? true,
                    bottomOffsetHeight: widget.bottomOffsetHeight ?? 0,
                    menuOffset: widget.menuOffset ?? 0,
                  ));
            },
            fullscreenDialog: true,
            opaque: false));
  }
}

class ViewDuctFocusedMenuDetails extends StatelessWidget {
  final List<DuctFocusedMenuItem> menuItems;
  final BoxDecoration? menuBoxDecoration;
  final Offset childOffset;
  final double? itemExtent;
  final Size? childSize;
  final Widget child;
  final bool animateMenu;
  final double? blurSize;
  final double? menuWidth;
  final Color? blurBackgroundColor;
  final double? bottomOffsetHeight;
  final double? menuOffset;

  const ViewDuctFocusedMenuDetails(
      {Key? key,
      required this.menuItems,
      required this.child,
      required this.childOffset,
      required this.childSize,
      required this.menuBoxDecoration,
      required this.itemExtent,
      required this.animateMenu,
      required this.blurSize,
      required this.blurBackgroundColor,
      required this.menuWidth,
      this.bottomOffsetHeight,
      this.menuOffset})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final maxMenuHeight = size.height * 0.45;
    final listHeight = menuItems.length * (itemExtent ?? 50.0);

    final maxMenuWidth = menuWidth ?? (size.width * 0.70);
    final menuHeight = listHeight < maxMenuHeight ? listHeight : maxMenuHeight;
    final leftOffset = (childOffset.dx + maxMenuWidth) < size.width
        ? childOffset.dx
        : (childOffset.dx - maxMenuWidth + childSize!.width);
    final topOffset = (childOffset.dy + menuHeight + childSize!.height) <
            size.height - bottomOffsetHeight!
        ? childOffset.dy + childSize!.height + menuOffset!
        : childOffset.dy - menuHeight - menuOffset!;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: blurSize ?? 4, sigmaY: blurSize ?? 4),
                child: Container(
                  color: (blurBackgroundColor ?? Colors.grey).withOpacity(0.7),
                ),
              )),
          Positioned(
            top: topOffset,
            left: leftOffset,
            child: TweenAnimationBuilder(
              duration: const Duration(milliseconds: 200),
              builder: (BuildContext context, dynamic value, Widget? child) {
                return Transform.scale(
                  scale: value,
                  alignment: Alignment.center,
                  child: child,
                );
              },
              tween: Tween(begin: 0.0, end: 1.0),
              child: frostedWhite(
                Container(
                  width: context.responsiveValue(
                      mobile: Get.height * 0.28,
                      tablet: Get.height * 0.8,
                      desktop: Get.height * 0.8),
                  //maxMenuWidth,
                  height: menuHeight,
                  decoration: menuBoxDecoration ??
                      const BoxDecoration(
                        color: Colors.white54,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        // boxShadow: [
                        //   const BoxShadow(
                        //       // color: Colors.black38,
                        //       blurRadius: 10,
                        //       spreadRadius: 1)
                        //]
                      ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    child: ListView.builder(
                      itemCount: menuItems.length,
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        DuctFocusedMenuItem item = menuItems[index];
                        Widget listItem = GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              item.onPressed();
                            },
                            child: Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(bottom: 1),
                                color:
                                    item.backgroundColor ?? Colors.transparent,
                                height: itemExtent ?? 50.0,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 14),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        item.title,
                                        if (item.trailingIcon != null) ...[
                                          item.trailingIcon!
                                        ]
                                      ],
                                    ),
                                  ),
                                )));
                        if (animateMenu) {
                          return TweenAnimationBuilder(
                              builder: (context, dynamic value, child) {
                                return Transform(
                                  transform: Matrix4.rotationX(1.5708 * value),
                                  alignment: Alignment.bottomCenter,
                                  child: child,
                                );
                              },
                              tween: Tween(begin: 1.0, end: 0.0),
                              duration: Duration(milliseconds: index * 200),
                              child: listItem);
                        } else {
                          return listItem;
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              top: childOffset.dy,
              left: childOffset.dx,
              child: AbsorbPointer(
                  absorbing: true,
                  child: SizedBox(
                      width: childSize!.width,
                      height: childSize!.height,
                      child: child))),
        ],
      ),
    );
  }
}

class DuctStatusView extends StatelessWidget {
  final int numberOfStatus;
  final int indexOfSeenStatus;
  final double spacing;
  final double radius;
  final double padding;
  final String centerImageUrl;
  final double strokeWidth;
  final Color seenColor;
  final Color unSeenColor;
  final String? bucketId;
  final bool? isProfile;
  final bool isDucts;
  final bool isLocalDucts;
  final Widget? ducts;
  const DuctStatusView(
      {Key? key,
      this.numberOfStatus = 10,
      this.indexOfSeenStatus = 0,
      this.spacing = 10.0,
      this.radius = 50,
      this.padding = 5,
      required this.centerImageUrl,
      this.strokeWidth = 4,
      this.seenColor = Colors.grey,
      this.unSeenColor = Colors.cyan,
      this.bucketId,
      this.isProfile = false,
      this.ducts,
      this.isDucts = false,
      this.isLocalDucts = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Storage storage = Storage(clientConnect());
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: radius * 2,
          height: radius * 2,
          child: CustomPaint(
            painter: Arc(
                alreadyWatch: indexOfSeenStatus,
                numberOfArc: numberOfStatus,
                spacing: spacing,
                strokeWidth: strokeWidth,
                seenColor: seenColor,
                unSeenColor: unSeenColor),
          ),
        ),
        CircleAvatar(
          radius: radius - padding,
          backgroundColor: CupertinoColors.systemYellow,
          child: isDucts == true
              ? ducts
              : isProfile == true
                  ? customNetworkImage(centerImageUrl, fit: BoxFit.cover)
                  : isLocalDucts == true
                      ? Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0, 11),
                                  blurRadius: 11,
                                  color: Colors.black.withOpacity(0.06))
                            ],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(100)),
                            image: DecorationImage(
                                image:
                                    FileImage(File(centerImageUrl.toString())),
                                fit: BoxFit.cover),
                          ),
                          //  child: Image.memory(pickedFile!.bytes!),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0, 11),
                                  blurRadius: 11,
                                  color: Colors.black.withOpacity(0.06))
                            ],
                            // borderRadius: BorderRadius.circular(100),
                          ),
                          child: FutureBuilder(
                            future: storage.getFileView(
                                bucketId: bucketId.toString(),
                                fileId:
                                    centerImageUrl), //works for both public file and private file, for private files you need to be logged in
                            builder: (context, snapshot) {
                              return snapshot.hasData && snapshot.data != null
                                  ? Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                              offset: const Offset(0, 11),
                                              blurRadius: 11,
                                              color: Colors.black
                                                  .withOpacity(0.06))
                                        ],
                                      ),
                                      child: Image.memory(
                                          snapshot.data as Uint8List,
                                          width: Get.height * 0.3,
                                          height: Get.height * 0.4,
                                          fit: BoxFit.contain),
                                    )
                                  : Center(
                                      child: SizedBox(
                                      width: Get.height * 0.2,
                                      height: Get.height * 0.2,
                                      child: LoadingIndicator(
                                          indicatorType:
                                              Indicator.ballTrianglePath,

                                          /// Required, The loading type of the widget
                                          colors: const [
                                            Colors.pink,
                                            Colors.green,
                                            Colors.blue
                                          ],

                                          /// Optional, The color collections
                                          strokeWidth: 0.5,

                                          /// Optional, The stroke of the line, only applicable to widget which contains line
                                          backgroundColor: Colors.transparent,

                                          /// Optional, Background of the widget
                                          pathBackgroundColor: Colors.blue

                                          /// Optional, the stroke backgroundColor
                                          ),
                                    )
                                      //  CircularProgressIndicator
                                      //     .adaptive()
                                      );
                            },
                          ),
                        ),

          //Image.asset(centerImageUrl),
        ),
      ],
    );
  }
}

class Arc extends CustomPainter {
  final int numberOfArc;
  final int alreadyWatch;
  final double spacing;
  final double strokeWidth;
  final Color seenColor;
  final Color unSeenColor;
  Arc(
      {required this.numberOfArc,
      required this.alreadyWatch,
      required this.spacing,
      required this.strokeWidth,
      required this.seenColor,
      required this.unSeenColor});

  double doubleToAngle(double angle) => angle * pi / 180.0;

  void drawArcWithRadius(
      Canvas canvas,
      Offset center,
      double radius,
      double angle,
      Paint seenPaint,
      Paint unSeenPaint,
      double start,
      double spacing,
      int number,
      int alreadyWatch) {
    for (var i = 0; i < number; i++) {
      canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          doubleToAngle((start + ((angle + spacing) * i))),
          doubleToAngle(angle),
          false,
          alreadyWatch - 1 >= i ? seenPaint : unSeenPaint);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2.0, size.height / 2.0);
    final double radius = size.width / 2.0;
    double angle = numberOfArc == 1 ? 360.0 : (360.0 / numberOfArc - spacing);
    var startingAngle = 270.0;

    Paint seenPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..color = seenColor;

    Paint unSeenPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..color = unSeenColor;

    drawArcWithRadius(canvas, center, radius, angle, seenPaint, unSeenPaint,
        startingAngle, spacing, numberOfArc, alreadyWatch);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ViewductChatBuble extends CustomPainter {
  final Color color;
  final Alignment alignment;
  final bool tail;

  ViewductChatBuble({
    required this.color,
    required this.alignment,
    required this.tail,
  });

  final double _radius = 10.0;

  @override
  void paint(Canvas canvas, Size size) {
    var h = size.height;
    var w = size.width;
    if (alignment == Alignment.topRight) {
      if (tail) {
        var path = Path();

        /// starting point
        path.moveTo(_radius * 2, 0);

        /// top-left corner
        path.quadraticBezierTo(0, 0, 0, _radius * 1.5);

        /// left line
        path.lineTo(0, h - _radius * 1.5);

        /// bottom-left corner
        path.quadraticBezierTo(0, h, _radius * 2, h);

        /// bottom line
        path.lineTo(w - _radius * 3, h);

        /// bottom-right bubble curve
        path.quadraticBezierTo(
            w - _radius * 1.5, h, w - _radius * 1.5, h - _radius * 0.6);

        /// bottom-right tail curve 1
        path.quadraticBezierTo(w - _radius * 1, h, w, h);

        /// bottom-right tail curve 2
        path.quadraticBezierTo(
            w - _radius * 0.8, h, w - _radius, h - _radius * 1.5);

        /// right line
        path.lineTo(w - _radius, _radius * 1.5);

        /// top-right curve
        path.quadraticBezierTo(w - _radius, 0, w - _radius * 3, 0);

        canvas.clipPath(path);
        canvas.drawRRect(
            RRect.fromLTRBR(0, 0, w, h, Radius.zero),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill);
      } else {
        var path = Path();

        /// starting point
        path.moveTo(_radius * 2, 0);

        /// top-left corner
        path.quadraticBezierTo(0, 0, 0, _radius * 1.5);

        /// left line
        path.lineTo(0, h - _radius * 1.5);

        /// bottom-left corner
        path.quadraticBezierTo(0, h, _radius * 2, h);

        /// bottom line
        path.lineTo(w - _radius * 3, h);

        /// bottom-right curve
        path.quadraticBezierTo(w - _radius, h, w - _radius, h - _radius * 1.5);

        /// right line
        path.lineTo(w - _radius, _radius * 1.5);

        /// top-right curve
        path.quadraticBezierTo(w - _radius, 0, w - _radius * 3, 0);

        canvas.clipPath(path);
        canvas.drawRRect(
            RRect.fromLTRBR(0, 0, w, h, Radius.zero),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill);
      }
    } else {
      if (tail) {
        var path = Path();

        /// starting point
        path.moveTo(_radius * 3, 0);

        /// top-left corner
        path.quadraticBezierTo(_radius, 0, _radius, _radius * 1.5);

        /// left line
        path.lineTo(_radius, h - _radius * 1.5);
        // bottom-right tail curve 1
        path.quadraticBezierTo(_radius * .8, h, 0, h);

        /// bottom-right tail curve 2
        path.quadraticBezierTo(
            _radius * 1, h, _radius * 1.5, h - _radius * 0.6);

        /// bottom-left bubble curve
        path.quadraticBezierTo(_radius * 1.5, h, _radius * 3, h);

        /// bottom line
        path.lineTo(w - _radius * 2, h);

        /// bottom-right curve
        path.quadraticBezierTo(w, h, w, h - _radius * 1.5);

        /// right line
        path.lineTo(w, _radius * 1.5);

        /// top-right curve
        path.quadraticBezierTo(w, 0, w - _radius * 2, 0);
        canvas.clipPath(path);
        canvas.drawRRect(
            RRect.fromLTRBR(0, 0, w, h, Radius.zero),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill);
      } else {
        var path = Path();

        /// starting point
        path.moveTo(_radius * 3, 0);

        /// top-left corner
        path.quadraticBezierTo(_radius, 0, _radius, _radius * 1.5);

        /// left line
        path.lineTo(_radius, h - _radius * 1.5);

        /// bottom-left curve
        path.quadraticBezierTo(_radius, h, _radius * 3, h);

        /// bottom line
        path.lineTo(w - _radius * 2, h);

        /// bottom-right curve
        path.quadraticBezierTo(w, h, w, h - _radius * 1.5);

        /// right line
        path.lineTo(w, _radius * 1.5);

        /// top-right curve
        path.quadraticBezierTo(w, 0, w - _radius * 2, 0);
        canvas.clipPath(path);
        canvas.drawRRect(
            RRect.fromLTRBR(0, 0, w, h, Radius.zero),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class StoryChatsLikesDetails extends StatelessWidget {
  final String? msgkey;
  final String? reciverId;
  final List<DuctFocusedMenuItem> menuItems;
  final BoxDecoration? menuBoxDecoration;
  final Offset childOffset;
  final double? itemExtent;
  final Size? childSize;
  final Widget child;
  final bool animateMenu;
  final double? blurSize;
  final double? menuWidth;
  final Color? blurBackgroundColor;
  final double? bottomOffsetHeight;
  final double? menuOffset;

  const StoryChatsLikesDetails(
      {Key? key,
      required this.menuItems,
      required this.child,
      required this.childOffset,
      required this.childSize,
      required this.menuBoxDecoration,
      required this.itemExtent,
      required this.animateMenu,
      required this.blurSize,
      required this.blurBackgroundColor,
      required this.menuWidth,
      this.bottomOffsetHeight,
      this.menuOffset,
      this.msgkey,
      this.reciverId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final maxMenuHeight = size.height * 0.45;
    final listHeight = menuItems.length * (itemExtent ?? 50.0);

    final maxMenuWidth = menuWidth ?? (size.width * 0.70);
    final menuHeight = listHeight < maxMenuHeight ? listHeight : maxMenuHeight;
    final leftOffset = (childOffset.dx + maxMenuWidth) < size.width
        ? childOffset.dx
        : (childOffset.dx - maxMenuWidth + childSize!.width);
    final topOffset = (childOffset.dy + menuHeight + childSize!.height) <
            size.height - bottomOffsetHeight!
        ? childOffset.dy + childSize!.height + menuOffset!
        : childOffset.dy - menuHeight - menuOffset!;
    final bottomOffset = (childOffset.dy + menuHeight + childSize!.height) <
            size.height - bottomOffsetHeight!
        ? childOffset.dy - childSize!.height + Get.width * 0.01 + menuOffset!
        : childOffset.dy + menuHeight - Get.width * 0.2 + menuOffset!;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: blurSize ?? 4, sigmaY: blurSize ?? 4),
                child: Container(
                  color: (blurBackgroundColor ?? Colors.grey).withOpacity(0.7),
                ),
              )),
          Positioned(
            top: topOffset,
            left: leftOffset,
            child: TweenAnimationBuilder(
              duration: const Duration(milliseconds: 200),
              builder: (BuildContext context, dynamic value, Widget? child) {
                return Transform.scale(
                  scale: value,
                  alignment: Alignment.center,
                  child: child,
                );
              },
              tween: Tween(begin: 0.0, end: 1.0),
              child: frostedWhite(
                Container(
                  width: maxMenuWidth,
                  height: menuHeight,
                  decoration: menuBoxDecoration ??
                      const BoxDecoration(
                        color: Colors.white54,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        // boxShadow: [
                        //   const BoxShadow(
                        //       // color: Colors.black38,
                        //       blurRadius: 10,
                        //       spreadRadius: 1)
                        //]
                      ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    child: ListView.builder(
                      itemCount: menuItems.length,
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        DuctFocusedMenuItem item = menuItems[index];
                        Widget listItem = GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              item.onPressed();
                            },
                            child: Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(bottom: 1),
                                color:
                                    item.backgroundColor ?? Colors.transparent,
                                height: itemExtent ?? 50.0,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 14),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      item.title,
                                      if (item.trailingIcon != null) ...[
                                        item.trailingIcon!
                                      ]
                                    ],
                                  ),
                                )));
                        if (animateMenu) {
                          return TweenAnimationBuilder(
                              builder: (context, dynamic value, child) {
                                return Transform(
                                  transform: Matrix4.rotationX(1.5708 * value),
                                  alignment: Alignment.bottomCenter,
                                  child: child,
                                );
                              },
                              tween: Tween(begin: 1.0, end: 0.0),
                              duration: Duration(milliseconds: index * 200),
                              child: listItem);
                        } else {
                          return listItem;
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              top: childOffset.dy,
              left: childOffset.dx,
              child: AbsorbPointer(
                  absorbing: true,
                  child: SizedBox(
                      width: childSize!.width,
                      height: childSize!.height,
                      child: child))),
          // Positioned(
          //   top: bottomOffset,
          //   left: leftOffset,
          //   child: SizedBox(
          //     height: Get.width * 0.165,
          //     // width: Get.width * 0.6,
          //     child: Stack(
          //       children: [
          //         Positioned(
          //             bottom: 0,
          //             right: 0,
          //             child: Row(
          //               children: [
          //                 frostedWhite(Container(
          //                   height: Get.width * 0.06,
          //                   width: Get.width * 0.06,
          //                   decoration: const BoxDecoration(
          //                     color: Colors.white24,
          //                     borderRadius:
          //                         BorderRadius.all(Radius.circular(100.0)),
          //                   ),
          //                 )),
          //                 frostedWhite(Container(
          //                   height: Get.width * 0.04,
          //                   width: Get.width * 0.04,
          //                   decoration: const BoxDecoration(
          //                       color: Colors.white60,
          //                       borderRadius:
          //                           BorderRadius.all(Radius.circular(100.0)),
          //                       boxShadow: [
          //                         BoxShadow(
          //                             // color: Colors.black38,
          //                             blurRadius: 10,
          //                             spreadRadius: 1)
          //                       ]),
          //                 )),
          //                 frostedWhite(Container(
          //                   height: Get.width * 0.03,
          //                   width: Get.width * 0.03,
          //                   decoration: const BoxDecoration(
          //                       color: Colors.white60,
          //                       borderRadius:
          //                           BorderRadius.all(Radius.circular(100.0)),
          //                       boxShadow: [
          //                         BoxShadow(
          //                             // color: Colors.black38,
          //                             blurRadius: 10,
          //                             spreadRadius: 1)
          //                       ]),
          //                 )),
          //               ],
          //             )),
          //         frostedWhite(
          //           Container(
          //             height: Get.width * 0.1,
          //             //width: Get.width * 0.5,
          //             color: Colors.white12,
          //             padding: const EdgeInsets.all(8),
          //             child: Row(
          //               children: [
          //                 GestureDetector(
          //                   onTap: () {
          //                     Navigator.pop(context);
          //                     chatState.onMessageUpdate(
          //                         msgkey, authState.userId, reciverId, 0);
          //                   },
          //                   child: Image.asset(
          //                     'assets/heartlove.png',
          //                     height: Get.width * 0.06,
          //                   ),
          //                 ),
          //                 SizedBox(
          //                   width: Get.width * 0.07,
          //                 ),
          //                 GestureDetector(
          //                   onTap: () {
          //                     Navigator.pop(context);
          //                     chatState.onMessageUpdate(
          //                         msgkey, authState.userId, reciverId, 3);
          //                   },
          //                   child: Image.asset(
          //                     'assets/happy.png',
          //                     height: Get.width * 0.06,
          //                   ),
          //                 ),
          //                 SizedBox(
          //                   width: Get.width * 0.07,
          //                 ),
          //                 GestureDetector(
          //                   onTap: () {
          //                     Navigator.pop(context);
          //                     chatState.onMessageUpdate(
          //                         msgkey, authState.userId, reciverId, 2);
          //                   },
          //                   child: Image.asset(
          //                     'assets/delicious.png',
          //                     height: Get.width * 0.06,
          //                   ),
          //                 ),
          //                 SizedBox(
          //                   width: Get.width * 0.07,
          //                 ),
          //                 GestureDetector(
          //                   onTap: () {
          //                     Navigator.pop(context);
          //                     chatState.onMessageUpdate(
          //                         msgkey, authState.userId, reciverId, 1);
          //                   },
          //                   child: Image.asset(
          //                     'assets/like  (1).png',
          //                     height: Get.width * 0.06,
          //                   ),
          //                 ),
          //                 SizedBox(
          //                   width: Get.width * 0.07,
          //                 ),
          //                 GestureDetector(
          //                   onTap: () {
          //                     Navigator.pop(context);
          //                     chatState.onMessageUpdate(
          //                         msgkey, authState.userId, reciverId, 4);
          //                   },
          //                   child: Image.asset(
          //                     'assets/sad.png',
          //                     height: Get.width * 0.06,
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}

class StoryDuctMenuHolder extends StatefulWidget {
  final Widget child;
  final double? menuItemExtent;
  final double? menuWidth;
  final String? msgkey;
  final String? reciverId;
  final List<DuctFocusedMenuItem> menuItems;
  final bool? animateMenuItems;
  final BoxDecoration? menuBoxDecoration;
  final Function onPressed;
  final Duration? duration;
  final double? blurSize;
  final Color? blurBackgroundColor;
  final double? bottomOffsetHeight;
  final double? menuOffset;

  /// Open with tap insted of long press.
  final bool openWithTap;

  const StoryDuctMenuHolder(
      {Key? key,
      required this.child,
      required this.onPressed,
      required this.menuItems,
      this.duration,
      this.menuBoxDecoration,
      this.menuItemExtent,
      this.animateMenuItems,
      this.blurSize,
      this.blurBackgroundColor,
      this.menuWidth,
      this.bottomOffsetHeight,
      this.menuOffset,
      this.openWithTap = false,
      this.msgkey,
      this.reciverId})
      : super(key: key);

  @override
  _StoryDuctMenuHolderState createState() => _StoryDuctMenuHolderState();
}

class _StoryDuctMenuHolderState extends State<StoryDuctMenuHolder> {
  GlobalKey containerKey = GlobalKey();
  Offset childOffset = const Offset(0, 0);
  Size? childSize;

  getOffset() {
    RenderBox renderBox =
        containerKey.currentContext!.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    setState(() {
      childOffset = Offset(offset.dx, offset.dy);
      childSize = size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        key: containerKey,
        onTap: () async {
          widget.onPressed();
          if (widget.openWithTap) {
            await openMenu(context);
          }
        },
        onLongPress: () async {
          if (!widget.openWithTap) {
            await openMenu(context);
          }
        },
        child: widget.child);
  }

  Future openMenu(BuildContext context) async {
    getOffset();
    await Navigator.push(
        context,
        PageRouteBuilder(
            transitionDuration:
                widget.duration ?? const Duration(milliseconds: 100),
            pageBuilder: (context, animation, secondaryAnimation) {
              animation = Tween(begin: 0.0, end: 1.0).animate(animation);
              return FadeTransition(
                  opacity: animation,
                  child: StoryChatsLikesDetails(
                    msgkey: widget.msgkey,
                    reciverId: widget.reciverId,
                    itemExtent: widget.menuItemExtent,
                    menuBoxDecoration: widget.menuBoxDecoration,
                    child: widget.child,
                    childOffset: childOffset,
                    childSize: childSize,
                    menuItems: widget.menuItems,
                    blurSize: widget.blurSize,
                    menuWidth: widget.menuWidth,
                    blurBackgroundColor: widget.blurBackgroundColor,
                    animateMenu: widget.animateMenuItems ?? true,
                    bottomOffsetHeight: widget.bottomOffsetHeight ?? 0,
                    menuOffset: widget.menuOffset ?? 0,
                  ));
            },
            fullscreenDialog: true,
            opaque: false));
  }
}
