import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:intl/intl.dart';
import 'package:tubes/entity/Film.dart';

class MovieTicketDetails extends StatelessWidget {
  final Film movie;
  final int ticketCount;
  final double ticketPrice;
  final double totalPrice;
  final String selectedTime;
  final String selectedCinemaFormat;
  final DateTime selectedDate;

  const MovieTicketDetails({
    Key? key,
    required this.movie,
    required this.ticketCount,
    required this.ticketPrice,
    required this.totalPrice,
    required this.selectedTime,
    required this.selectedCinemaFormat,
    required this.selectedDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Movie Ticket'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black, // To make the text black
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  movie
                      .poster, // Use the movie poster URL from the 'Film' object
                  width: 200,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16),
              Text(
                movie.judul_film, // Display movie title
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "ATMA Cinema, Studio 1", // Display selected cinema format
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 16),
              Column(
                children: [
                  Text(
                    DateFormat('EEEE, dd MMMM yyyy')
                        .format(selectedDate), // Display selected date
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    selectedTime, // Display selected time
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Column(
                children: [
                  Text(
                    "Seats: $ticketCount", // Display ticket count
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Total: Rp${totalPrice.toStringAsFixed(2)}", // Display total price
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              BarcodeWidget(
                barcode: Barcode.qrCode(), // Example barcode type
                data: "CODEBOOKING1", // Example barcode data (could be dynamic)
                width: 500,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
