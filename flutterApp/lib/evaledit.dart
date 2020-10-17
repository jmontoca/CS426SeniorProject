//Class EvalEdit is used to create the pop up for editing an evaluator.
//This class fetches the evaluator data using an http request from 
//Google Firebase, that information is stored in a list that will be called
//in the future builder. The storted list allows for populating the evaluator
//information that is in the database into the edit pop up fields.
//When the user makes changes to these fields and submits, editEvaluator function
//is called and the information is updated in Google Firebase.
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'eval.dart';

class EvalEdit extends StatefulWidget {
  @override
  EvalEditState createState() {
    return EvalEditState();
  }
}

class EvalEditState extends State<EvalEdit> {
  Iterable<String> keys; //used to keep track of the index of the given evaluator in the database. To make sure the correct evaluator is edited.

  //fetch the evaluator data from Google Firebase. This will be used to
  //be able to determine the evaluators available for editing. 
  Future<List<Eval>> evaluatorsList() async {
    const url = 'https://projectworkflow.firebaseio.com/Evaluators.json';
    final response = await http.get(url);
    Map<String, dynamic> fetchedEvaluatorsList = json.decode(response.body);
    dynamic valuesFromMap = fetchedEvaluatorsList.values;
    List<Eval> evaluatorList = new List();
    keys = fetchedEvaluatorsList.keys;

    for (var v in valuesFromMap) {
      Eval test = Eval(
          firstName: v['firstName'],
          lastName: v['lastName'],
          email: v['email'],
          weight: v['weight'],
          choice: false);
      evaluatorList
          .add(test); //saves to this list, tested the output and recieved data
    }
    return evaluatorList;
  }

  //edits the current evaluator selected
  //http.patch used to make changes to existing data
  //the function takes in key: the given index in the database of the evaluator to 
  //be edited, editedEmail: the updated email, editedFirstName: the updated first name,
  //editedLastName: the updated last name, and editedWeight: the updated weight.
  Future<void> editEvaluator(String key, String editedEmail,
      String editedFirstName, String editedLastedName, editedWeight) async {
    String url =
        'https://projectworkflow.firebaseio.com/Evaluators/' + key + '.json';
    return await http.patch(
      url,
      body: json.encode(
        {
          'email': editedEmail,
          'firstName': editedFirstName,
          'lastName': editedLastedName,
          'weight': editedWeight,
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .40,
      width: MediaQuery.of(context).size.width * .25,
      color: Colors.grey[350],
      child: FutureBuilder(
        future: evaluatorsList(),
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
                        color: Colors.yellow,
                      ),
                      title: Text(
                          '${snapshot.data[index].firstName} ${snapshot.data[index].lastName}      ${snapshot.data[index].email}'),
                      trailing: Icon(
                        Icons.arrow_right,
                        color: Colors.yellow,
                      ),
                      onTap: () {
                        //onTap will cause a simple dialog widget to pop up, this will be where the
                        //evaluator information will be edited.
                        SimpleDialog box = SimpleDialog(
                          title: Text(
                            'Change ${snapshot.data[index].firstName}' +
                                '\'s' +
                                ' Information',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.yellow,
                            ),
                          ),
                          children: <Widget>[
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    icon: Icon(
                                      Icons.person_add,
                                      color: Colors.yellow,
                                    ),
                                  ),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                  initialValue:
                                      '${snapshot.data[index].firstName}',
                                  onChanged: (String first) {
                                    snapshot.data[index].firstName = first;
                                  },
                                ),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    icon: Icon(
                                      Icons.person_add,
                                      color: Colors.yellow,
                                    ),
                                  ),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                  initialValue:
                                      '${snapshot.data[index].lastName}',
                                  onChanged: (String last) {
                                    snapshot.data[index].lastName = last;
                                  },
                                ),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    icon: Icon(
                                      Icons.email,
                                      color: Colors.yellow,
                                    ),
                                  ),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                  initialValue: '${snapshot.data[index].email}',
                                  onChanged: (String mail) {
                                    snapshot.data[index].email = mail;
                                  },
                                ),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    icon: Icon(
                                      Icons.score,
                                      color: Colors.yellow,
                                    ),
                                  ),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                  initialValue:
                                      '${snapshot.data[index].weight}',
                                  onChanged: (String weight) {
                                    snapshot.data[index].weight = weight;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .20,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 80, right: 80),
                                child: RaisedButton(
                                  onPressed: () async {
                                    //edits saved and pushed to the database here
                                    await editEvaluator(
                                        keys.elementAt(index),
                                        snapshot.data[index].email,
                                        snapshot.data[index].firstName,
                                        snapshot.data[index].lastName,
                                        snapshot.data[index].weight);
                                    //pops the dialog box
                                    Navigator.pop(context);
                                  },
                                  child: Text('Submit',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      )),
                                  color: Colors.yellow,
                                ),
                              ),
                            )
                          ],
                        );
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return box;
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            );
          } else if (snapshot.hasError) {
            return Text(
              "Error: ${snapshot.error}",
            );
          } //sized box with a looping green circle will apear if waiting on information to populate
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