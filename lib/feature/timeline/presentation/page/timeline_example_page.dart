import 'package:flutter/material.dart';
import 'package:sample_todo/feature/timeline/utils/timeline_demo.dart';

class TimelineExamplePage extends StatefulWidget {
  const TimelineExamplePage({super.key});

  @override
  State<TimelineExamplePage> createState() => _TimelineExamplePageState();
}

class _TimelineExamplePageState extends State<TimelineExamplePage> {
  final List<String> _eventLog = [];
  String? _lastDuration;

  void _runDemo(String label, void Function() demo) {
    final duration = measureSyncOperation(label, demo);
    _recordRun(label, duration);
  }

  Future<void> _runAsyncDemo(String label, Future<void> Function() demo) async {
    final stopwatch = Stopwatch()..start();
    await demo();
    stopwatch.stop();
    _recordRun(label, stopwatch.elapsed);
  }

  void _recordRun(String label, Duration duration) {
    setState(() {
      _lastDuration = '${duration.inMilliseconds} ms';
      _eventLog.insert(0, '$label finished in $_lastDuration');
      if (_eventLog.length > 8) {
        _eventLog.removeLast();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Timeline API'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Timeline from dart:developer records work for Flutter DevTools. '
            'Run with flutter run --profile, open DevTools → Performance, '
            'then tap each example below.',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          if (_lastDuration != null) ...[
            const SizedBox(height: 12),
            Text('Last run: $_lastDuration'),
          ],
          const SizedBox(height: 24),
          _ExampleSection(
            number: 1,
            title: 'Very basic startSync',
            description:
                'Bracket synchronous work with startSync and finishSync. '
                'Always call finishSync in a finally block.',
            code: """
Timeline.startSync('basic-start-sync');
try {
  simulateCpuWork(iterations);
} finally {
  Timeline.finishSync();
}""",
            buttonLabel: 'Run basic startSync',
            onPressed: () => _runDemo(
              'basic-start-sync',
              runBasicStartSyncDemo,
            ),
          ),
          _ExampleSection(
            number: 2,
            title: 'Very basic timeSync',
            description:
                'timeSync wraps a closure and calls startSync / finishSync '
                'for you automatically.',
            code: """
Timeline.timeSync('basic-time-sync', () {
  return simulateCpuWork(iterations);
});""",
            buttonLabel: 'Run basic timeSync',
            onPressed: () => _runDemo(
              'basic-time-sync',
              runBasicTimeSyncDemo,
            ),
          ),
          _ExampleSection(
            number: 3,
            title: 'Multiple timeline using startSync',
            description:
                'Nest multiple startSync calls with different workloads — '
                'short steps finish early, long steps stretch the parent slice.',
            code: """
Timeline.startSync('parent-operation');
try {
  Timeline.startSync('step-1-parse', arguments: {'duration': 'short'});
  try { parseFast(); } finally { Timeline.finishSync(); }

  Timeline.startSync('step-2-transform', arguments: {'duration': 'long'});
  try { transformSlow(); } finally { Timeline.finishSync(); }

  Timeline.startSync('step-3-format', arguments: {'duration': 'short'});
  try { formatFast(); } finally { Timeline.finishSync(); }
} finally {
  Timeline.finishSync();
}""",
            buttonLabel: 'Run multiple startSync',
            onPressed: () => _runDemo(
              'parent-operation',
              runMultipleStartSyncDemo,
            ),
          ),
          _ExampleSection(
            number: 4,
            title: 'Multiple timeline using timeSync',
            description:
                'Same nested structure as startSync, but some steps run longer '
                'than others so child slices have visibly different widths.',
            code: """
Timeline.timeSync('parent-operation', () {
  Timeline.timeSync('step-1-parse', arguments: {'duration': 'short'}, () {
    parseFast();
  });
  Timeline.timeSync('step-2-transform', arguments: {'duration': 'long'}, () {
    transformSlow();
  });
  Timeline.timeSync('step-3-format', arguments: {'duration': 'short'}, () {
    formatFast();
  });
});""",
            buttonLabel: 'Run multiple timeSync',
            onPressed: () => _runDemo(
              'parent-operation',
              runMultipleTimeSyncDemo,
            ),
          ),
          _ExampleSection(
            number: 5,
            title: 'Multiple timeline with multi-thread',
            description:
                'CPU work runs in parallel worker isolates. The main isolate '
                'uses TimelineTask; each worker resumes its task via '
                'TimelineTask.pass / withTaskId and records nested timeSync '
                'slices.',
            code: """
// Main isolate
final parent = TimelineTask();
parent.start('multi-thread-parent');
final workerId = TimelineTask(parent: parent).pass();
await Isolate.spawn(worker, workerId);
parent.finish();

// Worker isolate
void worker(int taskId) {
  final task = TimelineTask.withTaskId(taskId);
  task.start('worker-0');
  Timeline.timeSync('worker-fetch', () { fetch(); });
  Timeline.timeSync('worker-parse', () { parse(); });
  task.finish();
}""",
            buttonLabel: 'Run multi-thread (3 workers)',
            onPressed: () => _runAsyncDemo(
              'multi-thread-parent',
              () async => runMultipleThreadTimelineDemo(),
            ),
          ),
          const SizedBox(height: 24),
          const _SectionTitle('Event log'),
          if (_eventLog.isEmpty)
            const Text('No demos run yet.')
          else
            ..._eventLog.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text('• $entry'),
              ),
            ),
          const SizedBox(height: 24),
          const _SectionTitle('Important constraints'),
          const Text(
            '• startSync / timeSync are for synchronous code on the current isolate.\n'
            '• For async orchestration on the main isolate, use TimelineTask.\n'
            '• Each isolate has its own timeline — pass task ids with '
            'TimelineTask.pass and TimelineTask.withTaskId to link events.\n'
            '• Always call finish / finishSync in finally to avoid corrupting '
            'the timeline.',
          ),
        ],
      ),
    );
  }
}

class _ExampleSection extends StatelessWidget {
  const _ExampleSection({
    required this.number,
    required this.title,
    required this.description,
    required this.code,
    required this.buttonLabel,
    required this.onPressed,
  });

  final int number;
  final String title;
  final String description;
  final String code;
  final String buttonLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle('$number. $title'),
          Text(description),
          const SizedBox(height: 12),
          _CodeBlock(code),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onPressed,
            child: Text(buttonLabel),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  const _CodeBlock(this.code);

  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: SelectableText(
        code.trim(),
        style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
      ),
    );
  }
}
