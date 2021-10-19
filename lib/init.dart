import 'dart:math';
import "package:path/path.dart" show join;
import 'dart:io';
import 'package:upnp_port_forward/init.dart' show UpnpPortForwardDaemon;
import 'package:rmwlog/init.dart';
import 'objectbox.g.dart';
import 'dart:async';
import 'package:settings_yaml/settings_yaml.dart';

import 'db/user.dart';
import 'lock.dart';

Future<void> init(String root) async {
  final dirLock = join(root, 'lock');
  await Directory(dirLock).create(recursive: true);

  final config = SettingsYaml.load(pathToSettings: join(root, 'config.yml'));

  final configPort = config['port'] ?? 0;
  final udp = await RawDatagramSocket.bind(InternetAddress.anyIPv4, configPort);
  final port = udp.port;
  if (port != configPort) {
    config['port'] = port;
    config.save();
  }

  try {
    lock(join(dirLock, "udp.$port"));
  } on FileSystemException catch (e) {
    log(e.message, e.path);
    exit(1);
  }

  print(udp);

  udp.listen((e) {
    // ignore: exhaustive_cases
    switch (e) {
      case RawSocketEvent.read:
        udp.writeEventsEnabled = true;

        log("e ${e.toString()}");
        final dg = udp.receive();
        if (dg != null) {
          for (var i in dg.data) {
            log(">> $i");
          }
        }
        break;
      case RawSocketEvent.write:
        // udpSocket.send( new Utf8Codec().encode('Hello from client'), clientAddress, port);
        break;
      case RawSocketEvent.closed:
        log('Client disconnected.');
        break;
    }
  });

  UpnpPortForwardDaemon('rmw.link', (protocol, port, state) {
    log("upnp port mapped : $protocol $port $state");
  })
    ..udp(udp.port)
    ..run();

  log(udp.port);

  final store = openStore(directory: join(root, "box"));

  final box = store.box<User>();
  final user = User(name: 'good');
  log(box.put(user));

  for (final i in box.getAll()) {
    log(i.id, i.name);
  }
  store.close();
}
