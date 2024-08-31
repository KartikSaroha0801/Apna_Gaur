import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  final ValueChanged<String>? onSearch; // Optional callback for search updates
  final String hintText; // Hint text for the TextField

  const SearchBarWidget({Key? key, this.onSearch, required this.hintText})
      : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: 50, // Adjust height as needed
      decoration: BoxDecoration(
        color: const Color(0xFFe4e4d6),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          children: [
            const Icon(Icons.search),
            const SizedBox(width: 10.0), // Add spacing between icon and TextField
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: widget.onSearch, // Call the onSearch callback if provided
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  border: InputBorder.none, // Remove default border for a cleaner look
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
