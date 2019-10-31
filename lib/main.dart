import 'package:flutter/material.dart';

import 'CheckboxList.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test of CheckboxList',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home> {
  final _formKey = GlobalKey<FormState>();  //for identifying form and having validation
  List<CheckBoxField> _checkboxFields;
  bool errorMessage;

  @override
  void initState(){
    super.initState();

    _setInitialValues();
  }

  //The checkbox list with two buttons
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test of CheckboxList'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidate: false,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                CheckboxList(
                  fields: _checkboxFields,
                  columns: 3,
                  onChanged: _toggleCheckbox,
                  validator: (value) => _validateCheckboxes(),
                  errorStyle: TextStyle(color: Colors.red),
                ),
                RaisedButton(
                  onPressed: _onClickButton,
                  child: Text('Save selection'),
                ),
                RaisedButton(
                  onPressed: _setInitialValues,
                  child: Text('Clean form'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Build the data to feed the checkbox list
  _setInitialValues([bool isInitState = false]){
    _checkboxFields = [
      CheckBoxField(id: 1, text: 'Checkbox 1', checked: false),
      CheckBoxField(id: 2, text: 'Checkbox 2', checked: false),
      CheckBoxField(id: 3, text: 'Checkbox 3', checked: false),
      CheckBoxField(id: 4, text: 'Checkbox 4', checked: false),
      CheckBoxField(id: 5, text: 'Checkbox 5', checked: false),
      CheckBoxField(id: 6, text: 'Checkbox 6', checked: false),
      CheckBoxField(id: 7, text: 'Checkbox 7', checked: false),
    ];

    if(!isInitState){
      //update state only if the method is not invoked from initState
      setState(() {});
    }
  }

  //A validation method; in this example is required to select at least one checkbox
  String _validateCheckboxes(){
    for(final c in _checkboxFields){
      if(c.checked){
        return null;
      }
    }

    return 'Choose at least one option';
  }

  //Process selections; using _formKey is possible to run the validator function, that is, _validateCheckboxes
  _onClickButton(){
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      String result = "Selected options: ";
      int selected = 0;

      _checkboxFields.forEach((c) {
        if(c.checked){
          result = '$result ${c.text}, ';
          selected++;
        }
      });

      if(selected == 0){
        result = '$result None!!';
      }

      _showDialog(result);

    }
  }

  //Function to invert value when a selection is changed
  _toggleCheckbox(int id){
    for(int i = 0; i < _checkboxFields.length; i++){
      if(_checkboxFields[i].id == id){
        CheckBoxField checkBoxField = CheckBoxField(
            id: _checkboxFields[i].id,
            text: _checkboxFields[i].text,
            checked: !_checkboxFields[i].checked
        );

        setState(() {
          _checkboxFields[i] = checkBoxField;
        });

        break;
      }
    }

  }

  //A dialog only to display results
  void _showDialog(String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(text),
          actions: <Widget>[
            FlatButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
