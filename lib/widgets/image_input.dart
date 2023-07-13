import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageInput extends StatefulWidget {
  ImageInput({super.key, required this.onPickImage});

  final void Function(File image) onPickImage;
  @override
  State<StatefulWidget> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  File? selectedImage;
  void takePicture() async {
    final imagepicker = ImagePicker();
    final pickedImage =
        await imagepicker.pickImage(source: ImageSource.camera, maxWidth: 600);

    if (pickedImage == null) {
      return;
    }
    setState(() {
      selectedImage = File(pickedImage.path);
    });

    widget.onPickImage(selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
        onPressed: takePicture,
        icon: Icon(Icons.camera),
        label: Text('Take Picture'));

    if (selectedImage != null) {
      content = GestureDetector(
        onDoubleTap: takePicture,
        child: Image.file(
          selectedImage!,
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }

    return Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          ),
        ),
        width: double.infinity,
        alignment: Alignment.center,
        height: 250,
        child: content);
  }
}
