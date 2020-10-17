import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './textWidget.dart';
import './nameDropdown.dart';
import './companyDropdown.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './questionaireResponse.dart';
import 'package:flutterApp/widgets.dart';
import 'package:intl/intl.dart';

//Defines the stateful widget, allowing for updates and changes

class Questionaire extends StatefulWidget {
  Questionaire({Key key, startup}) : super(key: key);

  //override the current standard state into one that we can modify
  @override
  _QuestionaireState createState() => _QuestionaireState();
}

//Defines the state of the widget, allowing for the rebuild of the context
class _QuestionaireState extends State<Questionaire> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Retrieve Text Input',
      home: MyHomePage(),
    );
  }
}

//global variables allowing for easy passing of variables across multiple files
String nameDropDown;
String companyDropDown;

//global map, this is where all of our data is stored from the questionaire
//after being filled out, it gets pushed from here, into a map in the database
Map map = {
  'pitchName': 'Pitch Name',
  'evaluatorName': 'FirstLast',
  'email': 'Email',
  'productKnowledge': '(Optional) Product Knowledge: Empty',
  'productFeasability': '(Optional) Product Feasability: Empty',
  'marketKnowledge': '(Optional) Market Knowledge: Empty',
  'marketEducationAbility': '(Optional) Market Education: Empty',
  'customerPersonaKnowledge': '(Optional) Customer Persona Knowledge: Empty',
  'customerBuyExecution': '(Optional) Customer Buy Execution: Empty',
  'competitionKnowledge': '(Optional) Competition Knowledge: Empty',
  'competitionExecution': '(Optional) Competition Execution: Empty',
  'founderExperienceInMarket': '(Optional) Founder Experience In Market: Empty',
  'founderBusinessExperience': '(Optional) Founder Business Experience: Empty',
  'founderCoachableFounder': '(Optional) Founder Coachable Founder: Empty',
  'overall': '(Optional) Overall: Empty',
  'feedbackForFounder': '(Optional) Feedback For Founder: Empty',
  'internalFeedback': '(Optional) Internal Feedback: Empty',
  'storedValues': new List(12),
  'dayOfWeek': 'Day of the week',
  'month': 'month',
};

//function to record the values provided
final List<int> recordedValues = new List(12);
bool nullFlag = false;

//function to set the values in the map at a particular index with a new value
//particularly used for storing items in the list within the map
void setValue(int index, int newValue) {
  map['storedValues'][index] = newValue;
}

//very similar to the previous function, however, this sets the map at destination
//previous one was for storing in the list in the map
void setOutput(String destination, String host) {
  map[destination] = host;
}

//Beginning of the new class definition
class MyHomePage extends StatelessWidget {
  //Text editing controllers used for gathering information from the user
  final feedbackForFounderController = TextEditingController();
  final internalFeedbackController = TextEditingController();
  final inputText = "Please rate from 1-5";
  final pitchName = 'pitchNameHere';
  final DateTime date = DateTime.now();

  void dispose() {
    // Clean up the controller when the widget is disposed.
    feedbackForFounderController.dispose();
    internalFeedbackController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //MediaQuery used to get the size of the screen, which is then used later 
    //to define the other sizes of items
    var screenSize = MediaQuery.of(context).size;
    map['pitchName'] = "Software StartUp";

    //future is gathering a snapshot of what's currently avaiable in the database
    //in this case, we're using it to simply store what we have
    Future<void> addAssessment() {
      const url = 'https://projectworkflow.firebaseio.com/Assessments.json';
      return http.post(
        url,
        body: json.encode(
          {
            //All of the values created earlier in the map getting their own
            //unique name in the database
            'pitchName': map['pitchName'],
            'evaluatorName': map['evaluatorName'],
            'email': map['email'],
            'productKnowledge': map['productKnowledge'],
            'productFeasability': map['productFeasability'],
            'marketKnowledge': map['marketKnowledge'],
            'marketEducationAbility': map['marketEducationAbility'],
            'customerPersonaKnowledge': map['customerPersonaKnowledge'],
            'customerBuyExecution': map['customerBuyExecution'],
            'competitionKnowledge': map['competitionKnowledge'],
            'competitionExecution': map['competitionExecution'],
            'founderExperienceInMarket': map['founderExperienceInMarket'],
            'founderBusinessExperience': map['founderBusinessExperience'],
            'founderCoachableFounder': map['founderCoachableFounder'],
            'overall': map['overall'],
            'feedbackForFounder': map['feedbackForFounder'],
            'internalFeedback': map['internalFeedback'],
            'storedValues': map['storedValues'],
            'dayOfWeek': map['dayOfWeek'],
            'month': map['month'],
          },
        ),
      );
    }
    //Top scaffold, following the color scheme provided by other team members 
    return Scaffold(
      backgroundColor: Colors.grey[350], //changed 4/4/2020
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900], //changed 4/4/2020
        title: Text(
          map['pitchName'], // changed here on 4/2/2020
          style: TextStyle(fontSize: 35),
        ),
      ),

      //Single Child scroll view, used to allow the the screen to scroll considering our questionnaire
      //was longer than the size of a screen.
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(
            screenSize.width * 0.10,
            10,
            screenSize.width * 0.10,
            10,
          ),
          child: Column(
            //determines the alignment of the column 
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //startupNV picture
              Center(
                child: MyImageWidget(),
              ),
              //where the dropdown menu's are located, at the top
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  NameDropdown(),
                  CompanyDropdown(),
                ],
              ),
              //This begins a lot of repetition, with putting in the "text"
              //And the "Ratings"
              Row(
                children: <Widget>[
                  Expanded(
                    child: Divider(
                      indent: 40,
                      endIndent: 40,
                      color: Colors.blue,
                      height: 80,
                      thickness: 1.0,
                    ),
                  ),
                  Text(
                    'The Product',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      indent: 40,
                      endIndent: 40,
                      color: Colors.blue,
                      height: 80,
                      thickness: 1.0,
                    ),
                  ),
                ],
              ),

              //So begins the repeition for a few lines...
              TextClass(
                'Knowledge',
              ),
              Response(0, 'productKnowledge'),
              TextClass(
                'Feasability',
              ),
              Response(1, 'productFeasability'),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Divider(
                      indent: 40,
                      endIndent: 40,
                      color: Colors.blue,
                      height: 80,
                      thickness: 1.0,
                    ),
                  ),
                  Text(
                    'The Market',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      indent: 40,
                      endIndent: 40,
                      color: Colors.blue,
                      height: 80,
                      thickness: 1.0,
                    ),
                  ),
                ],
              ),
              TextClass(
                'Knowledge',
              ),
              Response(2, 'marketKnowledge'),
              TextClass(
                'Education Ability',
              ),
              Response(3, 'marketEducationAbility'),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Divider(
                      indent: 40,
                      endIndent: 40,
                      color: Colors.blue,
                      height: 80,
                      thickness: 1.0,
                    ),
                  ),
                  Text(
                    'Customer Questions',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      indent: 40,
                      endIndent: 40,
                      color: Colors.blue,
                      height: 80,
                      thickness: 1.0,
                    ),
                  ),
                ],
              ),
              TextClass(
                'Knowledge',
              ),
              Response(4, 'customerPersonaKnowledge'),
              TextClass(
                'Execution',
              ),
              Response(5, 'customerBuyExecution'),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Divider(
                      indent: 40,
                      endIndent: 40,
                      color: Colors.blue,
                      height: 80,
                      thickness: 1.0,
                    ),
                  ),
                  Text(
                    'The Competition',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      indent: 40,
                      endIndent: 40,
                      color: Colors.blue,
                      height: 80,
                      thickness: 1.0,
                    ),
                  ),
                ],
              ),
              TextClass(
                'Knowledge',
              ),
              Response(6, 'competitionKnowledge'),
              TextClass(
                'Execution',
              ),
              Response(7, 'competitionExecution'),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Divider(
                      indent: 40,
                      endIndent: 40,
                      color: Colors.blue,
                      height: 80,
                      thickness: 1.0,
                    ),
                  ),
                  Text(
                    'The Team',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      indent: 40,
                      endIndent: 40,
                      color: Colors.blue,
                      height: 80,
                      thickness: 1.0,
                    ),
                  ),
                ],
              ),
              TextClass(
                'Knowledge',
              ),
              Response(8, 'founderExperienceInMarket'),
              TextClass(
                'Execution',
              ),
              Response(9, 'founderBusinessExperience'),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Divider(
                      indent: 40,
                      endIndent: 40,
                      color: Colors.blue,
                      height: 80,
                      thickness: 1.0,
                    ),
                  ),
                  Text(
                    'The Founder',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      indent: 40,
                      endIndent: 40,
                      color: Colors.blue,
                      height: 80,
                      thickness: 1.0,
                    ),
                  ),
                ],
              ),
              TextClass(
                'Founder Coachability',
              ),
              Response(10, 'founderCoachableFounder'),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Divider(
                      indent: 40,
                      endIndent: 40,
                      color: Colors.blue,
                      height: 80,
                      thickness: 1.0,
                    ),
                  ),
                  Text(
                    'Overall',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      indent: 40,
                      endIndent: 40,
                      color: Colors.blue,
                      height: 80,
                      thickness: 1.0,
                    ),
                  ),
                ],
              ),
              TextClass(
                'Overall',
              ),
              Response(11, 'overall'),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Divider(
                      indent: 40,
                      endIndent: 40,
                      color: Colors.blue,
                      height: 80,
                      thickness: 1.0,
                    ),
                  ),
                  Text(
                    'Feedback',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      indent: 40,
                      endIndent: 40,
                      color: Colors.blue,
                      height: 80,
                      thickness: 1.0,
                    ),
                  ),
                ],
              ),

              //Location for internal, and external feedback
              Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: TextClass(
                  'External',
                ),
              ),
              TextField(
                controller: feedbackForFounderController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Please leave feedback for the founder [external]",
                ),
                maxLines: null,
                textAlign: TextAlign.center,
              ),
              Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: TextClass(
                  'Internal',
                ),
              ),
              TextField(
                controller: internalFeedbackController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Please leave feedback for the founder [internal]",
                ),
                maxLines: null,
                textAlign: TextAlign.center,
              ),

              //The submit button at the bottom of the page, aligned in the center
              Align(
                alignment: Alignment.bottomCenter,
                child: RaisedButton(
                  //Command for once the button is pressed, which is to store the info in the database
                  //Also check to make sure that every button has been pressed
                  onPressed: () {
                    for (var i in map['storedValues']) {
                      if (i == null) {
                        nullFlag = true;
                      }
                    }
                    if (nullFlag == true) {
                      return showDialog(
                          context: context,
                          builder: (context) {
                            nullFlag = false;
                            return AlertDialog(
                              content: Text(
                                  "Error! Please complete all 1-5 ratings!"),
                            );
                          });
                    } else if (nullFlag != true) {
                      map['feedbackForFounder'] =
                          feedbackForFounderController.text;
                      map['internalFeedback'] = internalFeedbackController.text;
                      map['dayOfWeek'] = DateFormat('EEEE').format(date);
                      map['month'] = DateFormat('MMMM').format(date);
                      map['evaluatorName'] = nameDropDown;
                      map['pitchName'] = companyDropDown;

                      // Nick Function here
                      addAssessment();
                      return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                              // Retrieve the text the that user has entered by using the controller
                              content: 

                              //The text that is displayed after the user clicks submit.                        
                              Text(
                                "$nameDropDown, Thank you for evaluating $companyDropDown!"  +
                                '\n' +
                                map['dayOfWeek'] + 
                                '\n' +
                                map['month'] +
                                '\n' +
                                map['productKnowledge'] +
                                '\n' +
                                map['productFeasability'] +
                                '\n' +
                                map['marketKnowledge'] +
                                '\n' +
                                map['marketEducationAbility'] +
                                '\n' +
                                map['customerPersonaKnowledge'] +
                                '\n' +
                                map['customerBuyExecution'] +
                                '\n' +
                                map['competitionKnowledge'] +
                                '\n' +
                                map['competitionExecution'] +
                                '\n' +
                                map['founderExperienceInMarket'] +
                                '\n' +
                                map['founderBusinessExperience'] +
                                '\n' +
                                map['founderCoachableFounder'] +
                                '\n' +
                                map['overall'] +
                                '\n' +
                                map['feedbackForFounder'] +
                                '\n' +
                                map['internalFeedback']
                                ),
                              );
                        },
                      );
                    }
                    return null;
                  },
                  child: Text('Submit'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
