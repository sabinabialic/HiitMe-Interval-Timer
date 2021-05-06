import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        onChanged: (inputController) { doSomething(inputController); },
        decoration: InputDecoration(
          hintText: "Timer Name", errorText: _errorString,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurple))
        ), validator: validateName
      ),

      actions: [
        // If the user clicks cancel, go back to the main page
        TextButton(onPressed: () => Navigator.of(context).pop(),
          child: widget.cancelWidget),
        // If the user clicks ok, the new values need to be updated
        TextButton(onPressed: () => validateName(inputController.text),
          child: widget.confirmWidget)
      ],
    );
  }

  String validateName(String value) {
    if (value.isEmpty) {setState(() {_errorString = "Please enter some text";});}
    else {Navigator.of(context).pop(value);}
    return null;
  }

  void doSomething(String inputController) {
    if (inputController.isEmpty) {
      setState(() {_errorString = "Please enter some text";});
    } else setState(() {_errorString = null;});
  }
}
