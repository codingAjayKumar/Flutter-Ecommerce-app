// import 'dart:io';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class StorageService {
//   // Cloudinary credentials
//   final String cloudName = 'dyemjjk1o';
//   final String uploadPreset = 'iavpipif'; // Your preset
//   final String uploadUrl =
//       'https://api.cloudinary.com/v1_1/dyemjjk1o/image/upload';

//   // To UPLOAD IMAGE TO CLOUDINARY
//   Future<String?> uploadImage(String path, BuildContext context) async {
//     ScaffoldMessenger.of(context)
//         .showSnackBar(const SnackBar(content: Text("Uploading image...")));
//     print("Uploading image...");

//     File file = File(path);

//     try {
//       // Read the file as bytes
//       List<int> imageBytes = await file.readAsBytes();

//       // Prepare the multipart request
//       var uri = Uri.parse(uploadUrl);
//       var request = http.MultipartRequest('POST', uri);

//       // Add the image as part of the form data
//       request.files.add(http.MultipartFile.fromBytes(
//         'file', // The key 'file' is required by Cloudinary
//         imageBytes,
//         filename: 'image_${DateTime.now().millisecondsSinceEpoch}.jpg',
//       ));

//       // Add the upload preset to the request fields
//       request.fields['upload_preset'] = uploadPreset;

//       // Send the request
//       var response = await request.send();

//       // Handle the response
//       if (response.statusCode == 200) {
//         // If successful, extract the response body
//         String responseBody = await response.stream.bytesToString();
//         var jsonResponse = json.decode(responseBody);

//         // Get the URL of the uploaded image
//         String imageUrl = jsonResponse['secure_url'];
//         print("Image uploaded successfully: $imageUrl");
//         return imageUrl;
//       } else {
//         // Handle failure
//         String errorResponse = await response.stream.bytesToString();
//         var errorJson = json.decode(errorResponse);
//         String errorMessage = errorJson['error']['message'] ?? 'Unknown error';
//         print("Failed to upload image: $errorMessage");
//         return null;
//       }
//     } catch (e) {
//       print("Error uploading image: $e");
//       return null;
//     }
//   }
// }

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // TO UPLOAD IMAGE TO FIREBASE STORAGE
  Future<String?> uploadImage(String path, BuildContext context) async {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Uploading image...")));
    print("Uploading image...");
    File file = File(path);
    try {
      // Create a unique file name based on the current time
      String fileName = DateTime.now().toString();

      // Create a reference to Firebase Storage
      Reference ref = _storage.ref().child("shop_images/$fileName");

      // Upload the file
      UploadTask uploadTask = ref.putFile(file);

      // Wait for the upload to complete
      await uploadTask;

      // Get the download URL
      String downloadURL = await ref.getDownloadURL();
      print("Download URL: $downloadURL");
      return downloadURL;
    } catch (e) {
      print("There was an error");
      print(e);

      return null;
    }
  }
}
