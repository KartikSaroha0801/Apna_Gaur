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

  @override
  void initState() {
    super.initState();
    // Any initialization if needed
  }

Future<void> _submitForm() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Retrieve the document ID from SharedPreferences
  String? docId = prefs.getString('docId');
  if (docId == null) {
    Get.snackbar('Error', 'Document ID not found!');
    return;
  }

  // Prepare data for updating Firestore
  Map<String, dynamic> listingData = {
    'Age of Property in Years': int.parse(_ageController.text),
    'Available from': _availableFrom,
    // 'Bhk': prefs.getString('bhk'),
    'Carpet Area': _carpetAreaController.text,
    'Facing': _facing,
    'Floor Number': int.parse(_floorNumberController.text),
    'Furnishing': prefs.getString('furnishingType'),
    'Rent': _rentController.text,
    'Society': _societyController.text,
  };

  try {
    // Update the existing document in Firestore
    await FirebaseFirestore.instance.collection('Rent_Flats').doc(docId).update(listingData);
    Get.snackbar('Success', 'Listing updated successfully!');
  } catch (e) {
    Get.snackbar('Error', 'Failed to update listing: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Additional Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Age of Property
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age of Property in Years'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter age of property';
                  }
                  return null;
                },
              ),

              // Carpet Area
              TextFormField(
                controller: _carpetAreaController,
                decoration: InputDecoration(labelText: 'Carpet Area (e.g., 1175 sq ft)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter carpet area';
                  }
                  return null;
                },
              ),

              // Floor Number
              TextFormField(
                controller: _floorNumberController,
                decoration: InputDecoration(labelText: 'Floor Number'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter floor number';
                  }
                  return null;
                },
              ),

              // Rent
              TextFormField(
                controller: _rentController,
                decoration: InputDecoration(labelText: 'Rent'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter rent';
                  }
                  return null;
                },
              ),

              // Society
              TextFormField(
                controller: _societyController,
                decoration: InputDecoration(labelText: 'Society'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter society name';
                  }
                  return null;
                },
              ),

              // Available from (Date picker)
              ListTile(
                title: Text(
                  _availableFrom == null
                      ? 'Select Available Date'
                      : 'Available from: ${_availableFrom!.toLocal()}',
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: _pickAvailableDate,
              ),

              // Facing (Dropdown)
              DropdownButtonFormField<String>(
                value: _facing,
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
                decoration: InputDecoration(labelText: 'Facing'),
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
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
