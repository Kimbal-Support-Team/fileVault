import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'data.dart';
import 'gdrive_service.api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UploadButton extends StatefulWidget {
  const UploadButton({super.key});

  @override
  State<UploadButton> createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {
  bool showLoading = false;
  bool showPinDialog = true;

  void showUploadDialog(BuildContext context) {
    String selectedOption = options[0];
    String pin = ''; // To store user-entered PIN
    String correctPin = dotenv.env['UPLOADING_PIN']!; // Hardcoded PIN
    bool isPinCorrect = false; // Flag to check PIN validity

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Upload Files",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ),
          content: StatefulBuilder(
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    "Enter PIN to Unlock Upload:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      hintText: 'Enter PIN',
                    ),
                    obscureText: true, // To hide PIN input
                    onChanged: (value) {
                      state(() {
                        pin = value;
                        isPinCorrect = pin == correctPin;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Select a Folder:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color.fromARGB(255, 255, 255, 255),
                      border: Border.all(color: Colors.grey[400]!),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButton<String>(
                      value: selectedOption,
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: options.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        state(() {
                          selectedOption = newValue!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  showLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                state(() {
                                  showLoading = false;
                                });
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
                                "Cancel",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 1, 124, 201),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: isPinCorrect
                                  ? () async {
                                      String folderId =
                                          folderIds[selectedOption] ?? '';
                                      state(() {
                                        showLoading = true;
                                      });
                                      bool isUploaded =
                                          await uploadFileToDrive(folderId);

                                      if (isUploaded) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                "File uploaded successfully to $selectedOption."),
                                            backgroundColor: Colors.green,
                                            behavior: SnackBarBehavior.floating,
                                            duration:
                                                const Duration(seconds: 2),
                                          ),
                                        );
                                        state(() {
                                          showLoading = false;
                                        });
                                        Navigator.of(context).pop();
                                      } else {
                                        state(() {
                                          showLoading = false;
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "File uploading failed. Please try again!"),
                                            backgroundColor: Colors.red,
                                            behavior: SnackBarBehavior.floating,
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                    }
                                  : null, // Disable button if PIN is incorrect
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                              child: Text(
                                "Upload",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isPinCorrect
                                      ? const Color.fromARGB(255, 1, 124, 201)
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Future<bool> uploadFileToDrive(String folderId) async {
    try {
      // Open file picker to allow user to select a file
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        String fileName = result.files.single.name;

        if (kIsWeb) {
          // Handle file upload for web
          Uint8List? fileBytes = result.files.single.bytes;

          if (fileBytes != null && fileBytes.isNotEmpty) {
            // Upload using web-specific logic
            return await GoogleDriveService()
                .uploadFileWeb(folderId, fileBytes, fileName);
          } else {
            debugPrint("No file content available for web.");
            return false;
          }
        } else {
          // Handle file upload for non-web (mobile/desktop)
          String? filePath = result.files.single.path;

          if (filePath != null) {
            return await GoogleDriveService()
                .uploadFileNonWeb(folderId, filePath, fileName);
          } else {
            debugPrint("No file path available for non-web.");
            return false;
          }
        }
      } else {
        debugPrint("No file selected.");
        return false;
      }
    } catch (e) {
      debugPrint("Error during file upload: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
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
          title: const Text(
            "Upload Files",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          trailing: const Icon(
            Icons.cloud_upload,
            color: Colors.blue,
            size: 32,
          ),
          onTap: () => showUploadDialog(context),
        ),
      ),
    );
  }
}
