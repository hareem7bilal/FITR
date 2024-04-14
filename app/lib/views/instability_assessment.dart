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
      body: const SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  CustomCard(
                      'Ankle Anterior Drawer Test', ADTDetector()),
                  CustomCard(
                      'Charcotism Detection', CharcotDetector()),
                  CustomCard(
                      'Fracture Detection', FractureDetector()),
                  CustomCard(
                      'Sprain Detection', SprainDetector()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

