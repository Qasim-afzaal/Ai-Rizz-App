import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:scroll_loop_auto_scroll/scroll_loop_auto_scroll.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sparkd/core/constants/imports.dart';
import 'package:sparkd/pages/home/home_controller.dart';
import 'package:sparkd/widgets/lines_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final InAppReview _inAppReview = InAppReview.instance;
  bool _hasReviewed = false;
  int _appUsageTime = 0;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _checkIfAlreadyReviewed();
    _startUsageTimer();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  // Check if the user has already seen the review
  Future<void> _checkIfAlreadyReviewed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!_isDisposed) {
      setState(() {
        _hasReviewed = prefs.getBool('hasReviewed') ?? false;
      });
    }
  }

  // Save that the review has been shown
  Future<void> _setHasReviewed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasReviewed', true);
  }

  // Start tracking user time in the app
  void _startUsageTimer() {
    const int timeLimit = 60; // 60 seconds before prompting review
    Future.delayed(const Duration(seconds: 1), () async {
      if (_isDisposed) return; // Exit if disposed
      setState(() {
        _appUsageTime++;
      });
      if (_appUsageTime >= timeLimit && !_hasReviewed) {
        _triggerInAppReview();
      } else {
        _startUsageTimer(); // Keep counting time
      }
    });
  }

  // Trigger in-app review
  Future<void> _triggerInAppReview() async {
    if (await _inAppReview.isAvailable()) {
      await _inAppReview.requestReview();
      await _setHasReviewed();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    // Determine number of items per row based on screen height
    int itemsPerRow;
    if (screenHeight >= 600 && screenHeight <= 776) {
      itemsPerRow = 17;
    } else if (screenHeight >= 932 && screenHeight <= 1000) {
      itemsPerRow = Platform.isIOS ? 10 : 10;
    } else if (screenHeight >= 926 && screenHeight <= 940) {
      itemsPerRow = Platform.isIOS ? 10 : 12;
    } else if (screenHeight >= 800 && screenHeight <= 940) {
      itemsPerRow = Platform.isIOS ? 14 : 12;
    } else if (screenHeight >= 826 && screenHeight < 850) {
      itemsPerRow = 12;
    } else {
      itemsPerRow = 14;
    }

    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return Scaffold(
          appBar: const SparkdAppBar(),
          body: SafeArea(
            child: Column(
              children: [
                Text(
                  AppStrings.letstartASparkd,
                  textAlign: TextAlign.center,
                  style: context.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SB.h(20),
                Container(
                  height: context.height * 0.19,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    image: DecorationImage(
                      image: Assets.images.uploadScreenShot.provider(),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: InkWell(
                    onTap: () async {
                      // Check connectivity status before proceeding
                      var connectivityResult =
                          await Connectivity().checkConnectivity();

                      if (connectivityResult != ConnectivityResult.none) {
                        // If internet is available, open image picker
                        utils.openImagePicker(
                          context,
                          onPicked: (pickFile) {
                            pickFile.forEach((element) async {
                              controller.imagePath = element;
                              controller.addNewChatManually(false);
                            });
                          },
                        );
                      } else {
                        // No internet connection, show snackbar and stop further execution
                        Get.snackbar(
                          "No Internet",
                          "Please check your internet connection and try again.",
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Assets.icons.upload.svg(),
                        SB.h(10),
                        Text(
                          AppStrings.uploadScreenShot,
                          textAlign: TextAlign.center,
                          style: context.bodyLarge?.copyWith(
                            color: context.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SB.h(10),
                // Text(
                //   AppStrings.or,
                //   textAlign: TextAlign.center,
                //   style: context.titleSmall?.copyWith(
                //     color: context.primary,
                //     fontWeight: FontWeight.w500,
                //   ),
                // ),
                AppButton.primary(
                  title: AppStrings.enterManually,
                  onPressed: () async {
                    var connectivityResult =
                        await Connectivity().checkConnectivity();

                    if (connectivityResult != ConnectivityResult.none) {
                      controller.addNewChatManually(true);
                    } else {
                      Get.snackbar(
                        "No Internet",
                        "Please check your internet connection and try again.",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                ).paddingSymmetric(
                  horizontal: context.width * 0.15,
                  vertical: 10,
                ),
                // SB.h(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                                "Sparkd tools",
                                style: context.headlineMedium?.copyWith(
                                  color: context.primary,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ).paddingSymmetric(vertical: 10),
                              Text(
                                "See all",
                                style: context.headlineMedium?.copyWith(
                                  color: context.primary,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ).paddingSymmetric(vertical: 10),
                    ],
                  ),
                   Row(
            children: [
              // First Container
              Expanded(
                child: Container(
                   height: 164,
                   padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                   border: Border.all(color: context.primary),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                          SizedBox(height: 5,),
                      Image.asset("assets/icons/scanner.png",color:Colors.black),
                      SizedBox(height: 5,),
                      Text(
                        "Social Media picture analyzer",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: context.primary ),
                      ),
                          SizedBox(height: 5,),
                      Text(
                        "Gain insights from your social media photos.",
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 16), // Space between the containers
              // Second Container
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(6),
               height: 164,
                  decoration: BoxDecoration(
                    border: Border.all(color:  context.primary),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                          SizedBox(height: 5,),
                     Image.asset("assets/icons/idea.png",color:Colors.black,),
                        SizedBox(height: 5,),
                      Text(
                        "Date idea \ngenerator",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: context.primary, ),
                      ),
                          SizedBox(height: 5,),
                      Text(
                        "Spark fresh inspiration for your next date!",
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        
                              SB.h(10),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: context.primary,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.getSparkdLines,
                            style: context.headlineMedium?.copyWith(
                              color: context.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ).paddingSymmetric(vertical: 10),
                          
                          Expanded(
                            child: ScrollLoopAutoScroll(
                              scrollDirection: Axis.horizontal,
                              gap: 0.0,
                              duration: const Duration(seconds: 1400),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  children: _buildRows(linesList, itemsPerRow),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ).paddingAll(context.paddingDefault),
          ),
        );
      },
    );
  }

  List<Widget> _buildRows(List<SparkLinesModel> linesList, int itemsPerRow) {
    List<Widget> rows = [];
    for (int i = 0; i < linesList.length; i += itemsPerRow) {
      List<Widget> rowChildren = [];
      for (int j = 0; j < itemsPerRow; j++) {
        final index = i + j;
        if (index < linesList.length) {
          rowChildren.add(LinesWidget(data: linesList[index]));
        } else {
          rowChildren.add(SizedBox.shrink());
        }
      }

      if (i + itemsPerRow >= linesList.length) {
        rowChildren =
            rowChildren.takeWhile((element) => element is! SizedBox).toList();
        rows.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: rowChildren,
          ),
        );
      } else {
        rows.add(Row(children: rowChildren));
      }
    }
    return rows;
  }
}
