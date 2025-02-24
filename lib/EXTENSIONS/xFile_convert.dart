import 'dart:io';

import 'package:image_picker/image_picker.dart';

extension XFileListToFileList on List<XFile> {
  List<File> toFileList() {
    return map((xFile) => File(xFile.path)).toList();
  }
}