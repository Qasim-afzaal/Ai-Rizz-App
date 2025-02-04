import 'package:sparkd/core/constants/imports.dart';
import 'package:sparkd/pages/pin/create_pin/create_pin.dart';
import 'package:sparkd/pages/profile/profile_controller.dart';
import 'package:sparkd/widgets/confirmation_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(
        title: AppStrings.profile,
      ),
      body: GetBuilder<ProfileController>(
        init: ProfileController(),
        builder: (controller) {
            final userId = getStorageData.getUserId();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SB.h(20),
              /*Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Subscription",
                    style: context.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "Sparkd GOLD",
                    style: context.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "\$6.99 / Every week",
                    style: context.bodySmall?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ).paddingAll(15),
              Divider(
                color: context.primary,
              ),*/
              // _Tile(
              //   iconPath: Assets.icons.pin.path,
              //   title: getStorageData.readBoolean(key: getStorageData.isPinCreated) ? AppStrings.changePin : AppStrings.createPin,
              //   onTap: () => Get.to(() => const CreatePinPage()),
              // ),
              _Tile(
                iconPath: Assets.icons.deleteAll.path,
                title: AppStrings.clearAll,
                onTap: () => Get.bottomSheet(
                  ConfirmationWidget(
                    title: AppStrings.clearAll,
                    description: AppStrings.clearAllDescription,
                    onConfirmation: () {
                      Get.back();
                      controller.deleteAllChat();
                    },
                  ),
                ),
              ),
              _Tile(
                iconPath: Assets.icons.logout.path,
                title: AppStrings.logout,
                onTap: () => Get.bottomSheet(
                  ConfirmationWidget(
                    title: AppStrings.logout,
                    description: AppStrings.logoutDescription,
                    onConfirmation: () {
                      getStorageData.removeAllData();
                    },
                  ),
                ),
              ),
               _Tile(
                iconPath: Assets.icons.deleteAll.path,
                title: "Delete Account",
                onTap: () => Get.bottomSheet(
                  ConfirmationWidget(
                    title: "Delete Account",
                    description: AppStrings.deletetDescription,
                    onConfirmation: () {
                      controller.deleteAccount();
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.iconPath, required this.title, this.onTap});

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
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
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
