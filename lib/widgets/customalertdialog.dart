import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InputAlertDialog extends StatefulWidget {
  final Widget title;
  final Widget confirmWidget;
  final Widget cancelWidget;

  InputAlertDialog({
    this.title,
    Widget confirmWidget,
    Widget cancelWidget
  }) : confirmWidget = confirmWidget ?? new Text(
        'OK', style: TextStyle(fontSize: 16, fontFamily: "Roboto", color: Colors.deepPurple)),
       cancelWidget = cancelWidget ?? new Text(
         'CANCEL', style: TextStyle(fontSize: 16, fontFamily: "Roboto", color: Colors.deepPurple));

  @override
  State<StatefulWidget> createState() => new _InputAlertDialogState();
}

class _InputAlertDialogState extends State<InputAlertDialog> {
  // Create a text controller and use it to retrieve the current value of the TextField
  final inputController = TextEditingController();
  // Form key to keep track of the state
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    inputController.dispose();
    super.dispose();
  }

  // Error message on invalid user input
  String _errorString;

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: widget.title,
      content: TextFormField(
        controller: inputController, textInputAction: TextInputAction.go,
        keyboardType: TextInputType.text, textAlign: TextAlign.center,
        cursorColor: Colors.deepPurpleAccent, key: _formKey,
        // When user input is changed, we need to make sure it's valid
        onChanged: (inputController) { validateName(inputController); },
        decoration: InputDecoration(
          hintText: "Timer Name", errorText: _errorString,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurple))
        ), validator: lastValidate
      ),

      actions: [
        // If the user clicks cancel, go back to the main page
        TextButton(onPressed: () => Navigator.of(context).pop(),
          child: widget.cancelWidget),
        // If the user clicks ok, the new values need to be updated
        TextButton(onPressed: () async {lastValidate(inputController.text);},
          child: widget.confirmWidget)
      ],
    );
  }

  void validateName(String inputController) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (inputController.isEmpty) {
      setState(() {_errorString = "Please enter some text";});
    } else if (prefs.containsKey(inputController)) {
      setState(() {_errorString = "This timer name is already in use";});
    }
    else setState(() {_errorString = null;});
  }

  String lastValidate(String value) {
    if (_errorString == null || _errorString.isEmpty) {Navigator.of(context).pop(value);}
    return null;
  }
}
