import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './questionaire.dart';

class CompanyDropdown extends StatefulWidget {
  @override
  _CompanyDropdownState createState() => _CompanyDropdownState();
}

class _CompanyDropdownState extends State<CompanyDropdown> {
  List listOfCompanies = [];

//Where we are pulling the values from the database
//Have to pull a future instance, and then later take a snapshot of it

  Future<List<String>> pullValues() async {
    List<String> listCompanies = [];
    const url2 = 'https://projectworkflow.firebaseio.com/Founder.json';
    final response2 = await http.get(url2);
    Map<String, dynamic> fetchedCompaniesList = json.decode(response2.body);
    dynamic valuesFromMap2 = fetchedCompaniesList.values.toList();
    valuesFromMap2.forEach((k) {

//Where the info is coming from, it's titled "foundry" within the database
      listCompanies.add('${k['foundry']}');
    });
    return listCompanies;
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
            width: MediaQuery.of(context).size.width * 0.3,
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  hint: Text("Which company are your evaluating?"),
                  value: companyDropDown,
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
                    setState(() {
                      companyDropDown = newValue;
                    });
                  },
                  //Where the values come from, key element here. Ususally is a list of strings,
                  //instead we replaced it with snapshot data map. turned out hella sick
                  items: snapshot.data.map<DropdownMenuItem<String>>((
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
