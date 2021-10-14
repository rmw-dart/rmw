#!/usr/bin/env dart

import "package:path/path.dart" show dirname, join;
import 'dart:io' show Platform;
import 'package:rmw/main.dart';

void main(List<String> arguments) {
  final fp = Platform.script.toFilePath();

  var root = dirname(fp);


  Main(
      join(root,"db")
  );
}
