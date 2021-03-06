import 'dart:convert';

import 'package:covid_chart_app/widgets/nav_drawer.dart';
import 'package:flutter/material.dart';

import 'utils.dart';
import './models/covid_day.dart';
import './models/covid_state.dart';

import './widgets/chart_state.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '🇮🇳  COVID-19 Cases'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, CovidState> covidStateData = new Map<String, CovidState>();
  Map<String, Widget> covidStateCharts = new Map<String, Widget>();
  List<dynamic> uniqueStateNames;

  Future<List<dynamic>> parseJson({bool stateDrawer = false}) async {
    String stateData = await loadStateData();

    //Cleaned Unique State Names : Each Name will have curve for itself
    uniqueStateNames = giveUniqueStateNames(json.decode(stateData)['data']);

    if (stateDrawer == true) {
      return uniqueStateNames.toSet().toList();
    }

    //Inserting India at Top
    uniqueStateNames.insert(0, "India");

    //Initializing Map for Each uniqueStateNames otherwise Null Error
    uniqueStateNames.forEach((state) {
      covidStateData[state] = CovidState();
    });

    //Filling Map with State Data
    (json.decode(stateData)['data'] as List).forEach((day) {
      (day['regional'] as List).forEach((state) {
        covidStateData[fixStateName(state['loc'])].stateName = state['loc'];
        covidStateData[fixStateName(state['loc'])].dayWiseScenerio.add(
              CovidDay(
                date: DateTime.parse(day['day']),
                totalCases: state['totalConfirmed'],
                totalDeaths: state['deaths'],
                totalDischarged: state['discharged'],
              ),
            );
      });
    });

    (json.decode(stateData)['data'] as List).forEach((day) {
      covidStateData["India"].stateName = 'India';
      covidStateData["India"].dayWiseScenerio.add(
            CovidDay(
              date: DateTime.parse(day['day']),
              totalCases: day['summary']['total'],
              totalDeaths: day['summary']['deaths'],
              totalDischarged: day['summary']['discharged'],
            ),
          );
    });

    //Main Screen only shows national data, all states are now in the side drawer
    return uniqueStateNames = ['India'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: FutureBuilder(
          //State drawer : Shows states data
          future: parseJson(stateDrawer: true),
          builder: (BuildContext ctx, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return NavDrawerTile(
                      stateName: snapshot.data[index],
                      stateData: covidStateData[snapshot.data[index]],
                    );
                  });
            }
          },
        ),
      ),
      body: FutureBuilder(
        future: parseJson(),
        builder: (BuildContext ctx, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return ChartState(snapshot.data[index],
                      covidStateData[snapshot.data[index]].dayWiseScenerio);
                });
          }
        },
      ),
    );
  }
}
