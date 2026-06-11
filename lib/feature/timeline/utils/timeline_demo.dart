import 'dart:developer';
import 'dart:isolate';

/// Runs a short CPU-bound loop to simulate synchronous work on the main isolate.
int simulateCpuWork(int iterations) {
  var sum = 0;
  for (var i = 0; i < iterations; i++) {
    sum += i;
  }
  return sum;
}

/// 1. Very basic [Timeline.startSync] / [Timeline.finishSync].
int runBasicStartSyncDemo({int iterations = 1500000}) {
  Timeline.startSync('basic-start-sync');
  try {
    return simulateCpuWork(iterations);
  } finally {
    Timeline.finishSync();
  }
}

/// 2. Very basic [Timeline.timeSync].
int runBasicTimeSyncDemo({int iterations = 1500000}) {
  return Timeline.timeSync('basic-time-sync', () {
    return simulateCpuWork(iterations);
  });
}

/// 3. Multiple nested timeline events using [Timeline.startSync].
int runMultipleStartSyncDemo({int iterations = 1000000}) {
  Timeline.startSync('parent-operation');
  try {
    Timeline.startSync('step-1-parse', arguments: {'duration': 'short'});
    try {
      simulateCpuWork(iterations ~/ 8);
    } finally {
      Timeline.finishSync();
    }

    Timeline.startSync('step-2-transform', arguments: {'duration': 'long'});
    try {
      simulateCpuWork(iterations * 3);
    } finally {
      Timeline.finishSync();
    }

    Timeline.startSync('step-3-format', arguments: {'duration': 'short'});
    try {
      return simulateCpuWork(iterations ~/ 10);
    } finally {
      Timeline.finishSync();
    }
  } finally {
    Timeline.finishSync();
  }
}

/// 4. Multiple nested timeline events using [Timeline.timeSync].
int runMultipleTimeSyncDemo({int iterations = 1000000}) {
  return Timeline.timeSync('parent-operation', () {
    Timeline.timeSync('step-1-parse', arguments: {'duration': 'short'}, () {
      simulateCpuWork(iterations ~/ 8);
    });

    Timeline.timeSync('step-2-transform', arguments: {'duration': 'long'}, () {
      simulateCpuWork(iterations * 3);
    });

    return Timeline.timeSync('step-3-format', arguments: {'duration': 'short'}, () {
      return simulateCpuWork(iterations ~/ 10);
    });
  });
}

void _multiThreadWorkerEntry(List<dynamic> message) {
  final taskId = message[0] as int;
  final SendPort replyPort = message[1] as SendPort;
  final iterations = message[2] as int;
  final workerName = message[3] as String;

  final workerTask = TimelineTask.withTaskId(taskId);
  workerTask.start(workerName);
  try {
    Timeline.timeSync('worker-fetch', () {
      simulateCpuWork(iterations ~/ 2);
    });

    final result = Timeline.timeSync('worker-parse', () {
      return simulateCpuWork(iterations);
    });

    replyPort.send(result);
  } finally {
    workerTask.finish();
  }
}

Future<int> _spawnLinkedWorker(
  TimelineTask parentTask,
  String workerName,
  int iterations,
) async {
  final workerTask = TimelineTask(parent: parentTask);
  final workerTaskId = workerTask.pass();

  final receivePort = ReceivePort();
  await Isolate.spawn(
    _multiThreadWorkerEntry,
    [
      workerTaskId,
      receivePort.sendPort,
      iterations,
      workerName,
    ],
  );

  try {
    return await receivePort.first as int;
  } finally {
    receivePort.close();
  }
}

/// 5. Multiple timeline events across parallel worker isolates.
Future<List<int>> runMultipleThreadTimelineDemo({
  int workerCount = 3,
  int iterationsPerWorker = 1000000,
}) async {
  final parentTask = TimelineTask();
  parentTask.start('multi-thread-parent', arguments: {'workers': workerCount});

  try {
    final futures = List.generate(
      workerCount,
      (index) => _spawnLinkedWorker(
        parentTask,
        'worker-$index',
        iterationsPerWorker,
      ),
    );
    return Future.wait(futures);
  } finally {
    parentTask.finish();
  }
}

/// Measures elapsed microseconds using [Timeline.now].
Duration measureSyncOperation(String name, void Function() operation) {
  final start = Timeline.now;
  Timeline.startSync(name);
  try {
    operation();
  } finally {
    Timeline.finishSync();
  }
  final end = Timeline.now;
  return Duration(microseconds: end - start);
}
