import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // For pie chart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:terra_shifter/core/usecases/app_localization.dart';
import 'package:terra_shifter/data/Services/fuel_consumption_service.dart';
import 'package:terra_shifter/presentation/blocs/fuel/fuel_consumption_bloc.dart';
import 'package:terra_shifter/presentation/pages/screens/fuel/fuel_consuption_screen.dart';
import 'package:terra_shifter/presentation/pages/screens/plates/bloc/plates_bloc.dart';
import 'package:terra_shifter/presentation/pages/screens/plates/service/plates_service.dart';
import 'package:terra_shifter/data/Services/tractor_work_service.dart';
import 'package:terra_shifter/presentation/blocs/tractor/tractor_work_bloc.dart';
import 'package:terra_shifter/presentation/pages/screens/jcb/bloc/jcb_work_bloc.dart';
import 'package:terra_shifter/presentation/pages/screens/jcb/jcb_work_screen.dart';
import 'package:terra_shifter/presentation/pages/screens/jcb/service/jcb_work_service.dart';
import 'package:terra_shifter/presentation/pages/screens/plates/plates_details_screen.dart';
import 'package:terra_shifter/presentation/pages/tractors/tractors_work_page.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  double spentAmount = 2200;
  double receivedAmount = 15000;
  double totalAmount = 17200;
  bool isConnected = true;

  @override
  void initState() {
    super.initState();
    checkConnectivity();
  }

  Future<void> checkConnectivity() async {
    try {
      final response = await http.get(Uri.parse('https://www.google.com'));
      setState(() {
        isConnected = response.statusCode == 200;
      });
    } catch (e) {
      setState(() {
        isConnected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      body: isConnected
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pie Chart
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 300,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 0,
                          startDegreeOffset: 120,
                          centerSpaceRadius: 50,
                          sections: [
                            PieChartSectionData(
                              value: spentAmount,
                              title:
                                  localizations?.translate('spent') ?? 'Spent',
                              color: Colors.red,
                              radius: 50,
                              titleStyle: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              showTitle: true,
                            ),
                            PieChartSectionData(
                              value: receivedAmount,
                              title: localizations?.translate('received') ??
                                  'Received',
                              color: Colors.green,
                              radius: 50,
                              titleStyle: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              showTitle: true,
                            ),
                            PieChartSectionData(
                              value:
                                  totalAmount - (spentAmount + receivedAmount),
                              title: localizations?.translate('remaining') ??
                                  'Remaining',
                              color: Colors.blue,
                              radius: 50,
                              titleStyle: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              showTitle: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Display Amounts
                  Center(
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${localizations?.translate('spent_amount') ?? 'Spent Amount'}: \₹ ${spentAmount.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${localizations?.translate('received_amount') ?? 'Received Amount'}: \₹ ${receivedAmount.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${localizations?.translate('total_amount') ?? 'Total Amount'}: \₹ ${totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Lottie.asset(
                  'assets/lottie/no_network.json',
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 36.0), // Move up by 20
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              heroTag: 'plates', // Unique hero tag
              backgroundColor: Colors.white,
              onPressed: isConnected
                  ? () {
                      // Navigate to plates page
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                    create: (context) =>
                                        PlatesBloc(PlatesService()),
                                    child: PlatesDetailsScreen(),
                                  )));
                    }
                  : null,
              tooltip: localizations?.translate('plates') ?? 'Plates',
              child:
                  Image.asset('assets/images/plate.png', width: 50, height: 50),
            ),
            const SizedBox(width: 16),
            FloatingActionButton(
              heroTag: 'tractor', // Unique hero tag
              backgroundColor: Colors.white,
              onPressed: isConnected
                  ? () {
                      // Added temporary navigation to plates details page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) =>
                                TractorsWorkBloc(TractorsWorkService()),
                            child: TractorsWorkPage(),
                          ),
                        ),
                      );
                    }
                  : null,
              tooltip: localizations?.translate('tractor') ?? 'Tractor',
              child: Image.asset('assets/images/tractor.png',
                  width: 50, height: 50),
            ),
            const SizedBox(width: 16),
            FloatingActionButton(
              heroTag: 'jcb', // Unique hero tag
              backgroundColor: Colors.white,
              onPressed: isConnected
                  ? () {
                      // Add your functionality here
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => JcbWorkBloc(JcbWorkService()),
                            child: JcbWorkScreen(),
                          ),
                        ),
                      );
                    }
                  : null,
              tooltip: localizations?.translate('fuel') ?? 'Fuel',
              child:
                  Image.asset('assets/images/jcb.png', width: 50, height: 50),
            ),
            const SizedBox(width: 16),
            FloatingActionButton(
              heroTag: 'fuel', // Unique hero tag
              backgroundColor: Colors.white,
              onPressed: isConnected
                  ? () {
                      // Add your functionality here
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) =>
                                FuelConsumptionBloc(FuelConsumptionService()),
                            child: FuelConsumptionScreen(),
                          ),
                        ),
                      );
                    }
                  : null,
              tooltip: localizations?.translate('fuel') ?? 'Fuel',
              child:
                  Image.asset('assets/images/fuel.png', width: 50, height: 50),
            ),
          ],
        ),
      ),
    );
  }
}
