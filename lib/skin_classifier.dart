import 'classifier.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

class SkinClassifier extends Classifier {
  SkinClassifier({int numThreads: 1}) : super(numThreads: numThreads);

  @override
  String get modelName => 'model_3.tflite';

  @override
  NormalizeOp get preProcessNormalizeOp => NormalizeOp(0, 1);

  @override
  NormalizeOp get postProcessNormalizeOp => NormalizeOp(0, 255);
}
