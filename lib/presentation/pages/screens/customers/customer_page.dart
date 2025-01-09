import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:terra_shifter/data/models/customer.dart';
import 'package:terra_shifter/core/usecases/app_localization.dart';
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
  bool isAddingCustomer = false;

  @override
  void initState() {
    super.initState();
    context.read<CustomerBloc>().add(GetAllCustomersEvent());
  }

  void _populateCustomerDetails(Customer customer) {
    setState(() {
      customerdata = customer;
      nameController.text = customer.name;
      addressController.text = customer.address;
      contactController.text = customer.contactNumber;
    });
  }

  void _toggleForm() {
    setState(() {
      isAddingCustomer = !isAddingCustomer;
      if (!isAddingCustomer) {
        _clearForm();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            if (isAddingCustomer) _buildCustomerForm(theme, localizations),
            const SizedBox(height: 10),
            Expanded(
              child: BlocConsumer<CustomerBloc, CustomerState>(
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
                    _toggleForm();
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

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: state.customers.length,
                      itemBuilder: (context, index) {
                        final customer = state.customers[index];
                        return _buildCustomerCard(customer, localizations);
                      },
                    );
                  }
                  return Center(child: Text(localizations?.translate('no_data_available') ?? "No data available"));
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleForm, 
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: theme.primaryColor,
      ),
    );
  }

  Widget _buildCustomerForm(ThemeData theme, AppLocalizations? localizations) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              localizations?.translate('customer_details') ?? 'Customer Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: localizations?.translate('customer_name') ?? "Customer Name",
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
                labelText: localizations?.translate('customer_address') ?? "Customer Address",
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
                labelText: localizations?.translate('contact_number') ?? "Contact Number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(localizations?.translate('add') ?? 'Add', Icons.add, () {
                        final customer = Customer(
                          id: idController.text.toString(),
                          name: nameController.text,
                          address: addressController.text,
                          contactNumber: contactController.text,
                        );
                        context.read<CustomerBloc>().add(AddCustomerEvent(customer));
                        _clearForm();
                      }),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildActionButton(localizations?.translate('refresh') ?? 'Refresh', Icons.refresh, () {
                        _clearForm();
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildActionButton(localizations?.translate('update') ?? 'Update', Icons.update, () {
                  final customer = Customer(
                    id: customerdata?.id ?? idController.text,
                    name: nameController.text,
                    address: addressController.text,
                    contactNumber: contactController.text,
                  );
                  context.read<CustomerBloc>().add(UpdateCustomerEvent(customer));
                  _clearForm();
                }, isEnabled: nameController.text.isNotEmpty && addressController.text.isNotEmpty && contactController.text.isNotEmpty),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onPressed, {bool isEnabled = true}) {
    return ElevatedButton.icon(
      onPressed: isEnabled ? onPressed : null,
      icon: Icon(icon),
      label: Text(label, style: TextStyle(fontSize: 16, color: Colors.white)),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildCustomerCard(Customer customer, AppLocalizations? localizations) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Theme.of(context).cardColor,
      child: InkWell(
        onTap: () => _populateCustomerDetails(customer),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Theme.of(context).primaryColor,
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.name,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.black54,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            customer.address,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.black54,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.phone,
                          color: Colors.blueAccent,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          customer.contactNumber,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 18,
              ),
            ],
          ),
        ),
      ),
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