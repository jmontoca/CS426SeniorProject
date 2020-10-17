import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:auto_size_text/auto_size_text.dart';

//create a class to hold form scores
class Statistics {
  int avgFormScores = 0;

//simple constructor
  Statistics({this.avgFormScores});
//more advanced constructor that pulls necessary values out labelled as "storeValues"
  factory Statistics.setScroes(dynamic mapForFormCount, int index) {
    return Statistics(
      avgFormScores: mapForFormCount['storedValues'][index],
    );
  }
}
//this is so we can work with information/items/values before we have them. 
Future<double> fetchStats() async {
  //fetch json result from our database
  const formURL = 'https://projectworkflow.firebaseio.com/Assessments.json';
  final formJsonResponse = await http.get(formURL);

//using above constructor, we extract the data we want out of the json result above. 
  Map<String, dynamic> mapOfFetchedForms = json.decode(formJsonResponse.body);

//in the result, we know which value we want so we use a necessary index to get to that position. 
  int overallScoreIndex = 11;
  int tempInt = 0;

//we only care about the values and not the keys of the map. 
  dynamic valuesOfMapOfFetchedForms = mapOfFetchedForms.values;

//run through all values and get average and the return it to be used later. 
  for (var temp in valuesOfMapOfFetchedForms) {
    Statistics overallScoreHolder =
        new Statistics.setScroes(temp, overallScoreIndex);
    if (overallScoreHolder.avgFormScores != null) {
      tempInt = tempInt + overallScoreHolder.avgFormScores;
    }
  }

  return (tempInt / mapOfFetchedForms.length);
}

//create new class that is stateful 
class StatsTile extends StatefulWidget {
  @override
  StatsTileState createState() {
    //here we call our implementation that will eventually be built using build widget. Implementation is below (statstilestate)
    return StatsTileState();
  }
}

class StatsTileState extends State<StatsTile> {
  // @override

//here is where we work with the thing that is called during runtime. Here we can mess with our average num of overall scores. 
  Widget fetchStatz = FutureBuilder<double>(
    //call our important function that returns the average number of overall scores
    future: fetchStats(),
    builder: (context, snapshot) {
    //check to see if fetchstats has data . 
      if (snapshot.hasData) {
        //in a container, we design what the title, arch, average number, spacing and footer will be. 
        return Container(

          decoration: BoxDecoration(
            color: Colors.blueGrey[900],
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              children: <Widget>[

                //this widget is called thorugh a library
                CircularPercentIndicator(
                  header: AutoSizeText(
                    'Overall Rating Given',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    minFontSize: 8,
                    maxLines: 1,
                  ),
                  radius: MediaQuery.of(context).size.height * .25,
                  animation: true,
                  animationDuration: 2000,
                  lineWidth: MediaQuery.of(context).size.height * .015,
                  percent: snapshot.data / 5,
                  reverse: false,
                  arcBackgroundColor: Colors.red,
                  arcType: ArcType.FULL,
                  center: AutoSizeText(
                    "${(snapshot.data).toStringAsFixed(2)}",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                    maxFontSize: 26,
                    maxLines: 1,
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  backgroundColor: Colors.transparent,
                  progressColor: Colors.blue,
                ),
                Container(
                   child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(width: 3,),
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: Colors.white,
                        ),
                        SizedBox(width: 3,),
                        Expanded(
                          child: AutoSizeText(
                  "This number represents the forms' overall score",
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      ),
                  minFontSize: 8,
                  maxLines: 2,
                 //textAlign: TextAlign.center,
                ),
                        ),
                        
                      ],
                    ),
                  
                ),
                
              ],
            ),
          ),
        );
        //if snapshot data has some error, display predefined error. 
      } else if (snapshot.hasError) {
        return new Text("${snapshot.error}");
      }

      // By default, show a loading spinner
      return new CircularProgressIndicator();
    },
  );

//////////////////////////////////////////////
//build our hardwork so that it can be displayed
  Widget build(BuildContext context) {
    return fetchStatz;
  }

}
