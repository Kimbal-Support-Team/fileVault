import 'package:flutter/material.dart';
import 'download_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
