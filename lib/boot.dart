import 'objectbox.g.dart';

import "package:path/path.dart" show join;
import 'dart:io' show Directory;

Future<void> boot(String directory) async {
  await Directory(directory).create(recursive: true);
  final store = openStore(directory:join(directory,"box"));
  store.close();
  print('Hello world!');
}
