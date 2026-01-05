import 'package:dio/dio.dart';

extension MapExt on Map<String, dynamic> {
  FormData toFormData() {
    return FormData.fromMap(this);
  }
}
