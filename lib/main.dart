import 'package:flutter/material.dart';
import 'views/products_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Color primaryColor = Colors.teal;
  final Color backgroundColor = Colors.grey[50]!;
  final Color textColor = Colors.grey[800]!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        primaryColor: primaryColor,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 1,
          iconTheme: IconThemeData(color: textColor),
          titleTextStyle: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ProductsView(),
    );
  }
}
