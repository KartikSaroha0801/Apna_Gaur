import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions() async {
  var status = await Permission.photos.status;
  if (!status.isGranted) {
    await Permission.photos.request();
  }

  var cameraStatus = await Permission.camera.status;
  if (!cameraStatus.isGranted) {
    await Permission.camera.request();
  }
}

class AdditionalDetailsController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  var imageFiles = <XFile>[].obs; // To hold the picked images
  var uploadedImageUrls = <String>[].obs; // To hold the uploaded image URLs

  // Observable variable for facing
  var facing = 'East'.obs; // Default facing value is set to "East"
  final List<String> facingOptions = ["East", "West", "North", "South"];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>(); // Form key for validation
  final TextEditingController ageController = TextEditingController();
  final TextEditingController carpetAreaController = TextEditingController();
  final TextEditingController floorNumberController = TextEditingController();
  final TextEditingController rentController = TextEditingController();
  final TextEditingController societyController = TextEditingController();

  DateTime? availableFrom;

Future<void> pickImage(ImageSource source) async {
    // Request permissions before picking images
    await requestPermissions();

    // Check permission status
    if (source == ImageSource.gallery && await Permission.photos.isGranted) {
      final pickedFiles = await _picker.pickMultiImage();
      imageFiles.value = pickedFiles;
        } else if (source == ImageSource.camera && await Permission.camera.isGranted) {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        imageFiles.add(pickedFile);
      } else {
        Get.snackbar('Error', 'No image taken');
      }
    } else {
      Get.snackbar('Permission Denied', 'Please enable permissions from settings.');
    }
  }


  /// Upload images to Firebase Storage and return their URLs.
 Future<void> uploadImagesToFirebase(String docId) async {
    if (imageFiles.isEmpty) {
      Get.snackbar('Error', 'No images selected for upload');
      return;
    }

  uploadedImageUrls.clear(); // Clear previous URLs
    for (var file in imageFiles) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('Rent_Flats/$docId/$fileName.jpg');

      try {
      // Upload the file to Firebase Storage
        TaskSnapshot taskSnapshot = await firebaseStorageRef.putFile(File(file.path));

      // Get the download URL after upload
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      // Log the successful upload
      print("Image uploaded successfully: $downloadUrl");

      // Store the image URL in the list
        uploadedImageUrls.add(downloadUrl);

      } catch (e) {
      Get.snackbar('Error', 'Failed to upload image: $e');
      print("Upload error: $e"); // Log the error for debugging
    }
  }

  // Ensure URLs are fetched
  if (uploadedImageUrls.isEmpty) {
    Get.snackbar('Error', 'Image upload failed. No image URLs available.');
  }
}


 Future<void> submitForm() async {
  if (formKey.currentState!.validate())  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? docId = prefs.getString('docId'); // Get the document ID

    if (docId == null) {
      Get.snackbar('Error', 'Document ID not found! Please complete the previous steps.');
      return;
    }

    // Check if image files are selected
    if (imageFiles.isEmpty) {
      Get.snackbar('Error', 'Please select at least one image');
      return;
    }

    try {
      await uploadImagesToFirebase(docId);
      
      // Ensure image URLs are fetched
      if (uploadedImageUrls.isEmpty) {
        Get.snackbar('Error', 'Image upload failed. No image URLs available.');
        return;
      }

    } catch (e) {
      Get.snackbar('Error', 'Image upload failed: $e');
      return;
    }

    // Proceed with the Firestore update if everything is valid
    Map<String, dynamic> listingData = {
      'Age of Property in Years': int.tryParse(ageController.text) ?? 0,
      'Available from': availableFrom, 
      'Carpet Area': carpetAreaController.text,
      'Facing': facing.value,
      'Floor Number': int.tryParse(floorNumberController.text) ?? 0,
      'Rent': rentController.text,
      'Society': societyController.text,
      'Image': uploadedImageUrls.toList(),
    };

    try {
      await FirebaseFirestore.instance.collection('Rent_Flats').doc(docId).update(listingData);
      Get.snackbar('Success', 'Listing updated successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update listing: $e');
    }
  } else {
    Get.snackbar('Error', 'Please complete all required fields');
    }
  }


  /// Pick the available date using a date picker
  void pickAvailableDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
      availableFrom = picked;
  }


  /// Method to update the facing value
  void setFacing(String selectedFacing) {
    facing.value = selectedFacing;
  }
}
