import 'package:flutter/material.dart';
import 'DL_models/adt_detector.dart';
import 'DL_models/charcot_detector.dart';
import 'DL_models/fracture_detector.dart';
import 'DL_models/sprain_detector.dart';
import '../widgets/custom_card.dart';

class InstabilityDetector extends StatelessWidget {
  const InstabilityDetector({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

 
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instability Assessment'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
              crossAxisSpacing: 16, // Space between columns
              mainAxisSpacing: 16, // Space between rows
              childAspectRatio: 1, // Ratio to make it square
            ),
            itemCount: 4, // The number of CustomCards
            itemBuilder: (context, index) {
              List<CustomCard> cards = [
                  const CustomCard(
                      label:'Ankle Anterior Drawer Test', viewPage: ADTDetector(),imageUrl: 'assets/images/custom_card/adt.png',),
                  const CustomCard(
                       label:'Charcotism Detection', viewPage:CharcotDetector(), imageUrl: 'assets/images/custom_card/charcot.jpg',),
                  const CustomCard(
                       label:'Fracture Detection', viewPage:FractureDetector(),imageUrl: 'assets/images/custom_card/fracture.png',),
                  const CustomCard(
                       label:'Sprain Detection', viewPage:SprainDetector(),imageUrl: 'assets/images/custom_card/sprain.png',),
                
              ];

              return cards[index]; // Return the CustomCard based on the index
            },
          ),
        ),
      ),
    );
  }
 
}
