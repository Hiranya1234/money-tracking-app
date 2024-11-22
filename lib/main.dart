import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/firebase_options.dart';
import 'package:flutter_application_4/widgets/auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF2074A5),
          primary: Color(0xFF2074A5),
          secondary: Color(0xFF2074A5).withOpacity(0.6), // Adjust opacity for secondary color
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color(0xFF2074A5), // Cursor color
          selectionColor: Color(0xFF2074A5).withOpacity(0.2), // Selection color
          selectionHandleColor: Color(0xFF2074A5), // Selection handle color
        ),
        appBarTheme: AppBarTheme(
          color: Color(0xFF2074A5),
          foregroundColor: Colors.white, // Text color in AppBar
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF2074A5), // Button background color
            // Button text color
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Color(0xFF2074A5).withOpacity(0.8)),
          hintStyle: TextStyle(color: Color(0xFF2074A5)),
        ),
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Color(0xFF2074A5).withOpacity(0.8)),
          bodyText2: TextStyle(color: Color(0xFF2074A5).withOpacity(0.8)),
          subtitle1: TextStyle(color: Color(0xFF2074A5).withOpacity(0.8)),
          subtitle2: TextStyle(color: Color(0xFF2074A5).withOpacity(0.8)),
        ),
        primarySwatch: MaterialColor(
          0xFF2074A5,
          <int, Color>{
            50: Color(0xFFE1E9F1),
            100: Color(0xFFB3C8E1),
            200: Color(0xFF82A2C9),
            300: Color(0xFF5283B1),
            400: Color(0xFF30709D),
            500: Color(0xFF2074A5),
            600: Color(0xFF1D6D9D),
            700: Color(0xFF1A648F),
            800: Color(0xFF165C81),
            900: Color(0xFF0C4D6A),
          },
        ),
        useMaterial3: true, // Optional: Use Material Design 3
      ),
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}
