import 'package:flutter/material.dart';
import 'package:tubes/entity/Film.dart';
import 'package:tubes/client/StudioClient.dart';
import 'package:tubes/client/FilmClient.dart';
import 'package:tubes/transaction/payment.dart';

class MovieShowtimePage extends StatefulWidget {
  final Film movie;

  const MovieShowtimePage({
    required this.movie,
    Key? key,
  }) : super(key: key);

  @override
  State<MovieShowtimePage> createState() => _MovieShowtimePageState();
}

class Jadwal {
  int nomorStudio;
  List<String> showtimes;

  Jadwal({
    required this.nomorStudio,
    required this.showtimes,
  });
}

class Showtime {
  final String id;
  final String time;
  final String price;

  Showtime({required this.id, required this.time, required this.price});
}

class _MovieShowtimePageState extends State<MovieShowtimePage> {
  int selectedDateIndex = 0;
  DateTime? selectedDate;
  String? selectedTime;
  Map<String, dynamic> filmSchedule = {}; // Untuk menyimpan jadwal film
  Future<int> availableSeats = Future.value(0);

  @override
  void initState() {
    super.initState();
    selectedDate =
        DateTime.now(); // Biar tanggal awal di view adalah tanggal hari ini
    selectedDateIndex =
        0; // Menyeting index tanggal yang dipilih adalah tanggal hari ini
    _loadFilmSchedule();
  }

  // Fungsi untuk memuat jadwal film dari API
  void _loadFilmSchedule() async {
    try {
      var scheduleData =
          await FilmClient.getFilmSchedule(widget.movie.id_film, selectedDate);
      print("Schedule data received: $scheduleData");
      setState(() {
        filmSchedule = scheduleData; // Untuk nyimpan data jadwal film
      });
    } catch (e) {
      print('Error fetching schedule: $e');
    }
  }

  // Untuk mendapatkan nama bulan berdasarkan angka bulan
  String _getMonth(int month) {
    List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return months[month - 1];
  }

  Future<int> countSeat(int idJadwal, int idFilm) async {
    try {
      var response = await StudioClient.countBookedDate(idJadwal, idFilm);
      int availableSeats = response['data'];
      print("Available seats: $availableSeats");
      return availableSeats;
    } catch (e) {
      print("Error fetching seat count: $e");
      return 0;
    }
  }

  Widget _buildShowtimesList() {
    if (filmSchedule.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    // List untuk menyimpan showtimes
    List<Showtime> showtimes = [];

    filmSchedule.forEach((key, value) {
      if (value is List) {
        for (var item in value) {
          if (item is Map && item.containsKey('jam_tayang')) {
            showtimes.add(Showtime(
              id: item['id_jadwal'].toString(),
              time: item['jam_tayang'].toString(),
              price: item['harga'].toString(),
            ));
          }
        }
      } else {
        print("Unexpected data for key $key: $value");
      }
    });

    // Mengecek apakah showtimes kosong
    if (showtimes.isEmpty) {
      return Center(child: Text('No showtimes available.'));
    }

    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 16.0,
      runSpacing: 16.0,
      children: showtimes.map((showtime) {
        return Container(
          width: 180,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                selectedTime = showtime.time;
              });
              _showTicketSelectionModal(
                  showtime.id, showtime.time, showtime.price);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  selectedTime == showtime ? Colors.amber : Colors.grey[800],
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(
                  color: selectedTime == showtime
                      ? Colors.amber
                      : Colors.grey[600]!,
                  width: 2.0,
                ),
              ),
              elevation: 5,
            ),
            child: Text(
              showtime.time,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        );
      }).toList(),
    );
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
        title: Text(
          widget.movie.judul_film,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ini Bagian Detail Dari Film
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
                          Row(
                            children: [
                              const Icon(Icons.access_time,
                                  color: Colors.grey, size: 14),
                              const SizedBox(width: 4),
                              Text("${widget.movie.durasi} min",
                                  style: const TextStyle(color: Colors.white)),
                              const SizedBox(width: 16),
                              const Icon(Icons.visibility,
                                  color: Colors.grey, size: 14),
                              const SizedBox(width: 4),
                              Text("${widget.movie.rating_umur}",
                                  style: TextStyle(color: Colors.white)),
                              const SizedBox(width: 16),
                              const Icon(Icons.theaters,
                                  color: Colors.grey, size: 14),
                              const SizedBox(width: 4),
                              Text("${widget.movie.dimensi}",
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text("${widget.movie.genre}",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 16)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Bagian Pemilihan Tanggal
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 7,
                    itemBuilder: (context, index) {
                      DateTime date = DateTime.now().add(Duration(days: index));
                      bool isSelected = selectedDateIndex == index;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDateIndex = index;
                            selectedDate = date;
                            _loadFilmSchedule();
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF0A2038)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: Text(
                              "${date.day} ${_getMonth(date.month)}",
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),
                Text(
                  'Showtimes',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 8),
                _buildShowtimesList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTicketSelectionModal(String id, String time, String price) {
    int idJadwal = int.parse(id);
    print("Selected id: $id");
    int seatCount = 1;
    double ticketPrice = double.parse(price);
    double totalPrice = ticketPrice * seatCount;

    availableSeats = countSeat(idJadwal, widget.movie.id_film);

    print("Available seats: $availableSeats");

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
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
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Time: $time",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "Price: \Rp${price}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<int>(
                    future: availableSeats,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text(
                          "Error fetching available seats",
                          style: TextStyle(color: Colors.white),
                        );
                      } else if (snapshot.hasData) {
                        int availableSeatCount = snapshot.data ?? 0;
                        return Column(
                          children: [
                            Text(
                              "Available Seats: $availableSeatCount",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove, color: Colors.white),
                                  onPressed: () {
                                    if (seatCount > 1) {
                                      setModalState(() {
                                        seatCount--;
                                        totalPrice = ticketPrice * seatCount;
                                      });
                                    }
                                  },
                                ),
                                Text("$seatCount",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18)),
                                IconButton(
                                  icon: Icon(Icons.add, color: Colors.white),
                                  onPressed: () {
                                    if (seatCount < 100) {
                                      setModalState(() {
                                        seatCount++;
                                        totalPrice = ticketPrice * seatCount;
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                print('Navigating to Payment');
                                print('Movie: ${widget.movie}');
                                print('Seat Count: $seatCount');
                                print('Ticket Price: $ticketPrice');
                                print('Total Price: $totalPrice');
                                print('Selected Time: $time');
                                print(
                                    'Selected Cinema Format: ${widget.movie.dimensi}');
                                print('Selected Date: $selectedDate');
                                print('ID Jadwal: $idJadwal');
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Payment(
                                    movie: widget.movie,
                                    ticketCount: seatCount,
                                    ticketPrice: ticketPrice,
                                    totalPrice: totalPrice,
                                    selectedTime: time,
                                    selectedCinemaFormat: widget.movie.dimensi,
                                    selectedDate: selectedDate!,
                                    idJadwal: idJadwal,
                                  ),
                                ));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 48),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                              child: const Text("CONTINUE",
                                  style: TextStyle(color: Colors.black)),
                            ),
                          ],
                        );
                      } else {
                        return const Text(
                          "No data available",
                          style: TextStyle(color: Colors.white),
                        );
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
