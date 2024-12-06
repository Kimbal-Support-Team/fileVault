import 'package:download_door/buttons_container.dart';
import 'package:flutter/material.dart';

import 'package:download_door/bottom_navbar.dart';
import 'package:flutter_svg/svg.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({Key? key}) : super(key: key);

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {


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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Row(
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
            const SizedBox(height: 16),
            ButtonsContainer()
          ],
        ),
      ),
      bottomNavigationBar: BottomNavbar(),
    );
  }
}
