import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sparkd/api_repository/api_class.dart';
import 'package:sparkd/core/constants/imports.dart';
import 'package:sparkd/routes/app_pages.dart';
import 'package:sparkd/widgets/CustomDropDown.dart';
import 'package:sparkd/widgets/confirmation_widget.dart';

import 'inbox_controller.dart';
import 'index_response.dart';

class InboxPage extends GetView<InboxController> {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SparkdAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Row(
                      children: InboxType.values
                          .map(
                            (type) => _InboxType(
                              type: type,
                              onTap: controller.callChatList,
                              selectedType: controller.selectedType.value,
                            ),
                          )
                          .toList(),
                    )),
                InkWell(
                  onTap: () async {
                    // Check connectivity status before proceeding
                    var connectivityResult =
                        await Connectivity().checkConnectivity();

                    // Print the result for debugging
                    print('Connectivity Result: $connectivityResult');

                    if (connectivityResult != ConnectivityResult.none) {
                      // If internet is available, navigate to the new route
                      Get.toNamed(
                        Routes.GATHER_NEW_CHAT_INFO,
                        arguments: {
                          HttpUtil.isManually: true,
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
                  child: Assets.icons.newchat.svg(),
                ),
              ],
            ),
            CustomTextField(
              controller: controller.searchController,
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12),
                child: SvgPicture.asset(
                  Assets.icons.search.path,
                  //  color: context.grey,
                ),
              ),
              onChange: _filterNames,
              textInputAction: TextInputAction.search,
              hintText: 'Search',
            ).paddingOnly(top: 20),
            Expanded(
              child: Obx(() => ListView.separated(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    itemBuilder: (context, index) {
                      print("api data ${controller.inboxList[index].name}");
                      return _Container(
                        mainData: controller.inboxList[index],
                        controller: controller,
                        index: index,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SB.h(15);
                    },
                    itemCount: controller.inboxList.length,
                  )),
            ),
          ],
        ).paddingOnly(
            left: context.paddingDefault,
            right: context.paddingDefault,
            top: context.paddingDefault),
      ),
    );
  }

  void _filterNames(String query) {
    List<IndexResponseData> filteredList = <IndexResponseData>[];

    if (query.isNotEmpty) {
      filteredList = controller.allInboxList
          .where((p0) => p0.name!.toLowerCase().contains(query.toLowerCase()))
          .toSet()
          .toList();
    } else {
      filteredList = controller.allInboxList.toSet().toList();
    }

    controller.inboxList.value = filteredList;
    controller.inboxList.refresh();
  }
}

class _Container extends StatelessWidget {
  const _Container(
      {super.key,
      required this.mainData,
      required this.controller,
      required this.index});

  final IndexResponseData mainData;
  final InboxController controller;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        // Check connectivity status before proceeding
        var connectivityResult = await Connectivity().checkConnectivity();

        // Print the result for debugging
        print('Connectivity Result: $connectivityResult');

        if (connectivityResult != ConnectivityResult.none) {
          // If internet is available, navigate to the appropriate route
          if (mainData.chatType == "spark-lines") {
            Get.toNamed(
              Routes.SPARKD_LINES_RESPONSE,
              arguments: {
                HttpUtil.conversationId: mainData.conversationId,
                HttpUtil.name: mainData.name == ""
                    ? "Sparked lines"
                    : mainData.name ?? "Sparked lines",
              },
            );
          } else {
            Get.toNamed(
              Routes.CHAT,
              arguments: {
                HttpUtil.conversationId: mainData.conversationId,
                HttpUtil.name: mainData.name,
                HttpUtil.isManually: false,
              },
            );
          }
        } else {
          // No internet connection, show snackbar and stop further execution
          Get.snackbar(
            "No Internet",
            "Please check your internet connection and try again.",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.primary)),
        child: Row(
          children: [
            Expanded(
              child: Text(
                (mainData.name != "")
                    ? mainData.name?.capitalizeFirst ?? ""
                    : "SparkD line",
                style: context.titleLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            /*  Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(children: [
                  Text(
                    "Neutral 😐",
                    style: context.bodySmall?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ])),*/
            CustomDropDown(
                dropDownIcon: const Icon(Icons.more_vert).paddingAll(10),
                onChanged: (data) {
                  if (data?.value == 'Delete') {
                    Get.bottomSheet(ConfirmationWidget(
                      title: AppStrings.deleteChat,
                      description: AppStrings.deleteChatDescription,
                      onConfirmation: () {
                        Get.back();
                        controller.deleteChat(mainData.conversationId!, index);
                      },
                    ));
                  } else if (data?.value == 'Archive') {
                    controller.archiveChat(mainData.conversationId!, index);
                  }
                },
                dropDownList: controller.dropDownList)
          ],
        ),
      ),
    );
  }
}

class _InboxType extends StatelessWidget {
  const _InboxType(
      {super.key, required this.type, this.selectedType, required this.onTap});

  final InboxType type;
  final InboxType? selectedType;
  final Function(InboxType, bool) onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(type, true),
      child: Text(
        type.name,
        style: context.headlineMedium?.copyWith(
          color:
              selectedType == type ? context.primary : const Color(0xFFA6907F),
          fontWeight: FontWeight.w400,
        ),
      ).paddingAll(10),
    );
  }
}
