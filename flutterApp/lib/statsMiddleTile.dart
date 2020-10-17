import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';





//create a class and initialize number of forms to 0; 
class Statistics {
  int numberOfFormsFilled = 0;
  
  
  //simple constructor
  Statistics(
      {this.numberOfFormsFilled
      });
// factory constructor is called below and searchs through json format and places number of forms
  // into classes attribute. To get this, we needed the length/amount of elements in json result. 
  factory Statistics.fromJson(Map<String, dynamic> mapForFormCount) {
    return Statistics(
      
      numberOfFormsFilled: mapForFormCount.length,
     
    );
  }

  
}
//future allows us to perform on something that isn't yet received until fetched or created in time. 
//in this case, we communicate with our online database, receive json result, perform function on it, 
//extract the number of forms using our class above. 
Future<int> fetchStats() async {
  const formURL = 'https://projectworkflow.firebaseio.com/Assessments.json';
 
  final formJsonResponse = await http.get(formURL);
 

  Map<String, dynamic> mapOfFetchedForms = json.decode(formJsonResponse.body);


  Statistics statsHolder = new Statistics.fromJson(
      mapOfFetchedForms);

 
  return (statsHolder.numberOfFormsFilled);// return number of forms and this function will be called later
}
//create new class that is stateful meaning it can change based on real live user events
class StatsMiddleTile extends StatefulWidget {
  @override
  StatsMiddleTileState createState() {
    //create a state of the implementation below (statslasttilestate)
    return StatsMiddleTileState();
  }
}



class StatsMiddleTileState extends State<StatsMiddleTile> {
  //Here we work with the future values we have not received until running the app. here we 
  //will fetch the number of forms and display it in the middle tile 
  

  Widget fetchStatz = FutureBuilder<int>(
        //call and receive our return value from fetchstats function. 
    future: fetchStats(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        
        return Container(
           
          child: Expanded(
                      child:AutoSizeText(
                  "${snapshot.data}",//snapshot.data is the number of forms that we fetched
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 125,
                      fontWeight: FontWeight.bold),
                  minFontSize: 20,
                  maxLines: 1,
                 // textAlign: TextAlign.center,
                ),
          ),
        );
      } else if (snapshot.hasError) {
                //this displays predefined error message
        return new Text("${snapshot.error}");
      }

      // By default, show a loading spinner
      return new CircularProgressIndicator();
    },
  );

//////////////////////////////////////////////
//build all of our work above into a nice diplay. 
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey[900],
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      padding: const EdgeInsets.all(8),
      //here we have one container with a column and one row in the column. 
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: AutoSizeText(
                  "Number of Forms",
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  minFontSize: 8,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
                   //this creates room between title and the number displayed. 
          Flexible(
            child: Divider(
              indent: 0,
              endIndent: 0,
              color: Colors.blue,
              thickness: 1.0,
            ),
          ),
           //This is the most important call . This is implemented above and returns the number of forms. 
          fetchStatz,
        ],
      ),
    );
  }
}
