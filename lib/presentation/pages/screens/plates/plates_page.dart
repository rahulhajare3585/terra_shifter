import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:terra_shifter/core/usecases/app_localization.dart';
import 'package:terra_shifter/data/Services/plates_service.dart';
import 'package:terra_shifter/data/Services/customer_service.dart';
import 'package:terra_shifter/data/models/plates.dart';
import 'package:terra_shifter/data/models/customer.dart';
import 'package:terra_shifter/presentation/blocs/plates/plates_bloc.dart';
import 'package:terra_shifter/presentation/blocs/plates/plates_event.dart';
import 'package:terra_shifter/presentation/blocs/plates/plates_state.dart';

class PlatesPage extends StatefulWidget {
  @override
  _PlatesPage createState() => _PlatesPage();
}

class _PlatesPage extends State<PlatesPage> {
  final _formKey = GlobalKey<FormState>();
  String? _customerName, _contactNumber;
  DateTime? _givenDate, _receivedDate;
  int? _totalDays, _quantity;
  double? _amountPerMonth, _totalAmount, _receivedAmount, _pendingAmount;
  String? _selectedCustomerId;

  // Controllers to handle the text input fields
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _totalDaysController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _amountPerMonthController =
      TextEditingController();
  final TextEditingController _totalAmountController = TextEditingController();
  final TextEditingController _receivedAmountController =
      TextEditingController();
  final TextEditingController _pendingAmountController =
      TextEditingController();
  final TextEditingController _givenDateController = TextEditingController();
  final TextEditingController _receivedDateController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  List<Customer> _customers = [];
  List<Customer> _filteredCustomers = [];
  String _newPlateId = '';

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
    _generateNewPlateId();

    // Add listeners to update total amount automatically
    _amountPerMonthController.addListener(_updateTotalAmount);
    _quantityController.addListener(_updateTotalAmount);
    _totalDaysController.addListener(_updateTotalAmount);
  }

  Future<void> _fetchCustomers() async {
    final customers = await CustomerService().getAllCustomers();
    setState(() {
      _customers = customers;
      _filteredCustomers = customers;
    });
  }

  Future<void> _generateNewPlateId() async {
    final plates = await PlatesService().getAllPlates();
    if (plates.isNotEmpty) {
      final lastPlateId = int.parse(plates.last.id);
      _newPlateId = (lastPlateId + 1).toString();
    } else {
      _newPlateId = '1';
    }
  }

  void _onCustomerSelected(Customer customer) {
    setState(() {
      _selectedCustomerId = customer.id;
      _customerNameController.text = customer.name;
      _contactNumberController.text = customer.contactNumber;
    });
    Navigator.of(context).pop();
  }

  void _showCustomerSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
              AppLocalizations.of(context)?.translate('select_customer') ??
                  'Select Customer'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context)?.translate('search') ??
                          'Search',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    _filteredCustomers = _customers
                        .where((customer) =>
                            customer.name
                                .toLowerCase()
                                .contains(value.toLowerCase()) ||
                            customer.contactNumber.contains(value))
                        .toList();
                  });
                },
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _filteredCustomers.length,
                  itemBuilder: (context, index) {
                    final customer = _filteredCustomers[index];
                    return ListTile(
                      title: Text(customer.name),
                      subtitle: Text(customer.contactNumber),
                      onTap: () => _onCustomerSelected(customer),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _calculateTotalDays() {
    if (_givenDate != null && _receivedDate != null) {
      setState(() {
        _totalDays = _receivedDate!.difference(_givenDate!).inDays;
        _totalDaysController.text = _totalDays.toString();
        _updateTotalAmount();
      });
    }
  }

  double _calculateTotalAmount(
      double amountPerMonth, int quantity, int totalDays) {
    // Calculate the total amount based on the amount per month for 100 plates for 30 days
    double amountPerDayPerPlate = amountPerMonth / 30 / 100;
    return amountPerDayPerPlate * quantity * totalDays;
  }

  void _updateTotalAmount() {
    if (_amountPerMonthController.text.isNotEmpty &&
        _quantityController.text.isNotEmpty &&
        _totalDaysController.text.isNotEmpty) {
      final amountPerMonth =
          double.tryParse(_amountPerMonthController.text) ?? 0.0;
      final quantity = int.tryParse(_quantityController.text) ?? 0;
      final totalDays = int.tryParse(_totalDaysController.text) ?? 0;
      final totalAmount =
          _calculateTotalAmount(amountPerMonth, quantity, totalDays);
      setState(() {
        _totalAmountController.text = totalAmount.toStringAsFixed(2);
      });
    }
  }

  void _updatePendingAmount() {
    if (_totalAmountController.text.isNotEmpty &&
        _receivedAmountController.text.isNotEmpty) {
      final totalAmount = double.tryParse(_totalAmountController.text) ?? 0.0;
      final receivedAmount =
          double.tryParse(_receivedAmountController.text) ?? 0.0;
      final pendingAmount = totalAmount - receivedAmount;
      setState(() {
        _pendingAmountController.text = pendingAmount.toString();
      });
    }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _contactNumberController.dispose();
    _totalDaysController.dispose();
    _quantityController.dispose();
    _amountPerMonthController.dispose();
    _totalAmountController.dispose();
    _receivedAmountController.dispose();
    _pendingAmountController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Function to handle Save
  void _saveData(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final plate = Plates(
        id: _newPlateId,
        customerId: _selectedCustomerId!,
        customerName: _customerNameController.text,
        contactNumber: _contactNumberController.text,
        givenDate: _givenDate!,
        receivedDate: _receivedDate!,
        totalDays: _totalDays!,
        quantity: int.parse(_quantityController.text),
        amountPerMonth: double.parse(_amountPerMonthController.text),
        totalAmount: double.parse(_totalAmountController.text),
        receivedAmount: double.parse(_receivedAmountController.text),
        pendingAmount: double.parse(_pendingAmountController.text),
      );
      context.read<PlatesBloc>().add(AddPlateEvent(plate));
    }
  }

  // Function to handle Edit
  void _editData(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final plate = Plates(
        id: _newPlateId,
        customerId: _selectedCustomerId!,
        customerName: _customerNameController.text,
        contactNumber: _contactNumberController.text,
        givenDate: _givenDate!,
        receivedDate: _receivedDate!,
        totalDays: _totalDays!,
        quantity: int.parse(_quantityController.text),
        amountPerMonth: double.parse(_amountPerMonthController.text),
        totalAmount: double.parse(_totalAmountController.text),
        receivedAmount: double.parse(_receivedAmountController.text),
        pendingAmount: double.parse(_pendingAmountController.text),
      );
      context.read<PlatesBloc>().add(UpdatePlateEvent(plate));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return BlocProvider(
      create: (context) =>
          PlatesBloc(PlatesService())..add(GetAllPlatesEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              localizations?.translate('plates_details') ?? 'Plates Details'),
          elevation: 0,
        ),
        body: BlocListener<PlatesBloc, PlatesState>(
          listener: (context, state) {
            if (state is PlatesOperationSuccess) {
              _showToast(state.message);
              Navigator.of(context).pop(); // Navigate back after success
            } else if (state is PlatesError) {
              _showToast(state.error);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // Customer Selection Button
                  ElevatedButton(
                    onPressed: _showCustomerSelectionDialog,
                    child: Text(localizations?.translate('select_customer') ??
                        'Select Customer'),
                  ),
                  const SizedBox(height: 16),

                  // Customer Name Input
                  TextFormField(
                    controller: _customerNameController,
                    decoration: InputDecoration(
                      labelText: localizations?.translate('customer_name') ??
                          'Customer Name',
                      labelStyle: TextStyle(color: theme.primaryColor),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: theme.primaryColor, width: 2),
                      ),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return localizations
                                ?.translate('please_enter_customer_name') ??
                            'Please enter the customer name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Contact Number Input
                  TextFormField(
                    controller: _contactNumberController,
                    decoration: InputDecoration(
                      labelText: localizations?.translate('contact_number') ??
                          'Contact Number',
                      labelStyle: TextStyle(color: theme.primaryColor),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: theme.primaryColor, width: 2),
                      ),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone, color: theme.primaryColor),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return localizations
                                ?.translate('please_enter_contact_number') ??
                            'Please enter a contact number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Given Date Input (Date Picker)
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: localizations?.translate('given_date') ??
                          'Given Date',
                      labelStyle: TextStyle(color: theme.primaryColor),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: theme.primaryColor, width: 2),
                      ),
                      border: OutlineInputBorder(),
                      suffixIcon:
                          Icon(Icons.calendar_today, color: theme.primaryColor),
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
                          _calculateTotalDays();
                        });
                      }
                    },
                    controller: TextEditingController(
                        text: _givenDate == null
                            ? ''
                            : _givenDate!.toLocal().toString().split(' ')[0]),
                  ),
                  const SizedBox(height: 16),

                  // Received Date Input (Date Picker)
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: localizations?.translate('received_date') ??
                          'Received Date',
                      labelStyle: TextStyle(color: theme.primaryColor),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: theme.primaryColor, width: 2),
                      ),
                      border: OutlineInputBorder(),
                      suffixIcon:
                          Icon(Icons.calendar_today, color: theme.primaryColor),
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
                          _calculateTotalDays();
                        });
                      }
                    },
                    controller: TextEditingController(
                        text: _receivedDate == null
                            ? ''
                            : _receivedDate!
                                .toLocal()
                                .toString()
                                .split(' ')[0]),
                  ),
                  const SizedBox(height: 16),

                  // Total Days Input
                  TextFormField(
                    controller: _totalDaysController,
                    decoration: InputDecoration(
                      labelText: localizations?.translate('total_days') ??
                          'Total Days',
                      labelStyle: TextStyle(color: theme.primaryColor),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: theme.primaryColor, width: 2),
                      ),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    readOnly: true,
                  ),
                  const SizedBox(height: 16),

                  // Quantity Input
                  TextFormField(
                    controller: _quantityController,
                    decoration: InputDecoration(
                      labelText:
                          localizations?.translate('quantity') ?? 'Quantity',
                      labelStyle: TextStyle(color: theme.primaryColor),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: theme.primaryColor, width: 2),
                      ),
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return localizations
                                ?.translate('please_enter_quantity') ??
                            'Please enter the quantity';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Amount Per Month Input
                  TextFormField(
                    controller: _amountPerMonthController,
                    decoration: InputDecoration(
                      labelText: localizations?.translate('amount_per_month') ??
                          'Amount Per Month',
                      labelStyle: TextStyle(color: theme.primaryColor),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: theme.primaryColor, width: 2),
                      ),
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return localizations
                                ?.translate('please_enter_amount_per_month') ??
                            'Please enter the amount per month';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Total Amount Input
                  TextFormField(
                    controller: _totalAmountController,
                    decoration: InputDecoration(
                      labelText: localizations?.translate('total_amount') ??
                          'Total Amount',
                      labelStyle: TextStyle(color: theme.primaryColor),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: theme.primaryColor, width: 2),
                      ),
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    readOnly: true,
                  ),
                  const SizedBox(height: 16),

                  // Received Amount Input
                  TextFormField(
                    controller: _receivedAmountController,
                    decoration: InputDecoration(
                      labelText: localizations?.translate('received_amount') ??
                          'Received Amount',
                      labelStyle: TextStyle(color: theme.primaryColor),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: theme.primaryColor, width: 2),
                      ),
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return localizations
                                ?.translate('please_enter_received_amount') ??
                            'Please enter the received amount';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      // Call _updatePendingAmount whenever the received amount changes
                      _updatePendingAmount();
                    },
                  ),

                  const SizedBox(height: 16),

                  // Pending Amount Input
                  TextFormField(
                    controller: _pendingAmountController,
                    decoration: InputDecoration(
                      labelText: localizations?.translate('pending_amount') ??
                          'Pending Amount',
                      labelStyle: TextStyle(color: theme.primaryColor),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: theme.primaryColor, width: 2),
                      ),
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return localizations
                                ?.translate('please_enter_pending_amount') ??
                            'Please enter the pending amount';
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
                        onPressed: () => _saveData(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 12),
                        ),
                        child: Text(localizations?.translate('save') ?? 'Save',
                            style: const TextStyle(fontSize: 16)),
                      ),
                      ElevatedButton(
                        onPressed: () => _editData(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 12),
                        ),
                        child: Text(
                            localizations?.translate('update') ?? 'Update',
                            style: const TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
