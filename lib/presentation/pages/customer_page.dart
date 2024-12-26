import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:terra_shifter/data/models/customer.dart';
import 'package:terra_shifter/presentation/blocs/customer/customer_bloc.dart';
import 'package:terra_shifter/presentation/blocs/customer/customer_event.dart';
import 'package:terra_shifter/presentation/blocs/customer/customer_state.dart';

class CustomerPage extends StatefulWidget {
  @override
  _CustomerPageState createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  Customer? customerdata;

  @override
  void initState() {
    super.initState();
    context.read<CustomerBloc>().add(GetAllCustomersEvent());
  }

  void _populateCustomerDetails(Customer customer) {
    setState(() {
      customerdata = customer;
      idController.text = customer.id;
      nameController.text = customer.name;
      addressController.text = customer.address;
      contactController.text = customer.contactNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              BlocConsumer<CustomerBloc, CustomerState>(
                listener: (context, state) {
                  if (state is CustomerOperationSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } else if (state is CustomerError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.error),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is CustomerLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CustomerLoaded) {
                    final nextId = state.customers.isNotEmpty
                        ? (state.customers.map((c) {
                            try {
                              return int.parse(c.id);
                            } catch (e) {
                              return 0;
                            }
                          }).reduce((a, b) => a > b ? a : b) + 1)
                            .toString()
                        : '1';
                    idController.text = nextId;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCustomerForm(theme),
                        const SizedBox(height: 24),
                        const Text(
                          "Customer List",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildCustomerList(state.customers),
                      ],
                    );
                  }
                  return const Center(child: Text("No data available."));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerForm(ThemeData theme) {
    final ThemeData theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Customer Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Customer Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: "Customer Address",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.location_on),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: contactController,
              decoration: InputDecoration(
                labelText: "Contact Number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton("Add", Icons.add, () {
                  final customer = Customer(
                    id: idController.text.toString(),
                    name: nameController.text,
                    address: addressController.text,
                    contactNumber: contactController.text,
                  );
                  context.read<CustomerBloc>().add(AddCustomerEvent(customer));
                  _clearForm();
                }),
                _buildActionButton("Update", Icons.update, () {
                  final customer = Customer(
                    id: customerdata?.id ?? idController.text,
                    name: nameController.text,
                    address: addressController.text,
                    contactNumber: contactController.text,
                  );
                  context.read<CustomerBloc>().add(UpdateCustomerEvent(customer));
                  _clearForm();
                }),
                _buildActionButton("Delete", Icons.delete, () {
                  context.read<CustomerBloc>().add(DeleteCustomerEvent(customerdata?.id ?? idController.text));
                  _clearForm();
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onPressed) {
    final ThemeData theme = Theme.of(context);
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label, style: TextStyle(fontSize: 16, color: theme.textTheme.bodySmall?.color)),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildCustomerList(List<Customer> customers) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: customers.length,
      itemBuilder: (context, index) {
        final customer = customers[index];
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: Text(
              customer.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(customer.address),
            trailing: Text(customer.contactNumber),
            onTap: () => _populateCustomerDetails(customer),
          ),
        );
      },
    );
  }

  void _clearForm() {
    setState(() {
      nameController.clear();
      addressController.clear();
      contactController.clear();
      final customerId = int.tryParse(idController.text) ?? 0;
      idController.text = (customerId + 1).toString();
    });
  }
}
