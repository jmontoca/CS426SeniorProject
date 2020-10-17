import 'package:flutterApp/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutterApp/mahoganyDashboard.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:async';

bool alertHasShown = false; // used in pop up for wrong credentials but correct syntax

// Change the look of default alert pop up 
var alertStyle = AlertStyle(
  animationType: AnimationType.fromBottom,
  isCloseButton: false,
  isOverlayTapDismiss: false,
  descStyle: TextStyle(fontWeight: FontWeight.bold),
  animationDuration: Duration(milliseconds: 400),
  alertBorder: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(30.0),
    side: BorderSide(
      color: Colors.red,
    ),
  ),
  titleStyle: TextStyle(
    color: Colors.red,
  ),
);

//declare loginpage class and make it stateless
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //scaffold is the overall structure of the webpage
    return Scaffold(
      backgroundColor: Colors.grey[350],
      //appbar is the top header of webpage
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: const Text('Welcome', style: TextStyle(fontSize: 32)),
      ),
      //loginform is a called widget that is implemented below
      body: LoginForm(),
    );
  }
}
 //initiate loginform class and have it be stateful so it can change when needed. 
class LoginForm extends StatefulWidget {
  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  //future means that there will some future event/value/item that will be available later
  Future<bool> fetchCredentials() async {
    bool flag = false;
    //This URL is linked to our database and is in json format. 
    const url = 'https://projectworkflow.firebaseio.com/credentials.json';
    //wait until we can extract the contents if you were to click on above link. 
    final response = await http.get(url);
    //From the response, we transform the json format into map (key/value pair)
    Map<String, dynamic> verify = json.decode(response.body);
    //perform some simple validation
    if (verify['Username'] == _email) {
      flag = true;
    } else {
      flag = false;
    }
    if (verify['Password'] == _password) {
      flag = true;
    } else {
      flag = false;
    }
    return flag;
  }
//declare variables here
  String name;
  String pass;
  final alphanumeric = RegExp(r'^[a-zA-Z0-9]+$');
  final _formKey = GlobalKey<FormState>();
  var _email, _password;

  @override
  //THis wdiget will build our implementation and can adjust to live events such as new screen size, button taps, etc. 
  Widget build(BuildContext context) {
    //grab the screensize of current screen
    var screenSize = MediaQuery.of(context).size;
    //return the form and its contents to be built. 
    return Form(
      key: _formKey,
      //create box inwhich you can scroll if needed. 
      child: SingleChildScrollView(
        
        child: Stack(children: <Widget>[
          // Container(
          //     //child:
          //     ),
          Center(
           //center following contents and place them in a column within a container that abide to screen size. 
            child: Container(
              padding: EdgeInsets.fromLTRB(
                  screenSize.width * 0.40,
                  screenSize.width * 0.10,
                  screenSize.width * 0.40,
                  screenSize.width * 0.10),
              child: Column(children: <Widget>[
                // This calls a wdiget that simply holds an image of my choice (StartupNVs Logo)
                new MyImageWidget(),
                //Create textform field for email with simple validation
                TextFormField(
                  autocorrect: false,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    prefixIcon: Icon(
                      Icons.mail,
                      color: Colors.red,
                      size: 24.0,
                    ),
                    hintText: 'Email',
                  ),
                  //Validation Section for Email Textfield
                  validator: (value) {
                    if (value.isEmpty) {
                      return ('Error: Email is empty.');
                    }

                    if (!value.contains('@') | !value.contains('.')) {
                      return ('Please type in a valid email address');
                    }
                    _email = value;

                    
                    return null;
                  },
                ),
                //create space between email and password textfields
                Padding(
                  padding: EdgeInsets.only(bottom: 25.0),
                  child: TextFormField(
                    onFieldSubmitted: (value) {
                      onPressed();
                    },

                    obscureText: true,
                    autocorrect: false,
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Colors.red,
                          size: 24.0,
                        ),
                        hintText: 'Password'),
                    //Validation Section for Password Textfield
                    validator: (value) {
                      if ((value.isEmpty) |
                          (value.length <= 7) |
                          (!value.contains(
                              new RegExp(r'[!@#$%^&*(),.?":{}|<>]')))) {
                        return ('Password is invalid.');
                      }
                      _password = value;
                      
                      return null;
                    },
                  ),
                ),

////////////////////////////////Submission Button
                RaisedButton(
                  color: Colors.grey[600],
                  onPressed: onPressed,
                  child: Text('LOG IN'),
                ),

              ]),
            ),
          ),
        ]),
      ),
    );
  }

  //called when user clicks "login"
  void onPressed() {
    var form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      setState(() async {
        if (await fetchCredentials() == true) {
          Navigator.push(
            context,
            //THis snip of code will navigate user to new page based on successful validation of credentials
            MaterialPageRoute(builder: (context) => Dashboard()),
          );
        } else {
          //upon wrong credentials, ccreate popup that tells user they dont exist
          if (alertHasShown == false) {
            alertHasShown = true;
            Alert(
              context: context,
              style: alertStyle,
              type: AlertType.error,
              title: "HUH?",
              desc: "we can't find you",
              buttons: [
                DialogButton(
                  child: Text(
                    "Okay",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    alertHasShown = false; // this is to fix double pop up based on user event. 
                    //when you tap login or tap out of form after you entered password, both
                      //events are as if you submitted so two popups appeared until this boolean fix
                  },
                  width: 120,
                )
              ],
            ).show();
          }

        }
      });
    }
  }
}
