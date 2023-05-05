import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;

class ImageInput extends HookWidget {
  Function _selectImage;
  //File? _image;
  File? _storedImage;
  ImageInput(this._selectImage, [this._storedImage]);

  @override
  Widget build(BuildContext context) {
    final _check = useState(0);
    if (_storedImage != null) {
      _check.value++;
    }

    Future<void> _pickImage() async {
      final picker = ImagePicker();
      final imageFile = await picker.pickImage(source: ImageSource.gallery);

      if (imageFile == null) {
        return;
      }

      _storedImage = File(imageFile.path);
      _check.value++;

      final appDir = await syspath.getApplicationDocumentsDirectory();
      final fileName = path.basename(imageFile.path);
      final savedImage = await _storedImage!.copy('${appDir.path}/$fileName');
      _selectImage(savedImage);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          height: 300,
          width: 260,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey, width: 2.5)),
          child: (_check.value == 0 || _storedImage == null)
              ? Text(
                  'No image selected.',
                  textAlign: TextAlign.center,
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: Image.file(
                    _storedImage!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
        ),
        TextButton.icon(
            onPressed: _pickImage,
            icon: Icon(Icons.image_search),
            label: Text('Chooose Image'))
      ],
    );
  }
}
