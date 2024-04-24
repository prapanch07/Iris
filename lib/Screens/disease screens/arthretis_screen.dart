import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healwiz/themes/theme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ScreenArthreris extends StatefulWidget {
  const ScreenArthreris({Key? key}) : super(key: key);

  @override
  State<ScreenArthreris> createState() => _ScreenArthrerisState();
}

class _ScreenArthrerisState extends State<ScreenArthreris> {
  Uint8List? image;

  @override
  Widget build(BuildContext context) {
    pickImage(ImageSource source, BuildContext context) async {
      final _imagepicker = ImagePicker();

      XFile? _file = await _imagepicker.pickImage(source: source);

      if (_file != null) {
        print('image selection succes');

        return await _file.readAsBytes();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('select an img'),
          ),
        );
      }
    }

    void selectImage() async {
      Uint8List? img = await pickImage(ImageSource.gallery, context);

      setState(() {
        image = img!;
      });
    }

//

    Future<void> _sendImage() async {
      if (image == null) {
        print('image null');
        return; 
      }

      final url = 'https://b557-103-149-159-37.ngrok-free.app/chest';
      final uri = Uri.parse(url);
 
      try {
        final response = await http.post(
          uri, 
          body: image,
          headers: {'Content-Type': 'application/octet-stream'},
        );

        if (response.statusCode == 200) {
          print('Image uploaded successfully');
        } else {
          print('Failed to upload image. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error uploading image: $e');
      }
    }

//

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          'artherits',
          style: TextStyle(color: AppColor.kWhite),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomImagePicker(
                  function: () => selectImage(),
                ),
                const Gap(30),
                image != null
                    ? Image(
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                        image: MemoryImage(image!),
                      )
                    : const Text('no image'),
                const Gap(30),
                const ResultContainer()
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _sendImage(),
        child: Text('Api call'),
      ),
    );
  }
}

class CustomImagePicker extends StatelessWidget {
  final VoidCallback function;
  const CustomImagePicker({super.key, required this.function});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: SizedBox(
        height: 30,
        width: 100,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.deepPurple[400],
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Align(
            alignment: Alignment.center,
            child: Text(
              'Select Image',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class ResultContainer extends StatelessWidget {
  const ResultContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.deepPurple,
      ),
    );
  }
}
