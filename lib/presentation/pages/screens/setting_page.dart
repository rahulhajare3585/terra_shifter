import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:terra_shifter/core/utils/locale/locale_notifier.dart';
import 'package:terra_shifter/core/utils/theme_config.dart';
import 'package:terra_shifter/core/utils/theme_notifier.dart';
import 'package:terra_shifter/core/usecases/app_localization.dart';
import 'package:terra_shifter/presentation/pages/authentication/login_page.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final localeNotifier = Provider.of<LocaleNotifier>(context);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Text(
            localizations?.translate('general') ?? 'Generar',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Divider(),
          SwitchListTile(
            title:  Text(localizations?.translate('dark_theme') ?? 'Dark Theme'),
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
            title:  Text(localizations?.translate('language')??'Language'),
            leading: const Icon(Icons.language),
            subtitle: Text(localeNotifier.locale.languageCode == 'mr' ? 'इंग्रजी' : 'Marathi'),
            onTap: () {
              localeNotifier.toggleLocale();
            },
          ),
          ListTile(
            title: Text(localizations?.translate('logout')??'Logout'),
            leading: Icon(Icons.logout),
            onTap: () {
              _showLogoutConfirmationDialog(context, localizations);
            },
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context, AppLocalizations? localizations) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localizations?.translate('logout')??'Logout'),
          content: Text(localizations?.translate('logout_confirmation')?? 'Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(localizations?.translate('cancel')??'Cancel'),
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
              child: Text(localizations?.translate('logout')??'Logout'),
            ),
          ],
        );
      },
    );
  }
}
