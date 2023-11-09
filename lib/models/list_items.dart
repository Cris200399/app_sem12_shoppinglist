class ListItem{
  //pongo los atributos q coinciden con la tabla
  int id;
  int idList;
  String name;
  String quantity;
  String note;

  ListItem(this.id, this.idList, this.name, this.quantity,
      this.note);

  //hago un mapeo
  Map<String, dynamic> toMap(){
    return{
      'id': (id==0)? null : id,
      'idList': idList,
      'quantity': quantity,
      'note': note
    };
  }
}