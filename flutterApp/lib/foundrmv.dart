import 'package:flutter/material.dart';
import 'founder.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FounderRemove extends StatefulWidget {
  @override
  FounderRemoveState createState() {
    return FounderRemoveState();
  }
}

class FounderRemoveState extends State<FounderRemove> {
  Iterable<String> keys; //used to hold the index position of the selected founder. Used to remove the correct founder in the Google Firebase 

  //fetchedFounder: this function makes a http request get call the the Google Firebase 
  //database. A the founders in the database are saved into a list of founders and the list
  //is returned when the function is called upon by the future buider.
  Future<List<Founder>> fetchedFounder() async {
    const url = 'https://projectworkflow.firebaseio.com/Founder.json'; //the url to the founder database
    final response = await http.get(url);
    Map<String, dynamic> fetchedEvaluatorsList = json.decode(response.body); //holds the information attained from the database
    dynamic valuesFromMap = fetchedEvaluatorsList.values; //the founders from the database
    List<Founder> founderList = new List(); //list of founders that will be returned
    keys = fetchedEvaluatorsList.keys;

    for (var v in valuesFromMap) {
      Founder found = Founder(foundry: v['foundry']);
      founderList.add(found);
    }
    return founderList;
  }

  //removeFounder: makes a http request delete call to the database
  //removes the founder at the given index. Function takes in key: the index of
  //the given founder to be deleted.
  Future<void> removeFounder(String key) async {
    String url =
        'https://projectworkflow.firebaseio.com/Founder/' + key + '.json'; //the url to the founder that is being deleted in the database
    return await http.delete(url);
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
                      leading: Icon(Icons.business, color: Colors.red,),
                      title: Text('${snapshot.data[index].foundry}',),
                      trailing: Icon(Icons.arrow_right, color: Colors.red,),
                      onTap: () {
                        confirmationPopUp(
                            keys.elementAt(index), snapshot.data[index].foundry);
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

  //confirmationPopUp: used to diplay a pop up to the user
  //as a form of security so that they do not delete the 
  //incorrect founder. A simple dialog widget is used as the 
  //pop up of this function. The removeFounder is called from
  //here once the user presses delete button on the pop up.
  void confirmationPopUp(String key, String companyName) {
    SimpleDialog box = SimpleDialog(
      title: Text(
        'Confirm Deletion',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      children: <Widget>[
        Center(child: Text('Are you sure you want to delete $companyName?')),
        Row(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 130.0, top: 10),
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
                await removeFounder(key); //await used ot wait on this process to end before going on to the next
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
