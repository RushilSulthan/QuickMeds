import 'package:appinterface/global_bloc.dart';
import 'package:appinterface/homepage.dart';
import 'package:appinterface/new_entry_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalBloc? globalBloc;

  @override
  void initState() {
    globalBloc = GlobalBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<GlobalBloc>.value(
        value: globalBloc!,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'QuickMeds',
          theme: ThemeData(
            primarySwatch: Colors.purple, // Set a primary theme color
            scaffoldBackgroundColor: Colors.white, // Default background color
          ),
          home: const Homepage(),
        ));
  }
}
