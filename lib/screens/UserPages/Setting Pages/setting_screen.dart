import 'package:AquaFocus/model/app_task.dart';
import 'package:AquaFocus/screens/Tasks/task_utils.dart';
import 'package:AquaFocus/screens/signin_screen.dart';
import 'package:AquaFocus/services/notification_services.dart';
import 'package:AquaFocus/services/task_firestore_service.dart';
import 'package:AquaFocus/widgets/loading.dart';
import 'package:AquaFocus/screens/Onboarding/core_concept.dart';
import 'package:AquaFocus/screens/UserPages/Setting%20Pages/change_username_screen.dart';
import 'package:AquaFocus/screens/UserPages/Setting%20Pages/feedback_screen.dart';
import 'package:AquaFocus/screens/reset_password.dart';
import 'package:AquaFocus/services/database_services.dart';
import 'package:AquaFocus/services/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  User? user;
  final Function _updateHomeName;
  SettingScreen(
    this._updateHomeName,
  );

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late String name;
  bool loading = true;
  late bool allowNotif;
  late bool showCompleted;
  late bool isCheckList;

  updateSetting(String newName) {
    setState(() {
      name = newName;
      widget._updateHomeName(newName);
    });
  }

  showNotifAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Disable Anyway"),
      onPressed: () async {
        Navigator.of(context).pop();
        setState(() {
          allowNotif = !allowNotif;
        });
        await DatabaseServices().updateNotif(allowNotif);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Are you sure to disable notification?"),
      content: const Text(
          "No reminders or any form of notification will be sent upon disabling."),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> getNameNotif() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      name = await DatabaseServices().getUserName(user.uid);
      allowNotif = await DatabaseServices().getAllowNotif();
      showCompleted = await DatabaseServices().getShowCompl();
      isCheckList = await DatabaseServices().getisCheckList();
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    getNameNotif();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return loading
        ? const Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              title: const Text("Settings"),
              backgroundColor: Color.fromARGB(40, 0, 0, 0),
            ),
            body: Stack(children: <Widget>[
              Container(
                constraints: BoxConstraints.expand(),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/background2.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                          padding: EdgeInsets.all(size.height * 0.01),
                          child: Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(colors: [
                                  Colors.blue.withOpacity(0.5),
                                  Colors.white.withOpacity(0.5)
                                ]),
                                boxShadow: const <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 5,
                                      offset: Offset(0.0, 5))
                                ]),
                            child: buildSettingHeader(context),
                          )),
                      Container(
                          padding: EdgeInsets.all(size.height * 0.01),
                          child: Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(colors: [
                                  Colors.blue.withOpacity(0.5),
                                  Colors.white.withOpacity(0.5)
                                ]),
                                boxShadow: const <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 5,
                                      offset: Offset(0.0, 5))
                                ]),
                            child: Wrap(children: [
                              ListTile(
                                leading: Icon(
                                  Icons.account_circle,
                                  size: size.height * 0.03,
                                  color: Colors.white,
                                ),
                                title: Text(
                                  "Account Settings",
                                  style: TextStyle(
                                      fontSize: size.height * 0.02,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              const Divider(
                                color: Colors.white70,
                                thickness: 2,
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.change_circle_outlined,
                                  size: size.height * 0.025,
                                  color: Colors.white,
                                ),
                                title: Text(
                                  "Change Username",
                                  style: TextStyle(
                                      fontSize: size.height * 0.02,
                                      color: Colors.white),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              changeUsernameScreen(
                                                  updateSetting)));
                                },
                              ),
                              const Divider(
                                color: Colors.white70,
                                indent: 10,
                                endIndent: 10,
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.password,
                                  size: size.height * 0.025,
                                  color: Colors.white,
                                ),
                                title: Text(
                                  "Reset Password",
                                  style: TextStyle(
                                      fontSize: size.height * 0.02,
                                      color: Colors.white),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ResetPassword()));
                                },
                              ),
                              const Divider(
                                color: Colors.white70,
                                indent: 10,
                                endIndent: 10,
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.auto_delete_outlined,
                                  size: size.height * 0.025,
                                  color: Colors.white,
                                ),
                                title: Text(
                                  "Clear Record",
                                  style: TextStyle(
                                      fontSize: size.height * 0.02,
                                      color: Colors.white),
                                ),
                                onTap: () {
                                  showClearRecordAlertDialog(context);
                                },
                              ),
                              const Divider(
                                color: Colors.white70,
                                indent: 10,
                                endIndent: 10,
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.delete_forever,
                                  size: size.height * 0.025,
                                  color: Colors.white,
                                ),
                                title: Text(
                                  "Delete Account",
                                  style: TextStyle(
                                      fontSize: size.height * 0.02,
                                      color: Colors.white),
                                ),
                                onTap: () {
                                  showDeleteAccountAlertDialog(context);
                                },
                              ),
                            ]),
                          )),
                      Container(
                        padding: EdgeInsets.all(size.height * 0.01),
                        child: Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(colors: [
                                Colors.blue.withOpacity(0.5),
                                Colors.white.withOpacity(0.5)
                              ]),
                              boxShadow: const <BoxShadow>[
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 5,
                                    offset: Offset(0.0, 5))
                              ]),
                          child: Wrap(children: [
                            ListTile(
                              leading: Icon(
                                Icons.dashboard_customize,
                                size: size.height * 0.03,
                                color: Colors.white,
                              ),
                              title: Text(
                                "Customisation",
                                style: TextStyle(
                                    fontSize: size.height * 0.02,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            const Divider(
                              color: Colors.white70,
                              thickness: 2,
                            ),
                            SwitchListTile(
                              value: isCheckList,
                              secondary: Icon(
                                Icons.all_inbox,
                                size: size.height * 0.025,
                                color: Colors.white,
                              ),
                              title: Text(
                                "List as Default To-Do List Page",
                                style: TextStyle(
                                    fontSize: size.height * 0.02,
                                    color: Colors.white),
                              ),
                              onChanged: (bool value) async {
                                setState(() {
                                  isCheckList = !isCheckList;
                                });
                                DatabaseServices().updateCheckList(isCheckList);
                              },
                            ),
                            SwitchListTile(
                              value: allowNotif,
                              secondary: Icon(
                                Icons.notifications,
                                size: size.height * 0.025,
                                color: Colors.white,
                              ),
                              title: Text(
                                "Allow Notifications",
                                style: TextStyle(
                                    fontSize: size.height * 0.02,
                                    color: Colors.white),
                              ),
                              onChanged: (bool value) async {
                                if (value) {
                                  setState(() {
                                    allowNotif = !allowNotif;
                                  });
                                  if (allowNotif) {
                                    //get Everything with notification
                                    List<AppTask> eventList =
                                        await taskDBS.getQueryList(args: [
                                      QueryArgsV2(
                                        "userId",
                                        isEqualTo: user!.uid,
                                      ),
                                      QueryArgsV2(
                                        "isCompleted",
                                        isEqualTo: false,
                                      ),
                                      QueryArgsV2(
                                        "hasTime",
                                        isEqualTo: true,
                                      ),
                                    ]);
                                    for (AppTask event in eventList) {
                                      addNotification(event);
                                    }
                                  } else {
                                    await NotifyHelper()
                                        .flutterLocalNotificationsPlugin
                                        .cancelAll();
                                  }
                                  await DatabaseServices()
                                      .updateNotif(allowNotif);
                                } else {
                                  showNotifAlertDialog(context);
                                }
                              },
                            ),
                            SwitchListTile(
                              value: showCompleted,
                              secondary: Icon(
                                Icons.remove_red_eye_rounded,
                                size: size.height * 0.025,
                                color: Colors.white,
                              ),
                              title: Text(
                                "Show Completed Tasks",
                                style: TextStyle(
                                    fontSize: size.height * 0.02,
                                    color: Colors.white),
                              ),
                              onChanged: (bool value) async {
                                setState(() {
                                  showCompleted = !showCompleted;
                                });
                                await DatabaseServices()
                                    .updateShowCompl(showCompleted);
                              },
                            ),
                          ]),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.all(size.height * 0.01),
                          child: Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(colors: [
                                  Colors.blue.withOpacity(0.5),
                                  Colors.white.withOpacity(0.5)
                                ]),
                                boxShadow: const <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 5,
                                      offset: Offset(0.0, 5))
                                ]),
                            child: Wrap(children: [
                              ListTile(
                                leading: Icon(
                                  Icons.info_outline,
                                  size: size.height * 0.03,
                                  color: Colors.white,
                                ),
                                title: Text(
                                  "About AquaFocus",
                                  style: TextStyle(
                                      fontSize: size.height * 0.02,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              const Divider(
                                color: Colors.white70,
                                thickness: 2,
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.menu_book_outlined,
                                  size: size.height * 0.025,
                                  color: Colors.white,
                                ),
                                title: Text(
                                  "Core Concept",
                                  style: TextStyle(
                                      fontSize: size.height * 0.02,
                                      color: Colors.white),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => coreConcept()));
                                },
                              ),
                              const Divider(
                                color: Colors.white70,
                                indent: 10,
                                endIndent: 10,
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.feedback_outlined,
                                  size: size.height * 0.025,
                                  color: Colors.white,
                                ),
                                title: Text(
                                  "Feedback Channel",
                                  style: TextStyle(
                                      fontSize: size.height * 0.02,
                                      color: Colors.white),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              feedbackScreen()));
                                },
                              ),
                            ]),
                          )),
                    ],
                  ),
                ),
              )
            ]));
  }

  Widget buildSettingHeader(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        color: Colors.transparent,
        padding: EdgeInsets.all(size.height * 0.03),
        child: Row(
          children: [
            CircleAvatar(
              radius: size.height * 0.04,
              backgroundImage: NetworkImage(getProfilePhoto()),
            ),
            Padding(
              padding: EdgeInsets.all(size.height * 0.01),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Username: $name',
                    style: TextStyle(
                        fontSize: size.height * 0.02, color: Colors.white)),
                SizedBox(height: size.height * 0.01),
                Text(getEmail(),
                    style: TextStyle(
                        fontSize: size.height * 0.02, color: Colors.white)),
              ],
            ),
          ],
        ));
  }
}

getEmail() {
  if (FirebaseAuth.instance.currentUser != null) {
    return FirebaseAuth.instance.currentUser!.email;
  } else {
    return "Annoymous user";
  }
}

getProfilePhoto() {
  if (FirebaseAuth.instance.currentUser != null &&
      FirebaseAuth.instance.currentUser!.photoURL != null) {
    return FirebaseAuth.instance.currentUser!.photoURL;
  } else {
    return "https://cdn.icon-icons.com/icons2/1378/PNG/512/avatardefault_92824.png";
  }
}

showDeleteAccountAlertDialog(BuildContext context) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: const Text("Delete Anyway"),
    onPressed: () {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Account deleted successfully')));
      Navigator.of(context).pop();
      FirebaseServices().deleteAccount(context);
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Are you sure to delete account?"),
    content: const Text(
        "You can no longer use this account. Once deleted, all the data in this account cannot be restored."),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showClearRecordAlertDialog(BuildContext context) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: const Text("Clear Anyway"),
    onPressed: () {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Records cleared successfully')));
      Navigator.of(context).pop();
      FirebaseServices().clearRecord(context);
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Are you sure to clear your focus and task record?"),
    content: const Text(
        "You can still use this account. However, all records will be cleared and cannot be restored."),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
