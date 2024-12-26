import 'package:flutter/material.dart';
import 'package:terra_shifter/data/models/customer.dart';

class CustomerListWidget extends StatelessWidget {
  final List<Customer> customers;

  const CustomerListWidget({Key? key, required this.customers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: customers.length,
      itemBuilder: (context, index) {
        final customer = customers[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              title: Text(
                customer.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4.0),
                  Text(customer.address),
                  const SizedBox(height: 4.0),
                  Text(
                    'Contact: ${customer.contactNumber}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).primaryColor,
                size: 20.0,
              ),
            ),
          ),
        );
      },
    );
  }
}
