// Uploading files to Cloudinary
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

Future<String?> uploadToCloudinary(XFile? xFile) async {
  if (xFile == null) {
    print("No file selected!");
    return null;
  }

  // Get Cloudinary credentials from environment variables
  final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
  final uploadPreset = dotenv.env['CLOUDINARY_UPLOAD_PRESET'] ?? '';

  if (cloudName.isEmpty || uploadPreset.isEmpty) {
    print("Cloudinary configuration is missing!");
    return null;
  }

  try {
    // Create a MultipartRequest for the upload
    final uri =
        Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");
    final request = http.MultipartRequest("POST", uri);

    // Add file to the request
    final fileBytes = await xFile.readAsBytes();
    final multipartFile = http.MultipartFile.fromBytes(
      'file',
      fileBytes,
      filename: xFile.name,
    );

    request.files.add(multipartFile);

    // Add upload preset and other fields
    request.fields['upload_preset'] = uploadPreset;

    // Send the request
    final response = await request.send();

    // Parse the response
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(responseBody);
      print("Upload successful! URL: ${jsonResponse["secure_url"]}");
      return jsonResponse["secure_url"];
    } else {
      print("Upload failed with status: ${response.statusCode}");
      print("Response: $responseBody");
      return null;
    }
  } catch (e) {
    print("Error during upload: $e");
    return null;
  }
}
