import 'objectbox.g.dart';
import 'db.dart';
import "package:path/path.dart" show join;
import 'dart:io' show Directory;

Future<void> boot(String root) async {
  await Directory(root).create(recursive: true);

  final store = openStore(directory:join(root,"box"));

  final box = store.box<User>();
  final user = User(name:'good');
  print(box.put(user));

  for(final i in box.getAll()){
    print("${i.id} ${i.name}");
  }
  store.close();
}
