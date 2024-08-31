import 'package:flutter/material.dart';

class FlatDetailsPage extends StatefulWidget {
  final String bhk;
  final int? rent;
  final String society;
  final String carpetArea;
  final int ageOfProperty;
  final String facing;
  final int floorNumber;
  final String furnishing;
  final DateTime availableFrom;
  final List<String> images;

  FlatDetailsPage({
    required this.bhk,
    required this.rent,
    required this.society,
    required this.carpetArea,
    required this.ageOfProperty,
    required this.facing,
    required this.floorNumber,
    required this.furnishing,
    required this.availableFrom,
    required this.images,
  });

  @override
  _FlatDetailsPageState createState() => _FlatDetailsPageState();
}

class _FlatDetailsPageState extends State<FlatDetailsPage> {
  int _currentPage = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Property Details'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image Section
            if (widget.images.isNotEmpty)
              Container(
                height: 250,
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                      itemCount: widget.images.length,
                      itemBuilder: (context, index) {
                        return Image.network(
                          widget.images[index],
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        color: Colors.black54,
                        child: Text(
                          'Image ${_currentPage + 1} of ${widget.images.length}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),

            // Property Summary Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.bhk} in ${widget.society}',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rent: ${widget.rent != null ? 'Rs. ${widget.rent}/month' : 'Not Available'}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(thickness: 1, height: 32),

            // Details Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Carpet Area', widget.carpetArea, Icons.aspect_ratio),
                  _buildDetailRow('Age of Property', '${widget.ageOfProperty} years',
                      Icons.calendar_today),
                  _buildDetailRow('Facing', widget.facing, Icons.explore),
                  _buildDetailRow('Floor Number', '${widget.floorNumber}',
                      Icons.elevator),
                  _buildDetailRow('Furnishing', widget.furnishing, Icons.chair),
                  _buildDetailRow('Available From',
                      '${widget.availableFrom.toLocal()}', Icons.calendar_today),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Book Now Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle booking action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding:
                      EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  'Book Now',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.teal),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
