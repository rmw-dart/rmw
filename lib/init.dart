import 'package:path/path.dart' show join;
import 'dart:io';
import 'package:rmwlog/init.dart';
import 'dart:async';
import 'package:settings_yaml/settings_yaml.dart';
import 'db.dart';
import 'db/user.dart';
import 'lock.dart';
import 'udp.dart';
import 'package:on_exit/init.dart';

Future<void> init(String root) async {
  await Directory(root).create(recursive: true);
  final config = SettingsYaml.load(pathToSettings: join(root, 'config.yml'));

  final configPort = config['port'] ?? 0;
  final udp = await udpSocket(configPort);
  final port = udp.port;
  try {
    lock(join(root, "udp.$port.lock"));
  } on FileSystemException catch (e) {
    loge(e.message, e.path);
    await onExit.exit(1);
  }
  if (port != configPort) {
    config['port'] = port;
    config.save();
  }

  initDb(join(root, "box"));
  final box = store.box<User>();
  final user = User(name: 'good');

  final all = box.getAll();
  if (all.length < 5) {
    log('put', box.put(user));
  }
  for (final i in all) {
    log(i.id, i.name);
  }
}
