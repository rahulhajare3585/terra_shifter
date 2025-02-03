import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:terra_shifter/data/models/customer.dart';
import 'package:terra_shifter/data/models/tractors_work.dart';
import 'package:terra_shifter/presentation/blocs/tractor/tractor_work_bloc.dart';
import 'package:terra_shifter/presentation/blocs/tractor/tractor_work_event.dart';
import 'package:terra_shifter/presentation/blocs/tractor/tractor_work_state.dart';
import 'package:terra_shifter/presentation/pages/tractors/invoice/bloc/tractor_invoice_bloc.dart';
import 'package:terra_shifter/presentation/pages/tractors/invoice/service/tractor_invoice_page_service.dart';
import 'package:terra_shifter/presentation/pages/tractors/invoice/tractor_invoice_page.dart';

class TractorsWorkPage extends StatefulWidget {
  @override
  _TractorsWorkPageState createState() => _TractorsWorkPageState();
}

class _TractorsWorkPageState extends State<TractorsWorkPage> {
  String? selectedCustomerName;
  String? selectedCustomerId;
  String machineType = 'Power Tiller';
  String measurementUnit = 'Acer';
  String workName = 'Shifting (Tailor)';
  String buttonText = "Save";
  List<TractorsWork> works = [];
  List<Customer> customers = [];
  bool isFormVisible = false;
  TractorsWork? _selectedWork;

  final TextEditingController _workNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _amountPerUnitController =
      TextEditingController();
  final TextEditingController _amountReceivedController =
      TextEditingController();
  final TextEditingController _machineTypeController = TextEditingController();
  final TextEditingController _measurementUnitController =
      TextEditingController();
  double totalAmount = 0;

  @override
  void initState() {
    super.initState();
    context.read<TractorsWorkBloc>().add(InitializeTractorsWorkPageEvent());
    _machineTypeController.text = machineType;
    _measurementUnitController.text = measurementUnit;
    _workNameController.text = workName;
  }

  void _toggleFormVisibility() {
    setState(() {
      isFormVisible = !isFormVisible;
    });
  }

  void _populateFields(TractorsWork work) {
    setState(() {
      _selectedWork = work;
      _workNameController.text = work.workName;
      _quantityController.text = work.AreaOrQuantity;
      _amountPerUnitController.text = work.amountPerUnit;
      selectedCustomerId = work.customerId;
      selectedCustomerName = customers
          .firstWhere((customer) => customer.id == work.customerId)
          .name;
      machineType = work.machineType;
      _machineTypeController.text = machineType;
      _amountReceivedController.text = work.receivedAmount;
      totalAmount = double.tryParse(work.totalWorkAmount) ?? 0;
      isFormVisible = true;
      buttonText = 'Update';
    });
  }

  void _resetFields() {
    setState(() {
      _workNameController.clear();
      _quantityController.clear();
      _amountPerUnitController.clear();
      selectedCustomerId = null;
      selectedCustomerName = null;
      machineType = 'Power Tiller';
      _machineTypeController.text = machineType;
      measurementUnit = 'Acer';
      _measurementUnitController.text = measurementUnit;
      workName = 'Shifting (Tailor)';
      _workNameController.text = workName;
      totalAmount = 0;
      isFormVisible = false;
    });
  }

  void _calculateTotal() {
    final double quantity = double.tryParse(_quantityController.text) ?? 0;
    final double amountPerUnit =
        double.tryParse(_amountPerUnitController.text) ?? 0;
    setState(() {
      totalAmount = quantity * amountPerUnit;
    });
  }

  void _saveWork(TractorsWork? work) {
    final newWork = TractorsWork(
      id: work?.id ?? DateTime.now().toString(),
      customerId: selectedCustomerId!,
      machineType: machineType,
      workName: _workNameController.text,
      workDate: DateFormat('yyyy-MM-dd')
          .format(DateTime.now()), // Assuming current date for simplicity
      AreaOrQuantity: _quantityController.text,
      amountPerUnit: _amountPerUnitController.text,
      totalWorkAmount: totalAmount.toStringAsFixed(2),
      measurementUnit: measurementUnit,
      receivedAmount: _amountReceivedController.text,
    );

    if (buttonText == "Save") {
      newWork.id = DateTime.now().toString();
      context.read<TractorsWorkBloc>().add(AddTractorsWorkEvent(newWork));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Customer added successfully!")),
      );
    } else {
      newWork.id = _selectedWork!.id;
      context.read<TractorsWorkBloc>().add(UpdateTractorsWorkEvent(newWork));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Customer updated successfully!")),
      );
      buttonText = "Save";
    }

    setState(() {
      _resetFields();
    _toggleFormVisibility();
    context.read<TractorsWorkBloc>().add(InitializeTractorsWorkPageEvent());
    });
  }

  void _showMachineTypeSelectionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: BlocProvider.of<TractorsWorkBloc>(this.context),
          child: MachineTypeSelectionSheet(
            selectedMachineType: machineType,
            onMachineTypeSelected: (type) {
              setState(() {
                machineType = type;
                _machineTypeController.text = type;
              });
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  void _showMeasurementUnitSelectionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return MeasurementUnitSelectionSheet(
          selectedMeasurementUnit: measurementUnit,
          onMeasurementUnitSelected: (unit) {
            setState(() {
              measurementUnit = unit;
              _measurementUnitController.text = unit;
            });
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void _showWorkNameSelectionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return WorkNameSelectionSheet(
          selectedWorkName: workName,
          onWorkNameSelected: (name) {
            setState(() {
              workName = name;
              _workNameController.text = name;
            });
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tractors Work'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isFormVisible)
              SizedBox(
                height: 500,
                child: Card(
                  shadowColor: Theme.of(context).primaryColor,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Work Details',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () => _showCustomerSelectionSheet(customers),
                            child: AbsorbPointer(
                              child: DropdownButtonFormField<String>(
                                value: selectedCustomerName,
                                decoration: const InputDecoration(
                                  labelText: 'Select Customer Name',
                                ),
                                items: customers
                                    .map((customer) => DropdownMenuItem<String>(
                                          value: customer.name,
                                          child: Text(customer.name),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedCustomerName = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: _showMachineTypeSelectionSheet,
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: _machineTypeController,
                                decoration: const InputDecoration(
                                  labelText: 'Machine Type',
                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: _showWorkNameSelectionSheet,
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: _workNameController,
                                decoration: const InputDecoration(
                                  labelText: 'Work Name',
                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: _showMeasurementUnitSelectionSheet,
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: _measurementUnitController,
                                decoration: const InputDecoration(
                                  labelText: 'Measurement Unit',
                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _quantityController,
                            keyboardType: TextInputType.number,
                            decoration:
                                const InputDecoration(labelText: 'Quantity'),
                            onChanged: (value) => _calculateTotal(),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _amountPerUnitController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                labelText: 'Amount Per Unit'),
                            onChanged: (value) => _calculateTotal(),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _amountReceivedController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                labelText: 'Received amount'),
                            onChanged: (value) => _calculateTotal(),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Amount:',
                                  style: TextStyle(fontSize: 16)),
                              Text('\₹${totalAmount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () => _saveWork(null),
                                icon: const Icon(Icons.save),
                                label: Text(buttonText),
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
                ),
              ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<TractorsWorkBloc, TractorsWorkState>(
                builder: (context, state) {
                  if (state is TractorsWorkAndCustomersLoaded) {
                    works = state.tractorsWorks;
                    customers = state.customers;
                    return ListView.builder(
                      itemCount: works.length,
                      itemBuilder: (context, index) {
                        final work = works[index];
                        final customerName = customers
                            .firstWhere(
                                (customer) => customer.id == work.customerId)
                            .name;
                        final customerAddress = customers
                            .firstWhere(
                                (customer) => customer.id == work.customerId)
                            .address;
                        final customerContact = customers
                            .firstWhere(
                                (customer) => customer.id == work.customerId)
                            .contactNumber;
                        return Card(
                          shadowColor: Theme.of(context).primaryColor,
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const SizedBox(width: 8),
                                    Text(
                                      work.workDate,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(children: [
                                      const Icon(Icons.person,
                                          size: 22, color: Colors.black),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        customerName,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ]),
                                  ],
                                ),
                                Row(children: [
                                  const Icon(Icons.location_on,
                                      size: 12, color: Colors.black),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    customerAddress,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ]),
                                Row(children: [
                                  const Icon(Icons.phone,
                                      size: 12, color: Colors.black),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    customerContact,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ]),
                                const Divider(),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Text('Machine Type :',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(width: 8),
                                    Text(
                                      work.machineType,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('Total work units :',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${work.AreaOrQuantity} ${work.measurementUnit}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('Amount :',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(width: 8),
                                    Text(
                                      ' ${work.amountPerUnit} / ${work.measurementUnit}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('Total Amount :',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(width: 8),
                                    Text(
                                      '₹ ${work.totalWorkAmount}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('Received Amount :',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(width: 8),
                                    Text(
                                      '₹ ${work.receivedAmount}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('Pending Amount :',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(width: 8),
                                    Text(
                                      '₹ ${(double.tryParse(work.totalWorkAmount) ?? 0) - (double.tryParse(work.receivedAmount) ?? 0)}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.receipt,
                                          color:
                                              Theme.of(context).primaryColor),
                                      onPressed: () {
                                        // Navigate to invoice page
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BlocProvider(
                                                      create: (context) =>
                                                          TractorInvoiceBloc(
                                                              TractorInvoicePageService()),
                                                      child: TractorInvoicePage(
                                                          customerId: work
                                                              .customerId
                                                              .toString()),
                                                    )));
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit,
                                          color:
                                              Theme.of(context).primaryColor),
                                      onPressed: () {
                                        _populateFields(work);
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is TractorsWorkLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return const Center(child: Text('No work data available'));
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

  void _showCustomerSelectionSheet(List<Customer> customers) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: BlocProvider.of<TractorsWorkBloc>(this.context),
          child: CustomerSelectionSheet(
            customers: customers,
            onCustomerSelected: (customer) {
              setState(() {
                selectedCustomerName = customer.name;
                selectedCustomerId = customer.id;
              });
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}

class CustomerSelectionSheet extends StatefulWidget {
  final List<Customer> customers;
  final Function(Customer) onCustomerSelected;

  CustomerSelectionSheet(
      {required this.customers, required this.onCustomerSelected});

  @override
  _CustomerSelectionSheetState createState() => _CustomerSelectionSheetState();
}

class _CustomerSelectionSheetState extends State<CustomerSelectionSheet> {
  TextEditingController _searchController = TextEditingController();
  List<Customer> _filteredCustomers = [];

  @override
  void initState() {
    super.initState();
    _filteredCustomers = widget.customers;
    _searchController.addListener(_filterCustomers);
  }

  void _filterCustomers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCustomers = widget.customers.where((customer) {
        return customer.name.toLowerCase().contains(query) ||
            customer.contactNumber.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterCustomers);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Search Customer',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredCustomers.length,
              itemBuilder: (context, index) {
                final customer = _filteredCustomers[index];
                return ListTile(
                  title: Text(customer.name),
                  subtitle: Text(customer.contactNumber),
                  onTap: () {
                    widget.onCustomerSelected(customer);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MachineTypeSelectionSheet extends StatelessWidget {
  final String selectedMachineType;
  final Function(String) onMachineTypeSelected;

  MachineTypeSelectionSheet(
      {required this.selectedMachineType, required this.onMachineTypeSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Select Machine Type',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ListTile(
            title: const Text('Power Tiller'),
            onTap: () => onMachineTypeSelected('Power Tiller'),
            selected: selectedMachineType == 'Power Tiller',
          ),
          ListTile(
            title: const Text('Tractor'),
            onTap: () => onMachineTypeSelected('Tractor'),
            selected: selectedMachineType == 'Tractor',
          ),
        ],
      ),
    );
  }
}

class MeasurementUnitSelectionSheet extends StatelessWidget {
  final String selectedMeasurementUnit;
  final Function(String) onMeasurementUnitSelected;

  MeasurementUnitSelectionSheet(
      {required this.selectedMeasurementUnit,
      required this.onMeasurementUnitSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Select Measurement Unit',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ListTile(
            title: const Text('Acer'),
            onTap: () => onMeasurementUnitSelected('Acer'),
            selected: selectedMeasurementUnit == 'Acer',
          ),
          ListTile(
            title: const Text('Tailor'),
            onTap: () => onMeasurementUnitSelected('Tailor'),
            selected: selectedMeasurementUnit == 'Tailor',
          ),
          ListTile(
            title: const Text('Hr'),
            onTap: () => onMeasurementUnitSelected('Hr'),
            selected: selectedMeasurementUnit == 'Hr',
          ),
        ],
      ),
    );
  }
}

class WorkNameSelectionSheet extends StatelessWidget {
  final String selectedWorkName;
  final Function(String) onWorkNameSelected;

  WorkNameSelectionSheet(
      {required this.selectedWorkName, required this.onWorkNameSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select Work Name',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ListTile(
              title: const Text('Shifting (Tailor)'),
              onTap: () => onWorkNameSelected('Shifting (Tailor)'),
              selected: selectedWorkName == 'Shifting (Tailor)',
            ),
            ListTile(
              title: const Text('Nangar'),
              onTap: () => onWorkNameSelected('Nangar'),
              selected: selectedWorkName == 'Nangar',
            ),
            ListTile(
              title: const Text('Roter'),
              onTap: () => onWorkNameSelected('Roter'),
              selected: selectedWorkName == 'Roter',
            ),
            ListTile(
              title: const Text('Level'),
              onTap: () => onWorkNameSelected('Level'),
              selected: selectedWorkName == 'Level',
            ),
            ListTile(
              title: const Text('Fun'),
              onTap: () => onWorkNameSelected('Fun'),
              selected: selectedWorkName == 'Fun',
            ),
            ListTile(
              title: const Text('Bhar'),
              onTap: () => onWorkNameSelected('Bhar'),
              selected: selectedWorkName == 'Bhar',
            ),
            ListTile(
              title: const Text('Razor (Sari)'),
              onTap: () => onWorkNameSelected('Razor (Sari)'),
              selected: selectedWorkName == 'Razor (Sari)',
            ),
          ],
        ),
      ),
    );
  }
}
