import 'package:flutter/material.dart';
import 'founder.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'webpageReport.dart';

//ChooseFounder is used by delverabletile.dart in order to generate the
//list of founders when the button is pressed on the deliverable tile.
//The founder information is gathered using the http request call to
//the Google Firebase. A future builder is used to get that information
//returned.

class ChooseFounder extends StatefulWidget {
  @override
  ChooseFounderState createState() {
    return ChooseFounderState();
  }
}

class ChooseFounderState extends State<ChooseFounder> {
  //fetches the founder data from the Goolge Firebase database.
  //This is done using the http request get and the results are saved to 
  //a list of the type Founder. Future builder will call this function and
  //use it to form the list of founders that will be displayed when the 
  //view report button is pressed.
  Future<List<Founder>> fetchedFounder() async {
    const url = 'https://projectworkflow.firebaseio.com/Founder.json';
    final response = await http.get(url);
    Map<String, dynamic> fetchedEvaluatorsList = json.decode(response.body);
    dynamic valuesFromMap = fetchedEvaluatorsList.values;
    List<Founder> founderList = new List();

    for (var v in valuesFromMap) {
      Founder found = Founder(foundry: v['foundry']);
      founderList.add(found);
    }
    return founderList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .40,
      width: MediaQuery.of(context).size.width * .25,
      color: Colors.grey[350],
      child: FutureBuilder(
        future: fetchedFounder(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return new Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.business,
                      color: Colors.blue,
                    ),
                    title: Text(
                      '${snapshot.data[index].foundry}',
                    ),
                    trailing: Icon(
                      Icons.arrow_right,
                      color: Colors.blue,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              WebpageReport('${snapshot.data[index].foundry}'),
                        ),
                      );
                    },
                  ),
                );
              },
            );
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
