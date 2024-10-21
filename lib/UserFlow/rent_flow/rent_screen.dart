import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:apna_gaur/Resuable_Widgets/search_bar.dart';
import 'package:apna_gaur/UserFlow/rent_flow/flat_detail_page.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class Flat {
  final String bhk;
  final List<String> images;
  final int? rent;
  final String society;
  final String carpetArea;
  final int ageOfProperty;
  final String facing;
  final int floorNumber;
  final String furnishing;
  final DateTime availableFrom;

  Flat({
    required this.bhk,
    required this.images,
    this.rent,
    required this.society,
    required this.carpetArea,
    required this.ageOfProperty,
    required this.facing,
    required this.floorNumber,
    required this.furnishing,
    required this.availableFrom,
  });

  factory Flat.fromJson(Map<String, dynamic> json) {
    return Flat(
      bhk: json['BHK'] ?? 'Not specified',
      images: json['Image'] != null ? List<String>.from(json['Image']) : [],
      rent: json['Rent'] != null ? int.tryParse(json['Rent'].toString()) : null,
      society: json['Society'] ?? 'Not specified',
      carpetArea: json['Carpet Area'] ?? 'Not specified',
      ageOfProperty: json['Age of Property in Years'] ?? 0,
      facing: json['Facing'] ?? 'Not specified',
      floorNumber: json['Floor Number'] ?? 0,
      furnishing: json['Furnishing'] ?? 'Not specified',
      availableFrom: (json['Available from'] as Timestamp).toDate(),
    );
  }
}

class RentScreen extends StatefulWidget {
  const RentScreen({super.key});

  @override
  State<RentScreen> createState() => _RentScreenState();
}

class _RentScreenState extends State<RentScreen> {
  late Future<List<Flat>> flatsFuture;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    flatsFuture = fetchFlats(); // Fetch all flats by default
  }

 Future<List<Flat>> fetchFlats({String searchQuery = ''}) async {
  Query query = FirebaseFirestore.instance.collection('Rent_Flats');
  
  if (searchQuery.isNotEmpty) {
    String searchKey = searchQuery.toLowerCase();
    
    // Fetch results where the 'Society' starts with the search query (case-insensitive)
    query = query
      .where('Society', isGreaterThanOrEqualTo: searchKey)
      .where('Society', isLessThanOrEqualTo: searchKey + '\uf8ff'); // \uf8ff is a high Unicode character to extend the range
  }
  
  final QuerySnapshot querySnapshot = await query.get();
  final List<Flat> flats = [];
  for (var doc in querySnapshot.docs) {
    final data = doc.data() as Map<String, dynamic>;
    flats.add(Flat.fromJson(data));
  }
  return flats;
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SearchBarWidget(
  hintText: "Search by Society...",
  onSearch: (value) {
    setState(() {
      searchQuery = value.toLowerCase(); // Convert to lowercase for consistent searching
      flatsFuture = fetchFlats(searchQuery: searchQuery);
    });
  },
),

            Expanded(
              child: FutureBuilder<List<Flat>>(
                future: flatsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  } else {
                    final flats = snapshot.data!;
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 0.75, // Adjust aspect ratio for a balanced layout
                      ),
                      padding: const EdgeInsets.all(8),
                      itemCount: flats.length,
                      itemBuilder: (context, index) {
                        final flat = flats[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FlatDetailsPage(
                                  bhk: flat.bhk,
                                  rent: flat.rent,
                                  society: flat.society,
                                  carpetArea: flat.carpetArea ?? 'N/A',
                                  ageOfProperty: flat.ageOfProperty,
                                  facing: flat.facing,
                                  floorNumber: flat.floorNumber,
                                  furnishing: flat.furnishing,
                                  availableFrom: flat.availableFrom,
                                  images: flat.images,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: flat.images.isNotEmpty
                                        ? Image.network(
                                            flat.images[0],
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            loadingBuilder: (BuildContext context, Widget child,
                                                ImageChunkEvent? loadingProgress) {
                                              if (loadingProgress == null) return child;
                                              return Shimmer.fromColors(
                                                baseColor: Colors.grey[300]!,
                                                highlightColor: Colors.grey[100]!,
                                                child: Container(
                                                  color: Colors.grey[300],
                                                ),
                                              );
                                            },
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container(
                                                child: Lottie.asset("assets/images/home_n_animation.json"),
                                              );
                                            },
                                          )
                                        : Container(
                                                child: Lottie.asset("assets/images/home_n_animation.json"),
                                              ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          flat.bhk,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Rent: ${flat.rent != null ? 'Rs. ${flat.rent}' : 'Not Available'}',
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          flat.society,
                                          style: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}