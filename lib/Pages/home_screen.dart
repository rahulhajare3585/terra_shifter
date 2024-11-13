import 'package:flutter/material.dart';
import '../../models/customer.dart';
import '../../services/customer_service.dart';

class HomeScreen extends StatelessWidget {
  final CustomerService customerService = CustomerService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Customer Management"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Example: Add a customer
                Customer customer = Customer(
                  id: "1", // Example id
                  name: "John Doe", // Example name
                  address: "123 Main Street", // Example address
                  contactNumber: "1234567890", // Example contact number
                );
                customerService.addCustomer(customer);
              },
              child: Text("Add Customer"),
            ),
            ElevatedButton(
              onPressed: () async {
                // Example: Get a customer
                Customer? customer =
                    await customerService.getCustomer("Ki4ZJH4Vix7VEa5HYE0E");
                if (customer != null) {
                  debugPrint("Customer Name: ${customer.name}");
                } else {
                  debugPrint("Customer not found");
                }
              },
              child: Text("Get Customer"),
            ),
            ElevatedButton(
              onPressed: () {
                // Example: Update a customer
                Customer customer = Customer(
                  id: "1", // Example id
                  name: "John Smith", // Updated name
                  address: "456 Another Street", // Updated address
                  contactNumber: "9876543210", // Updated contact number
                );
                customerService.updateCustomer(customer);
              },
              child: Text("Update Customer"),
            ),
            ElevatedButton(
              onPressed: () {
                // Example: Delete a customer
                customerService.deleteCustomer("1");
              },
              child: Text("Delete Customer"),
            ),
          ],
        ),
      ),
    );
  }
}
