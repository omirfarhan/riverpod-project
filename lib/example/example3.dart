import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

enum City { Dhaka, Kishoreganj, Kushtia }

typedef weatheraEmoji = String;

Future<weatheraEmoji> getWeather(City city) {
  return Future.delayed(
    const Duration(seconds: 1),
    () =>
        {City.Dhaka: '☀️', City.Kishoreganj: '🌧️', City.Kushtia: '🌈'}[city]!,
  );
}

final currentCityProvider = StateProvider<City?>((ref) => null);
const unknownWeatherCity = '❄️';

final weatherScopeProvider = FutureProvider<weatheraEmoji>((ref) {
  final city = ref.watch(currentCityProvider);
  if (city != null) {
    return getWeather(city);
  } else {
    return unknownWeatherCity;
  }
});

class Example3 extends ConsumerWidget {
  const Example3({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeather = ref.watch(weatherScopeProvider);

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Weather')),
      body: Column(
        children: [
          currentWeather.when(
            data: (data) => Text(data, style: TextStyle(fontSize: 40)),
            error: (error, stackTrace) => Text('error'),
            loading: () => const CircularProgressIndicator(),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: City.values.length,
              itemBuilder: (context, index) {
                final city = City.values[index];
                final isSelected = city == ref.watch(currentCityProvider);
                return ListTile(
                  title: Text(city.toString()),
                  trailing: isSelected ? const Icon(Icons.check) : null,
                  onTap: () {
                    ref.read(currentCityProvider.notifier).state = city;
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
