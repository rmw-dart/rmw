import 'objectbox.g.dart';
import 'db/user.dart';

import "package:path/path.dart" show join;
import 'dart:io'
    show Directory, RawDatagramSocket, InternetAddress, SocketException;
import 'package:upnp_port_forward/init.dart' show UpnpPortForwardDaemon;

Future<void> init(String root) async {
  late final RawDatagramSocket udp;

  try {
    udp = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
  } on SocketException catch (e) {
    print(e.osError);
    print(e.osError?.errorCode);
    return;
  }

  final port = udp.port;

  UpnpPortForwardDaemon('rmw.link', (protocol, port, state) {
    print("upnp port mapped : $protocol $port $state");
  })
    ..udp(port)
    ..run();

  print(udp.port);

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
