import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

/// Profile view demonstrating Material 3 design with GetX
class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up),
            onPressed: controller.speakProfile,
            tooltip: 'Speak Profile',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile Card
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      // Avatar
                      const CircleAvatar(
                        radius: 50,
                        child: Icon(Icons.person, size: 50),
                      ),
                      const SizedBox(height: 16),

                      // User Name
                      Text(
                        controller.userName.value,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),

                      // User Email
                      Text(
                        controller.userEmail.value,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                      const SizedBox(height: 16),

                      // Profile Views
                      Chip(
                        avatar: const Icon(Icons.visibility),
                        label: Text(
                          '${controller.profileViews.value} profile views',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Edit Name Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Edit Profile',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.edit),
                        ),
                        onSubmitted: controller.updateUserName,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Actions
              FilledButton.icon(
                onPressed: controller.speakProfile,
                icon: const Icon(Icons.volume_up),
                label: const Text('Speak Profile'),
              ),
              const SizedBox(height: 12),

              OutlinedButton.icon(
                onPressed: controller.clearProfileData,
                icon: const Icon(Icons.delete_outline),
                label: const Text('Clear Profile Data'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
