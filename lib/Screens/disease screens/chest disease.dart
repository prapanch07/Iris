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

class ScreenChestDisease extends StatefulWidget {
  const ScreenChestDisease({Key? key}) : super(key: key);

  @override
  State<ScreenChestDisease> createState() => _ScreenArthrerisState();
}

class _ScreenArthrerisState extends State<ScreenChestDisease> {
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

    Future<void> _sendImage() async {
      if (image == null) {
        _customSnackBar(context, 'select an image');
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
          _customSnackBar(context, 'image upload successfull');
        } else {
          _customSnackBar(
            context,
            'Failed to upload image. Status code: ${response.statusCode}',
          );
        }
      } catch (e) {
        print('Error uploading image: $e');
        _customSnackBar(context, 'exception : ${e.toString()}');
      }
    }

    pickImage(ImageSource source, BuildContext context) async {
      final _imagepicker = ImagePicker();

      XFile? file = await _imagepicker.pickImage(source: source);

      if (file != null) {
        image = File(file.path);
        displayimg = await file.readAsBytes();
        _sendImage();

        setState(() {});
      } else {
        _customSnackBar(context, 'select an image');
      }
    }

//

//

    final _size = MediaQuery.sizeOf(context);
    return RefreshIndicator(
      onRefresh: () => _sendImage(),
      child: Scaffold(
        appBar: AppBar( 
          backgroundColor: Colors.deepPurple,
          title: Text(
            'chest disease ',
            style: TextStyle(
              color: AppColor.kWhite,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
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
              image != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 10,
                      ),
                      child: Image(
                        height: _size.height / 2,
                        width: _size.width,
                        fit: BoxFit.cover,
                        image: MemoryImage(displayimg!),
                      ),
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
