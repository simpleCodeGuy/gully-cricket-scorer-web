import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gully_cricket_scorer/bloc/homescreen_bloc.dart';
import 'package:gully_cricket_scorer/data/data_repository.dart';
import 'package:gully_cricket_scorer/ui/phone_login_page.dart';
import 'ui/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import '/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // in actual app instead of DefaultFirebaseOptions.currentPlatform, info of
  // your firebase project should be given
  // FirebaseOptions(
  //   apiKey: "",
  //   appId: "",
  //   messagingSenderId: "",
  //   projectId: "",
  // ),
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => DataRepository(), lazy: false)
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) {
              var repo = RepositoryProvider.of<DataRepository>(context);
              return HomescreenBloc(repo);
            },
            lazy: false,
          )
        ],
        child: MaterialApp(
          title: 'Gully Cricket Scorer',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
            fontFamily: 'ComicNeue',
            useMaterial3: true,
          ),
          // home: (FirebaseAuth.instance.currentUser != null)
          //     ? MyHomePage(user: FirebaseAuth.instance.currentUser!)
          //     : const PhoneLoginPage(),
          home: const PhoneLoginPage(appStartedForFirstTime: true),
        ),
      ),
    );
    // MaterialApp(
    //   title: 'Flutter Demo',
    //   theme: ThemeData(
    //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    //     useMaterial3: true,
    //   ),
    //   // home: const MyHomePage(),
    //   home: MultiRepositoryProvider(
    //     providers: [
    //       RepositoryProvider(create: (_) => DataRepository(), lazy: false)
    //     ],
    //     child: MultiBlocProvider(
    //       providers: [
    //         BlocProvider(
    //           create: (context) {
    //             var repo = RepositoryProvider.of<DataRepository>(context);
    //             return HomescreenBloc(repo);
    //           },
    //           lazy: false,
    //         )
    //       ],
    //       child: (FirebaseAuth.instance.currentUser != null)
    //           ? const MyHomePage()
    //           : const LoginPage(),
    //     ),
    //   ),
    // );
  }
}
