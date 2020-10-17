import 'dart:async';
import 'package:flutter/material.dart';
import 'eval.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//Debugging v for the problems (v indicates down)

class EvalRmv extends StatefulWidget {
  @override
  EvalRmvState createState() {
    return EvalRmvState();
  }
}

//clean up the fetching code
class EvalRmvState extends State<EvalRmv> {
  //Testing to see if we need this (Going through the problems... )
  //static FirebaseDatabase _database = FirebaseDatabase.instance;
  Iterable<String> keysFromMap;
  String temp;

  //fetch the evaluator list from the firbase database. Uses json decode to parse data
  Future<List<Eval>> evaluatorsList(Iterable<String> temp) async {
    const url = 'https://projectworkflow.firebaseio.com/Evaluators.json';
    final response = await http.get(url);
    Map<String, dynamic> fetchedEvaluatorsList = json.decode(response.body);
    dynamic valuesFromMap = fetchedEvaluatorsList.values;
    List<Eval> evaluatorList = new List();
    keysFromMap = fetchedEvaluatorsList.keys;

//loops through returned map to set the list for useage.
    for (var v in valuesFromMap) {
      Eval test = Eval(
          firstName: v['firstName'],
          lastName: v['lastName'],
          email: v['email'],
          weight: v['weight'],
          choice: false);
      evaluatorList
          .add(test); 
    }
    return evaluatorList;
  }

  //deletes the evaluator from the database
  Future<void> removeEvaluator(String key) async {
    String url =
        'https://projectworkflow.firebaseio.com/Evaluators/' + key + '.json';
    return await http.delete(url);
  }

  @override
  //widget tree, this is all UI elements
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .40,
      width: MediaQuery.of(context).size.width * .25,
      color: Colors.grey[350],
      child: FutureBuilder(
        future: evaluatorsList(keysFromMap),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scrollbar(
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return new Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.person,
                        color: Colors.red,
                      ),
                      //sets text to value from database
                      title: Text(
                          '${snapshot.data[index].firstName} ${snapshot.data[index].lastName}      ${snapshot.data[index].email}'),
                      trailing: Icon(
                        Icons.arrow_right,
                        color: Colors.red,
                      ),
                      //calls the popup menu on press of the button to show list elements
                      onTap: () async {
                        confirmationPopUp(
                            keysFromMap.elementAt(index),
                            snapshot.data[index].firstName,
                            snapshot.data[index].lastName);
                      },
                    ),
                  );
                },
              ),
            );
            //error validation
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

//code for the configuration of the popup menu. Holds on the UI elements to remove an evaluator
  void confirmationPopUp(String key, String firstName, String lastName) {
    SimpleDialog box = SimpleDialog(
      title: Text(
        'Confirm Deletion',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      children: <Widget>[
        Center(
            child:
                Text('Are you sure you want to delete $firstName $lastName?')),
        Row(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 120.0, top: 10),
            child: FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
              ),
              color: Colors.grey,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 10),
            child: FlatButton(
              onPressed: () async {
                await removeEvaluator(key);
                Navigator.pop(context);
              },
              child: Text(
                'Delete',
              ),
              color: Colors.red,
            ),
          ),
        ])
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return box;
      },
    );
  }
}