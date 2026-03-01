import 'package:drugvet_master/core/service/storage_service.dart';
import 'package:flutter/cupertino.dart';

class Global {
  static late StorageService storageService;
  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    storageService = await StorageService().init();
  }
}
