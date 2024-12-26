import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // For pie chart

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
    return Scaffold(
      body: Column(
        children: [
          // Pie Chart
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 300,
              child: AnimatedSwitcher(
                duration: Duration(seconds: 1), // Duration of the animation
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 0, // Space between sections
                    startDegreeOffset: 180, // Start drawing from the bottom
                    sections: [
                      PieChartSectionData(
                        value: spentAmount,
                        title: 'Spent',
                        color: Colors.red,
                        radius: 50,
                        titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        showTitle: true,
                      ),
                      PieChartSectionData(
                        value: receivedAmount,
                        title: 'Get',
                        color: Colors.green,
                        radius: 50,
                        titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        showTitle: true,
                      ),
                      PieChartSectionData(
                        value: totalAmount - (spentAmount + receivedAmount),
                        title: 'Rem',
                        color: Colors.blue,
                        radius: 50,
                        titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        showTitle: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Display Amounts
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Spent Amount: \$${spentAmount.toStringAsFixed(2)}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 8),
                Text('Received Amount: \$${receivedAmount.toStringAsFixed(2)}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 8),
                Text('Total Amount: \$${totalAmount.toStringAsFixed(2)}', style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 36.0), // Move up by 20
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              onPressed: () {
                // Add your functionality here
              },
              child: Icon(Icons.circle_outlined),
              tooltip: 'Plates',
            ),
            SizedBox(width: 16),
            FloatingActionButton(
              onPressed: () {
                // Add your functionality here
              },
              child: Icon(Icons.directions_car),
              tooltip: 'Tractor',
            ),
            SizedBox(width: 16),
            FloatingActionButton(
              onPressed: () {
                // Add your functionality here
              },
              child: Icon(Icons.agriculture),
              tooltip: 'Power Tillers',
            ),
          ],
        ),
      ),
    );
  }
}
