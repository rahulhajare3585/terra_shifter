import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:terra_shifter/data/Services/plates_manage_service.dart';
import 'package:terra_shifter/data/Services/plates_service.dart';
import 'package:terra_shifter/presentation/blocs/plates/plates_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:terra_shifter/presentation/blocs/plates_details/plate_details_bloc.dart';
import 'package:terra_shifter/presentation/blocs/plates_details/plate_details_event.dart';
import 'package:terra_shifter/presentation/blocs/plates_details/plate_details_state.dart';
import 'package:terra_shifter/presentation/blocs/plates_manage/plates_manage_bloc.dart';
import 'package:terra_shifter/presentation/pages/screens/plates/Manager/plates_manage_page.dart';
import 'package:terra_shifter/presentation/pages/screens/plates/plates_page.dart';
import 'package:terra_shifter/presentation/pages/screens/invoice/invoice_page.dart';

class PlatesDetailsPage extends StatefulWidget {
  @override
  _PlatesDetailsPage createState() => _PlatesDetailsPage();
}

class _PlatesDetailsPage extends State<PlatesDetailsPage> {
  @override
  void initState() {
    super.initState();
    // Fetch all plates on page load
    context.read<PlateDetailsBloc>().add(GetAllPlatesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plates Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.manage_history),
            tooltip: 'Manage Details', // Tooltip when hovered or long-pressed
            onPressed: () {
              // Navigate to manage details page or perform desired action
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => PlatesManageBloc(PlatesManageService()),
                    child: PlatesManagePage(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<PlateDetailsBloc, PlateDetailsState>(
        builder: (context, state) {
          if (state is PlatesLoading) {
            return Center(
              child: SizedBox(
                height: 100,
                width: 100,
                child: Lottie.asset(
                  'assets/lottie/loader.json',
                  decoder: LottieComposition.decodeGZip,
                ),
              ),
            );
          } else if (state is PlatesLoaded) {
            final plates = state.plates;
            final theme = Theme.of(context);
            if (plates.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 0,
                  children: [
                    Lottie.asset(
                  'assets/lottie/no_data.json',
                  decoder: LottieComposition.decodeGZip,
                ),
                    Text('No data found.' , style: TextStyle(fontSize: 20,color: theme.primaryColor),),
                  ],
                )
              );
            }
            return ListView.builder(
              itemCount: plates.length + 1, // Add one for the extra space
              itemBuilder: (context, index) {
                if (index == plates.length) {
                  return SizedBox(height: 80); // Extra space at the bottom
                }
                final plate = plates[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Customer Name and Contact in a single row
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  plate.customerName ?? '',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: theme.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            // Contact Number
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.phone,
                                    color: theme.primaryColor, size: 16.0),
                                const Text(
                                  ': ',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  plate.contactNumber ?? '',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: theme.primaryColor,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Divider(),
                        SizedBox(height: 8.0),
                        _buildInfoRow(
                          context,
                          label: 'Given Date',
                          value: plate.givenDate
                                  ?.toLocal()
                                  .toString()
                                  .split(' ')[0] ??
                              '',
                          icon: Icons.date_range,
                        ),
                        _buildInfoRow(
                          context,
                          label: 'Received Date',
                          value: plate.receivedDate
                                  ?.toLocal()
                                  .toString()
                                  .split(' ')[0] ??
                              '',
                          icon: Icons.calendar_today,
                        ),
                        _buildInfoRow(
                          context,
                          label: 'Total Days',
                          value: '${plate.totalDays ?? 0}',
                          icon: Icons.timelapse,
                        ),
                        _buildInfoRow(
                          context,
                          label: 'Quantity',
                          value: '${plate.quantity ?? 0}',
                          icon: Icons.format_list_numbered,
                        ),
                        _buildInfoRow(
                          context,
                          label: 'Amount Per Month',
                          value:
                              '\₹ ${plate.amountPerMonth?.toStringAsFixed(2) ?? '0.00'}',
                          icon: Icons.attach_money,
                        ),
                        _buildInfoRow(
                          context,
                          label: 'Total Amount',
                          value:
                              '\₹ ${plate.totalAmount?.toStringAsFixed(2) ?? '0.00'}',
                          icon: Icons.account_balance_wallet,
                        ),
                        _buildInfoRow(
                          context,
                          label: 'Received Amount',
                          value:
                              '\₹ ${plate.receivedAmount?.toStringAsFixed(2) ?? '0.00'}',
                          icon: Icons.done_all,
                        ),
                        _buildInfoRow(
                          context,
                          label: 'Pending Amount',
                          value:
                              '\₹ ${plate.pendingAmount?.toStringAsFixed(2) ?? '0.00'}',
                          icon: Icons.warning,
                        ),
                        // Edit and Bill Icons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: theme.primaryColor),
                              onPressed: () {
                                // Handle edit action
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.receipt,
                                  color: theme.primaryColor),
                              onPressed: () {
                                // Navigate to InvoicePage
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => InvoicePage(
                                        customerID: plate.customerId),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is PlatesError) {
            return Center(
              child: Text(state.error),
            );
          }
          return const Center(
            child: Text('Unknown state.'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => PlatesBloc(PlatesService()),
                child: PlatesPage(),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context,
      {required String label, required String value, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20.0, color: Theme.of(context).primaryColor),
          const SizedBox(width: 8.0),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
