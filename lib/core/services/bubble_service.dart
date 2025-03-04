import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class NativeService {
  
  static var platform = MethodChannel('com.droppingride.driver');

  // Initialize the service
  Future<void> initService({
    required double screenHeight,
    required String? chatHeadIcon,
    required String? notificationIcon,
     String? notificationTitle,
     String? notificationBody,
    required int? notificationCircleHexColor,
  }) async {
    try {
      await platform.invokeMethod('initService', {
        'screenHeight': screenHeight,
        'chatHeadIcon': chatHeadIcon,
        'notificationIcon': notificationIcon,
        'notificationTitle': notificationTitle,
        'notificationBody': notificationBody,
        'notificationCircleHexColor': notificationCircleHexColor,
      });
    } on PlatformException catch (e) {
      debugPrint("Failed to initialize service: '${e.message}'.");
    }
  }

  // Check if permission is granted
  Future<bool> checkPermission() async {
    try {
      final bool hasPermission = await platform.invokeMethod('checkPermission');
      return hasPermission;
    } on PlatformException catch (e) {
      debugPrint("Failed to get permission: '${e.message}'.");
      return false;
    }
  }

  // Ask for permission
  Future<void> askPermission() async {
    try {
      await platform.invokeMethod('askPermission');
    } on PlatformException catch (e) {
      debugPrint("Failed to ask permission: '${e.message}'.");
    }
  }

  // Start the service
  Future<void> startService() async {
    try {
      await platform.invokeMethod('startService');
    } on PlatformException catch (e) {
      debugPrint("Failed to start service: '${e.message}'.");
    }
  }

  // Stop the service
  Future<void> stopService() async {
    try {
      await platform.invokeMethod('stopService');
    } on PlatformException catch (e) {
      debugPrint("Failed to stop service: '${e.message}'.");
    }
  }
}

