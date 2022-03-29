cmake_minimum_required(VERSION 3.7 FATAL_ERROR)
project(finalizer_library VERSION 1.0.0 LANGUAGES C)
add_library(finalizer_library SHARED finalizer.c finalizer.def)
add_executable(finalizer_test finalizer.c)

set_target_properties(finalizer_library PROPERTIES
    PUBLIC_HEADER finalizer.h
    VERSION ${PROJECT_VERSION}
    SOVERSION 1
    OUTPUT_NAME "finalizer"
    XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "Hex_Identity_ID_Goes_Here"
)
