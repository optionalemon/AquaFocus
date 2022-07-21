import 'package:AquaFocus/screens/reset_password.dart';
import 'package:AquaFocus/services/firebase_services.dart';
import 'package:AquaFocus/services/notification_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:AquaFocus/widgets/reusable_widget.dart';
import 'package:AquaFocus/screens/home_screen.dart';
import 'package:AquaFocus/screens/signup_screen.dart';
import 'package:flutter/material.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
User? user;


class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  void initState() {
    auth.userChanges().listen((event) => mounted ? setState(() => user = event) : null);
    super.initState();
    
  }

  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            padding: EdgeInsets.fromLTRB(20, size.height * 0.1, 20, 0),
            child: Column(
              children: <Widget>[
                logoWidget('assets/images/logo1.png', size),
                SizedBox(
                  height: size.height * 0.02,
                ),
                reusableTextField("Enter Email Address", Icons.person_outline,
                    false, _emailTextController, null, (_) => setState(() {})),
                SizedBox(
                  height: size.height * 0.02,
                ),
                reusableTextField("Enter Password", Icons.lock_outline, true,
                    _passwordTextController, null, (_) => setState(() {})),
                forgetPassword(size),
                firebaseButton(context, "Log In", () {
                  _signin();
                }),
                signUpOption(),
                buildSignInWithText(size),
                buildSocialBtnRow(size)
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

  Widget forgetPassword(Size size) {
    return Container(
      width: size.width,
      height: size.height * 0.05,
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

  Widget buildSignInWithText(Size size) {
    return Column(
      children: <Widget>[
        SizedBox(height: size.height * 0.01),
        const Text(
          '- OR -',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: size.height * 0.01),
        const Text(
          'Sign in with',
          style: TextStyle(color: Colors.white70),
        ),
      ],
    );
  }

  Widget buildSocialBtn(VoidCallback pressed, AssetImage logo, Size size) {
    return GestureDetector(
      onTap: pressed,
      child: Container(
        height: size.height * 0.07,
        width: size.height * 0.07,
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

  Widget buildSocialBtnRow(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
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
            size,
          ),
          buildSocialBtn(
            () async {
              await FirebaseServices().signInWithGoogle();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          //HomeScreen()
                          HomeScreen()));
            },
            const AssetImage(
              'assets/images/google.jpg',
            ),
            size,
          ),
        ],
      ),
    );
  }
}
