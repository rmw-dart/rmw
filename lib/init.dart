import 'dart:math';
import "package:path/path.dart" show join;
import 'dart:io'
    show
        Directory,
        RawDatagramSocket,
        InternetAddress,
        SocketException,
        RawSocketEvent;

import 'package:upnp_port_forward/init.dart' show UpnpPortForwardDaemon;
import 'package:rmwlog/init.dart';
import 'objectbox.g.dart';
import 'db/user.dart';

Future<void> init(String root) async {
  final port = 20000; //Random().nextInt(40000) + 20000;

  final udp = await RawDatagramSocket.bind(InternetAddress.anyIPv4, port);

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

  await Directory(root).create(recursive: true);

  final store = openStore(directory: join(root, "box"));

  final box = store.box<User>();
  final user = User(name: 'good');
  log(box.put(user));

  for (final i in box.getAll()) {
    log(i.id, i.name);
  }
  store.close();
}
