import 'package:flutter/material.dart';
import 'package:note_app/Screens/note_detail.dart';


class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
      ),
      body: getNotesListView(),
      floatingActionButton: FloatingActionButton(onPressed:() {
        debugPrint("Add Tapped");
        navigateToDetails("Add Note");
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
              backgroundColor: Colors.yellow,
              child: Icon(Icons.keyboard_arrow_right),
            ),
            title: Text(
              "Dumy Title",
              style: titlestyle,
            ),
            subtitle: Text("dummy date"),
            trailing:  Icon(Icons.delete,color: Colors.grey,),
            onTap: ()
            {
              debugPrint("List Tapped");
              navigateToDetails("Edit Note");
            },
          ),
        );
      },
    );
  }
  
  void navigateToDetails(String title)
  {
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return NoteDetails(title);
    }));
  }
}
