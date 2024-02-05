import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mercuri/Wrapper.dart';
import 'package:mercuri/firebase_options.dart';
import 'package:mercuri/theme.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child:
            Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Mercuri',
            theme: ThemeData(
              fontFamily: GoogleFonts.robotoCondensed().fontFamily,
              textTheme: GoogleFonts.robotoCondensedTextTheme(
                  Theme.of(context).textTheme),
              colorScheme:
                  ColorScheme.fromSeed(seedColor: const Color(0xff1EB980)),
            ),
            darkTheme: ThemeData.dark().copyWith(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xff1EB980),
                ),
                textTheme: GoogleFonts.robotoCondensedTextTheme(
                    Theme.of(context).textTheme),
                useMaterial3: true),
            themeMode:
                themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            home: const Wrapper(),
          );
        }));
  }
}
