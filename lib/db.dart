import 'objectbox.g.dart';
import 'dart:io';

late final Store store;

void initDb(String directory) {
  store = openStore(directory: directory);
}
