import 'package:flutter/material.dart';
import '../movie/movie.dart';
import '../home/home.dart';
import 'package:intl/intl.dart';
// import 'package:tubes/transaction/invoice_pdf.dart';
import '../transaction/ticketDetails.dart';
import '../transaction/invoice_pdf.dart';
import 'package:tubes/entity/Film.dart';
import 'package:tubes/entity/User.dart';
import 'package:tubes/client/UserClient.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentConfirmation extends StatefulWidget {
  final Film movie;
  final int ticketCount;
  final double ticketPrice;
  final double totalPrice;
  final String selectedTime;
  final String selectedCinemaFormat;
  final DateTime selectedDate;
  final String selectedMethod;

  const PaymentConfirmation({
    Key? key,
    required this.movie,
    required this.ticketCount,
    required this.ticketPrice,
    required this.totalPrice,
    required this.selectedTime,
    required this.selectedCinemaFormat,
    required this.selectedDate,
    required this.selectedMethod,
  }) : super(key: key);

  @override
  _PaymentConfirmationState createState() => _PaymentConfirmationState();
}

class _PaymentConfirmationState extends State<PaymentConfirmation> {
  String? token;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  void _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token'); // Mengambil token dari SharedPreferences
    print(token);

    if (token != null) {
    } else {
      // Kalau token tidak ada  / null, maka print pesan error dan mundur ke halaman login
      print('Token not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false, //Biar gak bisa back
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 100),
              const SizedBox(height: 16),
              const Text(
                "PAYMENT SUCCESSFUL",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieTicketDetails(
                        movie: widget.movie, // Pass the movie object
                        ticketCount: widget.ticketCount,
                        ticketPrice: widget.ticketPrice,
                        totalPrice: widget.totalPrice,
                        selectedTime: widget.selectedTime,
                        selectedCinemaFormat: widget.selectedCinemaFormat,
                        selectedDate: widget.selectedDate,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(40),
                ),
                child: const Text(
                  "CHECK YOUR TICKETS",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InvoicePage(
                        movie: widget.movie,
                        ticketCount: widget.ticketCount,
                        ticketPrice: widget.ticketPrice,
                        totalPrice: widget.totalPrice,
                        selectedTime: widget.selectedTime,
                        selectedCinemaFormat: widget.selectedCinemaFormat,
                        selectedDate: widget.selectedDate,
                        selectedMethod: widget.selectedMethod,
                        token: token.toString(),
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Check Invoice",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              const SizedBox(height: 16),
              //Ini ya buat detail pembayaran dan movienya apa
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      widget.movie.poster,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.movie.judul_film,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: const [
                            Icon(Icons.access_time,
                                color: Colors.grey, size: 14),
                            SizedBox(width: 4),
                            Text("1h 20m",
                                style: TextStyle(color: Colors.white)),
                            SizedBox(width: 16),
                            Icon(Icons.visibility,
                                color: Colors.grey, size: 14),
                            SizedBox(width: 4),
                            Text("17+", style: TextStyle(color: Colors.white)),
                            SizedBox(width: 16),
                            Icon(Icons.theaters, color: Colors.grey, size: 14),
                            SizedBox(width: 4),
                            Text("2D", style: TextStyle(color: Colors.white)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Action, Sci-Fi",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A2D57),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          "ATMA Cinema, Studio 1",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('d MMM yyyy').format(widget.selectedDate),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          widget.selectedTime,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.chair, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          widget.selectedCinemaFormat,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Ticket(s): ${widget.ticketCount} x Rp ${widget.ticketPrice.toStringAsFixed(3)}",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    "Rp ${widget.totalPrice.toStringAsFixed(3)}",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
              const Divider(color: Colors.grey),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total Payment",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Rp ${widget.totalPrice.toStringAsFixed(3)}",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => homePage()),
                    //Itu harusnya routing ke halaman ticket
                    //Tapi sementara ini routing ke home dulu
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text(
                  "CONTINUE",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
