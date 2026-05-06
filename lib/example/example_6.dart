import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:hooks_riverpod/misc.dart';
import 'package:riverpod/riverpod.dart';

enum FavoriteStatus { All, Favorite, NotFavorite }

final favoriteStatusProvider = StateProvider<FavoriteStatus>(
  (_) => FavoriteStatus.All,
);

final allFilmsProvider = StateNotifierProvider<FilmNotifier, List<Film>>(
  (_) => FilmNotifier(),
);

final favoriteFilmProvider = Provider<Iterable<Film>>((ref) {
  final film = ref.watch(allFilmsProvider);
  return film.where((film) => film.isFavourite);
});

final NotfavoriteFilmProvider = Provider<Iterable<Film>>((ref) {
  final film = ref.watch(allFilmsProvider);
  return film.where((film) => !film.isFavourite);
});

class Example6 extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Example 6')),
      body: Column(
        children: [
          const FilterWidget(),
          Consumer(
            builder: (context, ref, child) {
              final filter = ref.watch(favoriteStatusProvider);
              switch (filter) {
                case FavoriteStatus.All:
                  return FilmList(provider: allFilmsProvider);

                case FavoriteStatus.Favorite:
                  return FilmList(provider: favoriteFilmProvider);
                case FavoriteStatus.NotFavorite:
                  return FilmList(provider: NotfavoriteFilmProvider);
              }
            },
          ),
        ],
      ),
    );
  }
}

class FilmList extends ConsumerWidget {
  final ProviderListenable<Iterable<Film>> provider;
  const FilmList({required this.provider, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final film = ref.watch(provider);
    return Expanded(
      child: ListView.builder(
        itemCount: film.length,
        itemBuilder: (context, index) {
          final films = film.elementAt(index);
          final favoriteIcon = films.isFavourite
              ? const Icon(Icons.favorite)
              : const Icon(Icons.favorite_border);

          return ListTile(
            title: Text(films.title),
            subtitle: Text(films.description),
            trailing: IconButton(
              onPressed: () {
                final isFavorite = !films.isFavourite;
                ref.read(allFilmsProvider.notifier).update(films, isFavorite);
              },
              icon: favoriteIcon,
            ),
          );
        },
      ),
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
    isFavourite: isFavorite,
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

  Film(
    id: '2',
    title: 'Bolywood cinema',
    description: 'Description 2',
    isFavourite: false,
  ),

  Film(
    id: '3',
    title: 'Tamil cinema',
    description: 'Description 3',
    isFavourite: false,
  ),

  Film(
    id: '4',
    title: 'Hollywod cinema',
    description: 'Description 4',
    isFavourite: false,
  ),
];

class FilmNotifier extends StateNotifier<List<Film>> {
  FilmNotifier() : super(allFilms);

  void update(Film film, bool isFavorite) {
    state = state
        .map((f) => f.id == film.id ? film.copy(isFavorite: isFavorite) : f)
        .toList();
  }
}
