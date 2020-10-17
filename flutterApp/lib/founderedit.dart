import 'package:flutter/material.dart';
import 'dart:convert';
import 'founder.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class FounderEdit extends StatefulWidget {
  @override
  FounderEditState createState() {
    return FounderEditState();
  }
}

class FounderEditState extends State<FounderEdit> {
  Iterable<String> keys; //used to find the correct founder to edit

  //fetches the founder data from the Google Firebase using the http request get
  //This is saved into a list of founders that will be used when the function is 
  //called by the future builder.
  Future<List<Founder>> fetchedFounder() async {
    const url = 'https://projectworkflow.firebaseio.com/Founder.json';
    final response = await http.get(url);
    Map<String, dynamic> fetchedEvaluatorsList = json.decode(response.body);
    dynamic valuesFromMap = fetchedEvaluatorsList.values;
    List<Founder> founderList = new List();
    keys = fetchedEvaluatorsList.keys;

    for (var v in valuesFromMap) {
      Founder found = Founder(foundry: v['foundry']);
      founderList.add(found);
    }
    return founderList;
  }

  //edits the current founder selected
  //http.patch used to make changes to existing data
  //the function takes in key: used to determine the index of the 
  //founder being edited in the database, editedName: used to update
  //the founders name in the database.
  Future<void> editFounder(String key, String editedName) async {
    String url =
        'https://projectworkflow.firebaseio.com/Founder/' + key + '.json';
    return await http.patch(
      url,
      body: json.encode(
        {
          'foundry': editedName,
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
        future: fetchedFounder(), //call to the future function is done here
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scrollbar(
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return new Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.business,
                        color: Colors.yellow,
                      ),
                      title: Text('${snapshot.data[index].foundry}'),
                      trailing: Icon(
                        Icons.arrow_right,
                        color: Colors.yellow,
                      ),
                      onTap: () {
                        SimpleDialog box = SimpleDialog(
                          title: Text(
                            'Change company name',
                            textAlign: TextAlign.center,
                          ),
                          children: <Widget>[
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    icon: Icon(
                                      Icons.business,
                                      color: Colors.yellow,
                                    ),
                                  ),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                  initialValue:
                                      '${snapshot.data[index].foundry}',
                                  onChanged: (String value) {
                                    snapshot.data[index].foundry = value;
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
                                    //pass in the key index of the founder and the changed parameters
                                    editFounder(keys.elementAt(index),
                                        snapshot.data[index].foundry);
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
