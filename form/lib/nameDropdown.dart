import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './questionaire.dart';

class NameDropdown extends StatefulWidget {
  @override
  _NameDropdownState createState() => _NameDropdownState();
}

class _NameDropdownState extends State<NameDropdown> {
  
  List listOfNames = [];

//Where we are pulling the values from the database
//Have to pull a future instance, and then later take a snapshot of it

  Future<List<String>> pullValues() async {
    List<String> listNames = [];
    const url2 = 'https://projectworkflow.firebaseio.com/Evaluators.json';
    final response2 = await http.get(url2);
    Map<String, dynamic> fetchedEvaluatorsList2 = json.decode(response2.body);
    dynamic valuesFromMap2 = fetchedEvaluatorsList2.values.toList();
    valuesFromMap2.forEach((k) {
      //Where the info is coming from, grabbing firstname and lastname within the database
      listNames.add('${k['firstName']} ${k['lastName']}');
    });    
    return listNames;
  }


  @override
  Widget build(BuildContext context) {
     //Had to call the whole thing as a future builder, in order to pull data from the databse.
    return FutureBuilder(
      future: pullValues(),
      builder: (context, snapshot) {
         //Snapshot is what the future builder, and the current values stored is seeing. It takes a single
        //instance of what it sees and displays.
        if (snapshot.hasData) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.2,
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  hint: Text("Who are you?"),
                  value: nameDropDown,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                  underline: Container(
                    height: 2,
                    color: Colors.blueGrey,
                  ),
                  onChanged: (String newValue) {
                    pullValues();
                    setState(() {
                      nameDropDown = newValue;
                      print("DropDown Value is now..: $nameDropDown");
                    });
                  },
                  items:
                   //Where the values come from, key element here. Ususally is a list of strings,
                  //instead we replaced it with snapshot data map. turned out hella sick
                      snapshot.data.map<DropdownMenuItem<String>>((
                    String value,
                  ) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          //The error that seems to be reoccuring
          print("Error : ${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }
}
