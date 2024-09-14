import 'package:apna_gaur/Widgets/Components/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdditionalDetailsPage extends StatefulWidget {
  const AdditionalDetailsPage({Key? key}) : super(key: key);

  @override
  _AdditionalDetailsPageState createState() => _AdditionalDetailsPageState();
}

class _AdditionalDetailsPageState extends State<AdditionalDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _carpetAreaController = TextEditingController();
  final TextEditingController _floorNumberController = TextEditingController();
  final TextEditingController _rentController = TextEditingController();
  final TextEditingController _societyController = TextEditingController();
  DateTime? _availableFrom;
  String _facing = "East";
  final List<String> _facingOptions = ["East", "West", "North", "South"];

  Future<void> _submitForm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? docId = prefs.getString('docId');
    if (docId == null) {
      Get.snackbar('Error', 'Document ID not found!');
      return;
    }

    Map<String, dynamic> listingData = {
      'Age of Property in Years': int.parse(_ageController.text),
      'Available from': _availableFrom,
      'Carpet Area': _carpetAreaController.text,
      'Facing': _facing,
      'Floor Number': int.parse(_floorNumberController.text),
      'Rent': _rentController.text,
      'Society': _societyController.text,
    };

    try {
      await FirebaseFirestore.instance.collection('Rent_Flats').doc(docId).update(listingData);
      Get.snackbar('Success', 'Listing updated successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update listing: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            AppBAR(title: "Additional Details"),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16,),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: screenHeight * 0.03),
                            Text(
                              'Fill in additional details for your Listing:',
                              style: TextStyle(
                                color: Color(0xFF242B5C),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.03),
                                  
                            // Age of Property
                            _buildTextField(
                              label: 'Age of Property in Years',
                              controller: _ageController,
                              keyboardType: TextInputType.number,
                              icon: Icons.calendar_today,
                            ),
                                  
                            // Carpet Area
                            _buildTextField(
                              label: 'Carpet Area (e.g., 1175 sq ft)',
                              controller: _carpetAreaController,
                              icon: Icons.aspect_ratio,
                            ),
                                  
                            // Floor Number
                            _buildTextField(
                              label: 'Floor Number',
                              controller: _floorNumberController,
                              keyboardType: TextInputType.number,
                              icon: Icons.stairs,
                            ),
                                  
                            // Rent
                            _buildTextField(
                              label: 'Rent',
                              controller: _rentController,
                              keyboardType: TextInputType.number,
                              icon: Icons.money,
                            ),
                                  
                            // Society
                            _buildTextField(
                              label: 'Society',
                              controller: _societyController,
                              icon: Icons.location_city,
                            ),
                                  
                            // Available from (Date picker)
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                _availableFrom == null
                                    ? 'Select Available Date'
                                    : 'Available from: ${_availableFrom!.toLocal().toString().split(' ')[0]}',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 18,
                                ),
                              ),
                              trailing: Icon(Icons.calendar_today, color: Colors.black54),
                              onTap: _pickAvailableDate,
                            ),
                            SizedBox(height: 20),
                                  
                            // Facing (Dropdown)
                            DropdownButtonFormField<String>(
                              value: _facing,
                              decoration: InputDecoration(
                                labelText: 'Facing',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              items: _facingOptions.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _facing = newValue!;
                                });
                              },
                            ),
                            SizedBox(height: 30),
                                  
                            // Submit Button
                            GestureDetector(
                              onTap: _submitForm,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: screenWidth * 0.6,
                                    height: screenHeight * 0.06,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(29),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Submit",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 21,
                                          fontFamily: 'Lato',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.black54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Future<void> _pickAvailableDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _availableFrom = picked;
      });
    }
  }
}
