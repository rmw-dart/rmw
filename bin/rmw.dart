#!/usr/bin/env dart

import "package:path/path.dart" show dirname, join;
import 'dart:io' show Platform;
import 'package:rmw/boot.dart';
import 'package:rmw/version.dart';
import 'package:args/args.dart' show ArgParser;

void main(List<String> arguments) async {

  final args = ArgParser();
  args.addFlag("dir", abbr: 'd', help:'工作目录',negatable:false);
  args.addFlag("help", abbr: 'h', help:'帮助',negatable:false);

  print("人民网络 v$packageVersion\n打倒数据霸权 · 网络土地革命！\nhttps://rmw.link\n");
  final config = args.parse(arguments);
  if (config['help']) {
    print(args.usage);
    return;
  }

  final fp = Platform.script.toFilePath();
  var root = dirname(fp);


  boot(
      join(root,"data")
  );
}
