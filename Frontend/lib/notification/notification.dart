import 'package:flutter/material.dart';
import 'package:tubes/notification/notif_detail.dart';

class NotifList extends StatelessWidget {
  const NotifList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: ListView(
          children: [
            NotifItem(
              imagePath: 'images/bg4.jpg',
              title: 'E-Voucher Discount up to Rp 500.000',
            ),
            NotifItem(
              imagePath: 'images/bg2.jpg',
              title: 'E-Voucher Discount up to Rp 50.000',
            ),
            NotifItem(
              imagePath: 'images/img_poster/endgame.jpg',
              title: 'Advance Ticket Sale Avengers: Endgame',
            ),
            NotifItem(
              imagePath: 'images/img_poster/Mufasa.jpg',
              title: 'Get 50% Cashback with BCA',
            ),
          ],
        ),
      ),
    );
  }
}

class NotifItem extends StatelessWidget {
  final String imagePath;
  final String title;

  const NotifItem({
    super.key,
    required this.imagePath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotifDetail(
              imagePath: imagePath,
              title: title,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0E1D39),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  bottomLeft: Radius.circular(16.0),
                ),
                child: Image.asset(
                  imagePath,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
