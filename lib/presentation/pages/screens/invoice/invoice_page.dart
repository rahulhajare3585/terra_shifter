import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:terra_shifter/data/Services/customer_service.dart';
import 'package:terra_shifter/data/Services/plates_service.dart';
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;

class InvoicePage extends StatefulWidget {
  //create constructor
  const InvoicePage({Key? key, required this.customerID}) : super(key: key);
  final String customerID;
  @override
  _InvoicePage createState() => _InvoicePage(customerID);
}

class _InvoicePage extends State<InvoicePage> {
  final String customerID;
  _InvoicePage(this.customerID);

  final CustomerService _customerService = CustomerService();
  final PlatesService _platesService = PlatesService();

  @override
  void initState() {
    super.initState();
    _showInvoice();
  }

  Future<void> _showInvoice() async {
    try {
      // Generate the PDF
      final pdf = await _generatePdf();

      // Show the PDF using `printing` package
      await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());

      // Pop twice from the navigation stack
      Navigator.of(context).pop();
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<pw.Document> _generatePdf() async {
    final pdf = pw.Document();

    // Load the background image
    final ByteData bytes = await rootBundle.load('assets/images/invoice_first_bg.png');
    final Uint8List backgroundImage = bytes.buffer.asUint8List();

    // Fetch customer and plates details
    final customer = await _customerService.getCustomer(customerID);
    final plates = await _platesService.getPlatesByCustomerId(customerID);

    if (customer == null) {
      throw Exception('Customer not found');
    }

    if (plates.isEmpty) {
      throw Exception('No plates found for the customer');
    }

    // Define some mock data
    const companyTitle = "SHRIGURU EARTHMOVERS & PLATES";
    const companyAddress =
        "Pichadgaon, Tel: Newasa Dist: Ahmednagar, Maharashtra, India";
    const companyContact = "+91 8177826981";

    final customerName = customer.name;
    final customerAddress = customer.address;
    final customerContact = customer.contactNumber;

    final invoiceDetails = plates.map((plate) {
      return {
        "givenDate": plate.givenDate.toLocal().toString().split(' ')[0],
        "receivedDate": plate.receivedDate.toLocal().toString().split(' ')[0],
        "totalDays": plate.totalDays,
        "amount": plate.totalAmount,
      };
    }).toList();

    final receivedAmount =
        plates.fold(0.0, (sum, plate) => sum + (plate.receivedAmount ?? 0.0));
    final totalAmount =
        plates.fold(0.0, (sum, plate) => sum + plate.totalAmount);
    final pendingAmount = totalAmount - receivedAmount;

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Stack(
            children: [
              // Background Image
              pw.Positioned.fill(
                child: pw.Opacity(
                  opacity: 0.3,
                  child: pw.Image(pw.MemoryImage(backgroundImage),
                      fit: pw.BoxFit.fitWidth),
                ),
              ),
              // Content
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Company Details
                  pw.Center(
                    child: pw.Text(companyTitle,
                        style: pw.TextStyle(
                            fontSize: 25,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.orange800)),
                  ),
                  pw.Center(
                      child: pw.Text(companyAddress,
                          style: const pw.TextStyle(
                              fontSize: 14, color: PdfColors.green600))),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Row(
                        children: [
                          pw.Text("Aakash Hajare: ",style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text("$companyContact"),
                        ]
                      ),
                      pw.Row(
                        children: [
                          pw.Text("Kishor Hajare: ",style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text("+91 9767745631"),
                        ]
                      )
                    ],
                  ),
                  pw.Divider(),

                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Row(
                        children: [
                          pw.Text("Customer Name: ",style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text("$customerName"),
                        ]
                      ),
                      pw.Row(
                        children: [
                          pw.Text("Contact Number: ",style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text("$customerContact"),
                        ]
                      )
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Row(
                        children: [
                          pw.Text("Address: ",style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text("$customerAddress"),
                        ]
                      ),
                    ],
                  ),
                  pw.SizedBox(height:50),

                  // Invoice Details
                  pw.Center(
                    child: pw.Text("Bill Details",
                        style: pw.TextStyle(
                            fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Divider(),
                  pw.SizedBox(height: 5),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text("Given Date",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text("Received Date",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text("Total Days",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text("Amount",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                  pw.SizedBox(height: 5),
                  ...invoiceDetails.map(
                    (detail) => pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(detail['givenDate'] as String),
                            pw.Text(detail['receivedDate'] as String),
                            pw.Text(detail['totalDays'].toString()),
                            pw.Text(" ${detail['amount']}"),
                          ],
                        ),
                        pw.SizedBox(height: 10),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 100),


                  // Spacer to push content to the bottom
                  pw.Spacer(),

                  // Summary Section
                  pw.Divider(),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children: [
                       pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Total Amount: $totalAmount',style: pw.TextStyle(fontSize: 14,fontWeight: pw.FontWeight.bold,)),
                      pw.SizedBox(height: 2),
                      pw.Text('Paid Amount: $receivedAmount',style: pw.TextStyle(fontSize: 14,fontWeight: pw.FontWeight.normal,)),
                      pw.SizedBox(height: 2),
                      pw.Text('Pending Amount: $pendingAmount',style: pw.TextStyle(fontSize: 14,fontWeight: pw.FontWeight.normal,)),
                    ]
                  ),
                    ]
                  ),

                 
                  
                  pw.SizedBox(height: 20),
                  pw.Text('Thank you for using our services. We look forward to staying connected with you.',
                      style: const pw.TextStyle(
                          fontSize: 14, color: PdfColors.blue)),
                  pw.SizedBox(height: 20),
                  pw.SizedBox(height: 20),

                  // Signature Area
                  pw.Align(
                    alignment: pw.Alignment.bottomRight,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text("Authorized Signature",
                            style:const pw.TextStyle(fontSize: 14)),
                        pw.SizedBox(height: 20)
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // Return an empty container as the PDF will be shown directly
  }
}