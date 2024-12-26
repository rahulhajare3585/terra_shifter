import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:terra_shifter/core/utils/theme_config.dart';
import 'package:terra_shifter/core/utils/theme_notifier.dart';
import 'package:terra_shifter/presentation/pages/login_page.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Text(
            'General',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Dark Theme'),
            value: themeNotifier.currentTheme == ThemeConfig.darkTheme,
            activeColor: Theme.of(context).textTheme.bodyMedium!.color,
            thumbColor: MaterialStateProperty.all<Color>(
              Theme.of(context).primaryColor ?? Colors.blue,
            ),
            onChanged: (value) {
              themeNotifier.toggleTheme();
            },
          ),
          ListTile(
            title: Text('Logout'),
            leading: Icon(Icons.logout),
            onTap: () {
              _showLogoutConfirmationDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}