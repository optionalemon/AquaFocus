import 'package:AquaFocus/reusable_widgets/loading.dart';
import 'package:AquaFocus/screens/UserPages/Aquarium/aquarium_screen.dart';
import 'package:AquaFocus/screens/UserPages/Statistics/statistics_screen.dart';
import 'package:AquaFocus/screens/UserPages/Setting%20Pages/setting_screen.dart';
import 'package:AquaFocus/screens/UserPages/Shop/shop_screen.dart';
import 'package:AquaFocus/screens/signin_screen.dart';
import 'package:AquaFocus/services/firebase_services.dart';
import 'package:AquaFocus/widgets/focus_timer.dart';
import 'package:AquaFocus/widgets/tasks_today.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:AquaFocus/services/database_services.dart';

class HomeScreen extends StatefulWidget {
  User? user;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int fishMoney = 0;
  late String name;
  bool loading = true;
  late bool isCheckList;

  _updateHomeScreen(int newMoney) {
    setState(() {
      fishMoney = newMoney;
    });
  }

  _updateHomeCheckList(bool newCheckList) {
    setState(() {
      isCheckList = newCheckList;
    });
  }

  _updateHomeName(String newName) {
    setState(() {
      name = newName;
    });
  }

  Future<void> getNameAndMoney() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      isCheckList = await DatabaseService().getisCheckList();
      name = await DatabaseService().getUserName(user.uid);
      fishMoney = await DatabaseService().getMoney();
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    getNameAndMoney();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            extendBodyBehindAppBar: true,
            appBar: _buildAppBar(MediaQuery.of(context).size),
            drawer: NavigationDrawer(
              updateHomeScreen: _updateHomeScreen,
              updateHomeName: _updateHomeName,
              updateHomeCheckList: _updateHomeCheckList,
              isCheckList: isCheckList,
            ),
            body: Stack(children: <Widget>[
              Container(
                constraints: const BoxConstraints.expand(),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/mainscreen.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SafeArea(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Tasks(
                    isCheckList: isCheckList,
                  ),
                  Expanded(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: FocusTimer(
                            updateHomeState: _updateHomeScreen,
                          )),
                        ]),
                  ),
                  //Row(children: [Expanded(child: FunFact())])
                ],
              ))
            ]),
          );
  }

  AppBar _buildAppBar(Size size) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Row(children: [
        Container(
          height: size.height * 0.05,
          width: size.width * 0.1,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset('assets/icons/AquaFocus_icon.png')),
        ),
        SizedBox(width: size.width * 0.025),
        SizedBox(
          width: size.width * 0.35,
          child: AutoSizeText(
            'Hello $name :)',
            maxLines: 1,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ]),
      actions: [
        Container(
            padding: EdgeInsets.all(size.width * 0.02),
            margin: EdgeInsets.only(
              right: size.width * 0.05,
              top: size.height * 0.01,
              bottom: size.height * 0.01,
            ),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(25)),
            child: Row(children: <Widget>[
              Image.asset(
                'assets/icons/money.png',
                height: size.height * 0.035,
              ),
              SizedBox(width: size.width * 0.02),
              Text(
                '$fishMoney',
              ),
            ])),
      ],
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  NavigationDrawer(
      {required this.updateHomeScreen,
      required this.updateHomeName,
      required this.updateHomeCheckList,
      required this.isCheckList,
      Key? key})
      : super(key: key);
  final currUser = FirebaseAuth.instance.currentUser;
  final updateHomeScreen;
  final updateHomeName;
  final updateHomeCheckList;
  bool isCheckList;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        width: size.width * 0.55,
        child: Drawer(
            child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                buildHeader(context),
                buildMenuItem(context, updateHomeName, updateHomeCheckList, isCheckList),
              ]),
        )));
  }

  Widget buildHeader(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        color: Colors.blue.shade700,
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: size.height * 0.067,
              backgroundImage: NetworkImage(getProfilePhoto()),
            ),
            Padding(padding: EdgeInsets.all(size.height * 0.01)),
            Text(getEmail(),
                style: TextStyle(
                    fontSize: size.height * 0.02, color: Colors.white)),
            Padding(padding: EdgeInsets.all(size.height * 0.01)),
          ],
        ));
  }

  getEmail() {
    if (currUser != null) {
      return currUser!.email;
    } else {
      return "Annoymous user";
    }
  }

  getProfilePhoto() {
    if (currUser != null && currUser!.photoURL != null) {
      return currUser!.photoURL;
    } else {
      return "https://cdn.icon-icons.com/icons2/1378/PNG/512/avatardefault_92824.png";
    }
  }

  Widget buildMenuItem(BuildContext context, Function updateHomeName,
      Function updateHomeCheckList, bool isCheckList) {
    Size size = MediaQuery.of(context).size;
    return Container(
        padding: EdgeInsets.all(size.height * 0.03),
        child: Wrap(
          runSpacing: size.height * 0.02,
          children: [
            ListTile(
              leading: Icon(
                Icons.waves,
                size: size.height * 0.025,
                color: Colors.blue,
              ),
              title: Text(
                "Aquarium",
                style:
                    TextStyle(fontSize: size.height * 0.02, color: Colors.blue),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AquariumScreen()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.store,
                size: size.height * 0.025,
                color: Colors.blue,
              ),
              title: Text(
                "Shop",
                style:
                    TextStyle(fontSize: size.height * 0.02, color: Colors.blue),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ShopScreen(updateHomeScreen)));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.grade,
                size: size.height * 0.025,
                color: Colors.blue,
              ),
              title: Text(
                "Statistics",
                style:
                    TextStyle(fontSize: size.height * 0.02, color: Colors.blue),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => StatisticsScreen()));
              },
            ),
            const Divider(color: Colors.black54),
            ListTile(
              leading: Icon(
                Icons.settings,
                size: size.height * 0.025,
              ),
              title: Text(
                "Settings",
                style: TextStyle(fontSize: size.height * 0.02),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SettingScreen(
                          updateHomeName, updateHomeCheckList, isCheckList
                        )));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.sensor_door_outlined,
                size: size.height * 0.025,
              ),
              title: Text(
                "Log out",
                style: TextStyle(fontSize: size.height * 0.02),
              ),
              onTap: () {
                showAlertDialog(context);
              },
            ),
          ],
        ));
  }
}

showAlertDialog(BuildContext context) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: const Text("Continue"),
    onPressed: () {
      Navigator.of(context).pop();
      FirebaseServices().signOut();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SignInScreen()));
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Are you sure to log out?"),
    content: const Text("Your data won't be sychronised anymore."),
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
