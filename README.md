# Health Care

## TODO List 
- [x] 3rd party video call 
- [x] UI Bugs
- [x] Record page empty (added invitation page, third party meeting)
- [x] call dispose handled
- [ ] messaging
- [x] refresh gesture on booking page
- [ ] calendar event list
- [ ] Doctor Detail save and message button
- [ ] Profile page edit
- [ ] hard ware
- [x] logout

## Notes for tflite implementation:

https://github.com/shaqian/flutter_tflite/issues/224

follow the comment of dejduu

1. download zip file from https://github.com/shaqian/flutter_tflite

2. modify the file according to this page https://github.com/shaqian/flutter_tflite/pull/230/files#

3. put the folder into "lib" 

4. add the path to pubspec.yaml as below

    tflite:
    path: "./lib/flutter_tflite-master"

## Tflite_flutter_helper

The link solves the issue:
https://stackoverflow.com/questions/73221388/execution-failed-for-task-tflite-flutter-helpercompiledebugkotlin

## Fix for "Failed to load dynamic library 'libtensorflowlite_c.so': dlopen failed: library "libtensorflowlite_c.so" not found"
run the install.sh file in root directory for Mac/linux user
https://stackoverflow.com/questions/69554879/failed-to-load-dynamic-library-libtensorflowlite-c-so-dlopen-failed-library

## Example
link:
https://github.com/am15h/object_detection_flutter
https://medium.com/@am15hg/updates-to-tensorflow-lite-flutter-support-suite-7076c3fc27a9