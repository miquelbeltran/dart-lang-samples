// Copyright (c) 2022, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

#include <stdio.h>
#include <string.h>
#include "finalizer.h"

void main()
{
    connect("mainDB");
    disconnect();
}

char database[10];

void connect(char *str)
{
    printf("Connected to Database: %s\n", str);
    strcpy(database, str);
}

void disconnect()
{
    printf("Disconnected from the Database: %s\n", database);
}