import 'package:AquaFocus/model/app_task.dart';
import 'package:AquaFocus/model/todo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:AquaFocus/model/app_user.dart';
import 'package:AquaFocus/screens/signin_screen.dart';
import 'package:firebase_helpers/firebase_helpers.dart';



class DatabaseService {
  late CollectionReference userCollection;
  late CollectionReference todoCollection;
  late DocumentReference userDoc;
  late CollectionReference focusTimeCollection;
  late CollectionReference habitCollection;

  DatabaseService({FirebaseFirestore? instanceInjection}) {
    FirebaseFirestore instance;
    String uid;

    if (instanceInjection == null) {
      instance = FirebaseFirestore.instance;
      uid = user!.uid;
    } else {
      instance = instanceInjection;
      uid = "0";
    }

    userCollection = instance.collection('users');
    userDoc = instance.collection('users').doc(uid);
    todoCollection = instance.collection('users').doc(uid).collection('Todos');
    focusTimeCollection =
        instance.collection('users').doc(uid).collection('FocusTime');
    habitCollection =
        instance.collection('users').doc(uid).collection('HabitTracker');
  }

  Future<void> addUser(AppUser user, String uid) async {
    await userCollection.doc(uid).set({
      'uid': uid,
      'email': user.email,
      'username': user.userName,
      'marlives': user.marLives,
      'money': user.fishMoney,
    });
  }

  Future<String> getUserName(String userId) async {
    String name = 'null';
    DocumentReference docRef = userCollection.doc(userId);
    await docRef.get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        name = documentSnapshot.get("username");
      }
    });
    return name;
  }

  Future<void> addMoney(int amt) async {
    userDoc.update({"money": FieldValue.increment(amt)});
  }

  Future<bool> hasEnoughMoney(int price) async {
    int userMoney = await getMoney();
    if (userMoney >= price) {
      return true;
    }
    return false;
  }

  Future<int> getMoney() async {
    int result = 0;
    await userDoc.get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        result = documentSnapshot.get("money");
      }
    });
    return result;
  }

  Future<List<int>> getList(String databaseField, String userId) async {
    late List<int> requestList;
    DocumentReference docRef = userCollection.doc(userId);
    await docRef.get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var requestListRaw = [];
        try {
          requestListRaw = documentSnapshot.get(databaseField);
        } catch (StateError) {
          print("rq list does not exist");
        }

        requestList = List<int>.from(requestListRaw);
      }
    });

    return requestList;
  }

  Future<List<int>> getMarLivesList(String userId) {
    return getList("marlives", userId);
  }

  Future<void> addMarLives(String userId, int marId) async {
    var marList = await getMarLivesList(userId);
    var doc = userCollection.doc(userId);
    if (!marList.contains(marId)) marList.add(marId);

    doc.update({"marlives": marList});
  }

  //add when no meaningful id
  Future createNewToDo(String title) async {
    return await todoCollection.add({
      'title': title,
      'isComplete': false,
    });
  }

  Future completeTask(uid) async {
    await todoCollection.doc(uid).update({'isComplete': true});
  }

  Future removeToDo(uid) async {
    await todoCollection.doc(uid).delete();
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
    return todoCollection.snapshots().map(todoFromFirestore);
  }
}
