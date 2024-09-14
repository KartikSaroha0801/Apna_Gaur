import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ListingController extends GetxController {
  var selectedListingType = ''.obs;
  var selectedPropertyCategory = ''.obs;
  var selectedFurnishingType = ''.obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void selectListingType(String type) {
    selectedListingType.value = type;
  }

  void selectBHKCategory(String category) {
    selectedPropertyCategory.value = category;
  }

  void selectFurnishing(String furnishing) {
    selectedFurnishingType.value = furnishing;
  }

  bool get isFormValid => selectedListingType.isNotEmpty &&
      selectedPropertyCategory.isNotEmpty &&
      selectedFurnishingType.isNotEmpty;

  Future<void> saveListingData() async {
    try {
      await firestore.collection('Rent_Flats').add({
        'Listing Type': selectedListingType.value,
        'BHK': selectedPropertyCategory.value,
        'Furnishing': selectedFurnishingType.value,
        'created_at': FieldValue.serverTimestamp(),
      });
      Get.snackbar('Success', 'Listing saved successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save listing: $e');
    }
  }
}
