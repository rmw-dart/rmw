import 'objectbox.g.dart';

late final Store store;

void initDb(String directory) {
  store = openStore(directory: directory);
}
