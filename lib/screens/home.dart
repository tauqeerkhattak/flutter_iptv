import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iptv/screens/video_screen/video_screen.dart';
import 'package:flutter_iptv/services/storage_service.dart';
import 'package:m3u_nullsafe/m3u_nullsafe.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<M3uGenericEntry> channels = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (ChannelStorageService.hasChannels()) {
        String rawData = ChannelStorageService.getChannels();
        final result = await M3uParser.parse(rawData);
        if (result.isNotEmpty) {
          channels.addAll(result);
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New App'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onFloatingActionButtonPressed,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    if (channels.isEmpty) {
      return const Center(
        child: Text(
          'No channels available, did you add an m3u file?',
          textAlign: TextAlign.center,
        ),
      );
    }
    return ListView.builder(
      itemCount: channels.length,
      itemBuilder: (context, index) {
        final channel = channels[index];
        return Card(
          child: ListTile(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoScreen(
                  url: channel.link,
                ),
              ),
            ),
            title: Text(channel.title),
          ),
        );
      },
    );
  }

  void _onFloatingActionButtonPressed() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['m3u'],
      // allowMultiple: false,
    );
    if (result != null) {
      log('RESULT: ${result.files.first}');
      final file = result.files.first;
      if (kIsWeb) {
        if (file.bytes != null) {
          String rawData = String.fromCharCodes(file.bytes!);
          // File newFile = File.fromRawPath(file.bytes!);
          // String rawData = await newFile.readAsString();
          List<M3uGenericEntry> parsedData = await M3uParser.parse(rawData);
          parsedData.removeWhere((channel) => channel.title == '');
          channels.addAll(parsedData);
          ChannelStorageService.saveChannels(rawData);
          setState(() {});
        }
      } else {
        if (file.path != null) {
          File newFile = File(file.path!);
          String rawData = await newFile.readAsString();
          List<M3uGenericEntry> parsedData = await M3uParser.parse(rawData);
          parsedData.removeWhere((channel) => channel.title == '');
          channels.addAll(parsedData);
          ChannelStorageService.saveChannels(rawData);
          setState(() {});
        }
      }
    } else {
      log('EMPTY');
    }
  }
}
