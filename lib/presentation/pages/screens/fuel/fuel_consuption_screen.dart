import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:terra_shifter/data/models/fuel_consumption.dart';
import 'package:terra_shifter/presentation/blocs/fuel/fuel_consumption_bloc.dart';
import 'package:terra_shifter/presentation/blocs/fuel/fuel_consumption_event.dart';
import 'package:terra_shifter/presentation/blocs/fuel/fuel_consumption_state.dart';

class FuelConsumptionScreen extends StatefulWidget {
  @override
  _FuelConsumptionScreenState createState() => _FuelConsumptionScreenState();
}

class _FuelConsumptionScreenState extends State<FuelConsumptionScreen> {
  DateTime selectedDate = DateTime.now();
  String machineType = 'Power Tiller';
  final TextEditingController amountPerLitreController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  double totalAmount = 0;
  FuelConsumption? selectedFuelConsumption;
  bool isFormVisible = false;
  bool isFilterVisible = false;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  String filterMachineType = 'Power Tiller';
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    context.read<FuelConsumptionBloc>().add(LoadFuelConsumptions());
  }

  void _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _calculateTotal() {
    final double amountPerLitre = double.tryParse(amountPerLitreController.text) ?? 0;
    final double quantity = double.tryParse(quantityController.text) ?? 0;

    setState(() {
      totalAmount = amountPerLitre * quantity;
    });
  }

  void _resetFields() {
    setState(() {
      selectedDate = DateTime.now();
      machineType = 'Power Tiller';
      amountPerLitreController.clear();
      quantityController.clear();
      totalAmount = 0;
      selectedFuelConsumption = null;
    });
  }

  void _populateFields(FuelConsumption fuelConsumption) {
    setState(() {
      selectedDate = fuelConsumption.date;
      machineType = fuelConsumption.machineType;
      amountPerLitreController.text = fuelConsumption.amountPerLitre.toString();
      quantityController.text = fuelConsumption.quantity.toString();
      totalAmount = fuelConsumption.totalAmount;
      selectedFuelConsumption = fuelConsumption;
      isFormVisible = true;
    });
  }

  void _saveFuelConsumption() {
    _calculateTotal();
    final fuelConsumption = FuelConsumption(
      id: selectedFuelConsumption?.id ?? DateTime.now().toString(),
      date: selectedDate,
      machineType: machineType,
      amountPerLitre: double.tryParse(amountPerLitreController.text) ?? 0,
      quantity: double.tryParse(quantityController.text) ?? 0,
      totalAmount: totalAmount,
    );
    if (selectedFuelConsumption == null) {
      context.read<FuelConsumptionBloc>().add(AddFuelConsumption(fuelConsumption));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fuel entry added')));
    } else {
      context.read<FuelConsumptionBloc>().add(UpdateFuelConsumption(fuelConsumption));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fuel entry updated')));
    }
    _resetFields();
    _toggleFormVisibility();
  }

  void _toggleFormVisibility() {
    setState(() {
      isFormVisible = !isFormVisible;
    });
  }

  void _toggleFilterVisibility() {
    setState(() {
      isFilterVisible = !isFilterVisible;
    });
  }

  void _applyFilter() {
    context.read<FuelConsumptionBloc>().add(FilterFuelConsumptions(startDate, endDate, filterMachineType));
    _toggleFilterVisibility();
  }

  void _selectMonthYear(BuildContext context) async {
    final picked = await showDialog<Map<String, int>>(
      context: context,
      builder: (BuildContext context) {
        int tempMonth = selectedMonth;
        int tempYear = selectedYear;
        return AlertDialog(
          title: const Text('Select Month and Year'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<int>(
                value: tempMonth,
                items: List.generate(12, (index) => index + 1)
                    .map((month) => DropdownMenuItem(
                          value: month,
                          child: Text(DateFormat.MMMM().format(DateTime(0, month))),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    tempMonth = value!;
                  });
                },
              ),
              DropdownButton<int>(
                value: tempYear,
                items: List.generate(50, (index) => DateTime.now().year - index)
                    .map((year) => DropdownMenuItem(
                          value: year,
                          child: Text(year.toString()),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    tempYear = value!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop({'month': tempMonth, 'year': tempYear});
              },
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedMonth = picked['month']!;
        selectedYear = picked['year']!;
      });
      _generatePdf();
    }
  }

  Future<void> _generatePdf() async {
  final pdf = pw.Document();

  final fuelConsumptions = (context.read<FuelConsumptionBloc>().state as FuelConsumptionLoaded).fuelConsumptions;
  final filteredFuelConsumptions = fuelConsumptions.where((fuelConsumption) {
    return fuelConsumption.date.month == selectedMonth && fuelConsumption.date.year == selectedYear;
  }).toList();

  // Calculate totals for each machine type
  final Map<String, double> machineTypeTotals = {};
  double grandTotal = 0;

  for (var fuelConsumption in filteredFuelConsumptions) {
    machineTypeTotals[fuelConsumption.machineType] = (machineTypeTotals[fuelConsumption.machineType] ?? 0) + fuelConsumption.totalAmount;
    grandTotal += fuelConsumption.totalAmount;
  }

  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Fuel Consumption Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 16),
            pw.Text('Month: ${DateFormat.MMMM().format(DateTime(0, selectedMonth))} $selectedYear', style: pw.TextStyle(fontSize: 16)),
            pw.SizedBox(height: 16),
            pw.Table.fromTextArray(
              headers: ['Date', 'Machine Type', 'Quantity (Litres)', 'Total Amount'],
              data: filteredFuelConsumptions.map((fuelConsumption) {
                return [
                  DateFormat.yMd().format(fuelConsumption.date),
                  fuelConsumption.machineType,
                  fuelConsumption.quantity.toString(),
                  fuelConsumption.totalAmount.toStringAsFixed(2),
                ];
              }).toList(),
            ),
            pw.SizedBox(height: 16),
            pw.Text('Totals by Machine Type:', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            ...machineTypeTotals.entries.map((entry) {
              return pw.Text('${entry.key}: Rs. ${entry.value.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 16));
            }).toList(),
            pw.SizedBox(height: 16),
            pw.Text('Grand Total: Rs. ${grandTotal.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          ],
        );
      },
    ),
  );

  await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fuel Consumption'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _toggleFilterVisibility,
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => _selectMonthYear(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isFormVisible)
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Fuel Consumption Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Date:', style: TextStyle(fontSize: 16)),
                              TextButton(
                                onPressed: _pickDate,
                                child: Text(DateFormat.yMd().format(selectedDate), style: const TextStyle(fontSize: 16)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: machineType,
                            decoration: InputDecoration(
                              labelText: 'Machine Type',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 10,
                              ),
                            ),
                            items: ['Power Tiller', 'Tractor', 'JCB']
                                .map((type) => DropdownMenuItem(
                                      value: type,
                                      child: Text(type),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                machineType = value!;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: amountPerLitreController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Amount per Litre',
                              labelText: 'Amount per Litre',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: const Icon(Icons.attach_money),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: quantityController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Quantity (Litres)',
                              labelText: 'Quantity (Litres)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: const Icon(Icons.local_gas_station),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Amount:', style: TextStyle(fontSize: 16)),
                              Text('\$${totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton.icon(
                                onPressed: _saveFuelConsumption,
                                icon: const Icon(Icons.save),
                                label: const Text('Save'),
                              ),
                              ElevatedButton.icon(
                                onPressed: _resetFields,
                                icon: const Icon(Icons.refresh),
                                label: const Text('Reset'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Expanded(
                  child: BlocBuilder<FuelConsumptionBloc, FuelConsumptionState>(
                    builder: (context, state) {
                      if (state is FuelConsumptionLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is FuelConsumptionLoaded) {
                        return ListView.builder(
                          itemCount: state.fuelConsumptions.length,
                          itemBuilder: (context, index) {
                            final fuelConsumption = state.fuelConsumptions[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                title: Text(fuelConsumption.machineType),
                                subtitle: Text(
                                  'Date: ${DateFormat.yMd().format(fuelConsumption.date)}\n'
                                  'Quantity: ${fuelConsumption.quantity} litres\n'
                                  'Total: \$${fuelConsumption.totalAmount.toStringAsFixed(2)}',
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    _populateFields(fuelConsumption);
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return const Center(child: Text('No fuel consumption data available'));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          if (isFilterVisible)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Filter Fuel Consumptions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Start Date:'),
                        TextButton(
                          onPressed: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: startDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null && picked != startDate) {
                              setState(() {
                                startDate = picked;
                              });
                            }
                          },
                          child: Text(DateFormat.yMd().format(startDate)),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('End Date:'),
                        TextButton(
                          onPressed: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: endDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null && picked != endDate) {
                              setState(() {
                                endDate = picked;
                              });
                            }
                          },
                          child: Text(DateFormat.yMd().format(endDate)),
                        ),
                      ],
                    ),
                    DropdownButtonFormField<String>(
                      value: filterMachineType,
                      decoration: InputDecoration(
                        labelText: 'Machine Type',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 10,
                        ),
                      ),
                      items: ['Power Tiller', 'Tractor', 'JCB']
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          filterMachineType = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: _applyFilter,
                          child: const Text('Apply'),
                        ),
                        ElevatedButton(
                          onPressed: _toggleFilterVisibility,
                          child: const Text('Cancel'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleFormVisibility,
        child: Icon(isFormVisible ? Icons.close : Icons.add),
      ),
    );
  }
}