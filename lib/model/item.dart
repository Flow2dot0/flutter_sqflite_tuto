
class Item {

  int _id;
  String _name;

  int get id => _id;
  String get name => _name;

  set id(int val) => _id = val;
  set name(String val) => _name = val;

  Item();

  // set the object from db data
  void fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
  }

  // prepare the object before upsert into db and returning the object in format map
  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "name": this.name,
    };

    if(this.id!=null){
      map['id'] = this.id;
    }
    return map;
  }

}