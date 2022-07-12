import 'package:AquaFocus/loading.dart';
import 'package:AquaFocus/reusable_widgets/reusable_widget.dart';
import 'package:AquaFocus/screens/Onboarding/Onboarding.dart';
import 'package:AquaFocus/screens/Onboarding/core_concept.dart';
import 'package:AquaFocus/screens/UserPages/Setting%20Pages/change_username_screen.dart';
import 'package:AquaFocus/screens/UserPages/Setting%20Pages/feedback_screen.dart';
import 'package:AquaFocus/screens/reset_password.dart';
import 'package:AquaFocus/screens/signin_screen.dart';
import 'package:AquaFocus/services/database_services.dart';
import 'package:AquaFocus/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  User? user;
  final Function _updateHomeName;
  SettingScreen(this._updateHomeName);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late String name;
  bool loading = true;

  updateSetting(String newName) {
    setState(() {
      name = newName;
      widget._updateHomeName(newName);
    });
  }

  Future<void> getName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      name = await DatabaseService().getUserName(user.uid);
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    getName();
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
                                              changeUsernameScreen(updateSetting)));
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
                                  "Clear Focus Record",
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
      Navigator.of(context).pop();
      //TODO
      FirebaseServices().deleteAccount(context);
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Are you sure to clear all focus records?"),
    content: const Text(
        "You can still use this account. However, all focus records will be cleared and cannot be restored."),
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
