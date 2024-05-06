# Health Care Application (Dr. UST)
The mobile app Dr. UST mainly targets medical staff and patients and is a supportive tool in medical consultation. Our telemedicine system is a comprehensive platform designed to benefit immobile individuals and others, particularly during pandemics. It offers advantages to clinics by improving booking processes, reducing contact, and minimizing the aggregation of infectious patients. Patients, especially those who are immobile or have busy schedules, can benefit from time and cost savings. The application utilizes machine learning for medical image predictions, symptom surveys, and video meetings, leveraging resources available on most mobile devices. Additionally, its messaging function enables seamless follow-up for medical problems. Overall, this telemedicine system represents a significant advancement in healthcare delivery, with the potential to improve lives during and after pandemics.

If you would like to known more of the project, you could view the [paper](https://drive.google.com/file/d/1N4W2iM2GKBxj5PLLNTmIGMv5g0VzcdLz/view?usp=sharing) or the [video](https://drive.google.com/file/d/1LkSA3A6bsWz6N9-kJrihpkCVTU9BoRqY/view?usp=sharing).

## Related repositories
The implementation of the [proxy flask server](https://github.com/jiffij/skin_ml_flask.git) and the [skin-lesion classification model](https://github.com/jiffij/skin_cancer_model.git).

## TODO List 
- [x] 3rd party video call 
- [x] UI Bugs
- [x] Record page empty (added invitation page, third party meeting)
- [x] call dispose handled
- [x] messaging
- [x] refresh gesture on booking page
- [x] calendar event list
- [x] Doctor Detail save and message button
- [x] Profile page edit
- [ ] hard ware
- [x] logout
- [x] doctor page color

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
