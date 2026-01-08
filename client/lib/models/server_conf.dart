import 'dart:convert';

import 'package:ripple_client/extensions/map.dart';

class ServerConf {
  final String httpUrl;
  final String wsUrl;
  final bool allowsCalls;
  final bool allowsFileUploads;
  final bool allowsRegistration;
  final String apiVersion;
  ServerConf({
    required this.httpUrl,
    required this.wsUrl,
    required this.allowsCalls,
    required this.allowsFileUploads,
    required this.allowsRegistration,
    required this.apiVersion,
  });

  factory ServerConf.fromJson(Map<String, dynamic> json) {
    return ServerConf(
      httpUrl: json.get('httpUrl'),
      wsUrl: json.get('wsUrl'),
      allowsCalls: json.get('allowsCalls'),
      allowsFileUploads: json.get('allowsFileUploads'),
      allowsRegistration: json.get('allowsRegistration'),
      apiVersion: json.get('apiVersion'),
    );
  }

  static ServerConf? fromJsonString(String jsonString) {
    try {
      final Map<String, dynamic> json = jsonDecode(jsonString);
      return ServerConf.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'httpUrl': httpUrl,
      'wsUrl': wsUrl,
      'allowsCalls': allowsCalls,
      'allowsFileUploads': allowsFileUploads,
      'allowsRegistration': allowsRegistration,
      'apiVersion': apiVersion,
    };
  }
}
