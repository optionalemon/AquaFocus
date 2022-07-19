import 'dart:collection';
import 'package:AquaFocus/model/app_task.dart';
import 'package:AquaFocus/screens/FocusTimer/CountDown/countdown_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:AquaFocus/model/app_user.dart';
import 'package:AquaFocus/model/tags.dart';
import 'package:AquaFocus/screens/signin_screen.dart';
import 'package:intl/intl.dart';

class DatabaseServices {
  late CollectionReference userCollection;
  late CollectionReference tagsCollection;
  late DocumentReference userDoc;
  late CollectionReference focusTimeCollection;
  late CollectionReference taskCollection;

  DatabaseServices({FirebaseFirestore? instanceInjection}) {
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
    tagsCollection = instance.collection('users').doc(uid).collection('Tags');
    taskCollection =
        instance.collection('users').doc(uid).collection('tasks');
    focusTimeCollection =
        instance.collection('users').doc(uid).collection('FocusTime');
  }

  Future<void> addTags(Tags newTag) async {
    await tagsCollection.doc(newTag.title).set({
      'title': newTag.title,
      'color': newTag.color,
    });
  }

  Future<List> getUserTags() async {
    List tags = [];
    await tagsCollection.get().then((snapshot) => {
      snapshot.docs.forEach((doc) {
        String color = doc.get("color");
        String title = doc.get("title");

        tags.add(Tags(title: title, color: color));
      })
    });
    return tags;
  }

  Future<void> removeTag(Tags tag) async {
    tagsCollection.doc(tag.title).delete();
  }

  Future<double> getPercentageForTag(Tags tag) async {
    QuerySnapshot tasks = await userDoc.collection('tasks').where('tag', isEqualTo: tag.title).get();
    //print(tasks.size);
    QuerySnapshot totalTasks = await userDoc.collection('tasks').get();
    //print(totalTasks.size);
    return tasks.size / totalTasks.size * 100;
  }

  Future<void> addUser(AppUser user, String uid) async {
    await userCollection.doc(uid).set({
      'uid': uid,
      'email': user.email,
      'username': user.userName,
      'marlives': user.marLives,
      'money': user.fishMoney,
      'isCheckList': true,
      'allowNotif': true,
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
    await userDoc.update({"money": FieldValue.increment(amt)});
  }

  Future<void> removeTagTask(AppTask task) async {
    await taskCollection.doc(task.id).update({"tag" : null});
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

  Future<void> updateCheckList(bool newCheckList) async {
    userDoc.update({"isCheckList": newCheckList});
  }

  Future<bool> getisCheckList() async {
    bool isCheckList = true;
    await userDoc.get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        isCheckList = documentSnapshot.get("isCheckList");
      }
    });
    return isCheckList;
  }

  Future<void> updateShowCompl(bool newShow) async {
    userDoc.update({"showCompleted": newShow});
  }

  Future<bool> getShowCompl() async {
    bool isCheckList = true;
    await userDoc.get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        isCheckList = documentSnapshot.get("showCompleted");
      }
    });
    return isCheckList;
  }

  Future<void> updateNotif(bool newNotif) async {
    userDoc.update({"isCheckList": newNotif});
  }

  Future<bool> getAllowNotif() async {
    bool allowNotif = true;
    await userDoc.get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        allowNotif = documentSnapshot.get("allowNotif");
      }
    });
    return allowNotif;
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

  Future<List<int>> getListForHours(String databaseField, String userId) async {
    List<int> requestList = [];
    DocumentReference docRef = userCollection
        .doc(userId)
        .collection('FocusTime')
        .doc(DateFormat('yyyy-MM-dd')
        .format(DateTime.now()));

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

  Future<List<int>> getHoursList(String userId) {
    return getListForHours('Hours', userId);
  }

  Future<void> saveFocusTime(int duration, String date, DateTime startTime, DateTime endTime) async {
    var focusTimeCollection = userDoc.collection('FocusTime');

    Duration diff = endTime.difference(startTime);
    List totalTime = CountDownHelper().timeString(diff.inSeconds);
    int diffInt = int.parse(totalTime[2]) +
        int.parse(totalTime[1]) * 60 +
        int.parse(totalTime[0]) * 60;
    var hours = await getHoursList(userDoc.id);


    if (hours.isEmpty) {
      hours = List.generate(24, (index) => 0);
      for(int i = 0; i < 24; i++) {
        if(i == startTime.hour && i == endTime.hour) {
          hours[i] = hours[i] + diffInt;
        }
        else if (i == startTime.hour && i != endTime.hour) {
          Duration diffToStart = DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              i + 1,
              0
          ).difference(startTime);
          List time = CountDownHelper().timeString(diffToStart.inSeconds);
          int diffToStartInt = int.parse(time[2]) +
              int.parse(time[1]) * 60 +
              int.parse(time[0]) * 60;

          hours[i] = hours[i] + diffToStartInt;

          for(int j = 0; j < 24; j++) {
            if (j == endTime.hour) {
              Duration diffToEnd = endTime.difference(DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  j,
                  0
              ));
              List time2 = CountDownHelper().timeString(diffToEnd.inSeconds);
              int diffToEndInt = int.parse(time2[2]) +
                  int.parse(time2[1]) * 60 +
                  int.parse(time2[0]) * 60;

              hours[j] = hours[j] + diffToEndInt;
              for (int k = i + 1; k < j; k++) {
                hours[k] = hours[k] + 60;
              }
            }
          }
        }
      }
    } else {
      for(int i = 0; i < 24; i++) {
        if(i == startTime.hour && i == endTime.hour) {
          hours[i] = hours[i] + diffInt;
        }
      }
    }

    final focusDate = await focusTimeCollection.doc(date).get();
    if (focusDate.exists) {
      focusTimeCollection
          .doc(date)
          .update({
        "totalTime": FieldValue.increment(duration),
        "Hours": hours,
      });
    } else {
      focusTimeCollection.doc(date).set({
        "totalTime": duration,
        "Date": DateFormat('yyyy-MM-dd').format(DateTime.now()),
        "Hours": hours,
      });
    }
  }

  Future<num> getTimeOfTheDay(String uid, String day) async {
    num totalMinutes = 0;

    CollectionReference userFocusTime =
    userCollection.doc(uid).collection('FocusTime');

    await userFocusTime.doc(day).get().then((DocumentSnapshot doc) {
      if (doc.exists) {
        totalMinutes = doc.get("totalTime");
      }
    });
    return totalMinutes;
  }

  Future<List> getTimeOfTheHours(String uid, String day) async {
    List timeByHour = [];

    CollectionReference userFocusTime =
    userCollection.doc(uid).collection('FocusTime');

    await userFocusTime.doc(day).get().then((DocumentSnapshot doc) {
      if (doc.exists) {
        timeByHour = doc.get("Hours");
      }
    });
    return timeByHour;
  }

  Future<Map<DateTime, int>> heatMapData() async {
    Map<DateTime, int> mapInput = new HashMap<DateTime, int>();
    await focusTimeCollection.get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        DateTime dt = DateTime.parse('${doc.get("Date")}');
        int duration = doc.get("totalTime");
        mapInput.putIfAbsent(dt, () => duration);
      }
    });
    return mapInput;
  }
}
