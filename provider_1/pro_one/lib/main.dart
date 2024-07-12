import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pro_one/models/student.dart';
import 'package:pro_one/providers/student_provider.dart';
import 'package:pro_one/providers/theme_provider.dart';
import 'package:pro_one/screens/home_page.dart';
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(StudentAdapter());
  await Hive.openBox<Student>('students');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StudentProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      return MaterialApp(
        title: 'Provider_one',
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.orange,
          primaryColor: const Color.fromARGB(57, 255, 153, 0),

          // Define the ElevatedButton theme
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all<Color>(
                const Color.fromARGB(194, 255, 153, 0),
              ),
            ),
          ),
        ),
        home: HomePage(),
        debugShowCheckedModeBanner: false,
      );
    });
  }
}
