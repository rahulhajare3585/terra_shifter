import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:terra_shifter/data/models/plates_master.dart';
import 'package:terra_shifter/data/models/customer.dart';
import 'package:terra_shifter/presentation/blocs/plates_manage/plates_manage_bloc.dart';
import 'package:terra_shifter/presentation/blocs/plates_manage/plates_manage_event.dart';
import 'package:terra_shifter/presentation/blocs/plates_manage/plates_managee_state.dart';

class PlatesManagePage extends StatefulWidget {
  @override
  _PlatesManagePageState createState() => _PlatesManagePageState();
}

class _PlatesManagePageState extends State<PlatesManagePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _givenPlatesQuantityController = TextEditingController();
  final TextEditingController _givenDateController = TextEditingController();
  final TextEditingController _receivedDateController = TextEditingController();
  final TextEditingController _receivedPlatesQuantityController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  List<Customer> _customers = [];
  List<Customer> _filteredCustomers = [];
  List<PlatesMaster> _platesMasters = [];
  List<PlatesMaster> _filteredPlatesMasters = [];
  int _totalPlates = 600; // Assuming totalPlates is 600
  int _availablePlates = 0;
  int _reservedPlates = 0;
  bool _showPlatesList = true;
  bool _isUpdate = false;
  PlatesMaster? _currentPlateMaster;

  @override
  void initState() {
    super.initState();
    context.read<PlatesManageBloc>().add(GetAllCustomersEvent());
    _fetchLastPlatesDetails();
    _fetchAllPlatesMasters();
  }

  void _fetchLastPlatesDetails() async {
    // Fetch the last PlatesMaster details
    final platesMasters = await context.read<PlatesManageBloc>().platesManageService.getAllPlateMasters();
    if (platesMasters.isNotEmpty) {
      final lastPlateMaster = platesMasters.last;
      setState(() {
        _availablePlates = lastPlateMaster.availablePlates;
        _reservedPlates = lastPlateMaster.reservedPlates;
      });
    } else {
      setState(() {
        _availablePlates = _totalPlates;
        _reservedPlates = 0;
      });
    }
  }

  void _fetchAllPlatesMasters() async {
    final platesMasters = await context.read<PlatesManageBloc>().platesManageService.getAllPlateMasters();
    setState(() {
      _platesMasters = platesMasters;
      _filteredPlatesMasters = platesMasters;
    });
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _givenPlatesQuantityController.dispose();
    _givenDateController.dispose();
    _receivedDateController.dispose();
    _receivedPlatesQuantityController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final customer = _customers.firstWhere(
        (customer) => customer.name == _customerNameController.text,
        orElse: () => Customer(id: '', name: '', contactNumber: '', address: ''),
      );

      if (customer != null) {
        final plateMaster = PlatesMaster(
          id: _isUpdate ? _currentPlateMaster!.id : DateTime.now().millisecondsSinceEpoch, // Auto-generated ID for new records
          availablePlates: _availablePlates,
          reservedPlates: _reservedPlates,
          customerId: customer.id,
          customerName: _customerNameController.text,
          givenPlatesQuantity: _givenPlatesQuantityController.text,
          givenDate: _givenDateController.text,
          receivedDate: _receivedDateController.text,
          receivedPlatesQuantity: _receivedPlatesQuantityController.text,
        );

        if (_isUpdate) {
          context.read<PlatesManageBloc>().add(UpdatePlateMasterEvent(plateMaster));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Record Updated Successfully')),
          );
        } else {
          context.read<PlatesManageBloc>().add(AddPlateMasterEvent(plateMaster));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Record Submitted Successfully')),
          );
        }

        _clearControllers();
        setState(() {
          _isUpdate = false;
          _currentPlateMaster = null;
        });
      } else {
        // Handle case where customer is not found
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Customer not found')),
        );
      }
    }
  }

  void _updateAvailablePlates() {
    final givenPlates = int.tryParse(_givenPlatesQuantityController.text) ?? 0;

    final updatedAvailablePlates = _availablePlates - givenPlates;
    setState(() {
      _availablePlates = updatedAvailablePlates;
      _reservedPlates = _totalPlates - updatedAvailablePlates;
    });
  }

  void _updateAvailablePlatesAfterReceived() {
    final receivedPlates = int.tryParse(_receivedPlatesQuantityController.text) ?? 0;

    final updatedAvailablePlates = _availablePlates + receivedPlates;
    setState(() {
      _availablePlates = updatedAvailablePlates;
      _reservedPlates = _totalPlates - updatedAvailablePlates;
    });
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  void _showCustomerSelectionDialog() {
    _filteredCustomers = _customers;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Select Customer'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor))
                    ),
                    onChanged: (value) {
                      setState(() {
                        _filteredCustomers = _customers
                            .where((customer) =>
                                customer.name.toLowerCase().contains(value.toLowerCase()) ||
                                customer.contactNumber.toLowerCase().contains(value.toLowerCase()))
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
                        return Card(
                          child: ListTile(
                            title: Text(customer.name),
                            subtitle: Row(
                              children: [
                                Icon(Icons.phone, size: 16),
                                SizedBox(width: 4),
                                Text(customer.contactNumber),
                              ],
                            ),
                            onTap: () {
                              setState(() {
                                _customerNameController.text = customer.name;
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _filterPlatesMasters(String query) {
    setState(() {
      _filteredPlatesMasters = _platesMasters
          .where((plateMaster) {
            final customer = _customers.firstWhere(
              (customer) => customer.id == plateMaster.customerId,
              orElse: () => Customer(id: '', name: '', contactNumber: '', address: ''),
            );
            return customer != null &&
                (plateMaster.customerName.toLowerCase().contains(query.toLowerCase()) ||
                customer.contactNumber.toLowerCase().contains(query.toLowerCase()));
          })
          .toList();
    });
  }

  void _showPlatesListBottomSheet(BuildContext context) {
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
              final theme = Theme.of(context);
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
                          _filteredPlatesMasters = _platesMasters
                              .where((plate) =>
                                  plate.customerName
                                      ?.toLowerCase()
                                      .contains(value.toLowerCase()) ??
                                  false)
                              .toList();
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _filteredPlatesMasters.length,
                        itemBuilder: (context, index) {
                          final plate = _filteredPlatesMasters[index];
                          final customer = _customers.firstWhere(
                            (customer) => customer.id == plate.customerId,
                            orElse: () => Customer(id: '', name: '', contactNumber: '', address: ''),
                          );
                          final givenPlates = int.tryParse(plate.givenPlatesQuantity ?? '0') ?? 0;
                          final receivedPlates = int.tryParse(plate.receivedPlatesQuantity ?? '0') ?? 0;
                          final reservedPlates = givenPlates - receivedPlates;
                          return Card(
                            elevation: 4,
                            child: ListTile(
                              title: Text(plate.customerName ?? '', style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(Icons.phone, size: 16),
                                      Text(' ${customer.contactNumber}'),
                                      SizedBox(width: 8),
                                    ],
                                  ),
                                  const Divider(),
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Given Date', style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text('Received Date', style: TextStyle(fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(plate.givenDate ?? '-'),
                                      Text(plate.receivedDate ?? '-'),
                                    ],
                                  ),
                                 const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Given Plates', style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text('Received Plates', style: TextStyle(fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('$givenPlates'),
                                      Text('$receivedPlates'),
                                    ],
                                  ),
                                  const Divider(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const Text('Engagged Plates: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text('$reservedPlates'),
                                    ],
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                                _populateFormFields(plate);
                              },
                            ),
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

  void _populateFormFields(PlatesMaster plateMaster) {
    final customer = _customers.firstWhere(
      (customer) => customer.id == plateMaster.customerId,
      orElse: () => Customer(id: '', name: '', contactNumber: '', address: ''),
    );

    if (customer != null) {
      setState(() {
        _customerNameController.text = customer.name;
        _givenPlatesQuantityController.text = plateMaster.givenPlatesQuantity ?? '';
        _givenDateController.text = plateMaster.givenDate ?? '';
        _receivedDateController.text = plateMaster.receivedDate ?? '';
        _receivedPlatesQuantityController.text = plateMaster.receivedPlatesQuantity ?? '';
        _isUpdate = true;
        _currentPlateMaster = plateMaster;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Plates'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              setState(() {
                _showPlatesList = true;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Available Plates: $_availablePlates',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Reserved Plates: $_reservedPlates',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _customerNameController,
                      decoration: InputDecoration(labelText: 'Customer Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter customer name';
                        }
                        return null;
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_drop_down),
                    onPressed: _showCustomerSelectionDialog,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _givenPlatesQuantityController,
                decoration: InputDecoration(labelText: 'Given Plates Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter given plates quantity';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _givenDateController,
                decoration: InputDecoration(
                  labelText: 'Given Date',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => {
                      _selectDate(context, _givenDateController),
                      _updateAvailablePlates(),
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter given date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _receivedPlatesQuantityController,
                decoration: InputDecoration(labelText: 'Received Plates Quantity'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _receivedDateController,
                decoration: InputDecoration(
                  labelText: 'Received Date',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => {
                      _selectDate(context, _receivedDateController),
                      _updateAvailablePlatesAfterReceived(),
                    },
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(_isUpdate ? 'Update' : 'Submit',style: TextStyle(color: Theme.of(context).cardColor),),
              ),
              const SizedBox(height: 20),
              BlocBuilder<PlatesManageBloc, PlatesManageState>(
                builder: (context, state) {
                  if (state is PlatesManageLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is PlatesManageError) {
                    return Center(child: Text(state.error));
                  } else if (state is CustomerLoaded) {
                    _customers = state.customers;
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPlatesListBottomSheet(context),
        child: const Icon(Icons.list),
      ),
    );
  }

  void _clearControllers() {
    _customerNameController.clear();
    _givenPlatesQuantityController.clear();
    _givenDateController.clear();
    _receivedDateController.clear();
    _receivedPlatesQuantityController.clear();
    setState(() {
      _isUpdate = false;
      _currentPlateMaster = null;
    });
  }
}