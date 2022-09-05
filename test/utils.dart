import 'dart:io';

Future<File> getBankStatement(String name) async =>
    File('${Directory.current.path}/test/bank-statements/$name');
