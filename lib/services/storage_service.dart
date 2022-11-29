import 'package:get_storage/get_storage.dart';

class ChannelStorageService {
  static final _box = GetStorage('channels_storage');

  static Future<void> saveChannels(String rawData) async {
    await _box.write('channels', rawData);
  }

  static String getChannels() {
    return _box.read('channels');
  }

  static bool hasChannels() {
    return _box.hasData('channels');
  }
}
