import 'package:download_door/drive_files_services.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:intl/intl.dart';
import 'redirect_services.dart';
import 'package:download_door/gdrive_service.api.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final String url;
  final String folderId;

  const CustomButton({
    super.key,
    required this.title,
    required this.url,
    required this.folderId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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
          onTap: () {
            showFilesDialog(context, title, folderId);
          },
        ),
      ),
    );
  }

  void showFilesDialog(BuildContext context, String title, String folderId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              const SizedBox(width: 8),
              Text(
                "$title Folder",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.35,
            height: MediaQuery.of(context).size.height * 0.45,
            child: FutureBuilder<List<drive.File>>(
              future: GoogleDriveService().fetchFolderContents(folderId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(child: Text("Failed to load files."));
                } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No files available in this folder."));
                }

                final files = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    final file = files[index];
                    final modifiedTime = file.modifiedTime != null
                        ? DateFormat.yMMMd().add_jm().format(file.modifiedTime!)
                        : "Unknown";
                    final fileTypeIcon = getFileTypeIcon(file.name);

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        leading: Icon(fileTypeIcon, color: Colors.blue),
                        title: Text(file.name ?? "Unnamed File",
                            style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text("Last modified: $modifiedTime"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.screen_share_outlined,
                                color: Colors.orange,
                              ),
                              onPressed: () => redirectToLink(
                                'https://drive.google.com/file/d/${file.id}/view',
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.download_rounded,
                                color: Colors.green,
                              ),
                              onPressed: () async {
                                bool isCompleted =
                                    await GoogleDriveService().downloadFile(file.id!);
                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text(
                "Close",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 1, 124, 201),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
