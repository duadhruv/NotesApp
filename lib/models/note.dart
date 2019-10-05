class Note
{
int _id,_priority;
String _title,_description,_date;

Note(this._id, this._priority, this._title, this._date,[this._description]);
Note.withid(this._priority, this._title, this._date,[this._description]);

get date => _date;

set date(value) {
  _date = value;
}

get description => _description;

set description(value) {
  _description = value;
}

String get title => _title;

set title(String value) {
  _title = value;
}

get priority => _priority;

set priority(value) {
  _priority = value;
}

int get id => _id;

set id(int value) {
  _id = value;
}

Map<String,dynamic> toMap()
{
  var map=Map<String,dynamic >();
  if(_id !=null)
    {
      map['id']=_id;
    }
  map['title']=_title;
  map['description']=_description;
  map['priority']=_priority;
  map['date']=_date;
  return map;


}

Note.fromMapObject(Map<String , dynamic>map)
{
  this._id=map['id'];
  this._date=map['date'];
  this._priority=map['priority'];
  this._description=map['description'];
  this._title=map['title'];
}

}