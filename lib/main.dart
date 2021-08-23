import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
//TODO: This package needs to be replace with custom as it is using deprecated calls
import 'package:system_proxy/system_proxy.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _res = "Response";
  void _incrementCounter() {
    fetchLocalHost().then((value){
      setState(() {
        _counter++;
        _res = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '$_counter:$_res',
              style: Theme.of(context).textTheme.bodyText1,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), 
    );
  }
}

Future<Dio> getDio() async {
  var proxy = "DIRECT";
  var proxySettings = await SystemProxy.getProxySettings();
  if (proxySettings != null) {
    var host = proxySettings['host'];
    var port = proxySettings['port'];
    proxy = 'PROXY $host:$port';
  }
  var dio = new Dio();
  (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
      (HttpClient client) {
    client.findProxy = (uri) {
      return proxy;
    };
  };
  return dio;
}

Future<String> fetchLocalHost() async {
  try {
    var dio = await getDio();
    var response = await dio.get('http://192.168.0.132:8000');
    return response.toString();
  } catch (e) {
    return e.toString();
  }
}


