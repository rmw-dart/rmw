import 'dart:io';
import 'package:rmwlog/init.dart';
import 'package:upnp_port_forward/init.dart' show UpnpPortForwardDaemon;

Future<RawDatagramSocket> udpSocket(int configPort) async {
  final udp = await RawDatagramSocket.bind(InternetAddress.anyIPv4, configPort,
      reuseAddress: false);

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
  return udp;
}
