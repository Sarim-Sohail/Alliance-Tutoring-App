// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';

class CarouselRender extends StatelessWidget {
  String imgPath;
  String txtPath;

  CarouselRender(this.txtPath, this.imgPath);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          txtPath,
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Cabin',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.2,
          child: Image.asset(imgPath),
        ),
      ],
    );
  }
}
