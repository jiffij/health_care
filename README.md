# simple_login

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Notes for tflite implementation:

https://github.com/shaqian/flutter_tflite/issues/224

follow the comment of dejduu

1. download zip file from https://github.com/shaqian/flutter_tflite

2. modify the file according to this page https://github.com/shaqian/flutter_tflite/pull/230/files#

3. put the folder into "lib" 

4. add the path to pubspec.yaml as below

    tflite:
    path: "./lib/flutter_tflite-master"
