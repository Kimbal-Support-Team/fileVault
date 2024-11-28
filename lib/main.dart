import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

class DownloadPage extends StatelessWidget {
  const DownloadPage({Key? key}) : super(key: key);

  Future<void> redirectToLink(String url, BuildContext context) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open link: $url')),
      );
    }
  }

  Widget buildButton(BuildContext context, String title, String url) {
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

  @override
  Widget build(BuildContext context) {
    // Get screen width to adjust grid layout
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth > 600
        ? 3
        : 2; // 3 columns for larger screens, 2 for smaller screens

    // List of download button data
    final downloadLinks = [
      {
        'title': 'QC App',
        'url':
            'https://drive.google.com/drive/folders/1kS08LCC9FI0De-sdgRIqVobZi87IkgnS?usp=drive_link'
      },
      {
        'title': 'SPM App',
        'url':
            'https://drive.google.com/drive/folders/1AWpocfxfeW_00gANQ9j_eazS0R7sk-dX?usp=drive_link'
      },
      {
        'title': 'DB Sync',
        'url':
            'https://drive.google.com/drive/folders/1T45l68a3g3LaXHPB26evy21riMccEf2B?usp=drive_link'
      },
      {
        'title': 'Electron App',
        'url':
            'https://drive.google.com/drive/folders/1pnwIMjzPORH3Eyc06h9XKOl2MHY9NXct?usp=sharing'
      },
      {
        'title': 'Vendor App',
        'url':
            'https://drive.google.com/drive/folders/1mwTRLQwRHpLJ64FobtsnwNYWxG-afGJ9?usp=drive_link'
      },
      {
        'title': 'Packaging App',
        'url':
            'https://drive.google.com/drive/folders/1_Ndn_X6V3uNtpFUoxpU8R-k3nvXkdkyg?usp=sharing'
      },
      {
        'title': 'API',
        'url':
            'https://drive.google.com/drive/folders/1T1pLLDh394QiNZ_pN0cif9uRDn38UxpS?usp=drive_link'
      },
    ];

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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Welcome to FileVault Buddy!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
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
                  itemCount: downloadLinks.length,
                  itemBuilder: (context, index) {
                    return buildButton(
                      context,
                      downloadLinks[index]['title']!,
                      downloadLinks[index]['url']!,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
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
      ),
    );
  }
}
