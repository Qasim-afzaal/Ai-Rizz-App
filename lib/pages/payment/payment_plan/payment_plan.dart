import 'package:url_launcher/url_launcher.dart';

import 'package:sparkd/core/constants/imports.dart';
import 'package:sparkd/routes/app_pages.dart';

import 'payment_plan_controller.dart';

class PaymentPlanPage extends StatelessWidget {
  const PaymentPlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    print("Screen Height: ${MediaQuery.of(context).size.height}");
    return GetBuilder(
      init: PaymentPlanController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              // Image asset in the background
              Positioned(
                top: 0,  // Starts at the top of the screen
                left: 0,
                right: 0,
                child: Image.asset(
                  "assets/images/paywall.png",
                  fit: BoxFit.cover,  // Makes sure the image covers the screen
                  height: MediaQuery.of(context).size.height * 0.5,  // Adjust height based on screen size
                ),
              ),
              // Column with content on top of the image
              Positioned.fill(
            top: (MediaQuery.of(context).size.height >= 667.0 &&
        MediaQuery.of(context).size.height <= 710.0)
      ? MediaQuery.of(context).size.height * 0.25
      : MediaQuery.of(context).size.height * 0.4,
                // top: MediaQuery.of(context).size.height * 0.4,  // Start the content below the image
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 100),  // Adjust this padding as needed to avoid overlap
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              color: context.primary.withOpacity(0.4), // Background color
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                color: const Color.fromARGB(255, 255, 145, 0), // Border color
                                width: 1, // Border width
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Assets.images.flame.image(scale: (1.5)),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Sparkd Coach",
                                    style: context.headlineMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 28,
                                        color: Colors.white),
                                  ),
                                ),
                                Assets.images.flame.image(scale: (1.5)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Monthly auto-renewable subscription",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: context.primary.withOpacity(0.4), // Background color
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                      color: const Color.fromARGB(255, 255, 145, 0), // Border color
                                      width: 1, // Border width
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Assets.images.flame.image(scale: (3)),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Unlimited sparks",
                                          style: context.headlineMedium?.copyWith(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: context.primary.withOpacity(0.4), // Background color
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                      color: const Color.fromARGB(255, 255, 145, 0), // Border color
                                      width: 1, // Border width
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Assets.images.flame.image(scale: (3)),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Personal coach",
                                          style: context.headlineMedium?.copyWith(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: 150,
                          height: 40,
                          decoration: BoxDecoration(
                            color: context.primary.withOpacity(0.4), // Background color
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: const Color.fromARGB(255, 255, 145, 0), // Border color
                              width: 1, // Border width
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Assets.images.flame.image(scale: (3)),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Personal coach",
                                  style: context.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          " Get unlimited sparks/chat with your premium Sparkd coach subscription",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AppButton.primary(
                            title: "Unlock free trial",
                            onPressed: () async {
                             Get.offNamed(Routes.PAYMENT_CONFIRMATION);
                            },
                          ),
                        ),
                        const SizedBox(height: 7),
                        const Text(
                          "Enjoy 30 Day free trial \nThen just \$3.99 per week afterward!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 8.0, 20, 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () async {
                                  // const url =
                                  //     'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/';
                                  // if (await canLaunch(url)) {
                                  //   await launch(url);
                                  // } else {
                                  //   throw 'Could not launch $url';
                                  // }
                                },
                                child: Text(
                                  "Terms of Use",
                                  textAlign: TextAlign.center,
                                  style: context.titleSmall?.copyWith(
                                    decorationColor: Colors.white,
                                    color: Colors.white,
                                    decoration: TextDecoration.underline, // Underline added here
                                    fontWeight: FontWeight.w400,
                                    height: 1,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  // Your existing code here...
                                },
                                child: Text(
                                  "Restore",
                                  textAlign: TextAlign.center,
                                  style: context.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white,
                                    height: 1,
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  // const url =
                                  //     'https://fancy-bubblegum-216efa.netlify.app/'; // Replace with your Privacy Policy URL
                                  // if (await canLaunch(url)) {
                                  //   await launch(url);
                                  // } else {
                                  //   throw 'Could not launch $url';
                                  // }
                                },
                                child: Text(
                                  "Privacy Policy",
                                  textAlign: TextAlign.center,
                                  style: context.titleSmall?.copyWith(
                                    color: Colors.white,
                                    decorationColor: Colors.white,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w400,
                                    height: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
