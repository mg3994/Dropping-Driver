import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:restart_tagxi/core/pushnotification/push_notification.dart';
import 'package:restart_tagxi/core/utils/connectivity_check.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:workmanager/workmanager.dart';
import '../../../../di/locator.dart' as locator;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'app_constants.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (AppConstants.packageName == '' || AppConstants.signKey == '') {
    var val = await PackageInfo.fromPlatform();
    AppConstants.packageName = val.packageName;
    AppConstants.signKey = val.buildSignature;
  }
  if (message.data['push_type'].toString() == 'meta-request') {
    if (Platform.isAndroid) {
      AndroidIntent intent = AndroidIntent(
        action: 'action_view',
        package: 'package name here',
        componentName: 'package name here.MainActivity',
      );
      await intent.launch();
    }
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      await Firebase.initializeApp();
      var val = await Geolocator.getCurrentPosition();
      dynamic id;
      if (inputData != null) {
        id = inputData['id'];
      }
      FirebaseDatabase.instance.ref().child('drivers/driver_$id').update({
        // 'lat-lng': val.latitude.toString(),
        'date': DateTime.now().toString(),
        'l': {'0': val.latitude, '1': val.longitude},
        'updated_at': ServerValue.timestamp
      });
    } catch (e) {
      debugPrint(e.toString());
    }

    return Future.value(true);
  });
}

Future<void> commonSetup() async {
  WidgetsFlutterBinding.ensureInitialized();
  WakelockPlus.enable();
  if (Platform.isAndroid) {
// ignore: deprecated_member_use
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }
  if (AppConstants.packageName == '' || AppConstants.signKey == '') {
    var val = await PackageInfo.fromPlatform();
    AppConstants.packageName = val.packageName;
    AppConstants.signKey = val.buildSignature;
  }

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.black,
  ));

  if (Platform.isAndroid) {
    Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  }
  ConnectivityService().initialize();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: AppConstants.firbaseApiKey,
          appId: AppConstants.firebaseAppId,
          messagingSenderId: AppConstants.firebasemessagingSenderId,
          projectId: AppConstants.firebaseProjectId));
  await locator.init();

  PushNotification().initMessaging();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  // Bloc.observer = const SimpleBlocObserver();
}

class SimpleBlocObserver extends BlocObserver {
  const SimpleBlocObserver();

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    debugPrint('onCreate -- bloc: ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    debugPrint('onEvent -- bloc: ${bloc.runtimeType}, event: $event');
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    debugPrint('onChange -- bloc: ${bloc.runtimeType}, change: $change');
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    debugPrint(
        'onTransition -- bloc: ${bloc.runtimeType}, transition: $transition');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    debugPrint('onError -- bloc: ${bloc.runtimeType}, error: $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    debugPrint('onClose -- bloc: ${bloc.runtimeType}');
  }
}
