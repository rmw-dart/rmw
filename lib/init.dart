import 'dart:math';
import "package:path/path.dart" show join;
import 'dart:io'
    show Directory, RawDatagramSocket, InternetAddress, SocketException;

import 'package:upnp_port_forward/init.dart' show UpnpPortForwardDaemon;

import 'objectbox.g.dart';
import 'db/user.dart';

Future<void> init(String root) async {
  late final RawDatagramSocket udp;

  //final port = Random().nextInt(30000) + 20000;
  var port = 20001;

  while (true) {
    try {
      udp = await RawDatagramSocket.bind(InternetAddress.anyIPv4, port);
    } on SocketException catch (e) {
      print(e.osError);
      if (e.osError?.errorCode == 48) {
        // Address already in use
        ++port;
        continue;
      }
      rethrow;
    }
    break;
  }

  udp.listen((e) {
    print(e.toString());
    final dg = udp.receive();
    if (dg != null) {
      for (var i in dg.data) {
        print(i);
      }
    }
  });

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
