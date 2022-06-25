import 'package:AquaFocus/assets/fish_icon_icons.dart';
import 'package:AquaFocus/screens/UserPages/aquarium_screen.dart';
import 'package:AquaFocus/screens/UserPages/setting_screen.dart';
import 'package:AquaFocus/screens/UserPages/Shop/shop_screen.dart';
import 'package:AquaFocus/screens/UserPages/statistics_screen.dart';
import 'package:AquaFocus/services/firebase_services.dart';
import 'package:AquaFocus/widgets/focus_timer.dart';
import 'package:AquaFocus/widgets/habit_tracker.dart';
import 'package:AquaFocus/widgets/to_do_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:AquaFocus/screens/signin_screen.dart';

import '../widgets/fun_fact.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      drawer: NavigationDrawer(),
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
            ToDo(),
            Expanded(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: FocusTimer()),
                    Expanded(child: HabitTracker()),
                  ]),
            ),
            Row(children: [Expanded(child: FunFact())])
          ],
        ))
      ]),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Row(children: [
        Container(
          height: 40,
          width: 40,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset('assets/icons/AquaFocus_icon.png')),
        ),
        const SizedBox(width: 10),
        const Text(
          'Hello :)',
          style: TextStyle(
              color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
        )
      ]),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  NavigationDrawer({Key? key}) : super(key: key);
  final currUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) => Container(
      width: 210,
      child: Drawer(
          child: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildHeader(context),
              buildMenuItem(context),
            ]),
      )));

  Widget buildHeader(BuildContext context) => Container(
      color: Colors.blue.shade700,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 52,
            backgroundImage: NetworkImage(getProfilePhoto()),
          ),
          Padding(padding: EdgeInsets.all(8.0)),
          Text(getEmail(),style: TextStyle(fontSize: 15,color: Colors.white)),
          Padding(padding: EdgeInsets.all(8.0)),
        ],
      ));

  getEmail() {
    if (currUser != null) {
      return currUser!.email;
    } else {
      return "Annoymous user";
    }
  }

  getProfilePhoto() {
    if (currUser != null) {
      return currUser!.photoURL;
    } else {
      return "https://cdn.icon-icons.com/icons2/1378/PNG/512/avatardefault_92824.png";
    }
  }

  Widget buildMenuItem(BuildContext context) => Container(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        runSpacing: 16,
        children: [
          ListTile(
            leading: const Icon(
              Icons.waves,
              size: 20,
              color: Colors.blue,
            ),
            title: const Text(
              "Aquarium",
              style: TextStyle(fontSize: 15, color: Colors.blue),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AquariumScreen()));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.store,
              size: 20,
              color: Colors.blue,
            ),
            title: const Text(
              "Shop",
              style: TextStyle(fontSize: 15, color: Colors.blue),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ShopScreen()));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.grade,
              size: 20,
              color: Colors.blue,
            ),
            title: const Text(
              "Statistics",
              style: TextStyle(fontSize: 15, color: Colors.blue),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => StatisticsScreen()));
            },
          ),
          const Divider(color: Colors.black54),
          ListTile(
            leading: const Icon(
              Icons.settings,
              size: 20,
            ),
            title: const Text(
              "Settings",
              style: TextStyle(fontSize: 15),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SettingScreen()));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.sensor_door_outlined,
              size: 20,
            ),
            title: const Text(
              "Log out",
              style: TextStyle(fontSize: 15),
            ),
            onTap: () {
              showAlertDialog(context);
            },
          )
        ],
      ));
}

showAlertDialog(BuildContext context) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: const Text("Cancel"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: const Text("Continue"),
    onPressed: () {
      Navigator.of(context).pop();
      FirebaseServices().signOut();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return const SignInScreen();
        }),
      );
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
