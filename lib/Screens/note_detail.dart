import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/utils/database_helper.dart';

class NoteDetails extends StatefulWidget {
  String title;
  Note note;

  NoteDetails(this.note, this.title);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailsState(note, title);
  }
}

class NoteDetailsState extends State<NoteDetails> {
  String title;
  Note note;

  NoteDetailsState(this.note, this.title);

  static var priorities = ['High', 'Low'];
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();

  DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    titlecontroller.text = note.title;
    descriptioncontroller.text = note.description;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15, left: 10, right: 10),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: DropdownButton(
                  items: priorities.map((String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(dropDownStringItem),
                    );
                  }).toList(),
                  style: textStyle,
                  value: prioritytostring(note.priority),
                  onChanged: (valueselectedbyuseer) {
                    setState(() {
                      debugPrint("User selected $valueselectedbyuseer");
                      prioritytoint(valueselectedbyuseer);
                    });
                  }),
            ),

            // Second element
            Padding(
              padding: EdgeInsets.only(top: 15, bottom: 15),
              child: TextField(
                controller: descriptioncontroller,
                style: textStyle,
                onChanged: (value) {
                  debugPrint("User entered $value");
                  updatetitle();
                },
                decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5))),
              ),
            ),

            //Third element
            Padding(
              padding: EdgeInsets.only(top: 15, bottom: 15),
              child: TextField(
                controller: titlecontroller,
                style: textStyle,
                onChanged: (value) {
                  debugPrint("User entered $value");
                  updatedescription();
                },
                decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5))),
              ),
            ),
            // fourth element
            Padding(
              padding: EdgeInsets.only(top: 15, bottom: 15),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      elevation: 5,
                      child: Text(
                        "Save",
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        setState(() {
                          debugPrint("save pressed");
                          updatetitle();
                          updatedescription();
                          _save();
                        });
                      },
                    ),
                  ),
                  Container(
                    width: 5,
                  ),
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      elevation: 5,
                      child: Text(
                        "Delete",
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        setState(() {
                          debugPrint("delete pressed");
                          _delete();
                        });
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void prioritytoint(String p) {
    switch (p) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

  String prioritytostring(int val) {
    if (val == 1) {
      return priorities[0];
    } else {
      return priorities[1];
    }
  }

  void updatetitle() {
    note.title = titlecontroller.text;
  }

  void updatedescription() {
    note.description = descriptioncontroller.text;
  }

  void _save() async {
    int result;
    moveToLastScreen();
    note.date = DateFormat.yMMMd().format(DateTime.now());
    if (note.id != null) {
      result = await _databaseHelper.updateNote(note);
    } else {
      result = await _databaseHelper.insertNote(note);
    }

    if (result != 0) {
      _showAlertDialog('Status', 'Note Saved Successfully');
    } else {
      _showAlertDialog('Status', 'Problem Saving Note');
    }
  }

  void _delete() async {
    int result;
    moveToLastScreen();
    if (note.id != null) {
      result = await _databaseHelper.deleteNote(note.id);
    } else {
      _showAlertDialog('Status', 'No Note was deleted');
    }


    if (result != 0) {
      _showAlertDialog('Status', 'Note Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Problem Deleting Note');
    }
  }


  void _showAlertDialog(String title, String msg) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(msg),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
