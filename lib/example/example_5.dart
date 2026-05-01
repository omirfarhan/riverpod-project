import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Example5 extends ConsumerWidget {
  const Example5({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

@immutable
class Persons {
  final String name;
  final String age;
  final String uuid;

  const Persons({
    required this.name,
    required this.age,
    required this.uuid,
  });
}
