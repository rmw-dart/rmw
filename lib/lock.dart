import 'dart:io';
import 'package:on_exit/init.dart';

void lock(String fp) {
  final file = File(fp);
  file.openSync(mode: FileMode.write).lockSync();
  onExit(() {
    if (file.existsSync()) file.deleteSync();
  });
}
