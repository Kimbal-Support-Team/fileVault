import 'package:flutter/material.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.1,
        color: const Color.fromARGB(255, 1, 124, 201),
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: const Center(
          child: Text(
            '© 2024 FileVault | Developed by MES Support - All rights reserved',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
  }
}