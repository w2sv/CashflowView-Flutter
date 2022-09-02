import 'dart:io';

Future<File> bankStatement(String name) async =>
    File('${Directory.current.path}/test/bank-statements/$name');
