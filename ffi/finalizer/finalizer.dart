// Copyright (c) 2022, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ffi';
import 'dart:io' show Platform, Directory;

import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as path;

typedef ConnectFunc = Void Function(Pointer<Utf8> str);
typedef Connect = void Function(Pointer<Utf8> str);

typedef DisconnectFunc = Void Function();
typedef Disconnect = void Function();

void main() {
  // Open the dynamic library
  var libraryPath =
      path.join(Directory.current.path, 'finalizer_library', 'libfinalizer.so');
  if (Platform.isMacOS) {
    libraryPath = path.join(
        Directory.current.path, 'finalizer_library', 'libfinalizer.dylib');
  }
  if (Platform.isWindows) {
    libraryPath = path.join(
        Directory.current.path, 'finalizer_library', 'Debug', 'finalizer.dll');
  }

  final dylib = DynamicLibrary.open(libraryPath);

  final connect = dylib.lookupFunction<ConnectFunc, Connect>('connect');
  final disconnect =
      dylib.lookupFunction<DisconnectFunc, Disconnect>('disconnect');

  // simulate a connect to a database
  final dbName = 'sample'.toNativeUtf8();
  connect(dbName);
  calloc.free(dbName);

  // simulate a disconnect from the database
  disconnect();
}
