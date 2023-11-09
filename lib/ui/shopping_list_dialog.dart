import 'package:flutter/material.dart';
import 'package:app_sem12_shoppinglist/util/dbhelper.dart';
import 'package:app_sem12_shoppinglist/models/shopping_list.dart';

class ShoppingListDialog{
  //creo los controles para el campo name y prioridad
  final txtName = TextEditingController();
  final txtPrority = TextEditingController();

  //creo el metodo buildDialog
  //q recibirá 3 parametros
  //1. el contexto
  //2. la clase
  //3. un booleano q hará de "bandera / flag" para determinar si:
  // es "nuevo" --> true
  // es "edición" --> false
  Widget buildDialog(BuildContext context, ShoppingList list, bool isNew){
    DbHelper helper = DbHelper();
    if (!isNew){ //q significaría esto? --> q es una edición, entonces cargo los datos
      txtName.text = list.name;
      txtPrority.text = list.priority.toString();
    }
    //para corregir ese problema del "NEW"
    else{
      txtName.text = "";
      txtPrority.text = "";
    }

    return AlertDialog(
      title: Text((isNew) ? "New shopping list" : "Edit shopping list"),
      content: SingleChildScrollView( //este widget genera la barra de desplazamiento
        child: Column(
          children: <Widget>[
            TextField(
              controller: txtName,
              decoration: InputDecoration(
                hintText: "Shopping list name"
              ),
            ),
            TextField(
              controller: txtPrority,
              decoration: InputDecoration(
                  hintText: "Shopping list priority (1-3)"
              ),
            ),
            ElevatedButton(
                onPressed: (){
                  //paso lo q se escribio a la tabla
                  list.name = txtName.text;
                  list.priority = int.parse(txtPrority.text);

                  //y ahora grabo en la tabla
                  helper.insertList(list);

                  //cierro la ventana
                  Navigator.pop(context);
                },
                child: Text("Save shopping list"))
          ],
        ),
      ),
    );
  }
}