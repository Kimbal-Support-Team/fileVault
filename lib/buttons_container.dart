import 'package:download_door/custom_button.dart';
import 'package:download_door/upload_button.dart';
import 'package:flutter/material.dart';
import 'data.dart';

class ButtonsContainer extends StatefulWidget {
  const ButtonsContainer({super.key});

  @override
  State<ButtonsContainer> createState() => _ButtonsContainerState();
}

class _ButtonsContainerState extends State<ButtonsContainer> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth > 600 ? 3 : 2;
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 1, 124, 201),
              Color.fromARGB(255, 27, 135, 202),
              Color.fromARGB(255, 54, 146, 203),
              Color.fromARGB(255, 84, 158, 204),
              Color.fromARGB(255, 114, 170, 206),
            ],
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 4),
          itemCount: downloadLinks.length + 1,
          itemBuilder: (context, index) {
            if (index < downloadLinks.length) {
              return CustomButton(
                title: downloadLinks[index]['title']!,
                url: downloadLinks[index]['url']!,
                folderId: folderIds[downloadLinks[index]['title']]!,
              );
            } else {
              return const UploadButton();
            }
          },
        ),
      ),
    );
  }
}
