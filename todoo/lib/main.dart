import 'package:flutter/material.dart';
import 'Model/userModel.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'Pages/anotacoes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox<UserModel>('users');
  runApp(myApp());
}

class myApp extends StatelessWidget {
  const myApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ANOTAÇÕES',
      home: Anotacoes(),
    );
  }
}
