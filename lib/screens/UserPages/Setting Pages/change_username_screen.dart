import 'package:AquaFocus/widgets/loading.dart';
import 'package:AquaFocus/widgets/reusable_widget.dart';
import 'package:AquaFocus/services/database_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class changeUsernameScreen extends StatefulWidget {
  final Function _updateSettingScreen;
  changeUsernameScreen(this._updateSettingScreen);
  User? user;

  @override
  State<changeUsernameScreen> createState() => _changeUsernameScreenState();
}

class _changeUsernameScreenState extends State<changeUsernameScreen> {
  TextEditingController newUsernameController = TextEditingController();
  late String name;
  bool loading = true;

  Future<void> getName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      name = await DatabaseServices().getUserName(user.uid);
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
    final GlobalKey<FormState> _formKey = GlobalKey();
    Size size = MediaQuery.of(context).size;

    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              title: const Text("Change Username"),
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
                            child: Container(
                              color: Colors.transparent,
                              padding: EdgeInsets.all(size.height * 0.03),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.all(size.height * 0.01),
                                    ),
                                    Text('Current username:  ',
                                        style: TextStyle(
                                            fontSize: size.height * 0.02,
                                            color: Colors.white)),
                                    Text('$name',
                                        overflow: TextOverflow.fade,
                                        style: TextStyle(
                                            fontSize: size.height * 0.02,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ]),
                            ))),
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
                            child: Container(
                              color: Colors.transparent,
                              padding: EdgeInsets.all(size.height * 0.03),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.all(size.height * 0.01),
                                    ),
                                    Text('New username:  ',
                                        style: TextStyle(
                                            fontSize: size.height * 0.02,
                                            color: Colors.white)),
                                    SizedBox(height: size.height * 0.03),
                                    reusableTextField(
                                        'Enter new username',
                                        Icons.person_outline,
                                        false,
                                        newUsernameController,
                                        _newUsernameErrorText,
                                        (_) => setState(() {
                                            })),
                                    SizedBox(height: size.height * 0.03),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue.withOpacity(0.5),
                                            fixedSize:
                                                Size(size.width * 0.8, 50),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50))),
                                        onPressed: _newUsernameErrorText != null
                                        ? null
                                        : () async {
                                          String message;
                                          try {
                                            FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(FirebaseAuth
                                                    .instance.currentUser!.uid)
                                                .update({
                                              'username':
                                                  newUsernameController.text
                                            });
                                            message =
                                                'Username changed successfully';
                                            setState(() {
                                              widget._updateSettingScreen(
                                                  newUsernameController.text);
                                            });
                                          } catch (_) {
                                            message =
                                                'Error when changing username';
                                          }
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(message)));
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'Change Username',
                                          style: TextStyle(color: Colors.white),
                                        )),
                                  ]),
                            ))),
                  ],
                ),
              )
            ]),
          );
  }

  String? get _newUsernameErrorText {
    final text = newUsernameController.value.text;
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    if (text.length < 4) {
      return 'Too short, username must be at least 4 characters';
    }
    if (text.length > 10) {
      return 'Too long, username must be less than 10 characters';
    }
    // return null if the text is valid
    return null;
  }
}
