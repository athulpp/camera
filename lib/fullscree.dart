
import 'dart:io';

import 'package:flutter/material.dart';

class FullSize extends StatelessWidget {
  final data;
  FullSize({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image'),
      ),
      body: Container(
        child: Image.file(File(data.toString())),
      ),
    );
  }
}
  