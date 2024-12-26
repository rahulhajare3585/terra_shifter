import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';
import 'package:terra_shifter/data/Services/customer_service.dart';
import 'package:terra_shifter/presentation/blocs/customer/customer_bloc.dart';
import 'package:terra_shifter/presentation/pages/customer_page.dart';
import 'package:terra_shifter/presentation/pages/setting_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> with TickerProviderStateMixin {
  late MotionTabBarController _motionTabBarController;

  @override
  void initState() {
    super.initState();
    _motionTabBarController = MotionTabBarController(
      initialIndex: 1,
      length: 3,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _motionTabBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: MotionTabBar(
        controller: _motionTabBarController,
        initialSelectedTab: "Home",
        useSafeArea: true,
        labels: const ["Customer", "Home", "Settings"],
        icons: const [Icons.people, Icons.home, Icons.settings],
        // badges: [
        //   const MotionBadgeWidget(
        //     text: '10+',
        //     textColor: Colors.white,
        //     color: Colors.red,
        //     size: 18,
        //   ),
        //   Container(
        //     color: Colors.black,
        //     padding: const EdgeInsets.all(2),
        //     child: const Text(
        //       '48',
        //       style: TextStyle(
        //         fontSize: 14,
        //         color: Colors.white,
        //       ),
        //     ),
        //   ),
        //   null,
        //   const MotionBadgeWidget(
        //     isIndicator: true,
        //     color: Colors.red,
        //     size: 5,
        //     show: true,
        //   ),
        // ],
        // tabSize: 50,
        tabBarHeight: 60,
        textStyle: const TextStyle(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        tabIconColor: theme.primaryColor,
        tabIconSize: 22.0,
        tabIconSelectedSize: 28.0,
        tabSelectedColor: theme.primaryColor,
        tabIconSelectedColor: Colors.white,
        tabBarColor: Colors.white,
        onTabItemSelected: (int value) {
          setState(() {
            _motionTabBarController.index = value;
          });
        },
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(), 
        controller: _motionTabBarController,
        children: <Widget>[
          BlocProvider(
            create: (context) => CustomerBloc(CustomerService()),
            child: CustomerPage(),
          ),
          const Center(child: Text("Home")),
          SettingsPage(),
        ],
      ),
    );
  }
}

class MainPageContentComponent extends StatelessWidget {
  const MainPageContentComponent({
    required this.title,
    required this.controller,
    Key? key,
  }) : super(key: key);

  final String title;
  final MotionTabBarController controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 50),
          const Text('Go to "X" page programmatically'),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => controller.index = 0,
            child: const Text('customer Page'),
          ),
          ElevatedButton(
            onPressed: () => controller.index = 1,
            child: const Text('Home Page'),
          ),
          ElevatedButton(
            onPressed: () => controller.index = 2,
            child: const Text('Settings Page'),
          ),
        ],
      ),
    );
  }
}