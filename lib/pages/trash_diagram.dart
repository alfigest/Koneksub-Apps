import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';

import '../theme.dart';

class pieChart extends StatefulWidget {
  @override
  State<pieChart> createState() => _pieChartState();
}

class _pieChartState extends State<pieChart> {
  List<String> month = [
    "Januari",
    "Februari",
    "Maret",
    "April",
    "Mei",
    "Juni",
    "Juli",
    "Agustus",
    "September",
    "Oktober",
    "November",
    "Desember"
  ];

  int monthCnt = 0;

  List<Map<String, double>> dataMap = [
    {"Plastik": 9, "Kertas": 8, "Gelas": 12, "Logam": 6},
    {"Plastik": 1, "Kertas": 4, "Gelas": 3, "Logam": 12},
    {"Plastik": 2, "Kertas": 3, "Gelas": 11, "Logam": 11},
    {"Plastik": 6, "Kertas": 12, "Gelas": 5, "Logam": 10},
    {"Plastik": 8, "Kertas": 2, "Gelas": 4, "Logam": 20},
    {"Plastik": 2, "Kertas": 4, "Gelas": 7, "Logam": 12},
    {"Plastik": 1, "Kertas": 4, "Gelas": 10, "Logam": 17},
    {"Plastik": 0, "Kertas": 2, "Gelas": 3, "Logam": 18},
    {"Plastik": 15, "Kertas": 7, "Gelas": 1, "Logam": 5},
    {"Plastik": 3, "Kertas": 6, "Gelas": 3, "Logam": 15},
    {"Plastik": 4, "Kertas": 0, "Gelas": 2, "Logam": 9},
    {"Plastik": 5, "Kertas": 1, "Gelas": 9, "Logam": 10},
  ];

  void incrementCounter() {
    if (monthCnt == 11) {
      setState(() {
        monthCnt = 0;
      });
    } else {
      setState(() {
        monthCnt++;
      });
    }
  }

  void decrementCounter() {
    if (monthCnt == 0) {
      setState(() {
        monthCnt = 11;
      });
    } else {
      setState(() {
        monthCnt--;
      });
    }
  }

  double totalTrash() {
    double tmp;
    tmp = dataMap[monthCnt]['Plastik']! +
        dataMap[monthCnt]['Kertas']! +
        dataMap[monthCnt]['Gelas']! +
        dataMap[monthCnt]['Logam']!;
    return tmp;
  }

  @override
  Widget build(BuildContext context) {
    // Widget pie_chart() {
    //   return PieChart(
    //     dataMap: dataMap,
    //     animationDuration: Duration(milliseconds: 800),
    //     chartLegendSpacing: 10,
    //     chartRadius: MediaQuery.of(context).size.width / 3.25,
    //     initialAngleInDegree: 0,
    //     chartType: ChartType.ring,
    //     ringStrokeWidth: 10,
    //     centerText: "January",
    //     legendOptions: LegendOptions(
    //       showLegendsInRow: false,
    //       legendPosition: LegendPosition.right,
    //       showLegends: true,
    //       legendTextStyle: TextStyle(
    //         fontWeight: FontWeight.bold,
    //       ),
    //     ),
    //     chartValuesOptions: ChartValuesOptions(
    //       showChartValueBackground: true,
    //       showChartValues: false,
    //       showChartValuesInPercentage: false,
    //       showChartValuesOutside: false,
    //       decimalPlaces: 1,
    //     ),
    //     // gradientList: ---To add gradient colors---
    //     // emptyColorGradient: ---Empty Color gradient---
    //   );
    // }

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Drop Point Area',
            style: primaryTextStyle.copyWith(
              fontSize: 23,
              fontWeight: semiBold,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: BackButton(color: Colors.black),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 25),
              child: PieChart(
                dataMap: dataMap[monthCnt],
                animationDuration: Duration(milliseconds: 300),
                colorList: [
                  Color.fromRGBO(38, 166, 154, 10),
                  Color.fromRGBO(212, 225, 87, 10),
                  Color.fromRGBO(156, 206, 101, 10),
                  Color.fromRGBO(255, 112, 67, 10),
                ],
                chartRadius: MediaQuery.of(context).size.width / 2,
                centerText: totalTrash().toString() +
                    " KG\nTotal Bulan\n" +
                    month[monthCnt],
                legendOptions: LegendOptions(showLegends: false),
                centerTextStyle: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                chartType: ChartType.ring,
                baseChartColor: Colors.grey[50]!.withOpacity(0.15),
                //colorList: colorList,
                chartValuesOptions: ChartValuesOptions(
                    showChartValues: false, showChartValueBackground: false),
              ),
            ),
            Row(
              //crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => {
                    decrementCounter(),
                  },
                  child: Icon(Icons.arrow_back_ios_new_rounded),
                  style: TextButton.styleFrom(
                      //foregroundColor: primaryColor, //seharusnya pake primary color
                      backgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                Text(
                  month[monthCnt] + " 2022",
                  style: TextStyle(color: primaryColor, fontSize: 17),
                ),
                TextButton(
                  onPressed: () => {
                    incrementCounter(),
                  },
                  child: Icon(Icons.arrow_forward_ios_rounded),
                  style: TextButton.styleFrom(
                      //foregroundColor: primaryColor,
                      backgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 5, bottom: 5),
                      width: 150,
                      height: 75,
                      color: Color.fromRGBO(38, 166, 154, 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            dataMap[monthCnt]["Plastik"].toString() + " KG",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "Plastik",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5, bottom: 5),
                      width: 150,
                      height: 75,
                      color: Color.fromRGBO(212, 225, 87, 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            dataMap[monthCnt]["Kertas"].toString() + " KG",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "Kertas",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 5, top: 5),
                      width: 150,
                      height: 75,
                      color: Color.fromRGBO(156, 206, 101, 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            dataMap[monthCnt]["Gelas"].toString() + " KG",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "Gelas",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5, top: 5),
                      width: 150,
                      height: 75,
                      color: Color.fromRGBO(255, 112, 67, 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            dataMap[monthCnt]["Logam"].toString() + " KG",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "Logam",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ));
  }
}
