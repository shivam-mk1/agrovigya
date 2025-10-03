import 'package:flutter/material.dart';

class CustomSliderContainer extends StatelessWidget {
  final Uri url;
  const CustomSliderContainer({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: ClipRRect(child: Image(image: NetworkImage(url.toString()))),
      ),
    );
  }
}
