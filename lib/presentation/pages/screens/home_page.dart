import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // For pie chart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:terra_shifter/core/usecases/app_localization.dart';
import 'package:terra_shifter/data/Services/plates_service.dart';
import 'package:terra_shifter/data/Services/tractor_work_service.dart';
import 'package:terra_shifter/presentation/blocs/plates_details/plate_details_bloc.dart';
import 'package:terra_shifter/presentation/blocs/tractor/tractor_work_bloc.dart';
import 'package:terra_shifter/presentation/pages/screens/plates/plates_details_page.dart';
import 'package:terra_shifter/presentation/pages/tractors/tractors_work_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  double spentAmount = 2200;
  double receivedAmount = 15000;
  double totalAmount = 17200;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      body: Padding(
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
                        title: localizations?.translate('spent') ?? 'Spent',
                        color: Colors.red,
                        radius: 50,
                        titleStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        showTitle: true,
                      ),
                      PieChartSectionData(
                        value: receivedAmount,
                        title:
                            localizations?.translate('received') ?? 'Received',
                        color: Colors.green,
                        radius: 50,
                        titleStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        showTitle: true,
                      ),
                      PieChartSectionData(
                        value: totalAmount - (spentAmount + receivedAmount),
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
              onPressed: () {
                // Navigate to plates page
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BlocProvider(
                              create: (context) =>
                                  PlateDetailsBloc(PlatesService()),
                              child: PlatesDetailsPage(),
                            )));
              },
              tooltip: localizations?.translate('plates') ?? 'Plates',
              child:
                  Image.asset('assets/images/plate.png', width: 50, height: 50),
            ),
            const SizedBox(width: 16),
            FloatingActionButton(
              heroTag: 'tractor', // Unique hero tag
              backgroundColor: Colors.white,
              onPressed: () {
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
              },
              tooltip: localizations?.translate('tractor') ?? 'Tractor',
              child: Image.asset('assets/images/tractor.png',
                  width: 50, height: 50),
            ),
            const SizedBox(width: 16),
            FloatingActionButton(
              heroTag: 'jcb', // Unique hero tag
              backgroundColor: Colors.white,
              onPressed: () {
                // Add your functionality here
              },
              tooltip: localizations?.translate('jcb') ?? 'JCB',
              child: Image.asset('assets/images/tractor.png',
                  width: 50, height: 50),
            ),
          ],
        ),
      ),
    );
  }
}
