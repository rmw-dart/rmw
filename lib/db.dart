import 'objectbox.g.dart';
import 'package:on_exit/init.dart';

late final Store store;

void initDb(String directory) {
  store = openStore(directory: directory);
  onExit(() {
    store.close();
  });
}
