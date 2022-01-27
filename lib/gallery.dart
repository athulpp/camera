import 'dart:io';

// import 'package:custom_gallery/FullScreenImg.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image/fullscree.dart';
import 'package:image_picker/image_picker.dart';

ValueNotifier<List> database = ValueNotifier([]);

class Gallery extends StatelessWidget {
  const Gallery({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My Gallery'),
        actions: [
          IconButton(
              onPressed: () async {
                final image =
                    await ImagePicker().pickImage(source: ImageSource.camera);
                if (image == null) {
                  return;
                } else {
                  File imagepath = File(image.path);
                  // debugPrint(image.path);
                  GallerySaver.saveImage(image.path, albumName: 'images');
                  await imagepath.copy(
                      '/data/user/0/com.example.image/image_(${DateTime.now()}).jpg');
                  Directory directory = Directory.fromUri(
                      Uri.parse('/data/user/0/com.example.image/'));
                  getitems(directory);
                }
              },
              icon: const Icon(Icons.camera))
        ],
      ),
      body: ValueListenableBuilder(
          valueListenable: database,
          builder: (context, List data, _) {
            // debugPrint();
            return Padding(
              padding: const EdgeInsets.all(2),
              child: GridView.extent(
                  maxCrossAxisExtent: 150,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.8,
                  children: List.generate(data.length, (index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => FullSize(data: data[index])));
                      },
                      child: Hero(
                          tag: data[index],
                          child: Image.file(File(data[index].toString()))),
                    );
                  })),
            );
          }),
    );
  }
}

getitems(Directory directory) async {
  final listDir = await directory.list().toList();
  // print(listDir);
  database.value.clear();
  for (var i = 0; i < listDir.length; i++) {
    if (listDir[i].path.substring(
            (listDir[i].path.length - 4), (listDir[i].path.length)) ==
        '.jpg') {
      database.value.add(listDir[i].path);
      database.notifyListeners();
    }
  }
}
