import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:terra_shifter/data/models/customer.dart';
import 'package:terra_shifter/core/usecases/app_localization.dart';
import 'package:terra_shifter/presentation/pages/screens/plates/bloc/plates_bloc.dart';
import 'package:terra_shifter/presentation/pages/screens/plates/bloc/plates_event.dart';
import 'package:terra_shifter/presentation/pages/screens/plates/bloc/plates_state.dart';
import 'package:terra_shifter/presentation/pages/screens/plates/model/plates.dart';
import 'package:terra_shifter/presentation/pages/screens/plates/service/plates_service.dart';

class PlatesDetailsScreen extends StatefulWidget {
  @override
  _PlatesDetailsScreenState createState() => _PlatesDetailsScreenState();
}

class _PlatesDetailsScreenState extends State<PlatesDetailsScreen> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController givenPlatesController = TextEditingController();
  final TextEditingController amountPer100PlatesController = TextEditingController();
  final TextEditingController givenDateController = TextEditingController();
  final TextEditingController receivedPlatesController = TextEditingController();
  final TextEditingController receivedDateController = TextEditingController();

  PlatesModel? platesData;
  bool isAddingPlates = false;
  List<Customer> customers = [];
  Customer? selectedCustomer;

  @override
  void initState() {
    super.initState();
    context.read<PlatesBloc>().add(GetAllPlatesEvent());
    _loadCustomers();
  }

  void _loadCustomers() async {
    final platesService = PlatesService();
    customers = await platesService.getAllCustomers();
    setState(() {});
  }

  void _populatePlatesDetails(PlatesModel plates) {
    final customer = customers.firstWhere((customer) => customer.id == plates.customerId.toString(), orElse: () => Customer(id: '', name: 'Unknown', address: 'Unknown', contactNumber: 'Unknown'));
    setState(() {
      platesData = plates;
      idController.text = plates.id.toString();
      customerNameController.text = customer.name;
      selectedCustomer = customer;
      givenPlatesController.text = plates.givenPlates.toString();
      amountPer100PlatesController.text = plates.amountPer100Plates;
      givenDateController.text = plates.givenDate;
      receivedPlatesController.text = plates.receivedPlates?.toString() ?? '';
      receivedDateController.text = plates.receivedDate ?? '';
    });
    _toggleForm();
  }

  void _toggleForm() {
    setState(() {
      isAddingPlates = !isAddingPlates;
      if (!isAddingPlates) {
        _clearForm();
      }
    });
  }

  void _showCustomerSelectionSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      builder: (BuildContext context) {
        return CustomerSelectionSheet(
          customers: customers,
          onCustomerSelected: (customer) {
            setState(() {
              customerNameController.text = customer.name;
              selectedCustomer = customer;
            });
            Navigator.pop(context);
          },
        );
      },
    );
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Plates Details'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                const SizedBox(height: 10),
                Expanded(
                  child: BlocConsumer<PlatesBloc, PlatesState>(
                    listener: (context, state) {
                      if (state is PlatesOperationSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        context.read<PlatesBloc>().add(GetAllPlatesEvent());
                      } else if (state is PlatesError) {
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
                      if (state is PlatesLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is PlatesLoaded) {
                        final nextId = state.plates.isNotEmpty
                            ? (state.plates.map((c) {
                                try {
                                  return int.parse(c.id.toString());
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
                          itemCount: state.plates.length,
                          itemBuilder: (context, index) {
                            final plates = state.plates[index];
                            return _buildPlatesCard(plates, localizations);
                          },
                        );
                      }
                      return Center(child: Text("No data available"));
                    },
                  ),
                ),
              ],
            ),
          ),
          if (isAddingPlates)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16.0),
                child: _buildPlatesForm(theme, localizations),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleForm,
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: theme.primaryColor,
      ),
    );
  }

  Widget _buildPlatesForm(ThemeData theme, AppLocalizations? localizations) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Plates Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _showCustomerSelectionSheet,
              child: AbsorbPointer(
                child: TextFormField(
                  controller: customerNameController,
                  decoration: InputDecoration(
                    labelText: "Customer Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.person),
                    suffixIcon: const Icon(Icons.arrow_drop_down),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: givenPlatesController,
              decoration: InputDecoration(
                labelText: "Given Plates",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.place),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: amountPer100PlatesController,
              decoration: InputDecoration(
                labelText: "Amount Per 100 Plates",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.attach_money),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _selectDate(context, givenDateController),
              child: AbsorbPointer(
                child: TextFormField(
                  controller: givenDateController,
                  decoration: InputDecoration(
                    labelText: "Given Date",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.date_range),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: receivedPlatesController,
              decoration: InputDecoration(
                labelText: "Received Plates",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.place),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _selectDate(context, receivedDateController),
              child: AbsorbPointer(
                child: TextFormField(
                  controller: receivedDateController,
                  decoration: InputDecoration(
                    labelText: "Received Date",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.date_range),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(localizations?.translate('add') ?? 'Add', Icons.add, () {
                        final plates = PlatesModel(
                          id: int.parse(idController.text),
                          customerId: int.parse(selectedCustomer!.id),
                          givenPlates: int.parse(givenPlatesController.text),
                          amountPer100Plates: amountPer100PlatesController.text,
                          givenDate: givenDateController.text,
                          receivedPlates: int.tryParse(receivedPlatesController.text),
                          receivedDate: receivedDateController.text,
                        );
                        context.read<PlatesBloc>().add(AddPlatesEvent(plates));
                        _clearForm();
                      }, isEnabled: platesData == null),
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
                  final plates = PlatesModel(
                    id: platesData?.id ?? int.parse(idController.text),
                    customerId: int.parse(selectedCustomer!.id),
                    givenPlates: int.parse(givenPlatesController.text),
                    amountPer100Plates: amountPer100PlatesController.text,
                    givenDate: givenDateController.text,
                    receivedPlates: int.tryParse(receivedPlatesController.text),
                    receivedDate: receivedDateController.text,
                  );
                  context.read<PlatesBloc>().add(UpdatePlatesEvent(plates));
                  _clearForm();
                }, isEnabled: platesData != null && givenPlatesController.text.isNotEmpty && amountPer100PlatesController.text.isNotEmpty && givenDateController.text.isNotEmpty),
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

  Widget _buildPlatesCard(PlatesModel plates, AppLocalizations? localizations) {
    final customer = customers.firstWhere((customer) => customer.id == plates.customerId.toString(), orElse: () => Customer(id: '', name: 'Unknown', address: 'Unknown', contactNumber: 'Unknown'));
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Theme.of(context).cardColor,
      child: InkWell(
        onTap: () => _populatePlatesDetails(plates),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Theme.of(context).primaryColor,
                child: const Icon(
                  Icons.place,
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
                      plates.givenPlates.toString(),
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
                          Icons.person,
                          color: Colors.black54,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            customer.name,
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
            ],
          ),
        ),
      ),
    );
  }

  void _clearForm() {
    setState(() {
      idController.clear();
      customerNameController.clear();
      givenPlatesController.clear();
      amountPer100PlatesController.clear();
      givenDateController.clear();
      receivedPlatesController.clear();
      receivedDateController.clear();
      selectedCustomer = null;
      platesData = null;
      final platesId = int.tryParse(idController.text) ?? 0;
      idController.text = (platesId + 1).toString();
    });
  }
}

class CustomerSelectionSheet extends StatefulWidget {
  final List<Customer> customers;
  final Function(Customer) onCustomerSelected;

  CustomerSelectionSheet({required this.customers, required this.onCustomerSelected});

  @override
  _CustomerSelectionSheetState createState() => _CustomerSelectionSheetState();
}

class _CustomerSelectionSheetState extends State<CustomerSelectionSheet> {
  TextEditingController searchController = TextEditingController();
  List<Customer> filteredCustomers = [];

  @override
  void initState() {
    super.initState();
    filteredCustomers = widget.customers;
    searchController.addListener(_filterCustomers);
  }

  void _filterCustomers() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredCustomers = widget.customers.where((customer) {
        return customer.name.toLowerCase().contains(query) ||
            customer.contactNumber.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    searchController.removeListener(_filterCustomers);
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Select Customer',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: 'Search',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: filteredCustomers.length,
              itemBuilder: (context, index) {
                final customer = filteredCustomers[index];
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