#!/usr/bin/env dart

import "package:path/path.dart" show dirname, join;
import 'dart:io' show Platform;
import 'package:rmw/boot.dart';
import 'package:rmw/version.dart' show packageVersion;
import 'package:args/args.dart' show ArgParser;

void main(List<String> arguments) async {

  final args = ArgParser();
  args.addOption("dir", abbr: 'd', help:'工作目录');
  args.addOption("help", abbr: 'h', help:'帮助');

  print("人民网络 $packageVersion\n打倒数据霸权 · 网络土地革命！\nhttps://rmw.link\n");

  final config = args.parse(arguments);
  if (config['help']!=null) {
    print(args.usage);
    return;
  }

  final root = config['dir']??join(dirname(Platform.script.toFilePath()),'data');

  await boot(
      root
  );
}
