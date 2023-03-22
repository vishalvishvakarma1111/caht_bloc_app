import 'dart:io';

import 'package:image_picker/image_picker.dart';

class Profile {
  String? name;
  String? desc;
  String? url;
  XFile? file;

  Profile({this.name, this.desc, this.url, this.file});

  factory Profile.fromJson(Map<String, dynamic> map) {
    return Profile(
      name: map["name"],
      desc: map["desc"],
      url: map["profile_pic"],
    );
  }

  @override
  String toString() {
    return 'Profile{name: $name, desc: $desc, url: $url, file: $file}';
  }
}
