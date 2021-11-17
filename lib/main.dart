import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_sign_up/screen/login/login.dart';
import 'package:firebase_sign_up/service/design.dart';
import 'package:firebase_sign_up/service/service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ServiceProvider>(create: (context) => ServiceProvider()),
        ChangeNotifierProvider<DesignProvider>(
            create: (context) => DesignProvider()),
      ],
      builder: (context, _) => MaterialApp(
          debugShowMaterialGrid: false,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            primarySwatch: Colors.amber,
          ),
          home: Login()),
    );
  }
}
