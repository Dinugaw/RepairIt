import 'package:flutter/material.dart';

var pageList = [
  PageModel(
      imageUrl: "assets/page01.jpg",
      title: "We do all kinds of repairs",
      body: "BROKEN? DONT WORRY WELL FIX IT",
      titleGradient: gradients[0]),
  PageModel(
      imageUrl: "assets/page02.jpg",
      title: "Hire Repairmen",
      body: "WITH A CLICK OF A BUTTON",
      titleGradient: gradients[1]),
  PageModel(
      imageUrl: "assets/page03.jpg",
      title: "Pay Online",
      body: "SECURE PAYMENT GATEWAY",
      titleGradient: gradients[2]),
];

List<List<Color>> gradients = [
  [Color(0xFFE2859F), Color(0xFFFCCF31)],
  [Colors.black54, Colors.black87, Colors.black54],
  [Color(0xFF5EFCE8), Color(0xFF736EFE)],
];

class PageModel {
  var imageUrl;
  var title;
  var body;
  List<Color> titleGradient = [];
  PageModel({this.imageUrl, this.title, this.body, this.titleGradient});
}
