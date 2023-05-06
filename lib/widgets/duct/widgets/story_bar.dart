// ignore_for_file: use_key_in_widget_constructors, prefer_typing_uninitialized_variables, unused_element, deprecated_member_use

//import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:viewducts/model/feedModel.dart';

class DuctPostBar extends StatefulWidget {
  const DuctPostBar({Key? key, this.list}) : super(key: key);

  final List<DuctStoryModel>? list;
  @override
  _DuctPostBarState createState() => _DuctPostBarState();
}

class _DuctPostBarState extends State<DuctPostBar> {
  int? count;
  double spacing = 4;

  @override
  void initState() {
    super.initState();

    int count = widget.list?.length ?? 0;
    spacing = (count > 15) ? 1 : ((count > 10) ? 2 : 4);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: widget.list?.map((it) {
            return Expanded(
              child: Container(
                padding: EdgeInsets.only(
                    right: widget.list!.last == it ? 0 : spacing),
                child: const DuctProgressIndicator(
                  1,
                  indicatorHeight: 3,
                ),
              ),
            );
          }).toList() ??
          [],
    );
  }
}

class OrderPostBar extends StatefulWidget {
  const OrderPostBar({Key? key, this.list}) : super(key: key);

  final List<OrderItemModel>? list;
  @override
  _OrderPostBarState createState() => _OrderPostBarState();
}

class _OrderPostBarState extends State<OrderPostBar> {
  int? count;
  double spacing = 4;

  @override
  void initState() {
    super.initState();

    int count = widget.list!.length;
    spacing = (count > 15) ? 1 : ((count > 10) ? 2 : 4);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: widget.list!.map((it) {
        return Expanded(
          child: Container(
            padding:
                EdgeInsets.only(right: widget.list!.last == it ? 0 : spacing),
            child: const DuctProgressIndicator(
              1,
              indicatorHeight: 3,
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Custom progress bar. Supposed to be lighter than the
/// original [ProgressIndicator], and rounded at the sides.
class DuctProgressIndicator extends StatelessWidget {
  /// From `0.0` to `1.0`, determines the progress of the indicator
  final double value;
  final double indicatorHeight;

  const DuctProgressIndicator(
    this.value, {
    this.indicatorHeight = 5,
  }) : assert(indicatorHeight > 0,
            "[indicatorHeight] should not be null or less than 1");

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.fromHeight(
        indicatorHeight,
      ),
      foregroundPainter: IndicatorOval(
        CupertinoColors.lightBackgroundGray,
        value,
      ),
      painter: IndicatorOval(
        Colors.red.shade200,
        1.0,
      ),
    );
  }
}

class IndicatorOval extends CustomPainter {
  final Color color;
  final double widthFactor;

  IndicatorOval(this.color, this.widthFactor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(0, 0, size.width * widthFactor, size.height),
            const Radius.circular(3)),
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
