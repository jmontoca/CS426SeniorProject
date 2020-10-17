import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
//custom form class for the evaluator
//used with addeval.dart to create a pop
//with two entry fields
//email and weight

class FounderCustomForm extends StatefulWidget {
  @override
  FounderCustomFormState createState() {
    return FounderCustomFormState();
  }
}

class FounderCustomFormState extends State<FounderCustomForm> {
  final _evalFormKey = GlobalKey<FormState>();
  final myController = TextEditingController();
  Duration tck = new Duration(seconds: 1);

  var _founderName;

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  //Fetching the data for the founder from the database
  Future<void> addFounder() {
    const url = 'https://projectworkflow.firebaseio.com/Founder.json';
    return http.post(
      url,
      body: json.encode(
        {
          'foundry': _founderName,
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _evalFormKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: TextFormField(
              controller: myController,
              autocorrect: false,
              decoration: const InputDecoration(
                  icon: Icon(
                    Icons.business,
                    color: Colors.green,
                  ),
                  hintText: 'Company Name'),
              //need to add an if statement to check if the email is already in the
              //database
              validator: (value) {
                if (value.isEmpty) {
                  return 'empty company name';
                } else if (!value.contains(new RegExp(
                    r"^(?=.{1,40}$)[a-zA-Z]+(?:[-'\s][a-zA-Z]+)*$"))) {
                  return 'Invalid name entered';
                } else {
                  return null;
                }
              },
              onSaved: (data) {
                _founderName = data;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20.0,
            ),
            child: RaisedButton(
              textColor: Colors.white,
              color: Colors.green,
              onPressed: () {
                if (_evalFormKey.currentState.validate()) {
                  //need to pass the saved values from
                  //_evalFormKey.currentState to the database
                  _evalFormKey.currentState.save();
                  addFounder(); //changed here
                  successPopUp();
                  Timer(
                    tck,
                    () {
                      Navigator.pop(context);
                    },
                  );
                }
              },
              child: Text(
                'Submit',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

//Displays a dialog popup when the
//user enters a valid evaluator
  void successPopUp() {
    Duration tick = new Duration(seconds: 1);
    SimpleDialog box = SimpleDialog(
      title: Text(
        "Founder Added",
        textAlign: TextAlign.center,
      ),
      children: <Widget>[
        Icon(
          Icons.check_circle_outline,
          color: Colors.green,
          size: 80,
        ),
      ],
    );
    //change back to return box;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return box;
        });
    //pop window after a second
    Timer(
      tick,
      () {
        Navigator.pop(context);
      },
    );
  }
}
