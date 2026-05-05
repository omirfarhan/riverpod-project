import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

enum FavoriteStatus { All, Favorite, NotFavorite }

final favoriteStatusProvider = StateProvider<FavoriteStatus>(
  (_) => FavoriteStatus.All,
);

class Example6 extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Example 6')),
      body: Column(children: [const FilterWidget()]),
    );
  }
}

class FilterWidget extends StatelessWidget {
  const FilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return DropdownButton<FavoriteStatus>(
          value: ref.watch(favoriteStatusProvider),
          items: FavoriteStatus.values.map((fs) {
            return DropdownMenuItem(
              child: Text(fs.name.split('.').last),
              value: fs,
            );
          }).toList(),
          onChanged: (status) {
            ref.read(favoriteStatusProvider.notifier).state = status!;
          },
        );
      },
    );
  }
}

@immutable
class Film {
  final String id;
  final String title;
  final String description;
  final bool isFavourite;

  const Film({
    required this.id,
    required this.title,
    required this.description,
    required this.isFavourite,
  });

  Film copy({required bool isFavorite}) => Film(
    id: id,
    title: title,
    description: description,
    isFavourite: isFavourite,
  );

  @override
  String toString() =>
      'Film(id: $id, title: $title, description: $description, isFavorite: $isFavourite)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Film && id == other.id && isFavourite == other.isFavourite;

  @override
  int get hashCode => Object.hash(id, isFavourite);
}

const allFilms = [
  Film(
    id: '1',
    title: 'Tollywod cinema',
    description: 'Description 1',
    isFavourite: false,
  ),
];
