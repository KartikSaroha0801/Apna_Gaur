import 'package:apna_gaur/Widgets/Components/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'upload_2.dart';

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
  final List<String> _bhkOptions = ['1 BHK', '2 BHK', '3 BHK', '4 BHK'];
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
      // Save data to Firestore and get the document ID
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
                            text: 'Please Fill detail of your \n',
                            style: TextStyle(
                              color: Color(0xFF242B5C),
                              fontSize: 25,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: 'flat listing ',
                            style: TextStyle(
                              color: Color(0xFF1F4C6B),
                              fontSize: 25,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      softWrap: true,
                    ),
                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    // Listing Type Dropdown
                    DropdownButtonFormField<String>(
                      decoration:
                          const InputDecoration(labelText: 'Listing Type'),
                      items: _listingTypeOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _listingType = newValue;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Please select listing type' : null,
                    ),
                    // BHK Dropdown
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'BHK'),
                      items: _bhkOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _bhk = newValue;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Please select BHK' : null,
                    ),

                    // Furnishing Dropdown
                    DropdownButtonFormField<String>(
                      decoration:
                          const InputDecoration(labelText: 'Furnishing'),
                      items: _furnishingOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _furnishingType = newValue;
                        });
                      },
                      validator: (value) => value == null
                          ? 'Please select furnishing type'
                          : null,
                    ),

                    const SizedBox(height: 20),

                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              if (_formKey.currentState?.validate() == true) {
                                // Save data to Firestore and SharedPreferences
                                await saveFirstPageData(
                                  listingType: _listingType!,
                                  bhk: _bhk!,
                                  furnishingType: _furnishingType!,
                                );
                                Get.to(() => const AdditionalDetailsPage());
                              } else {
                                Get.snackbar(
                                    'Error', 'Please fill in all fields.');
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
            ),
          ],
        ),
      ),
    );
  }
}
