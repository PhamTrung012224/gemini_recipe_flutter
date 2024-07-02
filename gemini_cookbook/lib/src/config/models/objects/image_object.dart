import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ImageObject {
  List<Image>? image;
  List<DataPart>? imageData;
  ImageObject({this.image,this.imageData});

  void resetData(){
    image!.clear();
    imageData!.clear();
  }
}
