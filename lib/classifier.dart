import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as imageLib;
import 'package:tflite/tflite.dart';
// import 'package:object_detection/tflite/recognition.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'pred_stat.dart';
import 'package:collection/collection.dart';

/// Classifier
abstract class Classifier {
  /// Instance of Interpreter
  late Interpreter _interpreter;
  late InterpreterOptions _interpreterOptions;

  /// Labels file loaded as list
  late List<String> _labels;

  static const String MODEL_FILE_NAME = "model.tflite";
  static const String LABEL_FILE_NAME = "label.txt";

  /// Input size of image (height = width = 300)
  // static const int INPUT_SIZE = 300;
  final int _labelsLength = 7;

  /// Result score threshold
  static const double THRESHOLD = 0.5;

  /// [ImageProcessor] used to pre-process the image
  late ImageProcessor imageProcessor;

  /// Padding the image to transform into square
  late int padSize;

  late List<int> _inputShape;
  late List<int> _outputShape;

  late TfLiteType _inputType;
  late TfLiteType _outputType;

  late TensorBuffer _outputBuffer;

  late var _probabilityProcessor;

  /// Number of results to show
  static const int NUM_RESULTS = 10;

  String get modelName;

  NormalizeOp get preProcessNormalizeOp;
  NormalizeOp get postProcessNormalizeOp;

  Classifier({int? numThreads}) {
    _interpreterOptions = InterpreterOptions();
    if (numThreads != null) {
      _interpreterOptions.threads = numThreads;
    }
    loadModel();
    loadLabels();
    // imageProcessor = ImageProcessorBuilder()
    //     .add(ResizeWithCropOrPadOp(75, 100))
    //     // .add(ResizeOp(INPUT_SIZE, INPUT_SIZE, ResizeMethod.BILINEAR))
    //     .add(preProcessNormalizeOp)
    //     .build();
  }

  /// Loads interpreter from asset
  void loadModel() async {
    try {
      _interpreter = //interpreter ??
          await Interpreter.fromAsset(modelName, options: _interpreterOptions);
      _inputShape = interpreter.getInputTensor(0).shape;
      _outputShape = interpreter.getOutputTensor(0).shape;
      _inputType = interpreter.getInputTensor(0).type;
      _outputType = interpreter.getOutputTensor(0).type;

      _outputBuffer = TensorBuffer.createFixedSize(_outputShape, _outputType);
      // _outputBuffer = TensorBuffer.createFixedSize(
      //   <int>[1, 7],
      //   TfLiteType.float32
      // );
      _probabilityProcessor =
          TensorProcessorBuilder().add(postProcessNormalizeOp).build();
    } catch (e) {
      print("Error while creating interpreter: $e");
    }
  }

  /// Loads labels from assets
  Future<void> loadLabels() async {
    try {
      _labels = //labels ??
          await FileUtil.loadLabels("assets/" + LABEL_FILE_NAME);
      if (labels.length == _labelsLength) {
        print('Labels loaded successfully');
      } else {
        print('Unable to load labels');
      }
    } catch (e) {
      print("Error while loading labels: $e");
    }
  }

  /// Pre-process the image
  TensorImage getProcessedImage(TensorImage inputImage) {
    // padSize = max(inputImage.height, inputImage.width);
    int h = inputImage.height, w = inputImage.width;
    if (h > w * 75 / 100) {
      double temp = w * 0.75;
      while (temp % 1 != 0) {
        temp = --w * 0.75;
      }
      h = temp.round();
    } else if (w > h * 100 / 75) {
      double temp = h * 100 / 75;
      while (temp % 1 != 0) {
        temp = --h * 100 / 75;
      }
      w = temp.round();
    } else {
      double temp = w * 0.75;
      while (temp % 1 != 0) {
        temp = --w * 0.75;
      }
      h = temp.round();
    }
    imageProcessor = ImageProcessorBuilder()
        .add(ResizeWithCropOrPadOp(h, w))
        .add(ResizeOp(75, 100, ResizeMethod.BILINEAR))
        .add(preProcessNormalizeOp)
        .build();
    inputImage = imageProcessor.process(inputImage);
    return inputImage;
  }

  /// Runs object detection on the input image
  Map<String, double> predict(imageLib.Image image) {
    final predictStartTime = DateTime.now().millisecondsSinceEpoch;

    // var preProcessStart = DateTime.now().millisecondsSinceEpoch;

    // Create TensorImage from image
    // TensorImage inputImage = TensorImage.fromImage(image);
    TensorImage inputImage = TensorImage(TfLiteType.float32);
    inputImage.loadImage(image);

    // Pre-process TensorImage
    inputImage = getProcessedImage(inputImage);

    final preProcessElapsedTime =
        DateTime.now().millisecondsSinceEpoch - predictStartTime;
    print('Time to load image: $preProcessElapsedTime ms');

    final runs = DateTime.now().millisecondsSinceEpoch;
    interpreter.run(inputImage.buffer, _outputBuffer.getBuffer());
    final run = DateTime.now().millisecondsSinceEpoch - runs;

    print('Time to run inference: $run ms');

    // TensorBuffers for output tensors
    Map<String, double> labeledProb = TensorLabel.fromList(
            labels, _probabilityProcessor.process(_outputBuffer))
        .getMapWithFloatValue();
    return labeledProb;
    // final pred = getTopProbability(labeledProb);
    // Inputs object for runForMultipleInputs
    // Use [TensorImage.buffer] or [TensorBuffer.buffer] to pass by reference
    // return Category(pred.key, pred.value);
  }

  void close() {
    interpreter.close();
  }

  /// Gets the interpreter instance
  Interpreter get interpreter => _interpreter;

  /// Gets the loaded labels
  List<String> get labels => _labels;
}

MapEntry<String, double> getTopProbability(Map<String, double> labeledProb) {
  var pq = PriorityQueue<MapEntry<String, double>>(compare);
  pq.addAll(labeledProb.entries);

  return pq.first;
}

int compare(MapEntry<String, double> e1, MapEntry<String, double> e2) {
  if (e1.value > e2.value) {
    return -1;
  } else if (e1.value == e2.value) {
    return 0;
  } else {
    return 1;
  }
}
