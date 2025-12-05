import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speakable/screen/emergency/widget/emergency_card.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          SafeArea(
            child: OrientationBuilder(
              builder: (context, orientation) {
                final isLandscape = orientation == Orientation.landscape;
                final crossAxisCount = isLandscape ? 4 : 2;
                final childAspectRatio = isLandscape ? 1.1 : 0.9;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Alert Banner
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.red.shade600, Colors.red.shade400],
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.warning_rounded,
                              color: Colors.white,
                              size: 40,
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Expanded(
                                        child: Text(
                                          'Emergency Communication',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.info_outline,
                                          color: Colors.white,
                                        ),
                                        onPressed: () =>
                                            _showInfoDialog(context),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    'Tap any button to speak the message loudly',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Critical Emergency Section
                      Text(
                        'Critical Emergency',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      const SizedBox(height: 15),

                      LayoutBuilder(
                        builder: (context, constraints) {
                          const spacing = 15.0;
                          final double widthForFourColumns =
                              (constraints.maxWidth -
                                  (crossAxisCount - 1) * spacing) /
                              crossAxisCount;
                          final double targetWidth =
                              widthForFourColumns * 2 +
                              spacing; // two cards + spacing
                          final double gridWidth = isLandscape
                              ? (targetWidth > constraints.maxWidth
                                    ? constraints.maxWidth
                                    : targetWidth)
                              : constraints.maxWidth;

                          return Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: gridWidth,
                              child: GridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: isLandscape
                                    ? 2
                                    : crossAxisCount,
                                mainAxisSpacing: spacing,
                                crossAxisSpacing: spacing,
                                childAspectRatio: childAspectRatio,
                                children: const [
                                  EmergencyCard(
                                    imagePath: 'assets/images/police-icon.png',
                                    title: 'Call Police',
                                    message:
                                        'Emergency! Please call the police immediately! I need help!',
                                    color: Colors.blue,
                                  ),
                                  EmergencyCard(
                                    imagePath:
                                        "assets/images/emergency-page-icon-ambulance.jpg",
                                    title: 'Need Ambulance',
                                    message:
                                        'Emergency! I need an ambulance! Please call emergency services!',
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 30),

                      // Medical Emergency Section
                      Text(
                        'Medical Emergency',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      const SizedBox(height: 15),

                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                        childAspectRatio: childAspectRatio,

                        children: const [
                          EmergencyCard(
                            imagePath: "assets/images/doctor-icon.png",
                            title: 'Need Doctor',
                            message:
                                'I need a doctor urgently! Please help me get medical attention!',
                            color: Colors.orange,
                          ),
                          EmergencyCard(
                            imagePath: "assets/images/hospital-image.png",
                            title: 'Go to Hospital',
                            message:
                                'I need to go to the hospital immediately! Please take me to the hospital!',
                            color: Colors.purple,
                          ),
                          EmergencyCard(
                            imagePath: "assets/images/chest-pain-image.png",
                            title: 'Chest Pain',
                            message:
                                'I have severe chest pain! I need medical help immediately! Call emergency services!',
                            color: Colors.red,
                          ),
                          EmergencyCard(
                            imagePath: "assets/images/medicine-image.jpg",
                            title: 'Need Medicine',
                            message:
                                'I need my medicine urgently! Please help me get my medication!',
                            color: Colors.teal,
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // General Help Section
                      Text(
                        'General Help',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      const SizedBox(height: 15),

                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                        childAspectRatio: childAspectRatio,
                        children: const [
                          EmergencyCard(
                            imagePath: "assets/images/need-help-image.png",
                            title: 'Need Help',
                            message:
                                'I need help! Please assist me! Can someone help me?',
                            color: Colors.green,
                          ),
                          EmergencyCard(
                            icon: Icons.water_drop,
                            title: 'Need Water',
                            message:
                                'I need water please! Can someone bring me water?',
                            color: Colors.blue,
                          ),
                          EmergencyCard(
                            icon: Icons.phone,
                            title: 'Call Someone',
                            message:
                                'Please call my family! I need to contact someone urgently!',
                            color: Colors.indigo,
                          ),
                          EmergencyCard(
                            icon: Icons.supervisor_account_rounded,
                            title: 'Need Assistance',
                            message:
                                'I need assistance! Please help me! I cannot speak!',
                            color: Colors.deepPurple,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.black,
                  onPressed: () => Get.back(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.info, color: Colors.red),
            SizedBox(width: 10),
            Text(
              'How to Use',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'This screen helps you communicate during emergencies when you cannot speak.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 15),
              Text(
                '1. Tap any button',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text('The message will be spoken out loud once.'),
              SizedBox(height: 15),
              Text('2. Volume', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text('Make sure your device volume is turned up high.'),
              SizedBox(height: 15),
              Text(
                '3. Stop Speaking',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text('Tap the button again to stop the message.'),
              SizedBox(height: 15),
              Text(
                '4. Emergency',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text('Use the red buttons for life-threatening situations.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }
}
