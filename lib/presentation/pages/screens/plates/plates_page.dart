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
import 'package:terra_shifter/presentation/pages/screens/plates/widgets/custom_selection_button.dart';
import 'package:terra_shifter/presentation/pages/screens/plates/widgets/custom_text_field.dart';

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
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _totalDaysController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _amountPerMonthController = TextEditingController();
  final TextEditingController _totalAmountController = TextEditingController();
  final TextEditingController _receivedAmountController = TextEditingController();
  final TextEditingController _pendingAmountController = TextEditingController();
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.8,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration:const InputDecoration(
                        labelText: 'Search',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _filteredCustomers = _customers
                              .where((customer) =>
                                  customer.name.toLowerCase().contains(value.toLowerCase()) ||
                                  customer.contactNumber.contains(value))
                              .toList();
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
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

  double _calculateTotalAmount(double amountPerMonth, int quantity, int totalDays) {
    // Calculate the total amount based on the amount per month for 100 plates for 30 days
    double amountPerDayPerPlate = amountPerMonth / 30 / 100;
    return amountPerDayPerPlate * quantity * totalDays;
  }

  void _updateTotalAmount() {
    if (_amountPerMonthController.text.isNotEmpty &&
        _quantityController.text.isNotEmpty &&
        _totalDaysController.text.isNotEmpty) {
      final amountPerMonth = double.tryParse(_amountPerMonthController.text) ?? 0.0;
      final quantity = int.tryParse(_quantityController.text) ?? 0;
      final totalDays = int.tryParse(_totalDaysController.text) ?? 0;
      final totalAmount = _calculateTotalAmount(amountPerMonth, quantity, totalDays);
      setState(() {
        _totalAmountController.text = totalAmount.toStringAsFixed(2);
      });
    }
  }

  void _updatePendingAmount() {
    if (_totalAmountController.text.isNotEmpty &&
        _receivedAmountController.text.isNotEmpty) {
      final totalAmount = double.tryParse(_totalAmountController.text) ?? 0.0;
      final receivedAmount = double.tryParse(_receivedAmountController.text) ?? 0.0;
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Plate added successfully'),
          duration: const Duration(seconds: 2),
        ),
      );
      _clearControllers();
      //pop the screen
      Navigator.of(context).pop();
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
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Plate updated successfully'),
          duration: const Duration(seconds: 2),
        ),

      );
      _clearControllers();
      //pop the screen
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return BlocProvider(
      create: (context) => PlatesBloc(PlatesService())..add(GetAllPlatesEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(localizations?.translate('plates_details') ?? 'Plates Details'),
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
                  CustomTextField(
                    controller: _customerNameController,
                    labelText: localizations?.translate('customer_name') ?? 'Customer Name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return localizations?.translate('please_enter_customer_name') ?? 'Please enter the customer name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomerSelectionButton(onPressed: _showCustomerSelectionDialog),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _contactNumberController,
                    labelText: localizations?.translate('contact_number') ?? 'Contact Number',
                    prefixIcon: Icon(Icons.phone, color: theme.primaryColor),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return localizations?.translate('please_enter_contact_number') ?? 'Please enter a contact number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _givenDateController,
                    labelText: localizations?.translate('given_date') ?? 'Given Date',
                    readOnly: true,
                    suffixIcon: Icon(Icons.calendar_today, color: theme.primaryColor),
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
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _receivedDateController,
                    labelText: localizations?.translate('received_date') ?? 'Received Date',
                    readOnly: true,
                    suffixIcon: Icon(Icons.calendar_today, color: theme.primaryColor),
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
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _totalDaysController,
                    labelText: localizations?.translate('total_days') ?? 'Total Days',
                    readOnly: true,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _quantityController,
                    labelText: localizations?.translate('quantity') ?? 'Quantity',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return localizations?.translate('please_enter_quantity') ?? 'Please enter the quantity';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _amountPerMonthController,
                    labelText: localizations?.translate('amount_per_month') ?? 'Amount Per Month',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return localizations?.translate('please_enter_amount_per_month') ?? 'Please enter the amount per month';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _totalAmountController,
                    labelText: localizations?.translate('total_amount') ?? 'Total Amount',
                    readOnly: true,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _receivedAmountController,
                    labelText: localizations?.translate('received_amount') ?? 'Received Amount',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return localizations?.translate('please_enter_received_amount') ?? 'Please enter the received amount';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _updatePendingAmount();
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _pendingAmountController,
                    labelText: localizations?.translate('pending_amount') ?? 'Pending Amount',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return localizations?.translate('please_enter_pending_amount') ?? 'Please enter the pending amount';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
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
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        ),
                        child: Text(localizations?.translate('save') ?? 'Save', style: TextStyle(fontSize: 16, color: theme.cardColor)),
                      ),
                      ElevatedButton(
                        onPressed: () => _editData(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(color: theme.primaryColor),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        ),
                        child: Text(localizations?.translate('update') ?? 'Update', style: TextStyle(fontSize: 16, color: theme.primaryColor)),
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
  
  void _clearControllers() {
    _customerNameController.clear();
    _contactNumberController.clear();
    _givenDateController.clear();
    _receivedDateController.clear();
    _totalDaysController.clear();
    _quantityController.clear();
    _amountPerMonthController.clear();
    _totalAmountController.clear();
    _receivedAmountController.clear();
    _pendingAmountController.clear();
    _searchController.clear();
  }
}