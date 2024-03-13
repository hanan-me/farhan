import 'package:flutter/material.dart';

import 'Dashborad.dart';

class VotingGuidePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Home(),
            ),
          ), // This will pop the current screen and navigate back to the previous screen
          icon: const Icon(Icons.arrow_back, color: Colors.greenAccent),
        ),
        title: const Text("Voter Guide"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How to Vote:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                '1. Click On the vote Button',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '2. Select Vote Type.',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '3. Choose the PP and NA according to your Area  .',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '4. Select the Province .',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '5. Select the City .',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '6. Select the Area .',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '7. Choose Candidates in the given list .',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '8. Cast your Vote  .',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Tips:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                '- Read the instructions carefully.',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '- Ensure your vote is private.',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '- Double-check your choice before submitting.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'طریقہ کار ووٹ دینے کا:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                '1. ووٹ بٹن پر کلک کریں۔',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '2. ووٹ کی قسم کا انتخاب کریں۔',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '3. اپنے علاقے کے مطابق پیپی اور این اے کا انتخاب کریں۔',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '4. صوبہ کا انتخاب کریں۔',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '5. شہر کا انتخاب کریں۔',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '6. علاقہ کا انتخاب کریں۔',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '7. دیے گئے فہرست میں امیدواروں کا انتخاب کریں۔',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '8. اپنا ووٹ دیں۔',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'نکات:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                '- ہدایات کو دھیان سے پڑھیں۔',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '- یقینی بنائیں کہ آپ کا ووٹ نجی ہے۔',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '- اپنی منتخبی کو دوبارہ چیک کریں پہلے سبمٹ کرنے سے۔',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
