class Stats {
  /// Total time taken in the isolate where the inference runs
  int totalPredictTime;

  /// [totalPredictTime] + communication overhead time
  /// between main isolate and another isolate
  // int totalElapsedTime;

  /// Time for which inference runs
  int inferenceTime;

  /// Time taken to pre-process the image
  int preProcessingTime;

  double score;

  String label;

  Stats(
      {required this.totalPredictTime,
      // required this.totalElapsedTime,
      required this.inferenceTime,
      required this.preProcessingTime,
      required this.score,
      required this.label});

  @override
  String toString() {
    return 'Stats{totalPredictTime: $totalPredictTime, inferenceTime: $inferenceTime, preProcessingTime: $preProcessingTime}';
  }
}
