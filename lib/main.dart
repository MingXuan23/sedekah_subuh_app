import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prim_derma_app/bloc/auth/login/login_bloc.dart';
import 'package:prim_derma_app/bloc/derma/derma_bloc.dart';
import 'package:prim_derma_app/bloc/info/info_bloc.dart';
import 'package:prim_derma_app/firebase_options.dart';
import 'package:prim_derma_app/models/user.dart';

import 'package:prim_derma_app/pages/widget_tree/start_page.dart';
import 'package:prim_derma_app/repo/derma_repo.dart';
import 'package:prim_derma_app/repo/info_repo.dart';
import 'package:prim_derma_app/repo/user_repo.dart';
import 'package:upgrader/upgrader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // String? token;

  // if (Platform.isIOS && kDebugMode) {
  //   token = await _firebaseMessaging.getAPNSToken();
  // } else {
  //   token = await _firebaseMessaging.getToken();
  // }

  // User.device_token = token;

  // NotificationSettings settings = await _firebaseMessaging.requestPermission(
  //   alert: true,
  //   announcement: false,
  //   badge: true,
  //   carPlay: false,
  //   criticalAlert: false,
  //   provisional: false,
  //   sound: true,
  // );

  runApp(const MyApp(
    home: StartPage(),
  ));

  setupNotifications();

  //runApp(const MyApp(home: LoginPage(),));
}

Future<void> setupNotifications() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // This triggers the registration process with Apple.
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    // 4. On iOS, wait a small moment for APNs to provide the token
    // or use a retry loop if getToken() fails.
    try {
      String? token;
      if (Platform.isIOS) {
        // Optional: wait for APNs token to be ready
        token = await messaging.getAPNSToken();
        // If getAPNSToken is successful, then getToken will work
        if (token != null) {
          token = await messaging.getToken();
        }
      } else {
        //Android
        token = await messaging.getToken();
      }

      if (token != null) {
        User.device_token = token;
      }
    } catch (e) {
      debugPrint("Error fetching token: $e");
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.home});
  final Widget home;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(LoginInitial(), UserRepo())),
        BlocProvider<DermaBloc>(
            create: (context) => DermaBloc(DermaInitial(), DermaRepo())),
        BlocProvider<InfoBloc>(
            create: (context) => InfoBloc(InfoInitial(), InfoRepo()))
      ],
      child: MaterialApp(
          title: 'Sedekah Subuh',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
            useMaterial3: true,
          ),
          home: UpgradeAlert(
              showIgnore: false,
              showLater: false,
              showReleaseNotes: false,
              upgrader: Upgrader(),
              child: home)),
    );
  }
}
