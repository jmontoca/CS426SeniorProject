//Created on: 3/18/2020
//class EvalTile:
//      Container, for the evaluator, that has interactable cards
//      different operations. The operations are as follows: add, remove, and edit

import 'package:flutter/material.dart';
import 'evalform.dart';
import 'evalrmv.dart';
import 'evaledit.dart';

class EvalTile extends StatefulWidget {
  @override
  EvalTileState createState() {
    return EvalTileState();
  }
}

class EvalTileState extends State<EvalTile> {
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
            children: <Widget>[ //
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Evaluator Workshop",
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
                  onTap: evalAdd,
                  leading: Icon(
                    Icons.person, color: Colors.green,
                  ),
                  title: Text(
                    'Add Evaluator', style: TextStyle(color: Colors.white,),
                  ),
                  subtitle: Text(
                    'Add a single evaluator', style: TextStyle(color: Colors.white,),
                  ),
                  trailing: Icon(
                    Icons.add_circle_outline, color: Colors.green,
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18,6,18,0),
              child: Card(
                color: Colors.grey[600],
                child: ListTile(
                  dense: true,
                  onTap: evalRemove, //add remove functionality here
                  leading: Icon(
                    Icons.supervisor_account, color: Colors.red,
                  ),
                  title: Text(
                    'Remove Evaluator', style: TextStyle(color: Colors.white,),
                  ),
                  subtitle: Text(
                    'Remove an evaluator', style: TextStyle(color: Colors.white,),
                  ),
                  trailing: Icon(
                    Icons.remove_circle_outline, color: Colors.red,
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18,6,18,0),
              child: Card(
                color: Colors.grey[600],
                child: ListTile(
                  dense: true,
                  onTap: evalEdit, //add edit functionality here
                  leading: Icon(
                    Icons.person, color: Colors.yellow,
                  ),
                  title: Text(
                    'Edit Evaluator', style: TextStyle(color: Colors.white,),
                  ),
                  subtitle: Text(
                    'Change evaluator information', style: TextStyle(color: Colors.white,),
                  ),
                  trailing: Icon(
                    Icons.mode_edit, color: Colors.yellow,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //function: evalAdd
  //          creates a popup dialog box that is used to input the different data fields
  //          of the evaluator. This data is stored in Googel FireBase
  void evalAdd() {
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
            "Add Evaluator",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.green,
              fontSize: 20,
            ),
          ),
        ),
        EvalCustomForm()
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return box;
        });
  }

  //function: evalRemove
  //          brings up a dialog box and lets user choose an evaluator to delete ontap
  void evalRemove() {
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
            "Remove Evaluator",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red,
              fontSize: 20,
            ),
            // style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        EvalRmv(), //add eval widget data in here
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return box;
        });
  }

  //function: evalEdit
  //          lets the user make changes to the selected evaluator
  //          still working on it on the back up file before copying it over here 3/30/20
  void evalEdit() async {
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
            "Edit Evaluator",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.yellow,
              fontSize: 20,
            ),
          ),
        ),
        EvalEdit(),
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return box;
        });
  }
}