import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:terra_shifter/data/models/customer.dart';
import 'package:terra_shifter/data/models/tractors_work.dart';
import 'package:terra_shifter/presentation/blocs/tractor/tractor_work_bloc.dart';
import 'package:terra_shifter/presentation/blocs/tractor/tractor_work_event.dart';
import 'package:terra_shifter/presentation/blocs/tractor/tractor_work_state.dart';

class TractorsWorkManagerScreen extends StatefulWidget {
  @override
  _TractorsWorkManagerScreenState createState() =>
      _TractorsWorkManagerScreenState();
}

class _TractorsWorkManagerScreenState extends State<TractorsWorkManagerScreen> {
  String? selectedCustomerName;
  String? selectedCustomerId;
  List<TractorsWork> works = [];

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
        return BlocListener<TractorsWorkBloc, TractorsWorkState>(
          listener: (context, state) {
            if(state is TractorsWorkLoaded) {
              Expanded(
              child: BlocBuilder<TractorsWorkBloc, TractorsWorkState>(
                builder: (context, state) {
                  if (state is TractorsWorkLoaded) {
                    works = state.tractorsWorks;
                    return ListView.builder(
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
                                // Implement edit functionality if needed
                              },
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is TractorsWorkLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Center(child: Text('No work data available'));
                  }
                },
              ),
            );
            }
          },
          child: CustomerSelectionSheet(
            customers: customers,
            onCustomerSelected: (customer) {
              setState(() {
                selectedCustomerName = customer.name;
                selectedCustomerId = customer.id;
              });
              Navigator.pop(context);
              context
                  .read<TractorsWorkBloc>()
                  .add(GetTractorsWorkByCustomerIdEvent(customer.id));
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tractors Work Manager'),
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
                          labelText: 'Select Customer Name',
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
                } else {
                  return Center(child: Text('Failed to load customers'));
                }
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<TractorsWorkBloc, TractorsWorkState>(
                builder: (context, state) {
                  if (state is TractorsWorkLoaded) {
                    works = state.tractorsWorks;
                    return ListView.builder(
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
                                // Implement edit functionality if needed
                              },
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is TractorsWorkLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Center(child: Text('No work data available'));
                  }
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
