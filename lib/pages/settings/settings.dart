
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:sparkd/core/constants/imports.dart';
import 'package:sparkd/pages/settings/settings_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(
        title: AppStrings.settings,
      ),
      body: GetBuilder<SettingsController>(
      init: SettingsController(inAppPurchaseSource: Get.find()),
        builder: (controller) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // SB.h(20),
                // _SubscriptionCard(controller: controller), // Show the subscription card
                SB.h(20),
                _Tile(
                  iconPath: Assets.icons.terms.path,
                  title: AppStrings.termsConditions,
                  onTap: ()async {
                     const url =
                            'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/'; // Replace with your Privacy Policy URL
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// class _SubscriptionCard extends StatelessWidget {
//   final SettingsController controller;
//   const _SubscriptionCard({super.key, required this.controller});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ListTile(
//             leading: Icon(Icons.star, color: context.primary),
//             title: Text(
//               'Premium Subscription',
//               style: context.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
//             ),
//             subtitle: Text('Get access to premium features for only \$19.99 per month.'),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: ElevatedButton(
//               onPressed: () async {
//                 // Trigger the subscription process
//               //  await _subscribe(context);
//               controller.onSubscriptionPressed();
//               },
//               child: Text('Subscribe Now'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _subscribe(BuildContext context) async {
//     final InAppPurchase inAppPurchase = InAppPurchase.instance;

//     // The product ID for your subscription
//     const String productId = 'com.app.sparkd.premium.monthly';

//     // Query product details
//     final ProductDetailsResponse response =
//         await inAppPurchase.queryProductDetails({productId});
//         print(response.productDetails);
//     if (response.error != null || response.productDetails.isEmpty) {
//       // Handle errors
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load subscription details')),
//       );
//       return;
//     }

//     final ProductDetails productDetails = response.productDetails.first;

//     // Start the subscription purchase
//     final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
//     inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
//   }
// }

class _Tile extends StatelessWidget {
  const _Tile({super.key, required this.iconPath, required this.title, this.onTap});
  final String iconPath, title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Image.asset(
                iconPath,
                width: 28,
                height: 28,
              ),
              SB.w(10),
              Expanded(
                child: Text(
                  title,
                  style: context.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: context.primary,
                size: 18,
              )
            ],
          ).paddingAll(15),
        ),
        Divider(
          color: context.primary,
        )
      ],
    );
  }
}
