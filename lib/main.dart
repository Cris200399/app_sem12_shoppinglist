import 'package:flutter/material.dart';
import 'package:app_sem12_shoppinglist/util/dbhelper.dart';
import 'package:app_sem12_shoppinglist/models/shopping_list.dart';
import 'package:app_sem12_shoppinglist/models/list_items.dart';
import 'package:app_sem12_shoppinglist/ui/shopping_list_dialog.dart';
import 'package:app_sem12_shoppinglist/ui/items_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //DbHelper helper = DbHelper();
    //helper.testDB();
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: ShowList()
    );
  }
}

class ShowList extends StatefulWidget {
  @override
  State<ShowList> createState() => _ShowListState();
}

class _ShowListState extends State<ShowList> {
  DbHelper helper = DbHelper();
  List<ShoppingList> shoppingList=[];

  ShoppingListDialog? dialog;
  @override
  void initState(){
    dialog = ShoppingListDialog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    showData();
    return Scaffold(
      appBar: AppBar(
        title: Text("Shopping List")
      ),
      body: ListView.builder(
          itemCount: (shoppingList != null)? shoppingList.length : 0,
          itemBuilder: (BuildContext context, int index){
            //aqui creo el ListTile
            return Dismissible(
              key: Key(shoppingList[index].name),
              onDismissed: (direction){
                String strName = shoppingList[index].name;
                helper.deleteList(shoppingList[index]);
                setState(() {
                  shoppingList.removeAt(index);
                });
                //Scaffold.of(context).showSnackBar(SnackBar(content: Text("$strName deleted")));
                Fluttertoast.showToast(
                    msg: "$strName deleted",
                    toastLength: Toast.LENGTH_SHORT,
                );
              },
              child: ListTile(
                title: Text(shoppingList[index].name),
                leading: CircleAvatar(
                  child: Text(shoppingList[index].priority.toString()),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: (){
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                    dialog!.buildDialog(context, shoppingList[index], false));
                  },
                ),
                onTap: (){ //Enviamos a otro route, donde este el detalle de c/rubro
                  Navigator.push(
                      context,
                  MaterialPageRoute(builder: (context) => ItemsScreen(shoppingList[index]))
                  );
                },
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add_circle
        ),
        backgroundColor: Colors.cyanAccent,
        onPressed: (){
          //aqui llamamos otra vez a buildDialog, pero ahora le pasamos como parametro "TRUE"
          showDialog(
              context: context,
              builder: (BuildContext context) =>
                  dialog!.buildDialog(context, ShoppingList(0, '', 0), true));
        },
      ),
    );
  }

  Future showData() async {
    await helper.openDb(); //Abro la BD

    //llamo a getLists y el resultado se graba en shoppingList
    shoppingList = await helper.getLists();

    //actualizo la lista con setState
    setState(() {
      shoppingList = shoppingList;
    });

  }
}