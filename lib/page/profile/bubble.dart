import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:viewducts/helper/constant.dart';
import 'package:viewducts/page/profile/see_provider.dart';
import 'package:viewducts/widgets/customWidgets.dart';

class Bubble extends StatelessWidget {
  const Bubble(
      {Key? key,
      required this.child,
      required this.timestamp,
      required this.delivered,
      required this.isMe,
      required this.isContinuing,
      this.userImage,
      this.createdAt})
      : super(key: key);
  final String? userImage;
  final dynamic timestamp;
  final Widget child;
  final dynamic delivered;
  final String? createdAt;
  final bool isMe, isContinuing;
  int? timeStamp() {
    if (timestamp == null) {
      return 0;
    }
    return timestamp;
  }

  humanReadableTime() => DateFormat('h:mm a')
      .format(DateTime.fromMillisecondsSinceEpoch(timeStamp()!));

  getSeenStatus(seen) {
    if (seen is bool) return true;
    if (seen is String) return true;
    if (seen is int) return true;
    return timestamp <= seen;
  }

  BorderRadius getBorder(bool isMe) {
    return BorderRadius.only(
      topLeft: const Radius.circular(20),
      topRight: const Radius.circular(20),
      bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(20),
      bottomLeft: isMe ? const Radius.circular(20) : const Radius.circular(0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool seen = getSeenStatus(SeenProvider.of(context).value);
    // final bg = isMe ? viewductBlue : viewductWhite;
    // final align = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    dynamic icon = delivered is bool && true
        ? (seen ? Icons.done_all : Icons.done)
        : Icons.access_time;
    final color = isMe ? Colors.blueGrey.withOpacity(0.8) : viewductBlack;
    icon =
        Icon(icon, size: 15.0, color: seen ? Colors.deepPurpleAccent : color);
    if (delivered is Future) {
      icon = FutureBuilder(
          future: delivered,
          builder: (context, res) {
            switch (res.connectionState) {
              case ConnectionState.done:
                return Icon((seen ? Icons.done_all : Icons.done),
                    size: 13.0, color: seen ? Colors.greenAccent : color);
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
              default:
                return Icon(Icons.access_time,
                    size: 13.0, color: seen ? Colors.greenAccent : color);
            }
          });
    }
    if (isContinuing) {}
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Container(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  margin: EdgeInsets.only(
                    right: isMe ? 10 : (fullWidth(context) / 4),
                    top: 20,
                    left: isMe ? (fullWidth(context) / 4) : 10,
                  ),
                  child: Stack(
                    children: <Widget>[
                      Material(
                        elevation: 10,
                        borderRadius: getBorder(isMe),
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: getBorder(isMe),
                              color: isMe ? Colors.black54 : Colors.white70,
                            ),
                            child: child),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget?>[
              Text(humanReadableTime().toString() + (isMe ? ' ' : ''),
                  style: TextStyle(
                    color: color,
                    fontSize: fullWidth(context) * 0.035,
                  )),
              isMe ? icon : null
            ].where((o) => o != null).toList() as List<Widget>,
          ),
        ],
      ),
    );
  }
}
