import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:tubes/review/inputReview.dart';
import '../client/FilmClient.dart';
import '../entity/Film.dart';
import '../transaction/ticketDetails.dart';
import 'package:tubes/entity/Tiket.dart';
import 'package:tubes/client/TiketClient.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({Key? key}) : super(key: key);

  @override
  _TicketsPageState createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _searchQuery = "";
  List<Tiket> _onProgressTickets = [];
  List<Tiket> _historyTickets = [];
  bool _isLoading = true;
  String? token;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _speech = stt.SpeechToText();
    _fetchTickets();
  }

  Future<int> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? idUser = prefs.getInt('id_user');
    if (idUser == null) {
      throw Exception('User ID not found. Please log in again.');
    }
    return idUser;
  }

  Future<void> _fetchTickets() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      token = prefs.getString('token');
      int userId = await getUserId();

      List<Tiket> tickets =
          await TiketClient.fetchTicketsByUser(userId, token!);

      print("Fetched Tickets: $tickets");

      List<Tiket> onProgress = [];
      List<Tiket> history = [];

      for (var tiket in tickets) {
        tiket.updateStatus();
        print("Ticket: ${tiket.judulFilm}, Status: ${tiket.status}");

        if (tiket.status == "on progress") {
          onProgress.add(tiket);
        } else if (tiket.status == "history") {
          history.add(tiket);
        }
      }

      onProgress.sort((a, b) {
        DateTime now = DateTime.now();

        DateTime dateA = DateTime.parse(
          '${a.tanggal!.split('-').reversed.join('-')} ${a.jamTayang!}',
        );

        DateTime dateB = DateTime.parse(
          '${b.tanggal!.split('-').reversed.join('-')} ${b.jamTayang!}',
        );

        return dateA.difference(now).compareTo(dateB.difference(now));
      });

      print("On Progress Tickets (Sorted): $onProgress");
      print("History Tickets: ${history.length}");

      setState(() {
        _onProgressTickets = onProgress;
        _historyTickets = history;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching tickets: $e');
      setState(() => _isLoading = false);
    }
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) => print("onStatus: $status"),
        onError: (error) => print("onError: $error"),
      );

      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            setState(() {
              _searchQuery = result.recognizedWords;
            });
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Tickets",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins-Medium',
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A2038),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.search, color: Colors.white54),
                        onPressed: () {},
                      ),
                      Expanded(
                        child: TextField(
                          // controller: _searchController,
                          onChanged: (query) {
                            // _performSearch(query);
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search for transaction...',
                            hintStyle: TextStyle(color: Colors.white54),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.mic, color: Colors.white54),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
              TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                tabs: const [
                  Tab(
                    child: Text(
                      "On Progress",
                      style: TextStyle(
                        fontFamily: 'Poppins-Semibold',
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "History",
                      style: TextStyle(
                        fontFamily: 'Poppins-Semibold',
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildTicketList(_onProgressTickets, "IN PROGRESS"),
                      _buildTicketList(_historyTickets, "HISTORY"),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildTicketList(List<Tiket> tickets, String statusLabel) {
    return tickets.isEmpty
        ? Center(
            child: Text(
              "No $statusLabel tickets found",
              style: TextStyle(color: Colors.white70),
            ),
          )
        : ListView.builder(
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              final tiket = tickets[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(color: Colors.grey, width: 2.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6.0,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 16.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            tiket.poster ?? '',
                            width: 115,
                            height: 180,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.broken_image, size: 100),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 15),
                              Text(
                                tiket.judulFilm ?? "Unknown",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.location_on,
                                      color: Colors.white, size: 16),
                                  SizedBox(width: 6),
                                  Text(
                                    "ATMA cinema, Studio " +
                                        (tiket.noStudio != null
                                            ? tiket.noStudio.toString()
                                            : "Unknown"),
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(Icons.calendar_today,
                                      color: Colors.white, size: 16),
                                  SizedBox(width: 6),
                                  Text(
                                    tiket.tanggal ?? "Unknown",
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 14),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(Icons.access_time,
                                      color: Colors.white, size: 16),
                                  SizedBox(width: 6),
                                  Text(
                                    tiket.jamTayang ?? "Unknown",
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 14),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.chair_outlined,
                                              color: Colors.white, size: 16),
                                          SizedBox(width: 6),
                                          Text(
                                            (tiket.jumlah_kursi != null
                                                    ? tiket.jumlah_kursi
                                                        .toString()
                                                    : "Unknown") +
                                                " seat",
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Text(
                                            tiket.format ?? "Unknown",
                                            style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (tiket.status == "history") {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ReviewPage(
                                                idFilm: tiket.id_film!,
                                                poster: tiket.poster!),
                                          ),
                                        );
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MovieTicketDetails(
                                              movie: tiket.film ?? Film(
                                                id_film: tiket.id_film!,
                                                judul_film: tiket.judulFilm!,
                                                durasi: 0,
                                                rating_umur: "N/A",
                                                dimensi: "2D",
                                                tanggal_rilis: "0000-00-00",
                                                genre: "Unknown",
                                                sinopsis: "No description available.",
                                                producer: "Unknown",
                                                director: "Unknown",
                                                writers: "Unknown",
                                                cast: "Unknown",
                                                poster: tiket.poster!,
                                                status: "Unknown",
                                                rating: null,  // Rating can be null
                                              )
                                                  ,
                                              ticketCount:
                                                  tiket.jumlah_kursi ?? 1,
                                              ticketPrice: tiket.harga ?? 0.0,
                                              totalPrice:
                                                  (tiket.jumlah_kursi ?? 1) *
                                                      (tiket.harga ?? 0.0),
                                              selectedTime:
                                                  tiket.jamTayang ?? "Unknown",
                                              selectedCinemaFormat:
                                                  tiket.format ?? "Unknown",
                                              selectedDate: DateTime.parse(
                                                tiket.tanggal!
                                                    .split('-')
                                                    .reversed
                                                    .join('-'),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF0A2038),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        fixedSize: Size(100, 10)),
                                    child: Text(
                                      tiket.status == "history"
                                          ? "REVIEW"
                                          : "TICKET",
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }
}
