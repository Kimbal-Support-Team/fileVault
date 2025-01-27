import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/drive/v3.dart' as drive;

class GoogleDriveService {
  final String _credentialsFile =
      dotenv.env['CREDENTIAL_FILE_PATH']!; // Update path if needed

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

  Future<bool> uploadFileNonWeb(
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

      debugPrint("File uploaded successfully!");
      return true;
    } catch (e) {
      debugPrint("Error uploading file: $e");
      return false;
    }
  }

  Future<List<drive.File>> fetchFolderContents(String folderId) async {
    try {
      final driveApi = await _authenticate();

      // List files and folders in the specified folder
      final fileList = await driveApi.files.list(
        q: "'$folderId' in parents",
        spaces: 'drive',
        $fields: 'files(id, name, mimeType,modifiedTime,parents, size)',
      );

      return fileList.files ?? [];
    } catch (e) {
      debugPrint("Error fetching folder contents: $e");
      return [];
    }
  }

  Future<bool> uploadFileWeb(
      String folderId, Uint8List fileBytes, String fileName) async {
    try {
      Stream<List<int>> byteStream = Stream.fromIterable([fileBytes]);

      final driveApi = await _authenticate();

      final driveFile = drive.File()
        ..name = fileName
        ..parents = [folderId];

      await driveApi.files.create(
        driveFile,
        uploadMedia: drive.Media(byteStream, fileBytes.length),
      );

      debugPrint("File uploaded successfully!");
      return true;
    } catch (e) {
      debugPrint("Error uploading file: $e");
      return false;
    }
  }

  Future<bool> downloadFile(String fileId) async {
    try {
      final driveApi = await _authenticate();
      final drive.File fileMetadata =
          await driveApi.files.get(fileId) as drive.File;
      final fileName = fileMetadata.name;
      // Ask the user where to save the file
      final directory = await getSavePath(fileName!);

      if (directory == null) {
        return false;
      }

      final file = await driveApi.files.get(fileId, downloadOptions: drive.DownloadOptions.fullMedia) as drive.Media;
      final saveFile = File(directory);
      final fileStream = saveFile.openWrite();

      await file.stream.pipe(fileStream);
      await fileStream.flush();
      await fileStream.close();


      return true;
    } catch (e) {
      debugPrint("Error downloading file: $e");
      return false;
    }
  }

  Future<String?> getSavePath(String fileName) async {
    String? result;
    if (Platform.isAndroid || Platform.isIOS) {
      if (kIsWeb) {
        // Web-specific file saving logic
        result = fileName; // Just return the file name as path
      } else {
        result = await FilePicker.platform.saveFile(
          dialogTitle: 'Please select an output file:',
          fileName: fileName,
        );
      }
    } else {
      result = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select an output file:',
      fileName: fileName,
      );
    }
    return result;
  }
}
