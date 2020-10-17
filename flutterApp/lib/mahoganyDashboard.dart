import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterApp/statsTile.dart';
import 'evaltile.dart'; //creates the evaluator tile container
import 'foundertile.dart'; //creates the founder tile container
import 'deliverabletile.dart'; //creates the deliverable tile container
import 'statsMiddleTile.dart';
import 'statsLastTile.dart';

//create new state that is stateful meaining it can change in real time. 
class Dashboard extends StatefulWidget {
  @override
  //create a state with our dashboard implementation and then calling it. 
  _DashboardState createState() => _DashboardState();
}

//declare that our dashboard state is of state dashboard. 
class _DashboardState extends State<Dashboard> {
  @override
  //Build our following implementation and change in real time to user events. 
  Widget build(BuildContext context) {
    //scaffold is the overall structure of webpage
    return Scaffold(
      backgroundColor: Colors.grey[350],
      //appbar is similar to a header and can be designed. 
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueGrey[900],
        centerTitle: true,
        title: Text(
          'StartUpNV Dashboard',
          style: TextStyle(
            fontSize: 32,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            hoverColor: Colors.blueGrey[700],
            shape: BeveledRectangleBorder(),
            textColor: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            }, //needs to be able to log the person out
            child: Text(
              'Log Out',
              style: TextStyle(
                decoration: TextDecoration.underline,
              ),
            ),
            color: Colors.blueGrey[900],
          )
        ],
      ),
      //the entire dashboard is centered in the middle of the screen with appropriate padding
      // found below uisng the mediaquery functionality. 
      body: Center(
        //within center element, we have a containter for more flexibility and 
        //inside this container is a column with two rows. Each row has 3 tiles.
        //between each tile, there is a sizedbox to small padding to prevent merge. 
        child: Container(
          padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.02,
              MediaQuery.of(context).size.width * 0.03,
              MediaQuery.of(context).size.width * 0.02,
              MediaQuery.of(context).size.width * 0.02),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(child: EvalTile()),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.01,
                    ),
                    Expanded(child: FounderTile()),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.01,
                    ),
                    Expanded(child: DeliverableTile()),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.01,
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(child: StatsTile()),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.01,
                    ),
                    Expanded(child: StatsMiddleTile()),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.01,
                    ),
                    Expanded(child: StatsLastTile()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
