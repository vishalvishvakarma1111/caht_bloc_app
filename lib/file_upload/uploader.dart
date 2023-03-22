import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import '../firebase_options.dart';

class BackgroundUploader {
  final simpleTaskKey = "be.tramckrijte.workmanagerExample.simpleTask";

  static void doJob() {

  }

  setTask() {
    Workmanager().registerOneOffTask(
      simpleTaskKey,
      simpleTaskKey,
      inputData: <String, dynamic>{
        'int': 1,
        'bool': true,
        'double': 1.0,
        'string': 'string',
        'array': [1, 2, 3],
      },
    );
  }
}
