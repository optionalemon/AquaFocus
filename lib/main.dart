import 'package:AquaFocus/screens/home_screen.dart';
import 'package:AquaFocus/services/notification_services.dart';
import 'package:AquaFocus/widgets/loading.dart';
import 'package:AquaFocus/screens/Onboarding/Onboarding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:AquaFocus/screens/signin_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';

int? initScreen;
NotifyHelper notifyHelper = NotifyHelper();
final FirebaseAuth auth = FirebaseAuth.instance;
User? user;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();

  initScreen = preferences.getInt('initScreen');
  await preferences.setInt('initScreen', 1);
  notifyHelper.initializeNotification();

  await Firebase.initializeApp(
    name: 'AquaFocus',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text(snapshot.error.toString()),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MediaQuery(
                data: MediaQueryData(), child: MaterialApp(home: Loading()));
          }
          initScreen == 0 || initScreen == null ? imageCache.clear() : null;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            supportedLocales: const [
              Locale('en'),
            ],
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              FormBuilderLocalizations.delegate,
            ],
            initialRoute: initScreen == 0 || initScreen == null
                ? 'onboard'
                : (user?.uid == null ? 'login' : 'home'),
            routes: {
              'login': (context) => const SignInScreen(),
              'onboard': (context) => Onboarding(),
              'home': (context) => HomeScreen(),
            },
            title: 'Aquafocus',
            theme: ThemeData(
              fontFamily: 'Alata',
              primarySwatch: Colors.blue,
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    auth
        .userChanges()
        .listen((event) => mounted ? setState(() => user = event) : null);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
