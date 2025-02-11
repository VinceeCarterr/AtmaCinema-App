import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:tubes/entity/Film.dart';
import 'package:tubes/entity/User.dart';
import 'package:tubes/client/UserClient.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvoicePage extends StatefulWidget {
  final Film movie;
  final int ticketCount;
  final double ticketPrice;
  final double totalPrice;
  final String selectedTime;
  final String selectedCinemaFormat;
  final DateTime selectedDate;
  final String selectedMethod;
  final String token;

  const InvoicePage({
    Key? key,
    required this.movie,
    required this.ticketCount,
    required this.ticketPrice,
    required this.totalPrice,
    required this.selectedTime,
    required this.selectedCinemaFormat,
    required this.selectedDate,
    required this.selectedMethod,
    required this.token,
  }) : super(key: key);

  @override
  _InvoicePageState createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
        future: UserClient.getProfile(widget.token),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No user data available.'));
          } else {
            User user = snapshot.data!;

            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: Text(
                  "Preview",
                  style: TextStyle(color: Colors.black),
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: Icon(Icons.download, color: Colors.black),
                    onPressed: () async {
                      await _downloadInvoice(context);
                    },
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "ATMA Cinema",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Invoice",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "INV/2024/1001",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Buyer",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                "Name: ${user.first_name} ${user.last_name}",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                widget.selectedTime,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Divider(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            widget.movie.poster,
                            width: 100,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.movie.judul_film,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.access_time,
                                      size: 16, color: Colors.grey),
                                  SizedBox(width: 4),
                                  Text(
                                    widget.movie.durasi.toString() + " minutes",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  SizedBox(width: 16),
                                  Icon(Icons.theaters,
                                      size: 16, color: Colors.grey),
                                  SizedBox(width: 4),
                                  Text(
                                    widget.movie.dimensi,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Number of Seats",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        Text(
                          widget.ticketCount.toString(),
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Price",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        Text(
                          widget.totalPrice.toString(),
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Service Fee",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        Text(
                          "Rp0",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Admin Fee",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        Text(
                          "Rp0",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Bill",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          widget.totalPrice.toString(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          "Payment Method:",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        SizedBox(width: 8),
                        Text(
                          widget.selectedMethod,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Spacer(),
                    Center(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: BarcodeWidget(
                              barcode: Barcode.qrCode(),
                              data: "abcdefg",
                              width: 150,
                              height: 150,
                              drawText: false,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "CODEBOOKING696",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }

  Future<void> _downloadInvoice(BuildContext context) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text('Invoice'),
          );
        },
      ),
    );

    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/invoice.pdf';
      final file = File(path);
      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invoice downloaded to $path')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download invoice: $e')),
      );
    }
  }
}
