import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:terra_shifter/core/usecases/app_localization.dart';
import 'package:terra_shifter/presentation/pages/screens/jcb/Invoice/bloc/jcb_invoice_bloc.dart';
import 'package:terra_shifter/presentation/pages/screens/jcb/Invoice/bloc/jcb_invoice_event.dart';
import 'package:terra_shifter/presentation/pages/screens/jcb/Invoice/bloc/jcb_invoice_state.dart';
import 'package:terra_shifter/presentation/pages/screens/jcb/Invoice/service/jcb_invoice_page_service.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;

class JCBInvoicePage extends StatefulWidget {
  const JCBInvoicePage({Key? key, required this.customerId}) : super(key: key);
  final String customerId;

  @override
  _JCBInvoicePageState createState() => _JCBInvoicePageState();
}

class _JCBInvoicePageState extends State<JCBInvoicePage> {
  late JCBInvoiceBloc _bloc;
  DateTime? _startDate;
  DateTime? _endDate;
  final List<String> _selectedWorks = [];

  @override
  void initState() {
    super.initState();
    _bloc = JCBInvoiceBloc(JcbInvoicePageService());
    _bloc.add(LoadJCBInvoice(widget.customerId));
  }

  void _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null &&
        picked !=
            DateTimeRange(
                start: _startDate ?? DateTime.now(),
                end: _endDate ?? DateTime.now())) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _bloc.add(FilterJCBInvoiceByDate(picked.start, picked.end));
    }
  }

  Future<void> _generateInvoice() async {
    try {
      final pdf = await _generatePdf();
      if (pdf != null) {
        await Printing.layoutPdf(
            onLayout: (PdfPageFormat format) async => pdf.save());
      }
    } catch (e) {
      print('Error generating invoice: $e');
    }
  }

  Future<pw.Document?> _generatePdf() async {
    final pdf = pw.Document();

    // Load the background image
    final ByteData bytes =
        await rootBundle.load('assets/images/invoice_first_bg.png');
    final Uint8List backgroundImage = bytes.buffer.asUint8List();

    // Fetch customer details
    final customer =
        await JcbInvoicePageService().getCustomerById(widget.customerId);
    if (customer == null) {
      throw Exception('Customer not found');
    }

    // Fetch selected works
    final selectedWorks = _bloc.state is JCBInvoiceLoaded
        ? (_bloc.state as JCBInvoiceLoaded)
            .jcbWork
            .where((work) => _selectedWorks.contains(work.id))
            .toList()
        : [];

    if (selectedWorks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                AppLocalizations.of(context)?.translate('please_select_work') ??
                    'Please select the work first')),
      );
      return null;
    }

    // Define some mock data
    const companyTitle = "VIGHNAHARTA EARTHMOVERS";
    const companyAddress =
        "Pichadgaon, Tel: Newasa Dist: Ahmednagar, Maharashtra, India";
    const companyContact = "+91 8177826981";

    final customerName = customer.name;
    final customerAddress = customer.address;
    final customerContact = customer.contactNumber;
    final billDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

    final invoiceDetails = selectedWorks.map((work) {
      return {
        "workName": work.WorkName,
        "workDate":
            DateFormat('dd-MM-yyyy').format(DateTime.parse(work.WorkDate)),
        "hours": "${work.WorkHours}",
        "amount": work.WorkAmount,
        "totalAmount": work.totalWorkAmount,
        "receivedAmount": work.receivedAmount,
      };
    }).toList();

    final totalAmount = selectedWorks.fold(
        0.0, (sum, work) => sum + double.parse(work.totalWorkAmount));
    final receivedAmount = selectedWorks.fold(
        0.0, (sum, work) => sum + double.parse(work.receivedAmount));
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
                      pw.Row(children: [
                        pw.Text("Aakash Hajare: ",
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text("$companyContact"),
                      ]),
                      pw.Row(children: [
                        pw.Text("Kishor Hajare: ",
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text("+91 9767745631"),
                      ])
                    ],
                  ),
                  pw.Divider(),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
                        pw.Text("Date: $billDate",
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 14)),
                      ]),
                  pw.SizedBox(height: 30),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Row(children: [
                        pw.Text("Customer Name: ",
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text("$customerName"),
                      ]),
                      pw.Row(children: [
                        pw.Text("Contact Number: ",
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text("$customerContact"),
                      ])
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Row(children: [
                        pw.Text("Address: ",
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text("$customerAddress"),
                      ]),
                    ],
                  ),

                  pw.Divider(),
                  pw.SizedBox(height: 20),
                  // Invoice Details
                  pw.Center(
                    child: pw.Text("Bill Details",
                        style: pw.TextStyle(
                            fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text("Work",
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Expanded(
                        flex: 1,
                        child: pw.Text("Date",
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.SizedBox(width: 10),
                      pw.Expanded(
                        flex: 1,
                        child: pw.Text("Hours",
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Expanded(
                        flex: 1,
                        child: pw.Text("Amount",
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Expanded(
                        flex: 1,
                        child: pw.Text("Total",
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Expanded(
                        flex: 1,
                        child: pw.Text("Received",
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
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
                            pw.Expanded(
                              flex: 2,
                              child: pw.Text(detail['workName'] as String),
                            ),
                            pw.Expanded(
                              flex: 1,
                              child: pw.Text(detail['workDate'] as String),
                            ),
                            pw.SizedBox(width: 10),
                            pw.Expanded(
                              flex: 1,
                              child: pw.Text(detail['hours'] as String),
                            ),
                            pw.Expanded(
                              flex: 1,
                              child: pw.Text(detail['amount'] as String),
                            ),
                            pw.Expanded(
                              flex: 1,
                              child: pw.Text("${detail['totalAmount']}"),
                            ),
                            pw.Expanded(
                              flex: 1,
                              child: pw.Text("${detail['receivedAmount']}"),
                            ),
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
                              pw.Text('Total Amount: $totalAmount',
                                  style: pw.TextStyle(
                                      fontSize: 14,
                                      fontWeight: pw.FontWeight.bold)),
                              pw.Text('Paid Amount: $receivedAmount',
                                  style: pw.TextStyle(
                                      fontSize: 14,
                                      fontWeight: pw.FontWeight.bold)),
                              pw.Text('Pending Amount: $pendingAmount',
                                  style: pw.TextStyle(
                                      fontSize: 14,
                                      fontWeight: pw.FontWeight.bold)),
                            ])
                      ]),

                  pw.SizedBox(height: 20),
                  pw.Text(
                      'Thank you for using our services. We look forward to staying connected with you.',
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
                            style: const pw.TextStyle(fontSize: 14)),
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
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        title: BlocBuilder<JCBInvoiceBloc, JCBInvoiceState>(
          bloc: _bloc,
          builder: (context, state) {
            if (state is JCBInvoiceLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person, size: 22),
                      SizedBox(width: 5),
                      Text(
                        state.customer.name,
                        style: const TextStyle(fontSize: 22),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16),
                      SizedBox(width: 5),
                      Text(
                        state.customer.address,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Icon(Icons.phone, size: 16),
                      SizedBox(width: 5),
                      Text(
                        state.customer.contactNumber,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              );
            }
            return Text(localizations?.translate('invoice_page_title') ??
                'JCB Invoice');
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.date_range),
            onPressed: _selectDateRange,
          ),
        ],
      ),
      body: BlocBuilder<JCBInvoiceBloc, JCBInvoiceState>(
        bloc: _bloc,
        builder: (context, state) {
          if (state is JCBInvoiceLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is JCBInvoiceLoaded) {
            return ListView.builder(
              itemCount: state.jcbWork.length,
              itemBuilder: (context, index) {
                final work = state.jcbWork[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: ListTile(
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Checkbox(
                                  value: _selectedWorks.contains(work.id),
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value == true) {
                                        _selectedWorks.add(work.id);
                                      } else {
                                        _selectedWorks.remove(work.id);
                                      }
                                    });
                                  },
                                ),
                                Text(
                                  '${work.WorkDate.substring(0, 10)}',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '${work.WorkName}',
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Divider(),
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Hours :',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: '${work.WorkHours}',
                              ),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Amount : ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: '${work.WorkAmount}',
                              ),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    '${localizations?.translate('total_amount') ?? 'Total Amount'} : ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: '${work.totalWorkAmount}',
                              ),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    '${localizations?.translate('received_amount') ?? 'Received Amount'} : ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: '${work.receivedAmount}',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is JCBInvoiceError) {
            return Center(child: Text(state.message));
          } else {
            return Center(
                child: Text(
                    localizations?.translate('no_tractor_works_found') ??
                        'No tractor works found for this customer.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _generateInvoice,
        child: const Icon(Icons.picture_as_pdf),
      ),
    );
  }
}
