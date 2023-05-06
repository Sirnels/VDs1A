import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:viewducts/features/auth/controller/auth_controller.dart';
import 'package:viewducts/features/products/product_controller.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/state/stateController.dart';

class ReviewDialog extends ConsumerWidget {
  final String productUid;
  const ReviewDialog({Key? key, required this.productUid}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return RatingDialog(
      title: const Text(
        'Type a review for this product!',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      // encourage your user to leave a high rating?

      submitButtonText: 'Send',
      commentHint: 'Type here',

      onSubmitted: (RatingDialogResponse res) async {
        try {
          ref.read(productControllerProvider.notifier).addProductReviews(
              res.comment,
              res.rating.toInt(),
              productUid,
              currentUser!.displayName.toString(),
              currentUser,
              context);
        } on AppwriteException catch (e) {
          cprint(e.toString());
        }
      },
    );
  }
}
