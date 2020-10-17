import 'package:flutter/material.dart';
import 'package:flutterApp/reportdata.dart';
import 'package:flutterApp/widgets.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'startupdata.dart';
import 'reportdata.dart';

//pulled data and can get the given name forms
//next need to run through the stored values and
//compute the values for the form
//also need to pull evaluator weight data in

class WebpageReport extends StatelessWidget {
  final DateTime date = DateTime.now();
  final pitchName;

  WebpageReport(this.pitchName); //used to pass in the startup name

  //Will return a list containing all the summed up stat data
  //for the given founder
  Future<ReportData> reportData(String namePassed) async {
    double pk = 0;
    double pf = 0;
    double mk = 0;
    double mea = 0;
    double cusk = 0;
    double cuse = 0;
    double compk = 0;
    double compe = 0;
    double fexpm = 0;
    double fbexe = 0;
    double coaf = 0;
    double all = 0;

    int minpk = 999;
    int minpf = 999;
    int minmk = 999;
    int minmea = 999;
    int mincusk = 999;
    int mincuse = 999;
    int mincompk = 999;
    int mincompe = 999;
    int minfexpm = 999;
    int minfbexe = 999;
    int mincoaf = 999;
    int minall = 999;

    int maxpk = 0;
    int maxpf = 0;
    int maxmk = 0;
    int maxmea = 0;
    int maxcusk = 0;
    int maxcuse = 0;
    int maxcompk = 0;
    int maxcompe = 0;
    int maxfexpm = 0;
    int maxfbexe = 0;
    int maxcoaf = 0;
    int maxall = 0;

    List<String> dataLoop = [
      "pk",
      "pf",
      "mk",
      "mea",
      "cusk",
      "cuse",
      "compk",
      "compe",
      "fexpm",
      "fbexe",
      "coaf",
      "all"
    ];

    //used to pull in the data from assessments table
    const url = 'https://projectworkflow.firebaseio.com/Assessments.json';
    final response = await http.get(url);
    Map<String, dynamic> reportDataList = json.decode(response.body);
    dynamic valuesFromMap = reportDataList.values;
    List<StartUpData> dataList = new List();

    //used to pull in the data from the evaluators table
    const url2 = 'https://projectworkflow.firebaseio.com/Evaluators.json';
    final response2 = await http.get(url2);
    Map<String, dynamic> reportDataList2 = json.decode(response2.body);
    dynamic valuesFromMap2 = reportDataList2.values;

    for (var v in valuesFromMap) {
      if (v['pitchName'] == pitchName) {
        StartUpData test = StartUpData(
            //firstName: v['firstName'],
            //lastName: v['lastName'],
            name: v['evaluatorName'], //changed on 4/27/2020
            email: v['email'],
            startUpName: v['pitchName'],
            vals: v['storedValues']);
        dataList.add(
            test); //saves to this list, tested the output and recieved data
      }
    }

    //match the evaluators from the assessment and eval tables to get the weight
    //this being done by matching first name and last name, might want to do it 
    //email 4/23/2020
    for (var e in valuesFromMap2) {
      for (var d in dataList) {
        if (d.name == e['firstName'] + ' ' + e['lastName']) {
          d.weight = double.parse(e['weight']);
          print(d.weight);
          print(d.name);
        }
      }
    }

    //calculate the stats and place them in the list to be returned
    //print(dataList.length); //test to see if the length of the data test is correct
    for (var i in dataList) {
      for (int j = 0; j < i.vals.length; j++) {
        if (dataLoop[j] == "pk") {
          pk = pk + (i.weight * i.vals[j]);
          if (i.vals[j] < minpk) {
            minpk = i.vals[j];
          }
          if (i.vals[j] > maxpk) {
            maxpk = i.vals[j];
          }
        } else if (dataLoop[j] == "pf") {
          pf = pf + (i.weight * i.vals[j]);
          if (i.vals[j] < minpf) {
            minpf = i.vals[j];
          }
          if (i.vals[j] > maxpf) {
            maxpf = i.vals[j];
          }
        } else if (dataLoop[j] == "mk") {
          mk = mk + (i.weight * i.vals[j]);
          if (i.vals[j] < minmk) {
            minmk = i.vals[j];
          }
          if (i.vals[j] > maxmk) {
            maxmk = i.vals[j];
          }
        } else if (dataLoop[j] == "mea") {
          mea = mea + (i.weight * i.vals[j]);
          if (i.vals[j] < minmea) {
            minmea = i.vals[j];
          }
          if (i.vals[j] > maxmea) {
            maxmea = i.vals[j];
          }
        } else if (dataLoop[j] == "cusk") {
          cusk = cusk + (i.weight * i.vals[j]);
          if (i.vals[j] < mincusk) {
            mincusk = i.vals[j];
          }
          if (i.vals[j] > maxcusk) {
            maxcusk = i.vals[j];
          }
        } else if (dataLoop[j] == "cuse") {
          cuse = cuse + (i.weight * i.vals[j]);
          if (i.vals[j] < mincuse) {
            mincuse = i.vals[j];
          }
          if (i.vals[j] > maxcuse) {
            maxcuse = i.vals[j];
          }
        } else if (dataLoop[j] == "compk") {
          compk = compk + (i.weight * i.vals[j]); //stopped here !!!!!!
          if (i.vals[j] < mincompk) {
            mincompk = i.vals[j];
          }
          if (i.vals[j] > maxcompk) {
            maxcompk = i.vals[j];
          }
        } else if (dataLoop[j] == "compe") {
          compe = compe + (i.weight * i.vals[j]);
          if (i.vals[j] < mincompe) {
            mincompe = i.vals[j];
          }
          if (i.vals[j] > maxcompe) {
            maxcompe = i.vals[j];
          }
        } else if (dataLoop[j] == "fexpm") {
          fexpm = fexpm + (i.weight * i.vals[j]);
          if (i.vals[j] < minfexpm) {
            minfexpm = i.vals[j];
          }
          if (i.vals[j] > maxfexpm) {
            maxfexpm = i.vals[j];
          }
        } else if (dataLoop[j] == "fbexe") {
          fbexe = fbexe + (i.weight * i.vals[j]);
          if (i.vals[j] < minfbexe) {
            minfbexe = i.vals[j];
          }
          if (i.vals[j] > maxfbexe) {
            maxfbexe = i.vals[j];
          }
        } else if (dataLoop[j] == "coaf") {
          coaf = coaf + (i.weight * i.vals[j]);
          if (i.vals[j] < mincoaf) {
            mincoaf = i.vals[j];
          }
          if (i.vals[j] > maxcoaf) {
            maxcoaf = i.vals[j];
          }
        } else if (dataLoop[j] == "all") {
          all = all + (i.weight * i.vals[j]);
          if (i.vals[j] < minall) {
            minall = i.vals[j];
          }
          if (i.vals[j] > maxall) {
            maxall = i.vals[j];
          }
        }
      }
    }

    //put all summed up values into the proper sections
    //and divide by the number of evaluators that
    //participated
    ReportData temp = ReportData(
      overall: all / dataList.length,
      prodKnow: pk / dataList.length,
      prodFeas: pf / dataList.length,
      markKnow: mk / dataList.length,
      markFeas: mea / dataList.length,
      custKnow: cusk / dataList.length,
      custExe: cuse / dataList.length,
      compKnow: compk / dataList.length,
      compExe: compe / dataList.length,
      foundExpMark: fexpm / dataList.length,
      foundBizExp: fbexe / dataList.length,
      coachableFound: coaf / dataList.length,
      minOverall: minall,
      minProdKnow: minpk,
      minProdFeas: minpf,
      minMarkKnow: minmk,
      minMarkFeas: minmea,
      minCustKnow: mincusk,
      minCustExe: mincuse,
      minCompKnow: mincompk,
      minCompExe: mincompe,
      minFoundExpMark: minfexpm,
      minFoundBizExp: minfbexe,
      minCoachableFound: mincoaf,
      maxOverall: maxall,
      maxProdKnow: maxpk,
      maxProdFeas: maxpf,
      maxMarkKnow: maxmk,
      maxMarkFeas: maxmea,
      maxCustKnow: maxcusk,
      maxCustExe: maxcuse,
      maxCompKnow: maxcompk,
      maxCompExe: maxcompe,
      maxFoundExpMark: maxfexpm,
      maxFoundBizExp: maxfbexe,
      maxCoachableFound: maxcoaf,
    );

    return temp;
  }
//widget tree holding all UI for the page.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "$pitchName Report",
          style: TextStyle(fontSize: 35),
        ),
      ),

      body: FutureBuilder(
        future: reportData(pitchName),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Align(
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: MyImageWidget(),
                    ),
                  ),
                  // formatting for the text that is being displayed.
                  Text(
                    "Pitch Evaluations Summary for today, ${DateFormat('EEEE').format(date)}\n",
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  Container(
                    child: Table(
                      children: [
                        TableRow(children: [
                          Text("Overall"),
                          Text(
                              '\t${(snapshot.data.overall).toStringAsFixed(2)}'),
                          Text(
                              '\t${snapshot.data.minOverall} - ${snapshot.data.maxOverall}'),
                        ]),
                        TableRow(children: [
                          Text("Product Knowledge"),
                          Text(
                              '\t${(snapshot.data.prodKnow).toStringAsFixed(2)}'),
                          Text(
                              '\t${snapshot.data.minProdKnow} - ${snapshot.data.maxProdKnow}'),
                        ]),
                        TableRow(children: [
                          Text("Product Feasibility"),
                          Text(
                              '\t${(snapshot.data.prodFeas).toStringAsFixed(2)}'),
                          Text(
                              '\t${snapshot.data.minProdFeas} - ${snapshot.data.maxProdFeas}'),
                        ]),
                        TableRow(children: [
                          Text("Market Knowledge"),
                          Text(
                              '\t${(snapshot.data.markKnow).toStringAsFixed(2)}'),
                          Text(
                              '\t${snapshot.data.minMarkKnow} - ${snapshot.data.maxMarkKnow}'),
                        ]),
                        TableRow(children: [
                          Text("Market Execution Ability"),
                          Text(
                              '\t${(snapshot.data.markFeas).toStringAsFixed(2)}'),
                          Text(
                              '\t${snapshot.data.minMarkFeas} - ${snapshot.data.maxMarkFeas}'),
                        ]),
                        TableRow(children: [
                          Text("Customer Persona Knowledge"),
                          Text(
                              '\t${(snapshot.data.custKnow).toStringAsFixed(2)}'),
                          Text(
                              '\t${snapshot.data.minCustKnow} - ${snapshot.data.maxCustKnow}'),
                        ]),
                        TableRow(children: [
                          Text("Customer Buy/Execution"),
                          Text(
                              '\t${(snapshot.data.custExe).toStringAsFixed(2)}'),
                          Text(
                              '\t${snapshot.data.minCustExe} - ${snapshot.data.maxCustExe}'),
                        ]),
                        TableRow(children: [
                          Text("Competition Knowledge"),
                          Text(
                              '\t${(snapshot.data.compKnow).toStringAsFixed(2)}'),
                          Text(
                              '\t${snapshot.data.minCompKnow} - ${snapshot.data.maxCompKnow}'),
                        ]),
                        TableRow(children: [
                          Text("Competition Execution"),
                          Text(
                              '\t${(snapshot.data.compExe).toStringAsFixed(2)}'),
                          Text(
                              '\t${snapshot.data.minCompExe} - ${snapshot.data.maxCompExe}'),
                        ]),
                        TableRow(children: [
                          Text("Founder Exp in Market"),
                          Text(
                              '\t${(snapshot.data.foundExpMark).toStringAsFixed(2)}'),
                          Text(
                              '\t${snapshot.data.minFoundExpMark} - ${snapshot.data.maxFoundExpMark}'),
                        ]),
                        TableRow(children: [
                          Text("Founder Biz Exp"),
                          Text(
                              '\t${(snapshot.data.foundBizExp).toStringAsFixed(2)}'),
                          Text(
                              '\t${snapshot.data.minFoundBizExp} - ${snapshot.data.maxFoundBizExp}'),
                        ]),
                        TableRow(children: [
                          Text("Coachable Founder"),
                          Text(
                              '\t${(snapshot.data.coachableFound).toStringAsFixed(2)}'),
                          Text(
                              '\t${snapshot.data.minCoachableFound} - ${snapshot.data.maxCoachableFound}'),
                        ]),
                      ],
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      defaultColumnWidth: IntrinsicColumnWidth(),
                    ),
                  ),
                ],
              ),
            );
            // error validation.
          } else if (snapshot.hasError) {
            return Text(
              "Error: ${snapshot.error}",
            );
          }
          return SizedBox(
            child: CircularProgressIndicator(
              backgroundColor: Colors.green,
              strokeWidth: 10,
            ),
            height: MediaQuery.of(context).size.height * .05,
            width: MediaQuery.of(context).size.width * .05,
          );
        },
      ),
    );
  }
}