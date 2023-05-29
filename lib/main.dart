import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/shared/network/local/cache_helper.dart';

import 'layout/ToDoApp/home_layout.dart';
import 'shared/bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // =>

  Bloc.observer = MyBlocObserver();
  await CachHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
        home: const HomeLayout(),
    );
  }
}