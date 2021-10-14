#!/usr/bin/env dart

import "package:path/path.dart" show dirname, join;
import 'dart:io' show Platform;
import 'package:rmw/boot.dart';
import 'package:args/args.dart' show ArgParser;

void main(List<String> arguments) {
  final args = ArgParser();
  args.addFlag("workdir", abbr: 'd');
  final config = args.parse(arguments);
  print(config);

  final fp = Platform.script.toFilePath();
  var root = dirname(fp);


  boot(
      join(root,"data")
  );
}
