import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

Future<void> saveFirstPageData({
  required String listingType,
  required String bhk,
  required String furnishingType,
}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  try {
    // Add data to Firestore and let Firebase generate the document ID
    DocumentReference docRef = await FirebaseFirestore.instance.collection('Rent_Flats').add({
      'Listing Type': listingType,
      'BHK': bhk,
      'Furnishing': furnishingType,
      'created_at': FieldValue.serverTimestamp(),
    });

    // Get the generated document ID
    String docId = docRef.id;

    // Save the document ID and other data to SharedPreferences
    await prefs.setString('docId', docId);
    await prefs.setString('listingType', listingType);
    await prefs.setString('bhk', bhk);
    await prefs.setString('furnishingType', furnishingType);

    Get.snackbar('Success', 'First page data saved with Document ID: $docId');
  } catch (e) {
    Get.snackbar('Error', 'Failed to save data: $e');
  }
}