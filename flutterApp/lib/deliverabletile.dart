//Created on: 3/18/2020
//class DeliverableTile:
//      Container, for the deliverables, that has interactable cards
//      different operations. The operations are as follows: view the 
//      startup report.
//      The main purpose of this class is to create the tile and button
//      for the deliverables of the project. This would be the view report
//      button. This calls the startUpWindow function to create a pop up
//      with the founders that are available in the database.
import 'package:flutter/material.dart';
import 'choosefounder.dart';

class DeliverableTile extends StatefulWidget {
  @override
  DeliverableTileState createState() {
    return DeliverableTileState();
  }
}

class DeliverableTileState extends State<DeliverableTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey[900],
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Deliverable Workshop",
                    style: new TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18,6,18,0),
              child: Card(
                color: Colors.grey[600],
                child: ListTile(
                  dense: true,
                  onTap: startUpWindow,
                  leading: Icon(
                    Icons.mail, color: Colors.blue,
                  ),
                  title: Text(
                    'View Startup Report', style: TextStyle(color: Colors.white,),
                  ),
                  subtitle: Text(
                    'View the report of a choosen startup', style: TextStyle(color: Colors.white,),
                  ),
                  trailing: Icon(
                    Icons.forward, color: Colors.blue,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //startUpWindow function is used to call the ChooseFounder class
  //in order to create the card list of the available founders. It uses
  //a simple dialog widget to create the pop up the user sees on screen.
  void startUpWindow() {
    SimpleDialog box = SimpleDialog(
      children: <Widget>[
        Container(
          alignment: Alignment.topRight,
          child: FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "X",
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Text(
            "Choose StartUp",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20,
            ),
          ),
        ),
        ChooseFounder(),
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return box;
        });
  }
}