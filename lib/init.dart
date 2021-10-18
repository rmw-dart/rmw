import 'objectbox.g.dart';
import 'db/user.dart';

import "package:path/path.dart" show join;
import 'dart:io' show Directory;
import 'package:intranet_ip/intranet_ip.dart';

Future<void> init(String root) async {
  print((await intranetIpv4()).rawAddress);

  await Directory(root).create(recursive: true);

  final store = openStore(directory: join(root, "box"));

  final box = store.box<User>();
  final user = User(name: 'good');
  print(box.put(user));

  for (final i in box.getAll()) {
    print("${i.id} ${i.name}");
  }
  store.close();
}
