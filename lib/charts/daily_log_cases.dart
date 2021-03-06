import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import '../models/covid_day.dart';

var indianNumberFormat = NumberFormat.compact(locale: 'en_IN');

class DailyLogTotalCases extends StatelessWidget {
  final String stateName;
  final List<CovidDay> covidDayList;

  DailyLogTotalCases(this.stateName, this.covidDayList);

  createAlertDialog(
      BuildContext context, String stateName, List<CovidDay> covidDayList) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              Text(
                stateName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              FittedBox(
                child: Row(
                  children: [
                    Text(
                      'Date',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                    Text(
                      'Cases',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      Icons.arrow_upward,
                      color: Colors.redAccent,
                      size: 15,
                    ),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                    Text(
                      'Discharged',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.arrow_downward,
                      color: Colors.greenAccent,
                      size: 15,
                    ),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                    Text(
                      'Deaths',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.airline_seat_flat,
                      color: Colors.grey,
                      size: 15,
                    ),
                  ],
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height - 200,
                width: MediaQuery.of(context).size.width - 100,
                child: ListView.builder(
                  itemCount: covidDayList.length,
                  itemBuilder: (context, index) {
                    return FittedBox(
                      child: Row(
                        children: [
                          Container(
                            width: (MediaQuery.of(context).size.width - 100) *
                                0.25,
                            child: Text(
                              DateFormat.yMMMd()
                                  .format(covidDayList[index].date)
                                  .toString(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                          Text(
                            indianNumberFormat
                                .format(covidDayList[index].totalCases),
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.red,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                          Text(
                            indianNumberFormat
                                .format(covidDayList[index].totalDischarged),
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                          Text(
                            indianNumberFormat
                                .format(covidDayList[index].totalDeaths),
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              createAlertDialog(context, stateName, covidDayList);
            },
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(stateName,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  Text(
                    indianNumberFormat.format(covidDayList.last.totalCases),
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    Icons.arrow_upward,
                    color: Colors.redAccent,
                    size: 20,
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                  Text(
                    indianNumberFormat
                        .format(covidDayList.last.totalDischarged),
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.arrow_downward,
                    color: Colors.greenAccent,
                    size: 20,
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                  Text(
                    indianNumberFormat.format(covidDayList.last.totalDeaths),
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.airline_seat_flat,
                    color: Colors.grey,
                    size: 15,
                  ),
                ],
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.all(10),
            elevation: 5,
            child: SizedBox(
                height: 350,
                width: 350,
                child: SafeArea(
                  child: SfCartesianChart(
                    zoomPanBehavior: ZoomPanBehavior(
                      enablePinching: true,
                    ),
                    legend: Legend(
                        isVisible: true, position: LegendPosition.bottom),
                    margin: EdgeInsets.all(10),
                    tooltipBehavior:
                        TooltipBehavior(enable: true, header: stateName),
                    primaryXAxis: CategoryAxis(),
                    primaryYAxis: NumericAxis(),
                    palette: <Color>[
                      Colors.red,
                      Colors.teal,
                    ],
                    series: <ChartSeries>[
                      LineSeries<CovidDay, String>(
                        name: 'Cases',
                        dataSource: covidDayList,
                        xValueMapper: (CovidDay covidDay, _) =>
                            DateFormat.yMMMd().format(covidDay.date).toString(),
                        yValueMapper: (CovidDay covidDay, _) =>
                            covidDay.totalCases == 0
                                ? 0
                                : log(covidDay.totalCases),
                      ),
                      LineSeries<CovidDay, String>(
                        name: 'Discharged',
                        dataSource: covidDayList,
                        xValueMapper: (CovidDay covidDay, _) =>
                            DateFormat.yMMMd().format(covidDay.date).toString(),
                        yValueMapper: (CovidDay covidDay, _) =>
                            covidDay.totalDischarged == 0
                                ? 0
                                : log(covidDay.totalDischarged),
                      ),
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
