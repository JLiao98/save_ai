import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_ai/provider/feedback_position_provider.dart';
import 'package:save_ai/ui/login_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:save_ai/style/theme_config.dart';
import 'ui/login.dart';
import 'package:firebase_core/firebase_core.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {

  // // Create the initialization Future outside of `build`:
  // final Future<FirebaseApp> _initialization = Firebase.initializeApp();


  // TEXT THEME
  ThemeData themeData(ThemeData theme) {
    return theme.copyWith(
      textTheme: GoogleFonts.sourceSansProTextTheme(
        theme.textTheme,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FeedbackPositionProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SAVE',
        theme: themeData(ThemeConfig.lightTheme),
        darkTheme: themeData(ThemeConfig.lightTheme),
        home: Login(),
      ),
    );
  }




  // @override
  // Widget build(BuildContext context) {
  //
  //   return FutureBuilder(
  //     // Initialize FlutterFire:
  //     future: _initialization,
  //     builder: (context, snapshot) {
  //
  //
  //       // Check for errors
  //       if (snapshot.hasError) {
  //         print(snapshot.error);
  //       }
  //
  //       // Once complete, show your application
  //       if (snapshot.connectionState == ConnectionState.done) {
  //         return ChangeNotifierProvider(
  //           create: (context) => FeedbackPositionProvider(),
  //           child: MaterialApp(
  //             debugShowCheckedModeBanner: false,
  //             title: 'SAVE',
  //             theme: themeData(ThemeConfig.lightTheme),
  //             darkTheme: themeData(ThemeConfig.lightTheme),
  //             home: Login(),
  //           ),
  //         );
  //       }
  //
  //       // Otherwise, show something whilst waiting for initialization to complete
  //       return MaterialApp(
  //           debugShowCheckedModeBanner: false,
  //           title: 'Loading...',
  //           theme: themeData(ThemeConfig.lightTheme),
  //           darkTheme: themeData(ThemeConfig.lightTheme),
  //           home: Text("Loading..."),
  //         );
  //     },
  //   );
  //
  //
  //
  // }
}
