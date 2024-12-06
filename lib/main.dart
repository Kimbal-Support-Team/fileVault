import 'package:flutter/material.dart';
import 'download_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FileVault',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const DownloadPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}