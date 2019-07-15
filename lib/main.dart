import 'package:flutter/material.dart';
import 'package:flutter_infinite_list_bloc/pages/home.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_infinite_list_bloc/blocs/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_infinite_list_bloc/blocs/simple_bloc_delegate.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text("Fetching Data from API"),
          ),
          body: BlocProvider(
            builder: (context) =>
                PostBloc(httpClient: http.Client())..dispatch(Fetch()),
            child: HomePage(),
          ),
        ));
  }
}
