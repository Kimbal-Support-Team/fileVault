import 'package:download_door/buttons_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:download_door/bottom_navbar.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({super.key});

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  final String _secretCode =
      "mes"; // Replace with your desired secret code
  final String _username = "mes"; // Default username
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _showSecurityDialog());
    super.initState();
  }
void _showSecurityDialog() {
  String? errorMessage; // Persistent error message
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dismissing by tapping outside
    barrierColor: const Color.fromARGB(255, 1, 124, 201)
        .withOpacity(1), // Darkened background
    builder: (context) {
      final TextEditingController usernameController =
          TextEditingController();
      final TextEditingController codeController = TextEditingController();

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24), // Rounded corners
            ),
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock, color: Colors.blue, size: 30),
                SizedBox(width: 8),
                Text(
                  "Login to FileVault",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
            content: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Enter your credentials to access FileVault.",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      labelText: "Username",
                      labelStyle: TextStyle(color: Colors.blueAccent),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: codeController,
                    obscureText: true, // Hides input for added security
                    decoration: const InputDecoration(
                      labelText: "Secret Code",
                      labelStyle: TextStyle(color: Colors.blueAccent),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent),
                      ),
                    ),
                  ),
                  if (errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      errorMessage ?? '',
                      style: const TextStyle(
                          color: Colors.red, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  final String username = usernameController.text.isNotEmpty
                      ? usernameController.text
                      : "User";

                  if (codeController.text == _secretCode &&
                      usernameController.text == _username) {
                    Navigator.of(context).pop(); // Close the dialog on success
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Welcome, $username!"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    setState(() {
                      errorMessage = "Access Denied. Please contact support.";
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Access Denied! Please enter valid credentials."),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text(
                  "Unlock",
                  style: TextStyle(color: Colors.blueAccent, fontSize: 16,fontWeight: FontWeight.w600),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 242, 245),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 124, 201),
        title: SvgPicture.network(
          'https://ipfs.filebase.io/ipfs/QmbMbv2WXqGhuxM42hMhgCoe2Qvue7Rabe7yEAvQm4DYrt',
        ),
        toolbarHeight: 80,
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Welcome to FileVault!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ButtonsContainer()
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavbar(),
    );
  }
}
