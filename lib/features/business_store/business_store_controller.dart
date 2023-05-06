import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viewducts/apis/business_store_api.dart';
import 'package:viewducts/apis/country_api.dart';
import 'package:viewducts/model/chatModel.dart';
import 'package:viewducts/model/feedModel.dart';

final businessStoreControllerProvider =
    StateNotifierProvider<CountryController, bool>(
  (ref) {
    return CountryController(
      // ref: ref,
      businessStoreApi: ref.watch(businessStoreAPIProvider),
    );
  },
);
final getStaffProvider =
    FutureProvider.family.autoDispose((ref, String userId) {
  final businessStoreController =
      ref.watch(businessStoreControllerProvider.notifier);
  return businessStoreController.getStaff(userId);
});
final getExchangeRateProvider =
    FutureProvider.family.autoDispose((ref, String userId) {
  final businessStoreController =
      ref.watch(businessStoreControllerProvider.notifier);
  return businessStoreController.getExchangeRate(userId);
});
final getProductReviewCommentProvider =
    FutureProvider.family.autoDispose((ref, String userId) {
  final businessStoreController =
      ref.watch(businessStoreControllerProvider.notifier);
  return businessStoreController.getProductReviewComment(userId);
});
final getVendorBusinessStatusProvider =
    FutureProvider.family.autoDispose((ref, String userId) {
  final businessStoreController =
      ref.watch(businessStoreControllerProvider.notifier);
  return businessStoreController.getVendorBusinessStatus(userId);
});
final getwasabiAwsApiProvider = FutureProvider((
  ref,
) {
  final productController = ref.watch(businessStoreControllerProvider.notifier);
  return productController.wasabiAwsApi();
});

class CountryController extends StateNotifier<bool> {
  final BusinessAPI _businessStoreApi;
  CountryController({
    required BusinessAPI businessStoreApi,
  })  : _businessStoreApi = businessStoreApi,
        super(false);
  Future<List<StaffUserModel>> getStaff(String userId) async {
    final businessStoreController = await _businessStoreApi.getStaff(userId);
    return businessStoreController
        .map((country) => StaffUserModel.fromSnapshot(country.data))
        .toList();
  }

  Future<List<ExchangeRateModel>> getExchangeRate(String currency) async {
    final businessStoreController =
        await _businessStoreApi.getExchangeRate(currency);
    return businessStoreController
        .map((exchangeRate) => ExchangeRateModel.fromJson(exchangeRate.data))
        .toList();
  }

  Future<List<StaffUserModel>> getVendorBusinessStatus(String userId) async {
    final businessStoreController =
        await _businessStoreApi.getVendorBusinessStatus(userId);
    return businessStoreController
        .map((businessVendor) =>
            StaffUserModel.fromSnapshot(businessVendor.data))
        .toList();
  }

  Future<AwsWasabiStorageModel> wasabiAwsApi() async {
    final getwasabiAwsApi = await _businessStoreApi.wasabiAwsApi();
    return AwsWasabiStorageModel.fromJson(getwasabiAwsApi.data);
  }

  Future<List<ProductReviewModel>> getProductReviewComment(
      String productId) async {
    final businessStoreController =
        await _businessStoreApi.getProductReviewComment(productId);
    return businessStoreController
        .map((productReview) =>
            ProductReviewModel.fromSnapshot(productReview.data))
        .toList();
  }
}
