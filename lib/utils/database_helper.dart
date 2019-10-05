import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:note_app/models/note.dart';
class DatabaseHelper
{
  static DatabaseHelper _databaseHelper;
  static Database _database;
  DatabaseHelper._createInstance();

  String noteTable="note_table";
  String colID="id";
  String colTitle="title";
  String colDescription="description";
  String colPriority="priority";
  String colDate="date";

  factory DatabaseHelper()
  {
    if(_databaseHelper==null)
      {
        _databaseHelper=DatabaseHelper._createInstance();
      }
     return _databaseHelper;
  }


  Future<Database> get database async{
    if(_database == null)
        {
          _database = await initializeDatabase();
        }
        return _database;
  }

  Future<Database>initializeDatabase() async
  {
    Directory directory = await getApplicationDocumentsDirectory();
    String path =directory.path+'notes.db';
    var notesDatabase = await openDatabase(path,version: 1,onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db,int newVersion) async{
    await db.execute('CREATE TABLE $noteTable( $colID INTEGER PRIMARY KEY AUTOINCREMENT , $colTitle TEXT ,$colDescription TEXT,$colPriority INTEGER,$colDate TEXT)');

  }

  Future<List<Map<String,dynamic>>>getNoteMapList() async
  {
    Database db = await this.database;
    var result = db.rawQuery("Select * from $noteTable order by $colPriority asc");
    return result;
  }

  Future<int> insertNote(Note note) async
  {
    Database db = await database;
    var result = await db.insert(noteTable, note.toMap());
    return result;

  }

  Future<int> updateNote(Note note) async
  {
    Database db = await database;
    var result = await db.update(noteTable, note.toMap(),where: "$colID = ?",whereArgs: [note.id]);
    return result;

  }

  Future<int> deleteNote(int id) async
  {
    Database db = await database;
    var result = await db.rawDelete("Delete from $noteTable where $colID = $id");
    return result;
  }


  Future<int> getCount() async
  {
    Database db = await database;
    List<Map<String,dynamic>> x  = await db.rawQuery("Select count (*) from $noteTable");
    int result = Sqflite.firstIntValue(x);
    return result;

  }


  Future<List<Note>> getnotelist () async
  {
    var notemaplist= await _databaseHelper.getNoteMapList();
    int count = notemaplist.length;
    List<Note> notelist = List<Note>();
    for(int i = 0 ;i<count;i++)
      {
        notelist.add(Note.fromMapObject(notemaplist[i]));
      }
      return notelist;
  }


}