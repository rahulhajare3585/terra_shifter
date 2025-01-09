import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:terra_shifter/data/models/fuel_consumption.dart';
import 'package:terra_shifter/data/services/fuel_consumption_service.dart';
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

  void _toggleFormVisibility() {
    setState(() {
      isFormVisible = !isFormVisible;
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

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        DateTime startDate = DateTime.now();
        DateTime endDate = DateTime.now();
        String filterMachineType = 'Power Tiller';

        return AlertDialog(
          title: const Text('Filter Fuel Consumptions'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.read<FuelConsumptionBloc>().add(FilterFuelConsumptions(startDate, endDate, filterMachineType));
                Navigator.pop(context);
              },
              child: const Text('Apply'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fuel Consumption'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Padding(
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
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleFormVisibility,
        child: Icon(isFormVisible ? Icons.close : Icons.add),
      ),
    );
  }
}