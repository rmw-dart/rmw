import 'objectbox.g.dart';
import 'on_exit.dart';

late final Store store;

void initDb(String directory) {
  store = openStore(directory: directory);
  onExit(() {
    store.close();
  });
}
