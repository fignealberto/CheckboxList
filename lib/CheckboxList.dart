import 'package:flutter/material.dart';
import 'package:meta/meta.dart';


class CheckboxList extends FormField<List<int>>{
  //Data for every checkbox
  final List<CheckBoxField> fields;
  //Number of columns for display the list
  final int columns;
  //Color for selected checkbox
  final Color activeColor;
  //Error message style
  final TextStyle errorStyle;

  CheckboxList({
    this.fields,
    this.columns = 1,
    //list of index (same type as FormField) to define element to be selected at first
    List<int> initialValues,
    //function to process selection
    FormFieldSetter<List<int>> onSaved,
    //function to perform a validation before onSaved
    FormFieldValidator<List<int>> validator,
    //flag to define if automatically invoke validator function when selection change
    bool autoValidate = false,
    //To process selection changes apart from validations and savings
    @required Function onChanged,
    this.activeColor,
    this.errorStyle
  }) : super(
      onSaved: onSaved,
      validator: validator,
      initialValue: initialValues,
      autovalidate: autoValidate,
      builder: (FormFieldState<List<int>> state) {
        return
          _getCheckboxList(
            fields,
            columns,
            initialValues,
            onChanged,
            activeColor,
            errorStyle,
            state.hasError,
            state.errorText,
          );
      }
  );

  /*
    Build final set as a Column
    - If columns = 1 every element is put in order vertically inside a Column;
      at the end the error message, if there is any
    - If columns > 1 elements are ordered by row
      for example:
        1 2 3
        4 5 6
        7 8
      The element rows will be inside a column; all columns will be inside a Row;
      that Row will be the content of de returned Column
  */
  static Column _getCheckboxList(
      List<CheckBoxField> fields,
      int columns,
      List<int> initialValues,
      Function onChanged,
      Color activeColor,
      TextStyle errorStyle,
      bool hasError,
      String errorText){

    print('$hasError');
    //Each element will be contained in a row, hence we need as many rows as there are fields
    List<Widget> rows = [];

    //fill the content rows
    fields.forEach((f) {
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Checkbox(
              onChanged: (v) => onChanged(f.id),
              value: f.checked, //or look for f.id in initialValues; if found, value: true
              activeColor: activeColor,
            ),
            Text(f.text),
          ],
        ));
    });

    if((columns ?? 0) <= 1){
      //Case columns = 1; use rows list directly

      //  Add error message
      if(hasError && (errorText ?? '') != ''){
        rows.add(Text(errorText, style: errorStyle));
      }

      //return a Column with the list of rows as content
      return Column(children: rows);


    } else {
      //Case columns = 1

      //First create a list with one list of widgets for each expected column
      List<List<Widget>> listOfWidgetsForColumns = [];
      for(int i = 0; i < columns; i++){
        listOfWidgetsForColumns.add(<Widget>[]);
      }

      //Second, each element is placed in a list alternately
      for(int i = 0; i < rows.length; i++){
        listOfWidgetsForColumns[i % columns].add(rows[i]);
      }

      //Third, create final columns with their respective content and group them in a list
      List<Widget> listOfFinalColumns = [];
      listOfWidgetsForColumns.forEach((l) {
        Column column = Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: l,
        );
        listOfFinalColumns.add(column);
      });

      //Forth, place all the content inside a row for alignment purpose
      Row columnsRow = Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: listOfFinalColumns
      );

      //Fifth, return the main column
      if(hasError && (errorText ?? '') != ''){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            columnsRow,
            Text(errorText, style: errorStyle)
          ],
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            columnsRow,
          ],
        );
      }
    }
  }

}

//A compact holder to pass the value of each checkbox in the list
class CheckBoxField{
  final int id;
  final String text;
  bool checked;

  CheckBoxField({this.id, this.text, this.checked = false});
}