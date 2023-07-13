import 'dart:io';

import 'package:favorite_palces/models/place.dart';
import 'package:favorite_palces/providers/user_places.dart';
import 'package:favorite_palces/widgets/image_input.dart';
import 'package:favorite_palces/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _AddPlaceScreenState();
  }
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final titleController = TextEditingController();
  File? selectedImage;
  PlaceLocation? selectedLocation;
  void savePlace() {
    final enteredTitle = titleController.text;
    if (enteredTitle.isEmpty ||
        selectedImage == null ||
        selectedLocation == null) {
      return;
    }

    ref
        .read(userPlacesProvider.notifier)
        .addPlace(enteredTitle, selectedImage!, selectedLocation!);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('add Place'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onBackground),
              controller: titleController,
              decoration: const InputDecoration(
                label: Text('title'),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            ImageInput(
              onPickImage: (image) {
                selectedImage = image;
              },
            ),
            const SizedBox(
              height: 24,
            ),
            LocationInput(onselectedLocation: (location) {
              selectedLocation = location;
            }),
            const SizedBox(
              height: 24,
            ),
            ElevatedButton.icon(
              onPressed: savePlace,
              label: const Text('add Place'),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
