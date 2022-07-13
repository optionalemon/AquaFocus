import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:AquaFocus/model/app_user.dart';
import 'package:AquaFocus/screens/signin_screen.dart';
import 'package:intl/intl.dart';



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

  Future<void> saveFocusTime(int duration, String date) async {
    var focusTimeCollection = userDoc.collection('FocusTime');

    final focusDate = await focusTimeCollection.doc(date).get();
    if (focusDate.exists) {
      focusTimeCollection.doc(date).update({
        "totalTime": FieldValue.increment(duration)
      });
    } else {
      focusTimeCollection.doc(date).set({
        "totalTime": duration,
        "Date": DateFormat('yyyy-MM-dd').format(DateTime.now())
      });
    }
  }

  Future<num> getTimeOfTheDay(String uid, String day) async {
    num totalMinutes = 0;

    CollectionReference userFocusTime = userCollection.doc(uid).collection('FocusTime');

    await userFocusTime.doc(day).get().then((DocumentSnapshot doc) {
      if (doc.exists) {
        totalMinutes = doc.get("totalTime");
      }
    });
    return totalMinutes;
  }
}
