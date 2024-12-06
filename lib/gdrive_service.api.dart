import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/drive/v3.dart' as drive;

class GoogleDriveService {
  final String _credentialsFile =
      'assets/filevault-443909-434a0b313409.json'; // Update path if needed

  Future<drive.DriveApi> _authenticate() async {
    // Load the service account credentials from the JSON file
    final jsonCredentials = await rootBundle.loadString(_credentialsFile);
    final credentialsMap = jsonDecode(jsonCredentials);

    final accountCredentials =
        ServiceAccountCredentials.fromJson(credentialsMap);

    // Define required scopes
    final scopes = [drive.DriveApi.driveScope];

    // Authenticate and obtain an authenticated client
    final client = await clientViaServiceAccount(accountCredentials, scopes);
    final driveApi = drive.DriveApi(client);

    return driveApi;
  }

  Future<bool> uploadFile(
      String folderId, String filePath, String fileName) async {
    try {
      final driveApi = await _authenticate();

      // Prepare the file to upload
      final file = File(filePath);
      final fileStream = file.openRead();
      final media = drive.Media(fileStream, await file.length());

      // Create the file metadata
      final driveFile = drive.File()
        ..name = fileName
        ..parents = [folderId];

      // Upload the file
      await driveApi.files.create(
        driveFile,
        uploadMedia: media,
      );

      print("File uploaded successfully!");
      return true;
    } catch (e) {
      print("Error uploading file: $e");
      return false;
    }
  }
}
