import 'package:sparkd/core/constants/imports.dart';
import 'splash_controller.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: SplashController(),
      builder: (controller) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Assets.images.splashBackground.provider(),
                fit: BoxFit.cover,
              ),
            ),
            // child: Center(
            //   child: Assets.images.logo.image(
            //     width: context.width * 0.7,
            //   ),
            // ),
          ),
        );
      },
    );
  }
}
