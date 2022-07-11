import 'package:AquaFocus/loading.dart';
import 'package:AquaFocus/model/state.dart';
import 'package:AquaFocus/screens/Onboarding/Onboarding.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; 
import 'package:flutter/material.dart';
import 'package:AquaFocus/screens/signin_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

int? initScreen;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  initScreen =  await preferences.getInt('initScreen');
  await preferences.setInt('initScreen', 1); 

  await Firebase.initializeApp(
    name: 'AquaFocus',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(BlocProvider(
      create: (BuildContext context) => HabitBoardCubit()..load(),
      child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
                data: MediaQueryData(),
                child: MaterialApp(home: Loading()));
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            supportedLocales: const [Locale('en'),],
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              FormBuilderLocalizations.delegate,
      ],
            initialRoute: initScreen == 0 || initScreen == null ? 'onboard' : 'home',
      routes: {
        'home' : (context) => SignInScreen(),
        'onboard': (context) => Onboarding(),
            },
            title: 'Aquafocus',
            theme: ThemeData(
              fontFamily: 'Alata',
              primarySwatch: Colors.blue,
            ),
            //home:SignInScreen(),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('State changed!');
    print(state);

    if (state == AppLifecycleState.paused) {
      context.read<HabitBoardCubit>().saveState();
    }
  }
}
