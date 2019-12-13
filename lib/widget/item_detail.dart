import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sqlite_from_tuto/model/database_client.dart';
import 'package:flutter_sqlite_from_tuto/model/item.dart';
import 'package:flutter_sqlite_from_tuto/model/article.dart';
import 'package:flutter_sqlite_from_tuto/widget/add_article.dart';
import 'package:flutter_sqlite_from_tuto/widget/empty_data.dart';

class ItemDetail extends StatefulWidget {
  // receipt an item
  Item item;

  ItemDetail({Key key, this.item}) : super(key: key);

  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {

  List<Article> articles;

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
        title: Text(widget.item.name.toUpperCase()),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                // add article, pushing new route Add Article
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext buildContext) {
                  return AddArticle(widget.item.id);
                })).then((onValue) {
                  // when back from AddArticle get the list again from db
                  getList();
                });
              },
              child: Text("Add", style: TextStyle(
                  color: Colors.white
              ),)
          )
        ],
      ),
      // check data
      body: (articles==null || articles.length == 0)
          ?
      EmptyData()
          :
      GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
          itemCount: articles.length,
          itemBuilder: (context, i) {
            Article article = articles[i];
            return InkWell(
              onLongPress: () {
                print('coucou');
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext builContext) {
                  return AddArticle(widget.item.id, idArticle: article.id,);
                })).then((a) {
                  getList();
                });
              },
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(article.name.toUpperCase(),textScaleFactor: 2, style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),),
                    Container(
                      child: (article.image==null) ? Image.asset("assets/img/no_image.png", height: 200,) : Image.file(File(article.image), height: 200,),
                    ),
                    Text((article.price==null ? 'No price given' : 'Price: ${article.price}')),
                    Text((article.shop==null ? 'No shop given' : 'Shop: ${article.shop}')),
                    IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          DatabaseClient().deleteArticle(article.id).then((int){
                            // refresh the list
                            getList();
                          });
                        }
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  // get the list of articles from db
  void getList(){
    DatabaseClient().getArticles(widget.item.id).then((list) {
      setState(() {
        articles = list;
      });
    });
  }
}