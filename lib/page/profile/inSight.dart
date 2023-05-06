// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/frosted.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SalesData {
  final String year;
  final double sales;

  SalesData(this.year, this.sales);
}

class InSightPage extends StatefulWidget {
  const InSightPage({Key? key}) : super(key: key);

  @override
  _InSightPageState createState() => _InSightPageState();
}

class _InSightPageState extends State<InSightPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          frostedTeal(
            Container(
              height: fullHeight(context),
              width: fullWidth(context),
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(100),
                //color: Colors.blueGrey[50]
                gradient: LinearGradient(
                  colors: [
                    Colors.blue[100]!.withOpacity(0.3),
                    Colors.green[200]!.withOpacity(0.1),
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
          frostedWhite(
            SizedBox(
              height: fullHeight(context),
              width: fullWidth(context),
            ),
          ),
          SizedBox(
              width: fullWidth(context),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: frostedYellow(Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: customTitleText(
                                  'WeekLy',
                                ),
                              )),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: frostedTeal(Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: customTitleText(
                                  'Monthly',
                                ),
                              )),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: frostedPink(Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: customTitleText(
                                  'Yearly',
                                ),
                              )),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: fullWidth(context) * 0.8,
                          width: fullWidth(context),
                          child: SfCircularChart(
                              legend: Legend(isVisible: true),
                              title: ChartTitle(
                                  text: 'Detailed Analysis',
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.w800)),
                              series: <PieSeries<SalesData, String>>[
                                PieSeries<SalesData, String>(
                                  dataSource: <SalesData>[
                                    SalesData('Clicks', 100),
                                    SalesData('Conversion', 380),
                                    SalesData('Customers', 300),
                                    SalesData('Male', 168),
                                    SalesData('female', 132),
                                  ],
                                  xValueMapper: (sales, index) => sales.year,
                                  yValueMapper: (sales, index) => sales.sales,
                                ),
                              ]),
                        ),
                      ],
                    ),
                    const Divider(),
                  ],
                ),
              )),
          Positioned(
            right: 10,
            top: 0,
            child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: Colors.black,
                      icon: const Icon(CupertinoIcons.clear_circled_solid),
                    ),
                    Text(
                      'Back',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey[300]),
                    ),
                  ],
                )),
          ),
        ],
      )),
    );
  }
}
