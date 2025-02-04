import 'package:sparkd/core/constants/imports.dart';
import 'package:sparkd/pages/dashboard/dashboard_controller.dart';
import 'package:sparkd/pages/home/home.dart';
import 'package:sparkd/pages/inbox/inbox.dart';
import 'package:sparkd/pages/sparkd_lines/sparkd_lines.dart';
import 'package:sparkd/pages/start_sparkd/start_sparkd.dart';
import 'package:sparkd/widgets/custom_navbar.dart';
import 'package:sparkd/widgets/lazy_stackindex.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {

    return GetBuilder<DashBoardController>(
        init: DashBoardController(),
        builder: (controller) {
          int currentTab = controller.currentIndex;

          return Scaffold(
            body: LazyIndexedStack(
              index: currentTab,
              children:  [
                HomePage(),
                StartSparkdPage(),
                SparkdLinesPage(),
                InboxPage(),

              ],
            ),
            bottomNavigationBar: CustomBottomNavBar(
              selectedIndex: currentTab,
              onTabTapped: controller.changeNaveIndex,
            ),
          );
        });
  }
}
