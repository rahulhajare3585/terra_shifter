import 'package:flutter/material.dart';

class CustomerDetailsPage extends StatefulWidget {
  @override
  _CustomerDetailsPage createState() => _CustomerDetailsPage();

}

class _CustomerDetailsPage extends State<CustomerDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Details'),
      ),
      body: Center(
        child: Text('Customer Details Page'),
      ),
    );
  }
}