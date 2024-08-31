import 'package:flutter/material.dart';
import 'package:apna_gaur/Resuable_Widgets/search_bar.dart';

class BuyFlat extends StatefulWidget {
  const BuyFlat({super.key});

  @override
  State<BuyFlat> createState() => _BuyFlatState();
}

class _BuyFlatState extends State<BuyFlat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SearchBarWidget(hintText: "Search...", onSearch: (value) {
              print('Search term: $value');    
            },)
          ],
        ),
      ),
    );
  }
}