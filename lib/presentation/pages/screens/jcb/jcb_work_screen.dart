import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:terra_shifter/data/models/jcb_work.dart';
import 'package:terra_shifter/data/models/customer.dart';
import 'package:terra_shifter/presentation/pages/screens/jcb/Invoice/bloc/jcb_invoice_bloc.dart';
import 'package:terra_shifter/presentation/pages/screens/jcb/Invoice/jcb_invoice_page.dart';
import 'package:terra_shifter/presentation/pages/screens/jcb/Invoice/service/jcb_invoice_page_service.dart';
import 'package:terra_shifter/presentation/pages/screens/jcb/bloc/jcb_work_bloc.dart';
import 'package:terra_shifter/presentation/pages/screens/jcb/bloc/jcb_work_event.dart';
import 'package:terra_shifter/presentation/pages/screens/jcb/bloc/jcb_work_state.dart';
import 'package:terra_shifter/presentation/pages/tractors/tractors_work_page.dart';

class JcbWorkScreen extends StatefulWidget {
  @override
  _JcbWorkScreenState createState() => _JcbWorkScreenState();
}

class _JcbWorkScreenState extends State<JcbWorkScreen> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController workNameController = TextEditingController();
  final TextEditingController workDescriptionController =
      TextEditingController();
  final TextEditingController lastUnitController = TextEditingController();
  final TextEditingController currentUnitController = TextEditingController();
  final TextEditingController workHoursController = TextEditingController();
  final TextEditingController workAmountController = TextEditingController();
  final TextEditingController totalWorkAmountController =
      TextEditingController();
  final TextEditingController receivedAmountController =
      TextEditingController();

  String? selectedCustomerName;
  String? selectedCustomerId;
  String? selectedCustomerAddress;
  JcbWork? jcbWorkData;
  bool isAddingJcbWork = false;
  List<Customer> customers = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }
  

  void _loadInitialData() {
    context.read<JcbWorkBloc>().add(GetAllJcbWorksEvent());
    context.read<JcbWorkBloc>().add(GetAllCustomersEvent());
  }

  void _populateJcbWorkDetails(JcbWork jcbWork) {
    final customer =
        customers.firstWhere((customer) => customer.id == jcbWork.customerId);
    setState(() {
      jcbWorkData = jcbWork;
      workNameController.text = jcbWork.WorkName;
      workDescriptionController.text = jcbWork.WorkDescription ?? '';
      lastUnitController.text = jcbWork.LastUnit;
      currentUnitController.text = jcbWork.CurrentUnit;
      workHoursController.text = jcbWork.WorkHours;
      workAmountController.text = jcbWork.WorkAmount;
      totalWorkAmountController.text = jcbWork.totalWorkAmount;
      receivedAmountController.text = jcbWork.receivedAmount;
      selectedCustomerId = jcbWork.customerId;
      selectedCustomerName = customer.name;
      selectedCustomerAddress = customer.address;
    });
    _toggleForm();
  }

  void _toggleForm() {
    setState(() {
      isAddingJcbWork = !isAddingJcbWork;
      _initializeLastUnit();
      if (!isAddingJcbWork) {
        _clearForm();
      }
    });
  }

  void _initializeLastUnit() {
    final blocState = context.read<JcbWorkBloc>().state;
    if (blocState is JcbWorkLoaded && blocState.jcbWorks.isNotEmpty) {
      final lastWork = blocState.jcbWorks.last;
      lastUnitController.text = lastWork.CurrentUnit;
    } else {
      lastUnitController.text = '0';
    }
  }

  void _showCustomerSelectionSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return CustomerSelectionSheet(
          customers: customers,
          onCustomerSelected: (customer) {
            setState(() {
              selectedCustomerName = customer.name;
              selectedCustomerId = customer.id;
              selectedCustomerAddress = customer.address;
            });
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('JCB Work'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              //add search filter as per customer name and contact number

            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                if (selectedCustomerName != null &&
                    selectedCustomerAddress != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Customer Name: $selectedCustomerName',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text('Customer ID: $selectedCustomerId',
                            style: TextStyle(fontSize: 16)),
                        Text('Customer Address: $selectedCustomerAddress',
                            style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                Expanded(
                  child: BlocConsumer<JcbWorkBloc, JcbWorkState>(
                    listener: (context, state) {
                      if (state is JcbWorkOperationSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        _loadInitialData();
                      } else if (state is JcbWorkError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.error),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        _toggleForm();
                      } else if (state is CustomerLoaded) {
                        setState(() {
                          customers = state.customers;
                        });
                      }
                    },
                    builder: (context, state) {
                      if (state is JcbWorkLoading || state is CustomerLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is JcbWorkLoaded) {
                        final nextId = state.jcbWorks.isNotEmpty
                            ? (state.jcbWorks.map((c) {
                                      try {
                                        return int.parse(c.id);
                                      } catch (e) {
                                        return 0;
                                      }
                                    }).reduce((a, b) => a > b ? a : b) +
                                    1)
                                .toString()
                            : '1';
                        idController.text = nextId;

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: state.jcbWorks.length,
                          itemBuilder: (context, index) {
                            final sortedJcbWorks =
                                List<JcbWork>.from(state.jcbWorks)
                                  ..sort((a, b) => DateTime.parse(b.WorkDate)
                                      .compareTo(DateTime.parse(a.WorkDate)));
                            final jcbWork = sortedJcbWorks[index];
                            return _buildJcbWorkCard(jcbWork);
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
          if (isAddingJcbWork)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: _buildJcbWorkForm(theme),
                ),
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

  Widget _buildJcbWorkForm(ThemeData theme) {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'JCB Work Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _showCustomerSelectionSheet,
                  child: AbsorbPointer(
                    child: DropdownButtonFormField<String>(
                      value: selectedCustomerName,
                      decoration: const InputDecoration(
                        labelText: 'Select Customer Name',
                      ),
                      items: customers.map((customer) {
                        return DropdownMenuItem<String>(
                          value: customer.name,
                          child: Text(customer.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCustomerName = value;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: workNameController,
                  decoration: InputDecoration(
                    labelText: "Work Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.work),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: workDescriptionController,
                  decoration: InputDecoration(
                    labelText: "Work Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.description),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: lastUnitController,
                  decoration: InputDecoration(
                    labelText: "Last Unit",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.speed),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  onChanged: (value) => setState(() {
                    final lastUnit =
                        double.tryParse(lastUnitController.text) ?? 0;
                    final currentUnit =
                        double.tryParse(currentUnitController.text) ?? 0;
                    //total work hour should be current unit - last unit =6 then 1 hour work
                    final totalWorkHour = (currentUnit - lastUnit) / 6;
                    workHoursController.text = totalWorkHour.toStringAsFixed(2);
                  }),
                  controller: currentUnitController,
                  decoration: InputDecoration(
                    labelText: "Current Unit",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.speed),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: workHoursController,
                  decoration: InputDecoration(
                    labelText: "Work Hours",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.timer),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  onChanged: (value) => setState(() {
                    final workHours =
                        double.tryParse(workHoursController.text) ?? 0;
                    final workAmount =
                        double.tryParse(workAmountController.text) ?? 0;
                    final totalWorkAmount = workAmount * workHours;
                    totalWorkAmountController.text =
                        totalWorkAmount.toStringAsFixed(2);
                  }),
                  controller: workAmountController,
                  decoration: InputDecoration(
                    labelText: "Work Amount",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.attach_money),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: totalWorkAmountController,
                  decoration: InputDecoration(
                    labelText: "Total Work Amount",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.attach_money),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: receivedAmountController,
                  decoration: InputDecoration(
                    labelText: "Received Amount",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.attach_money),
                  ),
                ),
                const SizedBox(height: 24),
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionButton('Add', Icons.add, () {
                            final jcbWork = JcbWork(
                              id: idController.text.toString(),
                              customerId: selectedCustomerId ??
                                  '1', // Replace with actual customer ID
                              WorkDate: DateTime.now().toString(),
                              WorkName: workNameController.text,
                              WorkDescription: workDescriptionController.text,
                              LastUnit: lastUnitController.text,
                              CurrentUnit: currentUnitController.text,
                              WorkHours: workHoursController.text,
                              WorkAmount: workAmountController.text,
                              totalWorkAmount: totalWorkAmountController.text,
                              receivedAmount: receivedAmountController.text,
                            );
                            context
                                .read<JcbWorkBloc>()
                                .add(AddJcbWorkEvent(jcbWork));
                            _clearForm();
                          }),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child:
                              _buildActionButton('Refresh', Icons.refresh, () {
                            _clearForm();
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildActionButton('Update', Icons.update, () {
                      final jcbWork = JcbWork(
                        id: jcbWorkData?.id ?? idController.text,
                        customerId: selectedCustomerId ??
                            '1', // Replace with actual customer ID
                        WorkDate: DateTime.now().toString(),
                        WorkName: workNameController.text,
                        WorkDescription: workDescriptionController.text,
                        LastUnit: lastUnitController.text,
                        CurrentUnit: currentUnitController.text,
                        WorkHours: workHoursController.text,
                        WorkAmount: workAmountController.text,
                        totalWorkAmount: totalWorkAmountController.text,
                        receivedAmount: receivedAmountController.text,
                      );
                      context
                          .read<JcbWorkBloc>()
                          .add(UpdateJcbWorkEvent(jcbWork));
                      _clearForm();
                    },
                        isEnabled: workNameController.text.isNotEmpty &&
                            lastUnitController.text.isNotEmpty &&
                            currentUnitController.text.isNotEmpty),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onPressed,
      {bool isEnabled = true}) {
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

  Widget _buildJcbWorkCard(JcbWork jcbWork) {
    final customer = customers.firstWhere(
        (customer) => customer.id == jcbWork.customerId,
        orElse: () => Customer(
            id: '',
            name: 'Unknown',
            address: 'Unknown',
            contactNumber: 'Unknown'));
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Theme.of(context).cardColor,
      child: InkWell(
        onTap: () => _populateJcbWorkDetails(jcbWork),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Theme.of(context).primaryColor,
                child: const Icon(
                  Icons.work,
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
                      jcbWork.WorkName,
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
                          Icons.description,
                          color: Colors.black54,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            jcbWork.WorkDescription ?? '',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
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
                          Icons.timer,
                          color: Colors.blueAccent,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          jcbWork.WorkHours,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
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
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
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
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
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
                          color: Colors.black54,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            customer.contactNumber,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.black54,
                                    ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      children: [
                        const Text('Rs :',style: TextStyle(color: Colors.green),),
                        const SizedBox(width: 8),
                        Text(
                          jcbWork.totalWorkAmount,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),

                        // widget at the end of row
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.receipt),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => JCBInvoiceBloc(JcbInvoicePageService()),
                                  child: JCBInvoicePage(customerId: jcbWork.customerId,),
                                ),
                              ),
                            );
                          },
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
      workNameController.clear();
      workDescriptionController.clear();
      currentUnitController.clear();
      workHoursController.clear();
      workAmountController.clear();
      totalWorkAmountController.clear();
      receivedAmountController.clear();
      selectedCustomerName = null;
      selectedCustomerId = null;
      selectedCustomerAddress = null;
      final jcbWorkId = int.tryParse(idController.text) ?? 0;
      idController.text = (jcbWorkId + 1).toString();
    });
  }
}
