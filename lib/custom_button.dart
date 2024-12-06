import 'package:flutter/material.dart';
import 'redirect_services.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final String url;
  const CustomButton({super.key, required this.title, required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: ListTile(
          title: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          trailing: const Icon(
            Icons.folder_shared_rounded,
            color: Colors.blue,
            size: 32,
          ),
          onTap: () => redirectToLink(url, context),
        ),
      ),
    );
  }
}
