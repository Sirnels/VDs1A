import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viewducts/state/appState.dart';
import 'package:viewducts/widgets/cartIcon.dart';

class Favourites extends StatelessWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  const Favourites({Key? key, this.scaffoldKey}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var appSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Consumer<AppState>(
        builder: (context, value, child) {
          return Stack(
            children: <Widget>[
              Positioned(
                top: appSize.width * 0.6,
                right: -50,
                child: ClipOval(
                  child: Container(
                    height: appSize.width,
                    width: appSize.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      gradient: LinearGradient(
                        colors: [
                          Colors.yellow[300]!.withOpacity(0.3),
                          Colors.yellow[200]!.withOpacity(0.1),
                          Colors.yellowAccent[100]!.withOpacity(0.2)
                          // Color(0xfffbfbfb),
                          // Color(0xfff7f7f7),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: CustomScrollView(
                      slivers: <Widget>[
                        CupertinoSliverNavigationBar(
                          trailing: CartIcon(),
                          largeTitle: Text(
                            'Favourites',
                            style: TextStyle(color: Colors.blueGrey[200]),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(flex: 10, child: Container())
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
