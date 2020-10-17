//used to create widget for the optional comment boxs. Works as a modular UI widget.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './customRadioButton.dart';
import './questionaire.dart';

//setup required for a stateful widget
class Response extends StatefulWidget {
  final int index;
  final String outputText;
  Response(this.index, this.outputText, {Key key}) : super(key: key);
  @override
  _ResponseState createState() => _ResponseState(index, outputText);
}

//formatting for intake data and UI setup for the comment forms. This is returned to the page that calls it as a UI element.
class _ResponseState extends State<Response> {
  int index;
  String outputText;

  final newController = TextEditingController();
  _ResponseState(this.index, this.outputText);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CustomRadioButton(index),
        Flexible(
          child: Container(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.10,
            ),
            child: TextField(
               inputFormatters: [BlacklistingTextInputFormatter(new RegExp('\n'))],
              controller: newController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Optional comments',
              ),
              onChanged: (val) {
                setOutput(outputText, val);
              },
              maxLines: null,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
