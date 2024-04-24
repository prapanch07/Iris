import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:healwiz/themes/theme.dart';
import 'package:healwiz/utils/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ScreenArthreris extends StatefulWidget {
  const ScreenArthreris({Key? key}) : super(key: key);

  @override
  State<ScreenArthreris> createState() => _ScreenArthrerisState();
}

class _ScreenArthrerisState extends State<ScreenArthreris> {
  File? image;
  Uint8List? displayimg;
  String? predicteddata;

  @override
  Widget build(BuildContext context) {
    //
    void _customSnackBar(BuildContext context, String text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(text),
        ),
      );
    }

    pickImage(ImageSource source, BuildContext context) async {
      final _imagepicker = ImagePicker();

      XFile? file = await _imagepicker.pickImage(source: source);

      if (file != null) {
        print('image selection succes');

        setState(() async {
          image = File(file.path);
          displayimg = await file.readAsBytes();
        });
      } else {
        _customSnackBar(context, 'error in selecting img');
      }
    }

//

    Future<void> _sendImage() async {
      if (image == null) {
        print('image null');
        return;
      }

      try {
        final multipartRequest = http.MultipartRequest(
          'POST',
          artheritisuri,
        );

        // Add the image to the request
        multipartRequest.files.add(
          http.MultipartFile(
            'image',
            image!.readAsBytes().asStream(),
            image!.lengthSync(),
            filename: image!.path.split('/').last,
          ),
        );
        final response = await multipartRequest.send();

        final responseData = await response.stream.toBytes();
        final decodedResponse = utf8.decode(responseData);

         

        setState(() { 
          predicteddata = decodedResponse;
        });

        if (response.statusCode == 200) {
          print('Image uploaded successfully');
          print(decodedResponse);
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomImagePicker(
              function: () {
                pickImage(ImageSource.gallery, context);
              },
            ),
            const Gap(30),
            image != null
                ? Image(
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                    image: MemoryImage(displayimg!),
                  )
                : const Text('no image'),
            const Gap(30),
            const Padding(
              padding: EdgeInsets.only(left: 28),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Prediction :',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 40),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  predicteddata != null ? predicteddata! : 'no prediction', 
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ), 
                ),
              ),
            )
          ],
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
