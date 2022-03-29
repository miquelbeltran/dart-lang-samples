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

late Connect connect;
late Disconnect disconnect;

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

  connect = dylib.lookupFunction<ConnectFunc, Connect>('connect');
  disconnect = dylib.lookupFunction<DisconnectFunc, Disconnect>('disconnect');

  Database.open('sample');

  // forget to close database
}

class Database {
  final Finalizer<void> _finalizer;

  Database(this._finalizer);

  factory Database.open(String name) {
    final finalizer = Finalizer<void>((_) {
      // call to native disconnect
      disconnect();
    });

    // call to native connect
    final dbName = name.toNativeUtf8();
    connect(dbName);
    calloc.free(dbName);

    final wrapper = Database(finalizer);

    finalizer.attach(wrapper, null, detach: wrapper);

    return wrapper;
  }

  void close() {
    // call to native disconnect
    disconnect();
    // Detach from finalizer, no longer needed.
    _finalizer.detach(this);
  }
}
