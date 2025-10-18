import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

const packageName = 'com.hashapps.lingoai';

@injectable
class IapService {
  IapService(this._inAppPurchase, this.logger);

  final InAppPurchase _inAppPurchase;
  final Logger logger;

  Stream<List<PurchaseDetails>> get purchaseStream => _inAppPurchase.purchaseStream;

  Future<List<ProductDetails>> getProductsDetails(Set<String> productIds) async {
    final isStoreAvailable = await _inAppPurchase.isAvailable();

    if (!isStoreAvailable) return [];

    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(IosPaymentQueueDelegate());
    }

    final response = await _inAppPurchase.queryProductDetails(productIds);

    return response.productDetails;
  }

  Future<bool> purchase(ProductDetails productDetails) async {
    try {
      final purchaseParam = PurchaseParam(productDetails: productDetails, applicationUserName: packageName);

      await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);

      return true;
    } on PlatformException catch (e) {
      logger.e('Error making ${Platform.isAndroid ? 'Android' : 'IOS'} buy_coins:$e');
      if (Platform.isIOS) await _finishIncompleteIosTransactions();
      return false;
    } catch (e) {
      logger.e('Error making buy_coins: $e');
      return false;
    }
  }

  Future<bool> restorePurchase() async {
    try {
      await _inAppPurchase.restorePurchases(applicationUserName: packageName);
      return true;
    } catch (e) {
      return false;
    }
  }
}

Future<void> _finishIncompleteIosTransactions() async {
  final transactions = await SKPaymentQueueWrapper().transactions();
  for (final skPaymentTransactionWrapper in transactions) {
    SKPaymentQueueWrapper().finishTransaction(skPaymentTransactionWrapper);
    log('Finished incomplete iOS transaction');
  }
}

/// Example implementation of the
/// [`SKPaymentQueueDelegate`](https://developer.apple.com/documentation/storekit/skpaymentqueuedelegate?language=objc).
///
/// The payment queue delegate can be implementated to provide information
/// needed to complete transactions.
class IosPaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
