import 'package:flutter/material.dart';
import 'package:app_sem12_shoppinglist/util/dbhelper.dart';
import 'package:app_sem12_shoppinglist/models/shopping_list.dart';
import 'package:app_sem12_shoppinglist/models/list_items.dart';

class ItemsScreen extends StatefulWidget {
  final ShoppingList shoppingList;
  ItemsScreen(this.shoppingList);

  @override
  State<ItemsScreen> createState() => _ItemsScreenState(this.shoppingList);
}

class _ItemsScreenState extends State<ItemsScreen> {
  final ShoppingList shoppingList;
  _ItemsScreenState(this.shoppingList);

  DbHelper? helper;
  List<ListItem> items=[];


  @override
  Widget build(BuildContext context) {
    helper = DbHelper();
    showData(this.shoppingList.id); //con esto vinculo la tabla de rubros a los detalles

    return Scaffold(
      appBar: AppBar(
        title: Text(shoppingList.name),
      ),
      body: ListView.builder(
          itemCount: (items != null)? items.length : 0,
          itemBuilder: (BuildContext context, int index){
            //aqui creo el ListTile
            return ListTile(
              title: Text(items[index].name),
              subtitle: Text(
                'Quantity: ${items[index].quantity} - Note: ${items[index].note}'
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: (){
                },
              ),
            );
          }),
    );
  }

  Future showData(int idList) async{
    await helper!.openDb();
    items = await helper!.getItems(idList);
    setState(() {
      items = items;
    });
  }
}
