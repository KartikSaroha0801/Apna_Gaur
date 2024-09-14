import 'package:apna_gaur/UserFlow/rent_flow/upload_2.dart';
import 'package:apna_gaur/Widgets/Components/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final _formKey = GlobalKey<FormState>();
  String? _listingType;
  String? _bhk;
  String? _furnishingType;

  final List<String> _listingTypeOptions = ['Sale', 'Rent'];
  final List<String> _bhkOptions = [
    '1 BHK',
    '2 BHK',
    '2 + 1 BHK',
    '3 BHK',
    '3 + 1 BHK',
    '4 BHK',
    '4 + 1 BHK'
  ];
  final List<String> _furnishingOptions = [
    'Fully Furnished',
    'Semi Furnished',
    'Unfurnished'
  ];

  // Save data to Firestore and SharedPreferences
  Future<void> saveFirstPageData({
    required String listingType,
    required String bhk,
    required String furnishingType,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      DocumentReference docRef =
          await FirebaseFirestore.instance.collection('Rent_Flats').add({
        'Listing Type': listingType,
        'BHK': bhk,
        'Furnishing': furnishingType,
        'created_at': FieldValue.serverTimestamp(),
      });

      String docId = docRef.id; // Get the generated document ID

      // Save to SharedPreferences
      await prefs.setString('docId', docId);
      await prefs.setString('listingType', listingType);
      await prefs.setString('bhk', bhk);
      await prefs.setString('furnishingType', furnishingType);

      Get.snackbar('Success', 'First page data saved with Document ID: $docId');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save data: $e');
    }
  }

  // Custom button builder
  Widget buildSelectableButtons({
    required String label,
    required List<String> options,
    required String? selectedValue,
    required void Function(String) onSelect,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 8),
        Wrap(
          // spacing: 10.0,
          children: options.map((option) {
            bool isSelected = selectedValue == option;
            return GestureDetector(
              onTap: () => onSelect(option),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Color(0xFF1F4C6B) : Colors.grey[200],
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isSelected ? Color(0xFF1F4C6B) : Colors.grey,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    option,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
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
            AppBAR(title: "Upload your Listing"),
            Expanded(
              child: SingleChildScrollView(
                // Wrap the content in SingleChildScrollView
                child: Column(
                  children: [
                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Please Fill detail of your Flat Listing ',
                                    style: TextStyle(
                                      color: Color(0xFF242B5C),
                                      fontSize: 18,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w500,
                                    ),
                                    ), 
                                ],
                              ),
                              softWrap: true,
                            ),
                            SizedBox(
                              height: screenHeight * 0.02,
                            ),

                            // Listing Type Buttons
                            buildSelectableButtons(
                              label: "Listing Type",
                              options: _listingTypeOptions,
                              selectedValue: _listingType,
                              onSelect: (value) {
                                setState(() {
                                  _listingType = value;
                                });
                              },
                            ),

                            // BHK Buttons
                            buildSelectableButtons(
                              label: "BHK",
                              options: _bhkOptions,
                              selectedValue: _bhk,
                              onSelect: (value) {
                                setState(() {
                                  _bhk = value;
                                });
                              },
                            ),

                            // Furnishing Buttons
                            buildSelectableButtons(
                              label: "Furnishing",
                              options: _furnishingOptions,
                              selectedValue: _furnishingType,
                              onSelect: (value) {
                                setState(() {
                                  _furnishingType = value;
                                });
                              },
                            ),

                            SizedBox(height: screenHeight * 0.01),
                            Lottie.asset("assets/images/form_lottie.json",
                                height: screenHeight * 0.1,
                                fit: BoxFit.fitHeight),

                            SizedBox(height: screenHeight * 0.02),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (_formKey.currentState?.validate() == true) {
                        await saveFirstPageData(
                          listingType: _listingType!,
                          bhk: _bhk!,
                          furnishingType: _furnishingType!,
                        );
                        Get.to(() => AdditionalDetailsPage());
                      } else {
                        Get.snackbar('Error', 'Please fill in all fields.');
                      }
                    },
                    child: Container(
                      width: screenWidth * 0.6,
                      height: screenHeight * 0.06,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(29),
                      ),
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Text(
                            "Next",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
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
    );
  }
}
