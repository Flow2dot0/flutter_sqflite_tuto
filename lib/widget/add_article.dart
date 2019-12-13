import 'dart:io';

import 'package:flutter_sqlite_from_tuto/model/database_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sqlite_from_tuto/model/article.dart';
import 'package:image_picker/image_picker.dart';

class AddArticle extends StatefulWidget{

  // required id from item
  // required id from article on update "optional"
  int id;
  int idArticle;

  AddArticle(this.id, {this.idArticle});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddArticleState();
  }
}

class _AddArticleState extends State<AddArticle> {

  String image, name, shop, price;
  Article article;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getArticle();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Add"),
        actions: <Widget>[
          FlatButton(
              onPressed: add,
              child: Text("O.K", style: TextStyle(
                color: Colors.white
              ),)
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Text("Article to add", textScaleFactor: 1.4, style: TextStyle(
              color: Colors.red,
              fontStyle: FontStyle.italic,
            ),),
            Padding(padding: EdgeInsets.all(10.0)),
            Card(
              elevation: 8.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // check data
                  (image == null)
                  ?
                      Image.asset('assets/img/no_image.png', height: 200.00,)
                      :
                      Image.file(File(image), height: 200.00,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.camera_enhance),
                          onPressed: () => getImage(ImageSource.camera)
                      ),
                      IconButton(
                          icon: Icon(Icons.photo_library),
                          onPressed: () => getImage(ImageSource.gallery)
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(50.0),
                    child: Column(
                      children: <Widget>[
                        myTextField(TypeTextField.name, "Name of article", name),
                        myTextField(TypeTextField.price, "Price", price),
                        myTextField(TypeTextField.shop, "Shop", shop)
                      ],
                    ),
                  )
                ]
              ),
            )
          ],
        ),
      ),
    );
  }

  // switch textfield setter
  TextField myTextField(TypeTextField type, String label, String value){
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        hintText: value,
      ),
      onChanged: (String str) {
        // set the right string
        switch (type) {
          case TypeTextField.name:
            this.name = str;
            break;
          case TypeTextField.price:
            this.price = str;
            break;
          case TypeTextField.shop:
            this.shop = str;
            break;
        }
      },
    );

  }

  void add() {
    // check if name text field filled
    if(name!=null){
      Map<String, dynamic> map = {
        'name': this.name,
        // put the id we get going on this route
        'item': widget.id,
      };

      // check if shop text field filled
      if(shop!=null)
        map['shop'] = this.shop;

      // check if price text field filled
      if(price!=null)
        map['price'] = this.price;

      // check if image filled
      if(image!=null)
        map['image'] = this.image;

      if(widget.idArticle!=null)
        map['id'] = widget.idArticle;

      // prepare
      Article article = Article();
      // convert into object
      article.fromMap(map);
      // call db
      DatabaseClient().upsertArticle(article).then((art) {
        // clean attributes
        this.image = null;
        this.name = null;
        this.price = null;
        this.shop = null;
        // back to previous context
        Navigator.pop(context);
      });
    }

  }

  Future<void> getArticle() async{
   article = await DatabaseClient().getArticle(widget.id, widget.idArticle);
   if(article!=null){
     setState(() {
       this.image = (article.image!=null? article.image : null);
       this.name = (article.name!=null? article.name : null);
       this.price = (article.price!=null? article.price : null);
       this.shop = (article.shop!=null? article.shop : null);
     });
   }
  }

  Future getImage(ImageSource source)async{
    var newImage = await ImagePicker.pickImage(source: source);
    if(newImage!=null){
      setState(() {
        image = newImage.path;
      });
    }
  }

}

// required for the switch textfield
enum TypeTextField{
  name,
  price,
  shop
}