import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:healwiz/themes/theme.dart';
import 'package:image_picker/image_picker.dart';

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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          'artherits',
          style: TextStyle(color: AppColor.kWhite),
        ),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          CustomImagePicker(
            function: () => selectImage(),
          ),
        image !=null ?  Image(
            image: MemoryImage(image!),
          ) :Text('no image')
        ],),
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
              borderRadius: BorderRadius.circular(50)),
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
