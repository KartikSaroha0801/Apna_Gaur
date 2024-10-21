import 'dart:io';
import 'package:apna_gaur/Controller/additional_listing_controller.dart';
import 'package:apna_gaur/Widgets/Components/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apna_gaur/Widgets/Components/appbar.dart';
import 'package:image_picker/image_picker.dart';



class AdditionalDetailsPage extends StatelessWidget {
  final AdditionalDetailsController controller =
      Get.put(AdditionalDetailsController());

  @override
  Widget build(BuildContext context) {
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
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Form(
                        key: controller.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            Text(
                              'Fill in additional details for your Listing:',
                              style: TextStyle(
                                color: Color(0xFF242B5C),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),

                            // Form Fields
                            _buildTextField(
                              label: 'Age of Property in Years',
                              controller: controller.ageController,
                              keyboardType: TextInputType.number,
                              icon: Icons.calendar_today,
                            ),
                            _buildTextField(
                              label: 'Carpet Area (e.g., 1175 sq ft)',
                              controller: controller.carpetAreaController,
                              icon: Icons.aspect_ratio,
                            ),
                            _buildTextField(
                              label: 'Floor Number',
                              controller: controller.floorNumberController,
                              keyboardType: TextInputType.number,
                              icon: Icons.stairs,
                            ),
                            _buildTextField(
                              label: 'Rent',
                              controller: controller.rentController,
                              keyboardType: TextInputType.number,
                              icon: Icons.money,
                            ),
                            _buildTextField(
                              label: 'Society',
                              controller: controller.societyController,
                              icon: Icons.location_city,
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Obx(() {
                                return DropdownButtonFormField<String>(
                                  value: controller.facing.value,
                                  items: controller.facingOptions
                                      .map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    controller.setFacing(newValue!);
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Facing',
                                    prefixIcon: Icon(Icons.compass_calibration),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  isExpanded: true,
                                );
                              }),
                            ),
                            ListTile(
                                  title: Text(
                                    controller.availableFrom == null
                                      ? 'Select Available Date'
                                        : 'Available from: ${controller.availableFrom!.toLocal().toString().split(' ')[0]}',
                                  style: TextStyle(fontSize: 18),
                                  ),
                              trailing: Icon(Icons.calendar_today),
                                  onTap: () =>
                                      controller.pickAvailableDate(context),
                            ),


                            // Image picker buttons
                            Row(
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () =>
                                      controller.pickImage(ImageSource.gallery),
                                  icon: Icon(Icons.photo_library),
                                  label: Text('Pick from Gallery'),
                                ),
                                SizedBox(width: 10),
                                ElevatedButton.icon(
                                  onPressed: () =>
                                      controller.pickImage(ImageSource.camera),
                                  icon: Icon(Icons.camera),
                                  label: Text('Take Photo'),
                                ),
                              ],
                            ),

                            SizedBox(height: 10),

                            // Display selected images
                            Obx(() {
                              return controller.imageFiles.isNotEmpty
                                  ? SizedBox(
                                      height: 100,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: controller.imageFiles.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.file(
                                              File(controller
                                                  .imageFiles[index].path),
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : Text("No images selected");
                            }),

                            SizedBox(height: 30),

                            // Submit Button
                            GestureDetector(
                              onTap: () {
                                if (controller.formKey.currentState!
                                    .validate()) {
                                  // Validate using the widget's form key
                                  controller.submitForm();
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    height: MediaQuery.of(context).size.height *
                                        0.06,
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
}
