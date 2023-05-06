import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viewducts/apis/country_api.dart';
import 'package:viewducts/model/feedModel.dart';

final countryControllerProvider =
    StateNotifierProvider<CountryController, bool>(
  (ref) {
    return CountryController(
      // ref: ref,
      countryApi: ref.watch(countryAPIProvider),
    );
  },
);
final getCountryProvider = FutureProvider((ref) {
  final countryController = ref.watch(countryControllerProvider.notifier);
  return countryController.getLocation();
});
final getCountryCitryProvider =
    FutureProvider.family.autoDispose((ref, String country) {
  final countryController = ref.watch(countryControllerProvider.notifier);
  return countryController.getCountryCity(country);
});

class CountryController extends StateNotifier<bool> {
  final CountryAPI _countryApi;
  CountryController({
    required CountryAPI countryApi,
  })  : _countryApi = countryApi,
        super(false);
  Future<List<CountryModel>> getLocation() async {
    final countryLocation = await _countryApi.getCountryLocation();
    return countryLocation
        .map((country) => CountryModel.fromSnapshot(country.data))
        .toList();
  }

  Future<List<CountryModel>> getCountryCity(String country) async {
    final countryLocationCity = await _countryApi.getCountryStateCity(country);
    return countryLocationCity
        .map((country) => CountryModel.fromSnapshot(country.data))
        .toList();
  }
}
