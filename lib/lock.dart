import 'dart:io';
import 'on_exit.dart';

void lock(String fp) {
  final file = File(fp);
  file.openSync(mode: FileMode.write).lockSync();
  onExit(() {
    file.deleteSync();
  });
}
