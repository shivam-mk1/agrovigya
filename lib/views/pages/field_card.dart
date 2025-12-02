import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FieldCard extends StatefulWidget {
  const FieldCard({super.key});

  @override
  State<FieldCard> createState() => _FieldCardState();
}

class _FieldCardState extends State<FieldCard> {
  File? _image;

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.height;
    final double w = MediaQuery.of(context).size.width;
    return Column(
      children: [
        InkWell(
          onTap: pickImage,
          child: Container(
            clipBehavior: Clip.hardEdge,
            height: h * 0.28,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            child:
                _image != null
                    ? Image.file(
                      _image!,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    )
                    : Image(
                      image: AssetImage("assets/images/farming_field.jpg"),
                      fit: BoxFit.fill,
                    ),
          ),
        ),
        SizedBox(height: h * 0.02),
        if (_image == null)
          SizedBox(
            width: w * 0.9,
            child: Text(
              "Add images of your field to see recommendations for your field",
            ),
          ),
      ],
    );
  }
}
