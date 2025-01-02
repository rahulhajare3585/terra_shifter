import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:terra_shifter/data/Services/tractor_work_service.dart';
import 'package:terra_shifter/data/models/customer.dart';
import 'package:terra_shifter/data/models/tractors_work.dart';
import 'package:terra_shifter/presentation/blocs/tractor/tractor_work_bloc.dart';
import 'package:terra_shifter/presentation/blocs/tractor/tractor_work_event.dart';
import 'package:terra_shifter/presentation/blocs/tractor/tractor_work_state.dart';

class TractorsWorkPage extends StatefulWidget {
  @override
  _TractorsWorkPageState createState() => _TractorsWorkPageState();
}

class _TractorsWorkPageState extends State<TractorsWorkPage> {
  String? selectedCustomerName;
  String? selectedCustomerId;
  List<TractorsWork> works = [];

  final TextEditingController _workNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _amountPerUnitController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<TractorsWorkBloc>().add(GetAllCustomersEvent());
  }

  void _showCustomerSelectionSheet(List<Customer> customers) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return BlocProvider(
          create: (context) => TractorsWorkBloc(TractorsWorkService()),
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

  void _showAddWorkSheet(BuildContext context,
      {TractorsWork? work, int? index}) {
    DateTime selectedDate = work?.workDate != null
        ? DateTime.parse(work!.workDate)
        : DateTime.now();
    String machineType = work?.machineType ?? 'Power Tiller';

    _workNameController.text = work?.workName ?? '';
    _quantityController.text = work?.AreaOrQuantity ?? '';
    _amountPerUnitController.text = work?.amountPerUnit ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                const Text('Work Details',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                DropdownButton<String>(
                  value: machineType,
                  items: ['Power Tiller', 'Tractor']
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      machineType = value!;
                    });
                  },
                ),
                TextField(
                  controller: _workNameController,
                  decoration: const InputDecoration(labelText: 'Work Name'),
                ),
                TextField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Quantity'),
                ),
                TextField(
                  controller: _amountPerUnitController,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Amount Per Unit'),
                ),
                ListTile(
                  title: Text('Date: ${DateFormat.yMd().format(selectedDate)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final quantity =
                        double.tryParse(_quantityController.text) ?? 0;
                    final amountPerUnit =
                        double.tryParse(_amountPerUnitController.text) ?? 0;
                    final totalAmount = quantity * amountPerUnit;

                    final newWork = TractorsWork(
                      id: work?.id ?? DateTime.now().toString(),
                      customerId: selectedCustomerId!,
                      machineType: machineType,
                      workName: _workNameController.text,
                      workDate: DateFormat('yyyy-MM-dd').format(selectedDate),
                      AreaOrQuantity: _quantityController.text,
                      amountPerUnit: _amountPerUnitController.text,
                      totalWorkAmount: totalAmount.toStringAsFixed(2),
                    );

                    if (work == null) {
                      context
                          .read<TractorsWorkBloc>()
                          .add(AddTractorsWorkEvent(newWork));
                    } else {
                      context
                          .read<TractorsWorkBloc>()
                          .add(UpdateTractorsWorkEvent(newWork));
                    }

                    Navigator.pop(context);
                  },
                  child: Text(work == null ? 'Add Work' : 'Update Work'),
                ),
              ],
            ),
          ),
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
            BlocBuilder<TractorsWorkBloc, TractorsWorkState>(
              builder: (context, state) {
                if (state is CustomerLoaded) {
                  return GestureDetector(
                    onTap: () => _showCustomerSelectionSheet(state.customers),
                    child: AbsorbPointer(
                      child: DropdownButtonFormField<String>(
                        value: selectedCustomerName,
                        decoration: InputDecoration(
                          labelText: 'Select or Enter Customer Name',
                        ),
                        items: state.customers
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
                  );
                } else if (state is TractorsWorkLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is TractorsWorkLoaded) {
                  works = state.tractorsWorks;
                  return Container();
                } else {
                  return Center(child: Text('Failed to load customers'));
                }
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: selectedCustomerId == null
                    ? null
                    : () {
                        _showAddWorkSheet(context);
                      },
                child: const Text('Add Work'),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: works.length,
                itemBuilder: (context, index) {
                  final work = works[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(work.workName),
                      subtitle: Text(
                          'Date: ${work.workDate}\nQuantity: ${work.AreaOrQuantity} units\nTotal: ${work.totalWorkAmount}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showAddWorkSheet(context, work: work, index: index);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
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
            decoration: InputDecoration(
              labelText: 'Search Customer',
              prefixIcon: Icon(Icons.search),
            ),
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
                  onTap: () => widget.onCustomerSelected(customer),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
