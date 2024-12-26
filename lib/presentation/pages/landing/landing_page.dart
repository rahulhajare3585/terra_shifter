import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';
import 'package:terra_shifter/data/Services/customer_service.dart';
import 'package:terra_shifter/presentation/blocs/customer/customer_bloc.dart';
import 'package:terra_shifter/presentation/pages/screens/customer_page.dart';
import 'package:terra_shifter/presentation/pages/screens/home_page.dart';
import 'package:terra_shifter/presentation/pages/screens/plates_page.dart';
import 'package:terra_shifter/presentation/pages/screens/setting_page.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPage createState() => _LandingPage();
}

class _LandingPage extends State<LandingPage> with TickerProviderStateMixin {
  late MotionTabBarController _motionTabBarController;
   String titleText='Terra Shifter';

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

  void _onFlyoutMenuSelected(String value) {
    switch (value) {
      case 'Plates':
        titleText='Plates';
         Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PlatesPage(),
              ),
            );
        break;
      case 'Logout':
        // Handle logout
        Navigator.pushReplacementNamed(context, '/login');
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(titleText),
        actions: [
          PopupMenuButton<String>(
            onSelected: _onFlyoutMenuSelected,
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'Plates',
                  child: Text('Plates'),
                ),
                const PopupMenuItem<String>(
                  value: 'Logout',
                  child: Text('Logout'),
                ),
              ];
            },
          ),
        ],
      ),
      bottomNavigationBar: MotionTabBar(
        controller: _motionTabBarController,
        initialSelectedTab: "Home",
        useSafeArea: true,
        labels: const ["Customers", "Home", "Settings"],
        icons: const [Icons.people, Icons.home, Icons.settings],
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
          HomePage(),
          SettingsPage(),
        ],
      ),
    );
  }
}
