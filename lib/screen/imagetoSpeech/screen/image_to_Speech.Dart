import 'package:flutter/material.dart';
import 'package:speakable/screen/imagetoSpeech/widget/category_card.dart';
import 'package:speakable/screen/imagetoSpeech/pages/family_page.dart';
import 'package:speakable/screen/imagetoSpeech/pages/food_page.dart';
import 'package:speakable/screen/imagetoSpeech/pages/drinks_page.dart';
import 'package:speakable/screen/imagetoSpeech/pages/travel_page.dart';

class ImageToSpeechScreen extends StatelessWidget {
  const ImageToSpeechScreen({super.key});

  // Simple navigation - just goes to the right page for each category
  void _goToPage(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      
      // Top bar with back button and title
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 2,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
          onPressed: () => Navigator.pop(context),  // Go back to previous screen
        ),
        title: Text(
          'Image to Speech',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      
      // Main content area
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 3),
              
              // Main title
              Text(
                'Choose a Category',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  height: 1,

                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 5),
              
              // Description text
              Text(
                'Select a category to add and manage images',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              const SizedBox(height: 15),
              // Category cards area with rotation support
              Expanded(
                child: OrientationBuilder(
                  builder: (context, orientation) {
                    final isLandscape = orientation == Orientation.landscape;
                    final crossAxisCount = isLandscape ? 2 : 1;
                    final aspectRatio = isLandscape ? 3.0 : 2.5;
                    
                    return GridView.count(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: isLandscape ? 20 : 0,
                      childAspectRatio: aspectRatio,
                      children: [
                    CategoryCard(
                      title: 'Family',
                      icon: Icons.family_restroom,
                      color: Colors.deepPurple,
                      onTap: () => _goToPage(context, const FamilyPage()),
                    ),
                    CategoryCard(
                      title: 'Food',
                      icon: Icons.restaurant,
                      color: Colors.orange,
                      onTap: () => _goToPage(context, const FoodPage()),
                    ),
                    CategoryCard(
                      title: 'Drinks',
                      icon: Icons.local_cafe,
                      color: Colors.blue,
                      onTap: () => _goToPage(context, const DrinksPage()),
                    ),
                    CategoryCard(
                      title: 'Travel',
                      icon: Icons.travel_explore,
                      color: Colors.teal,
                      onTap: () => _goToPage(context, const TravelPage()),
                    ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}