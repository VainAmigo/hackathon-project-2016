import 'package:cross_file/cross_file.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

Future<MultipartFile> multipartFromXFile(XFile x) async {
  if (!kIsWeb && x.path.isNotEmpty) {
    return MultipartFile.fromFile(x.path, filename: x.name);
  }
  final bytes = await x.readAsBytes();
  return MultipartFile.fromBytes(bytes, filename: x.name);
}
