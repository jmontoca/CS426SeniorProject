import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

//custom form class for the evaluator
//used with addeval.dart to create a pop
//with two entry fields
//email and weight

//updated regular expression in validator of add
//now only gets up to two decimal places
//still need to find away to limit the front number to just 1 or 0
//updated: 4/18/2020

class EvalCustomForm extends StatefulWidget {
  @override
  EvalCustomFormState createState() {
    return EvalCustomFormState();
  }
}

class EvalCustomFormState extends State<EvalCustomForm> {
  Duration tck = new Duration(seconds: 1); //used to delay the poping of the given pop up
  final _evalFormKey = GlobalKey<FormState>(); 
  var _evalFirstName, _evalLastName, _evalEmail, _evalWeight; //used to hold the evaluator information from the input fields

  @override
  Widget build(BuildContext context) {

    //addEvaluator function uses a http request post call to add the 
    //given evaluator information into the Google Firebase database.
    //the function is called when the submit button from the add evaluator 
    //pop up is pressed.
    Future<void> addEvaluator() {
      const url = 'https://projectworkflow.firebaseio.com/Evaluators.json';
      return http.post(
        url,
        body: json.encode(
          {
            'firstName': _evalFirstName,
            'lastName': _evalLastName,
            'email': _evalEmail,
            'weight': _evalWeight
          },
        ),
      );
    }

    return Form(
      key: _evalFormKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: TextFormField(
              autocorrect: false,
              decoration: const InputDecoration(
                icon: Icon(
                  Icons.person_add,
                  color: Colors.green,
                ),
                hintText: 'First Name',
              ),
              //need to add an if statement to check if the email is already in the
              //database
              //the validator here will check if the field is empty and that the name
              //has a proper form.
              //the regular expression used here was created with the help of https://regexr.com/
              validator: (value) {
                if (value.isEmpty) {
                  return 'Name field cannot be empty';
                } else if (!value.contains(new RegExp(
                    r'^(?=.{1,40}$)[a-zA-Z]+(?:[-\s][a-zA-Z]+)*$'))) {
                  return 'Invalid name entered';
                } else {
                  _evalFirstName = value;
                  return null;
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: TextFormField(
              autocorrect: false,
              decoration: const InputDecoration(
                  icon: Icon(
                    Icons.person_add,
                    color: Colors.green,
                  ),
                  hintText: 'Last Name'),
              //need to add an if statement to check if the email is already in the
              //database
              //the validator here will check if the field is empty and that the name
              //has a proper form.
              //the regular expression used here was created with the help of https://regexr.com/
              validator: (value) {
                if (value.isEmpty) {
                  return 'Name field cannot be empty';
                } else if (!value.contains(new RegExp(
                    r'^(?=.{1,40}$)[a-zA-Z]+(?:[-\s][a-zA-Z]+)*$'))) {
                  return 'Invalid name entered';
                } else {
                  _evalLastName = value;
                  return null;
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: TextFormField(
              autocorrect: false,
              decoration: const InputDecoration(
                  icon: Icon(
                    Icons.email,
                    color: Colors.green,
                  ),
                  hintText: 'Email'),
              //need to add an if statement to check if the email is already in the
              //database
              //the validator here will check if the field is empty and that the email is valid
              //and has a proper form.              
              validator: (value) {
                if (value.isEmpty) {
                  return 'Email field cannot be empty';
                } else if (!value.contains('@') || !value.contains('.')) {
                  return 'Invalid email: example@mail.com';
                } else {
                  _evalEmail = value;
                  return null;
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: TextFormField(
              decoration: const InputDecoration(
                  icon: Icon(
                    Icons.score,
                    color: Colors.green,
                  ),
                  hintText: 'Weight (number 0 - 1)'),
              //need to check if input is a number
              //the validator here will check if the field is empty and that a number is entered
              //and has a proper form of two decimal places 
              validator: (value) {
                if (value.isEmpty) {
                  return 'Weight field cannot be empty';
                } else if (!value
                    .contains(new RegExp(r'^[+]?[0-9]*\.?[0-9]{0,2}$'))) {
                  return 'Invalid weight entered';
                } else {
                  _evalWeight = value;
                  return null;
                }
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
                  _evalFormKey.currentState.save();
                  addEvaluator();
                  successPopUp();
                  //the timer is used to pop the pop up once the 
                  //success pop up is finished and pops
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
        "Evaluator Added",
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

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return box;
        });

    Timer(
      tick,
      () {
        Navigator.pop(context);
      },
    );
  }
}