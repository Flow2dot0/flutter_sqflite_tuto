import 'package:flutter/material.dart';
import 'package:flutter_sqlite_from_tuto/model/article.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'item.dart';

// access to directory
import 'package:path/path.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseClient{

  Database _database;

  Future<Database> get database async{
    if(_database!=null){
      return _database;
    }else{
      // create db
      _database = await createDb();
      return _database;
    }
  }

  Future createDb() async {
    // get the dir
    Directory directory = await getApplicationDocumentsDirectory();
    String databaseDirectory = join(directory.path, 'database.db');
    // open
    var bdd = await openDatabase(databaseDirectory, version: 1, onCreate: _onCreate);
    return bdd;

  }

  // create table
  Future _onCreate(Database db, int version) async{
    await db.execute('''
        CREATE TABLE item(
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL)
    ''');
    await db.execute('''
        CREATE TABLE article(
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        item INTEGER,
        price TEXT,
        shop TEXT,
        image TEXT)
    ''');
  }

  //// CRUD : C/U/D

  // add item
  Future<Item> addItem(Item item) async{
    // call db
    Database myDb = await database;
    // add
    item.id = await myDb.insert("item", item.toMap());
    return item;
  }

  // update item from item object
  Future<int> updateItem(Item item)async{
    // call db
    Database myDb = await database;
    // update
    return myDb.update("item", item.toMap(), where:  "id=?", whereArgs: [item.id]);
  }

  // add or update item
  Future<Item> upsertItem(Item item)async{
    // call db
    Database myDb = await database;
    // if case new item
    if(item.id==null){
      item.id = await myDb.insert("item", item.toMap());
    }
    // if case update item
    else{
      await myDb.update("item", item.toMap(), where:  "id=?", whereArgs: [item.id]);
    }
    return item;
  }

  // add or update article
  Future<Article> upsertArticle(Article article) async{
    // call db
    Database myDb = await database;
    // check id
    (article.id==null) ?
      article.id = await myDb.insert('article', article.toMap())
        :
        await myDb.update('article', article.toMap(), where: 'id=?', whereArgs: [article.id]);
    return article;
  }

  // delete item from id and table
  Future<int> deleteItem(int id, String table) async {
    // call db
    Database myDb = await database;
    // delete both article and item when erasing an item
    await myDb.delete("article", where: "item=?", whereArgs: [id]);
    return await myDb.delete(table, where: "id=?", whereArgs: [id]);
  }

  // delete article from id
  Future<int> deleteArticle(int id)async{
    // call db
    Database myDb = await database;
    // delete
    return await myDb.delete("article", where: "id=?", whereArgs: [id]);
  }

  ////// CRUD : R

  // get all items
  Future<List<Item>> getItems() async{
    // call db
    Database myDb = await database;
    // query and exec
    List<Map<String, dynamic>> results = await myDb.rawQuery(
      'SELECT * FROM item'
    );
    // preparing the return
    List<Item> items = [];
    // loop on data results
    results.forEach((map) {
      // new item
      Item item = Item();
      // convert to object
      item.fromMap(map);
      // add to the list returning
      items.add(item);
    });
    return items;
  }

  // get all articles
  Future<List<Article>> getArticles(int item,)async{
    // call db
    Database myDb = await database;
    // query get only article from id item
    List<Map<String, dynamic>> results = await myDb.query('article', where: "item=?", whereArgs: [item]);
    // create empty list of articles
    List<Article> articles = [];
    // loop on data results
    results.forEach((map) {
      // new article
      Article article = Article();
      // convert to object
      article.fromMap(map);
      // add to the list returning
      articles.add(article);
    });
    return articles;

  }

}