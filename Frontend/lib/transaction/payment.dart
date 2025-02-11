import 'package:flutter/material.dart';
import 'package:tubes/client/TransaksiClient.dart';
import 'package:tubes/client/TiketClient.dart';
import '../entity/Transaksi.dart';
import '../movie/movie.dart';
import 'paymentConfirmation.dart';
import 'package:intl/intl.dart';
import 'package:tubes/entity/Film.dart';
import 'package:tubes/entity/User.dart';
import 'package:tubes/entity/Tiket.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubes/client/UserClient.dart';

class Payment extends StatefulWidget {
  final Film movie;
  final int ticketCount;
  final double ticketPrice;
  final double totalPrice;
  final String selectedTime;
  final String selectedCinemaFormat;
  final DateTime selectedDate;
  final int idJadwal;

  const Payment({
    Key? key,
    required this.movie,
    required this.ticketCount,
    required this.ticketPrice,
    required this.totalPrice,
    required this.selectedTime,
    required this.selectedCinemaFormat,
    required this.selectedDate,
    required this.idJadwal,
  }) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  String? _selectedPaymentMethod;
  late String _paymentExpiryTime;
  int? _idUser;
  String? _token;

  @override
  void initState() {
    super.initState();
    _setPaymentExpiryTime();
    _loadUserData();
  }

  //Ini prosedur buat expiry time pembayaran
  //Logikanya itu waktu sekarang ditambah 15 menit
  //Formatnya tanggal bulan tahun, jam menit AM/PM
  void _setPaymentExpiryTime() {
    final now = widget.selectedDate;
    final expiryTime = now.add(const Duration(minutes: 15));
    _paymentExpiryTime = DateFormat('d MMMM yyyy, hh:mm a').format(expiryTime);
  }

  _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token'); // Mendapatkan token pengguna

    if (_token != null) {
      // Ambil data profil menggunakan UserClient
      User? user = await UserClient.getProfile(_token!);
      if (user != null) {
        // Mengisi data pengguna ke variabel state dari data yang didapat (database)
        setState(() {
          _idUser = user.id_user;
        });
      } else {
        // Handle error, jika data gagal diambil
        print('Failed to load user data');
      }
    }
  }

  Future<void> _saveTransaksi() async {
    try {
      int? id_transaksi = await TransaksiClient.storeTransaksi(
          _idUser, widget.totalPrice, "1", _token);
      if (id_transaksi != null) {
        final Map<String, dynamic> tiketData = {
          'id_transaksi': id_transaksi,
          'id_jadwal': widget.idJadwal,
          'jumlah_kursi': widget.ticketCount,
          'id_user': _idUser
        };
        Tiket hasil = await TiketClient.create(tiketData, _token);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentConfirmation(
              movie: widget.movie,
              ticketCount: widget.ticketCount,
              ticketPrice: widget.ticketPrice,
              totalPrice: widget.totalPrice,
              selectedTime: widget.selectedTime,
              selectedCinemaFormat: widget.selectedCinemaFormat,
              selectedDate: widget.selectedDate,
              selectedMethod: _selectedPaymentMethod.toString(),
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error occurred: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Order Confirmation",
            style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            //Ini menampilkan detail dari movie
            children: [
              //ini row untuk gambar dan detail movie
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
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Date: ${DateFormat('d MMM yyyy').format(widget.selectedDate)}",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
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
              //ini container untuk detail lokasi dan waktu
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A2038),
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
                          "${DateFormat('d MMM yyyy').format(widget.selectedDate)} - ${widget.selectedTime}",
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
              //ini bagian untuk menampilkan jumlah tiket dan harga
              Text("Ticket(s)",
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${widget.ticketCount} x Rp ${widget.ticketPrice.toStringAsFixed(3)}",
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
              //ini bagian untuk menampilkan total pembayaran
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
              //ini bagian untuk menampilkan tenggat waktu pembayaran
              Text(
                "Complete your payment before:",
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              Text(
                _paymentExpiryTime,
                style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              //ini button untuk memilih metode pembayaran
              ElevatedButton.icon(
                onPressed: _showPaymentMethodModal,
                icon: const Icon(Icons.payment, color: Colors.white),
                label: Text(
                  _selectedPaymentMethod ?? "Select Payment Method",
                  style: const TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A2D57),
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
              const SizedBox(height: 12),
              //ini button untuk konfirmasi pembayaran
              ElevatedButton(
                onPressed:
                    _selectedPaymentMethod == null ? null : _saveTransaksi,
                child: Text(
                  "CONFIRM PAYMENT Rp ${widget.totalPrice.toStringAsFixed(3)}",
                  style: const TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Prosedur buat menampilkan modal untuk memilih metode pembayaran
  void _showPaymentMethodModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select Payment Method",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text("E-Wallet",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.account_balance_wallet,
                    color: Colors.white),
                title:
                    const Text("GOPAY", style: TextStyle(color: Colors.white)),
                trailing: const Icon(Icons.chevron_right, color: Colors.white),
                onTap: () {
                  setState(() {
                    _selectedPaymentMethod = "GOPAY";
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.account_balance_wallet,
                    color: Colors.white),
                title:
                    const Text("DANA", style: TextStyle(color: Colors.white)),
                trailing: const Icon(Icons.chevron_right, color: Colors.white),
                onTap: () {
                  setState(() {
                    _selectedPaymentMethod = "DANA";
                  });
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16),
              const Text("Banks",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.account_balance, color: Colors.white),
                title: const Text("BCA Virtual Account",
                    style: TextStyle(color: Colors.white)),
                trailing: const Icon(Icons.chevron_right, color: Colors.white),
                onTap: () {
                  setState(() {
                    _selectedPaymentMethod = "BCA Virtual Account";
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
