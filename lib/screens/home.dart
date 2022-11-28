import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:m3u_nullsafe/m3u_nullsafe.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New App'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () async {
          log('Hi');
          final result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['m3u'],
            // allowMultiple: false,
          );
          log('Hi1');
          if (result != null) {
            log('RESULT: ${result.files.first}');
            final file = result.files.first;
            if (file.path != null) {
              File newFile = File(file.path!);
              String rawData = await newFile.readAsString();
              final parsedData = await M3uParser.parse(rawData);
              log('PARSED: ${parsedData.first.attributes}');
            }
          } else {
            log('EMPTY');
          }
        },
      ),
    );
  }
}
