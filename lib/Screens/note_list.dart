import 'package:flutter/material.dart';
import 'package:note_app/Screens/note_detail.dart';

import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/utils/database_helper.dart';


class NoteList extends StatefulWidget {




  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  int count = 0;
  DatabaseHelper databaseHelper = DatabaseHelper();
  List <Note> noteList;


  @override
  Widget build(BuildContext context) {
    if(noteList==null)
      {
        noteList=List <Note>() ;
        updateListView();
      }

    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
      ),
      body: getNotesListView(),
      floatingActionButton: FloatingActionButton(onPressed:() {
        debugPrint("Add Tapped");
        navigateToDetails(Note('','',2),"Add Note");
      },
        tooltip: 'Add Note',
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getNotesListView() {
    TextStyle titlestyle = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getprioritycolor(this.noteList[position].priority),
              child: GestureDetector(child: getpriorityicons(this.noteList[position].priority) ,
                onTap: (){
                _delete(context, noteList[position]);
                },
              ) ,

            ),
            title: Text(
              this.noteList[position].title,
              style: titlestyle,
            ),
            subtitle: Text(this.noteList[position].date),
            trailing:  Icon(Icons.delete,color: Colors.grey,),
            onTap: ()
            {
              debugPrint("List Tapped");
              navigateToDetails(noteList[position],"Edit Note");
            },
          ),
        );
      },
    );
  }


  Icon getpriorityicons(int priority)
  {
    switch(priority)
    {
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;
      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  Color getprioritycolor(int priority)
  {
    switch(priority)
    {
      case 1:
        return Colors.red;
        break;
      case 2 :
        return Colors.yellow;
        break;
      default:
        return Colors.yellow;

    }
  }

  void _delete(BuildContext context,Note note) async
  {
    int result = await databaseHelper.deleteNote(note.id);
    if(result!=0)
      {
        _showsnackbar(context,"Note Deleted Successfully");
        updateListView();
      }
  }

  void _showsnackbar(BuildContext context , String txt)
  {
    final snackBar = SnackBar(content:Text(txt));
    Scaffold.of(context).showSnackBar(snackBar);


  }
  void navigateToDetails(Note note , String title) async
  {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context){
      return NoteDetails(note , title);
    }));

    if(result == true)
      {
        updateListView();
      }
  }

  void updateListView()
  {
    final Future<Database> dbfuture = databaseHelper.initializeDatabase();
    dbfuture.then((database)
    {
      Future<List<Note>> notelistfuture = databaseHelper.getnotelist();
      notelistfuture.then((noteList)
          {
            setState(() {
              this.noteList = noteList;
              this.count = noteList.length;
            });
          }
      );
    });
  }
}
