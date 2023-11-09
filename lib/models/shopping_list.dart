class ShoppingList{
  //pongo los atributos q coinciden con la tabla
  int id;
  String name;
  int priority;

  ShoppingList(this.id, this.name, this.priority);

  //hago un mapeo
  Map<String, dynamic> toMap(){
    return{
      'id': (id==0)? null : id,
      'name': name,
      'priority': priority
    };
  }
}