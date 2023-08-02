import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journalbot/wrapper.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;

void main() async {
  runApp(
    const ProviderScope(
      child: JournalBot(),
    ),
  );
  await Firebase.initializeApp();
  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };
}

// TODO : Change the name of the class
class JournalBot extends ConsumerWidget {
  const JournalBot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      title: 'Journal Bot',
      home: const Wrapper(),
    );
  }
}
