import 'package:flutter/material.dart';
import 'package:tqdrpaysa/tqdrpaysa.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TQDRPaySa Example App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: TqdrPaySa(
          // You can pick api key from contract you do with TQDRPaySa
          apiKey: 'abcdefg12345',
          // The same you can pick store id from contract you do with TQDRPaySa
          store: '123',
        ),
      ),
    );
  }
}
