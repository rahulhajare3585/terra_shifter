import 'package:flutter/material.dart';

class PlatesPage extends StatefulWidget {
  @override
  _PlatesPage createState() => _PlatesPage();
}

class _PlatesPage extends State<PlatesPage> {
  final _formKey = GlobalKey<FormState>();
  String? _customerName, _contactNumber;
  DateTime? _givenDate, _receivedDate;
  int? _totalDays;
  double? _amountPerMonth, _totalAmount, _pendingAmount;

  // Controllers to handle the text input fields
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _totalDaysController = TextEditingController();
  final TextEditingController _amountPerMonthController = TextEditingController();
  final TextEditingController _totalAmountController = TextEditingController();
  final TextEditingController _pendingAmountController = TextEditingController();

  @override
  void dispose() {
    _customerNameController.dispose();
    _contactNumberController.dispose();
    _totalDaysController.dispose();
    _amountPerMonthController.dispose();
    _totalAmountController.dispose();
    _pendingAmountController.dispose();
    super.dispose();
  }

  // Function to handle Save
  void _saveData() {
    if (_formKey.currentState!.validate()) {
      // You can add your saving logic here
      print('Data Saved');
    }
  }

  // Function to handle Edit
  void _editData() {
    // Edit logic can be implemented here
    print('Edit Data');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plates Details'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Customer Name Input
              TextFormField(
                controller: _customerNameController,
                decoration: InputDecoration(
                  labelText: 'Customer Name',
                  labelStyle: TextStyle(color: theme.primaryColor),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.primaryColor, width: 2),
                  ),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the customer name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Contact Number Input
              TextFormField(
                controller: _contactNumberController,
                decoration: InputDecoration(
                  labelText: 'Contact Number',
                  labelStyle: TextStyle(color: theme.primaryColor),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.primaryColor, width: 2),
                  ),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone, color: theme.primaryColor),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a contact number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Given Date Input (Date Picker)
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Given Date',
                  labelStyle: TextStyle(color: theme.primaryColor),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.primaryColor, width: 2),
                  ),
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today, color: theme.primaryColor),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _givenDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null && pickedDate != _givenDate) {
                    setState(() {
                      _givenDate = pickedDate;
                    });
                  }
                },
                controller: TextEditingController(text: _givenDate == null ? '' : _givenDate!.toLocal().toString().split(' ')[0]),
              ),
              const SizedBox(height: 16),

              // Received Date Input (Date Picker)
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Received Date',
                  labelStyle: TextStyle(color: theme.primaryColor),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.primaryColor, width: 2),
                  ),
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today, color: theme.primaryColor),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _receivedDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null && pickedDate != _receivedDate) {
                    setState(() {
                      _receivedDate = pickedDate;
                    });
                  }
                },
                controller: TextEditingController(text: _receivedDate == null ? '' : _receivedDate!.toLocal().toString().split(' ')[0]),
              ),
              const SizedBox(height: 16),

              // Total Days Input
              TextFormField(
                controller: _totalDaysController,
                decoration: InputDecoration(
                  labelText: 'Total Days',
                  labelStyle: TextStyle(color: theme.primaryColor),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.primaryColor, width: 2),
                  ),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the total days';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Amount Per Month Input
              TextFormField(
                controller: _amountPerMonthController,
                decoration: InputDecoration(
                  labelText: 'Amount Per Month',
                  labelStyle: TextStyle(color: theme.primaryColor),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.primaryColor, width: 2),
                  ),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the amount per month';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Total Amount Input
              TextFormField(
                controller: _totalAmountController,
                decoration: InputDecoration(
                  labelText: 'Total Amount',
                  labelStyle: TextStyle(color: theme.primaryColor),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.primaryColor, width: 2),
                  ),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the total amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Pending Amount Input
              TextFormField(
                controller: _pendingAmountController,
                decoration: InputDecoration(
                  labelText: 'Pending Amount',
                  labelStyle: TextStyle(color: theme.primaryColor),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.primaryColor, width: 2),
                  ),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the pending amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Save and Edit Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _saveData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    ),
                    child: const Text('Save', style: TextStyle(fontSize: 16)),
                  ),
                  ElevatedButton(
                    onPressed: _editData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    ),
                    child: const Text('Edit', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
