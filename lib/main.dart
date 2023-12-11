import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'screens/home.dart';

void main() async {
  await GetStorage.init('channels_storage');
  runApp(const FlutterIPTV());
}

class FlutterIPTV extends StatelessWidget {
  const FlutterIPTV({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}
