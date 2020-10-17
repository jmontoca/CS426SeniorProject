import 'package:flutter/material.dart';

class TextClass extends StatelessWidget {
  final String outputText;

//used in the questionaire dart file
//To display the text for each title
//repeated code is bad code
//Essentially used to template a prefered text style 
  TextClass(this.outputText);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //Where the text is received, and then templated for uniformity
          Text(
            outputText,
            style: TextStyle(
              decoration: TextDecoration.underline,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

