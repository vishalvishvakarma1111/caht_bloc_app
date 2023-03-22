import 'dart:developer';
import 'dart:io';

import 'package:chat_bloc_app/file_upload/uploader.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:workmanager/workmanager.dart';

import '../firebase_options.dart';

File? file;

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {

    var map = inputData ?? {}['file'];

    var path=map['file'];

     await Firebase.initializeApp();
    String? fileName = path
        .split('/')
        .last;
    print("-----print-----fileName   ${fileName}");

    final storage = FirebaseStorage.instance.ref().child('background/$fileName');
    TaskSnapshot taskSnapshot = await storage.putFile(File(path));
    String url = await taskSnapshot.ref.getDownloadURL();
    log("----- error log url--- ", error: " ${url}");

    return Future.value(true);
  });
}

class FileUploadBackground extends StatefulWidget {
  FileUploadBackground({Key? key}) : super(key: key);

  @override
  State<FileUploadBackground> createState() => _FileUploadBackgroundState();
}

class _FileUploadBackgroundState extends State<FileUploadBackground> {
  @override
  void initState() {
    super.initState();
    Workmanager().initialize(callbackDispatcher);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UploadFile'),
      ),
      body: Container(
        color: Colors.red,
        width: double.maxFinite,
        height: double.maxFinite,
        child: Column(
          children: [
            file == null
                ? const SizedBox.shrink()
                : Image.file(
              file ?? File(""),
              width: double.maxFinite,
              height: 300,
            ),
            MaterialButton(
              height: 30,
              onPressed: () => showMyPicker(context),
              color: Colors.blue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: const Text(
                "Add Photo",
                style: TextStyle(color: Colors.white),
              ),
            ),
            MaterialButton(
              height: 30,
              onPressed: () async {
                if (file != null) {

                  Workmanager().registerOneOffTask('uniqueName', 'back_upload', inputData: {"file": file?.path ?? ""});
                }
              },
              color: Colors.blue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: const Text(
                "Upload Photo",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showMyPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Photo Library'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _imgFromCameraAndGallery(false, context);
                  }),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _imgFromCameraAndGallery(true, context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future _imgFromCameraAndGallery(bool fromCamera,
      BuildContext context,) async {
    final picker = ImagePicker();
    picker.pickImage(source: fromCamera ? ImageSource.camera : ImageSource.gallery, imageQuality: 50).then(
          (pickedFile) {
        if (pickedFile != null) {
          file = File(pickedFile.path);
          setState(() {});
        }
      },
    );
  }
}
