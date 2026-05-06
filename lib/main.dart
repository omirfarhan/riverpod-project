import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:riverpod_project/example/example3.dart';
import 'package:riverpod_project/example/example_5.dart';
import 'package:riverpod_project/example/example_6.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

extension OptionalInfixAddition<T extends num> on T? {
  T? operator +(T? other) {
    final shadow = this;
    if (shadow != null) {
      return shadow + (other ?? 0) as T;
    } else {
      return null;
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueGrey,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      themeMode: ThemeMode.light,
      home: const MyHomePage(),
    );
  }
}

final currentDate = Provider<DateTime>((ref) => DateTime.now());

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = ref.watch(currentDate);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Riverpod state management',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Text(date.toIso8601String()),
            Consumer(
              builder: (context, ref, child) {
                final count = ref.watch(counterProvider);
                final text = count == null
                    ? 'Press your button'
                    : count.toString();
                return Text(text, style: TextStyle(fontSize: 25));
              },
            ),
            ElevatedButton(
              onPressed: ref.read(counterProvider.notifier).increment,
              child: Text('Increment counter'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => Example3()));
              },
              child: Text('Example 3'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => Example5()));
              },
              child: Text('Example 5'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => Example6()));
              },
              child: Text('Example 6'),
            ),
          ],
        ),
      ),
    );
  }
}

final counterProvider = StateNotifierProvider<Counter, int?>(
  (ref) => Counter(),
);

class Counter extends StateNotifier<int?> {
  Counter() : super(null);
  void increment() {
    state = state == null ? 1 : state + 1;
  }
}
