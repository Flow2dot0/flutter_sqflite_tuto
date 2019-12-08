import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_sqlite_from_tuto/model/item.dart';
import 'package:flutter_sqlite_from_tuto/model/database_client.dart';
import 'package:flutter_sqlite_from_tuto/widget/empty_data.dart';
import 'package:flutter_sqlite_from_tuto/widget/item_detail.dart';

class HomeController extends StatefulWidget {
  HomeController({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeControllerState createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {

  String newList;
  List<Item> items;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                add(null);
              },
              child: Text("Add", style: TextStyle(
                color: Colors.white,
              ),)
          )
        ],
      ),
      // check data
      body: (items==null || items.length==0?
        EmptyData()
        :
        ListView.builder(
          itemCount: items.length,
            itemBuilder: (context, i) {
            // shortcut
              Item item = items[i];
              return ListTile(
                title: Text(item.name),
                trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // delete item
                      DatabaseClient().deleteItem(item.id, "item").then((int) {
                        // callback getList again after deleting
                        getList();
                      });
                    }
                ),
                leading: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: (){
                      add(item);
                    }
                ),
                onTap: () {
                  // push new route with item as parameter
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext buildContext) {
                    return ItemDetail(item: item,);
                  }));
                },
              );
            }
        )
      )
    );
  }

  Future<void> add(Item item) async{
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctt) {
          return AlertDialog(
            title: Text("${(item==null? "Add" : "Edit")} a wish list"),
            content: TextField(
              decoration: InputDecoration(
                labelText: "Title",
                hintText: (item==null? " ex: future Netflix playlist" : item.name),
              ),
              onChanged: (String str) {
                // do smthing
                newList = str;
              },
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.pop(ctt),
                  child: Text("Cancel")
              ),
              FlatButton(
                  onPressed: () {
                    //// add code to link db
                    if(newList!=null){
                      if(item==null){
                        // create new item
                        item = Item();
                        // create a map with str value
                        Map<String, dynamic> map = {
                          'name': newList
                        };
                        // parse the map into an item filled
                        item.fromMap(map);
                      }
                      else{
                        item.name = newList;
                      }
                      // add into db and return new list from db
                      DatabaseClient().upsertItem(item).then((i) => getList());
                      // reset the str
                      newList = null;
                    }
                    // push context
                    Navigator.pop(ctt);
                  },
                  child: Text("O.K", style: TextStyle(
                      color: Colors.blue
                  ),
                  )
              )
            ],
          );
        }
    );
  }

  void getList() {
    DatabaseClient().getItems().then((items) {
      setState(() {
        this.items = items;
      });
    });
  }
}
