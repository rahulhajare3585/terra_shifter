import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fuel Consumption'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Date:',
                            style: TextStyle(fontSize: 16),
                          ),
                          TextButton(
                            onPressed: _pickDate,
                            child: Text(
                              DateFormat.yMd().format(selectedDate),
                              style: const TextStyle(fontSize: 16),
                            ),
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
                          const Text(
                            'Total Amount:',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            '\$${totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              _calculateTotal();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Fuel entry added')),
                              );
                            },
                            icon: const Icon(Icons.add),
                            label:  Text('Add', style: TextStyle(color: Theme.of(context).cardColor)),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              _calculateTotal();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Fuel entry updated')),
                              );
                            },
                            icon: const Icon(Icons.update),
                            label: Text('Update', style: TextStyle(color: Theme.of(context).cardColor)),
                          ),
                          ElevatedButton.icon(
                            onPressed: _resetFields,
                            icon: const Icon(Icons.refresh),
                            label: const Text(''),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
