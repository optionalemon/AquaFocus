import 'package:AquaFocus/screens/reset_password.dart';
import 'package:AquaFocus/services/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:AquaFocus/reusable_widgets/reusable_widget.dart';
import 'package:AquaFocus/screens/home_screen.dart';
import 'package:AquaFocus/screens/signup_screen.dart';
import 'package:flutter/material.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
late User? user;

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  void initState() {
    auth.userChanges().listen((event) => setState(() => user = event));
    super.initState();
  }

  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background2.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.1, 20, 0),
            child: Column(
              children: <Widget>[
                logoWidget('assets/images/logo1.png'),
                const SizedBox(
                  height: 10,
                ),
                reusableTextField("Enter Email Address", Icons.person_outline,
                    false, _emailTextController, null, (_) => setState(() {})),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Password", Icons.lock_outline, true,
                    _passwordTextController, null, (_) => setState(() {})),
                const SizedBox(
                  height: 5,
                ),
                forgetPassword(context),
                firebaseButton(context, "Log In", () {
                  _signin();
                }),
                signUpOption(),
                buildSignInWithText(),
                buildSocialBtnRow()
              ],
            ),
          ),
        ),
      ),
    );
  }

  _signin() async {
    try {
      await FirebaseServices().signInWithEmail(
          _emailTextController.text, _passwordTextController.text);

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Invalid Password or/and Email'),
      ));
    }
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account yet?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          //Go to sign up screen
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignUpScreen()));
          },
          child: const Text(
            "  Sign up now!",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: const Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.white70),
          textAlign: TextAlign.right,
        ),
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ResetPassword())),
      ),
    );
  }

  Widget buildSignInWithText() {
    return Column(
      children: const <Widget>[
        SizedBox(height: 10.0),
        Text(
          '- OR -',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          'Sign in with',
          style: TextStyle(color: Colors.white70),
        ),
      ],
    );
  }

  Widget buildSocialBtn(VoidCallback pressed, AssetImage logo) {
    return GestureDetector(
      onTap: pressed,
      child: Container(
        height: 50.0,
        width: 50.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget buildSocialBtnRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          buildSocialBtn(
            () async {
              await FirebaseServices().signInWithFacebook();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            },
            const AssetImage(
              'assets/images/facebook.jpg',
            ),
          ),
          buildSocialBtn(
            () async {
              await FirebaseServices().signInWithGoogle();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            },
            const AssetImage(
              'assets/images/google.jpg',
            ),
          ),
        ],
      ),
    );
  }
}
