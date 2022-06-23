import 'package:AquaFocus/model/todo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class DatabaseService {
  CollectionReference todosCollection =
      FirebaseFirestore.instance.collection('ToDos');

  Future createNewToDo(String title) async {
    return await todosCollection.add({
        'title': title,
        'isComplete': false,
      });
  }

  Future completeTask(uid) async{
    await todosCollection.doc(uid).update({
        'isComplete': true
      });
  }

  Future removeToDo(uid) async {
    await todosCollection.doc(uid).delete();
  }

  List<CreateToDo> todoFromFirestore(QuerySnapshot snapshot) {
      return snapshot.docs.map((e) {
        return CreateToDo(
          isComplete: (e.data() as dynamic)['isComplete'],
          title: (e.data() as dynamic)['title'],
          uid: e.id,
        );
      }).toList();
  }

  Stream<List<CreateToDo>> listToDos() {
    return todosCollection.snapshots().map(todoFromFirestore);
  }
}