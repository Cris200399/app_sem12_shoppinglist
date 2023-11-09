import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:app_sem12_shoppinglist/models/shopping_list.dart';
import 'package:app_sem12_shoppinglist/models/list_items.dart';

class DbHelper {
  final int version = 1;
  Database? db;

  //codigo para q solo se abra una instancia de la BD.
  static final DbHelper dbHelper = DbHelper.internal();
  DbHelper.internal();
  factory DbHelper(){
    return dbHelper;
  }

  Future<Database> openDb() async {
    db ??= await openDatabase(join(await getDatabasesPath(), 'shoppingvfin.db' ),
        onCreate: (database, version) {

          database.execute(
              'CREATE TABLE lists(id INTEGER PRIMARY KEY, name TEXT, priority INTEGER)');

          database.execute(
              'CREATE TABLE items(id INTEGER PRIMARY KEY, idlist INTEGER, name TEXT, quantity INTEGER, note TEXT, FOREIGN KEY(idlist) REFERENCES lists(id))');
        }, version: version);
    return db!;
  }

  Future testDB() async {
    db = await openDb();
    await db!.execute('INSERT INTO lists VALUES(0, "Frutas", 1)');
    await db!.execute('INSERT INTO items VALUES(0, 0, "Manzana", "20 unds", "De preferencia roja")');

    List lists = await db!.rawQuery('SELECT * FROM lists');
    List items = await db!.rawQuery('SELECT * FROM items');

    print(lists[0]);
    print(items[0]);
  }

  //insert list
  Future<int> insertList(ShoppingList list) async{
    int id = await this.db!.insert(
        'lists',
    list.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace);
    //la linea 40, me permite actualizar!!!

    return id;
  }

  //ahora, hacemos lo mismo, pero para la tabla items
  //insert items
  Future<int> insertItem(ListItem item) async{
    int id = await this.db!.insert(
        'items',
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return id;
  }

  //list tabla lists
  Future<List<ShoppingList>> getLists() async{
    final List<Map<String, dynamic>> maps = await db!.query('lists');

    return List.generate(maps.length, (i) {
      return ShoppingList(
        maps[i]['id'],
        maps[i]['name'],
        maps[i]['priority'],
      );
    });
  }

  //list tabla items
  Future<List<ListItem>> getItems(int idList) async{
    final List<Map<String, dynamic>> maps =
    await db!.query('items', where: 'idList = ?', whereArgs: [idList]); //pongo la condicion con un where

    return List.generate(maps.length, (i) {
      return ListItem(
        maps[i]['id'],
        maps[i]['idList'],
        maps[i]['name'],
        maps[i]['quantity'],
        maps[i]['note'],
      );
    });
  }

  //borrar tabla lists
  Future<int> deleteList(ShoppingList list) async{
    int result = await db!.delete('items', where: 'idList = ?', whereArgs: [list.id]);
    result = await db!.delete('lists', where: 'id = ?', whereArgs: [list.id]);

    return result;
  }

}