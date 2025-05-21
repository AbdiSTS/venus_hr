import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'page/bottom_navigator_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white, // ⬅️ warna AppBar
          elevation: 0, // tanpa bayangan
          iconTheme: IconThemeData(color: Colors.black), // icon hitam
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.black, // ⬅️ warna utama (misal tombol)
        ),
      ),
      home: BottomNavigatorView(),
    );
  }
}
