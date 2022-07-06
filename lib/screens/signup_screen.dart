import 'package:AquaFocus/model/app_user.dart';
import 'package:AquaFocus/screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:AquaFocus/reusable_widgets/reusable_widget.dart';
import 'package:AquaFocus/services/database_services.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  TextEditingController _passwordAgainTextController = TextEditingController();

  final auth = FirebaseAuth.instance;
  var _text = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          constraints: BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background2.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: size.height*0.02,
                ),
                reusableTextField(
                    "Enter UserName",
                    Icons.person_outline,
                    false,
                    _userNameTextController,
                    _userErrorText,
                    (_) => setState(() {})),
                SizedBox(
                  height: size.height*0.02,
                ),
                reusableTextField(
                    "Enter Email Id",
                    Icons.email_outlined,
                    false,
                    _emailTextController,
                    _emailErrorText,
                    (text) => setState(() => _text)),
                SizedBox(
                  height: size.height*0.02,
                ),
                reusableTextField(
                    "Enter Password",
                    Icons.lock_outlined,
                    true,
                    _passwordTextController,
                    _passwordErrorText,
                    (text) => setState(() => _text)),
                SizedBox(
                  height: size.height*0.02,
                ),
                reusableTextField(
                    "Confirm Password",
                    Icons.lock_outlined,
                    true,
                    _passwordAgainTextController,
                    _passwordAgainErrorText,
                    (text) => setState(() => _text)),
                SizedBox(
                  height: size.height*0.02,
                ),
                firebaseButton(context, "Sign Up", () {
                  _emailErrorText == null &&
                          _passwordErrorText == null &&
                          _userErrorText == null
                      ? (_passwordAgainTextController.text ==
                              _passwordTextController.text
                          ? _register()
                          : ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                              content: Text("Passwords do not match"),
                            )))
                      : null;
                })
              ],
            ),
          ))),
    );
  }

  _register() async {
    try {
      final newUser = await auth.createUserWithEmailAndPassword(
          email: _emailTextController.text,
          password: _passwordTextController.text);
      AppUser appUser = AppUser(
          email: _emailTextController.text,
          userName: _userNameTextController.text);
      DatabaseService().addUser(appUser, newUser.user!.uid);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SignInScreen()));
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-email") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Invalid email"),
        ));
      } else if (e.code == "weak-password") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("weak password: should be at least 6 characters"),
        ));
      } else if (e.code == "email-already-in-use") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("You have already registered with this email"),
        ));
      }
    }
  }

  String? get _userErrorText {
    final text = _userNameTextController.value.text;
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

  String? get _emailErrorText {
    final text = _emailTextController.value.text;
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    // return null if the text is valid
    return null;
  }

  String? get _passwordErrorText {
    final text = _passwordTextController.value.text;
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    if (text.length < 6) {
      return 'Too short, password must be at least 6 characters';
    }
    // return null if the text is valid
    return null;
  }

  String? get _passwordAgainErrorText {
    final text = _passwordAgainTextController.value.text;
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    if (text.length < 6) {
      return 'Too short, password must be at least 6 characters';
    }
    // return null if the text is valid
    return null;
  }
}
