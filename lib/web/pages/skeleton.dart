import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_ui/web/pages/confirmation_page.dart';
import 'package:project_ui/web/pages/duration_page.dart';
import 'package:project_ui/web/pages/login_page.dart';
import 'package:project_ui/web/pages/plate_logged_page.dart';
import 'package:project_ui/web/pages/plate_page.dart';
import 'package:project_ui/web/pages/help_page.dart';
import 'dart:async';
import 'dart:convert';
import 'package:project_ui/web/pages/home_page.dart';
import 'package:project_ui/web/pages/ticket_page.dart';
import 'package:project_ui/web/utils/config_web.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SkeletonPage extends StatefulWidget {
  const SkeletonPage({super.key});

  @override
  State<SkeletonPage> createState() => _SkeletonPageState();
}

class _SkeletonPageState extends State<SkeletonPage> {
  late String _formattedTime;
  late String _formattedDate;
  late Timer _timer;

  String _clientId = "";
  List<String> _allParkingNames = [];
  String _currentPageKey = "home";

  String _parkingName = "";
  List<int> _durations = [];
  List<int> _prices = [];

  String _username = "";

  String _plate = "";
  List<String> _userPlates = [];
  int _parkingDurationLeft = 0;
  int _curentTicketDuration = 0;
  int _curentTicketPrice = 0;
  String _currentTicketId = "";
  int _currentTicketCreationTime = 0;
  int _currentTicketEnd = 0;

  final channel = WebSocketChannel.connect(Uri.parse(wsServerAddress));

  String _generateRandomString(int length) {
    const characters =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();
    return List.generate(
      length,
      (index) => characters[random.nextInt(characters.length)],
    ).join();
  }

  void _sendClientId() {
    final payload = jsonEncode({
      "type": "set_client_id",
      "client_id": _clientId,
    });
    channel.sink.add(payload);
  }

  void _getParkingData() {
    final payload = jsonEncode({
      "type": "get_parking_infos",
      "parking_name": _parkingName,
    });
    channel.sink.add(payload);
  }

  void _getAllParkings() {
    final payload = jsonEncode({"type": "get_all_parkings"});
    channel.sink.add(payload);
  }

  void _getUserCars(username) {
    final payload = jsonEncode({"type": "get_user_cars", "username": username});
    channel.sink.add(payload);
  }

  void _getCarParkingStatus() {
    final payload = jsonEncode({
      "type": "get_car_parcking_status",
      "plate": _plate,
    });
    channel.sink.add(payload);
  }

  void _setParkingData(Map<String, dynamic> data) {
    setState(() {
      _parkingName = data["parking_name"];
      _durations = List<int>.from(data["durations"]);
      _prices = List<int>.from(data["prices"]);
    });
  }

  @override
  void initState() {
    setState(() {
      _clientId = _generateRandomString(20);
    });

    super.initState();
    _setListener();
    _sendClientId();
    _getAllParkings();

    _formattedDate = _getFormattedDate();
    _formattedTime = _getFormattedTime();

    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      setState(() {
        _formattedDate = _getFormattedDate();
        _formattedTime = _getFormattedTime();
      });
    });
  }

  void _setListener() {
    // add the ticket_creation type to get the ticket_id
    channel.stream.listen((data) {
      final decoded = jsonDecode(data);
      print("decoded recv data : $decoded");
      if (decoded["type"] == "login") {
        if (_currentPageKey == "login") {
          setState(() {
            _username = decoded["username"];
          });
          setPage("home");
          _getUserCars(_username);
        }
      } else if (decoded["type"] == "all_parking_names") {
        setState(() {
          _allParkingNames = List<String>.from(decoded["all_parking_names"]);
        });
      } else if (decoded["type"] == "parking_data") {
        _setParkingData(decoded);
      } else if (decoded["type"] == "user_cars") {
        setState(() {
          _userPlates = List<String>.from(decoded["plates"]);
        });
      } else if (decoded["type"] == "get_car_parcking_status") {
        setState(() {
          _parkingDurationLeft = decoded["time_left"];
        });
      } else if (decoded["type"] == "ticket_creation") {
        setState(() {
          _currentTicketCreationTime = decoded["start_time"];
          _currentTicketId = decoded["ticket_id"];
          _currentTicketEnd = decoded["stop_time"];
          _currentPageKey = "visualise_ticket";
        });
      }
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    _timer.cancel();
    super.dispose();
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    return DateFormat('dd/MM/yyyy').format(now);
  }

  String _getFormattedTime() {
    final now = DateTime.now();
    return DateFormat('HH:mm').format(now);
  }

  void createTicket() {
    final payload = jsonEncode({
      "type": "create_new_ticket",
      "parking_name": _parkingName,
      "price": _curentTicketPrice,
      "duration": _curentTicketDuration,
      "plate": _plate,
    });
    channel.sink.add(payload);
    // setPage("visualise_ticket");
  }

  void setPage(String pageNb) {
    setState(() {
      _currentPageKey = pageNb;
      if (pageNb == "duration") {
        _getCarParkingStatus();
      }
    });
  }

  Widget _getCurrentPage() {
    // reset all values on comme back on home page
    switch (_currentPageKey) {
      case "home":
        return HomePage(
          onButtonPressed: setPage,
          currentUsername: _username,
          setUsername: (username) {
            setState(() {
              _username = username;
              if (username == "") _userPlates = [];
            });
          },
        );
      case "help":
        return HelpPage(
          onButtonPressed: setPage,
          prices: _prices,
          durations: _durations,
        );
      case "plate":
        return _userPlates.isEmpty
            ? EnterPlatePage(
              onNavButtonPressed: setPage,
              setPlate: (p) => setState(() => _plate = p),
            )
            : SelectionPage(
              options: _userPlates,
              onNavButtonPressed: setPage,
              setPlate: (p) => setState(() => _plate = p),
            );
      case "duration":
        return DurationPage(
          onNavButtonPressed: setPage,
          currentParkingDuration: _parkingDurationLeft,
          plate: _plate,
          durations: _durations,
          prices: _prices,
          setDurationPrice: (d, p) {
            setState(() {
              _curentTicketDuration = d;
              _curentTicketPrice = p;
            });
          },
        );
      case "paye":
        return ConfirmationPage(
          onButtonPressed: setPage,
          onTicketCreation: createTicket,
          plate: _plate,
          duration: _curentTicketDuration,
          price: _curentTicketPrice,
        );
      case "login":
        return LoginPage(onNavButtonPressed: setPage, clienId: _clientId);
      case "visualise_ticket":
        return TicketPage(
          onButtonPressed: setPage,
          plate: _plate,
          duration: _curentTicketDuration,
          price: _curentTicketPrice,
          ticketId: _currentTicketId,
          ticketCreationTime: _currentTicketCreationTime,
          ticketEnd: _currentTicketEnd,
          parkingName: _parkingName,
        );
      default:
        return const Placeholder();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight((120 / 1080) * screenHeight),
        child: AppBar(
          backgroundColor: Color(0xFFB0B0B0),
          flexibleSpace: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: (60 / 1920) * screenWidth,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: ((40 / 1920) * screenWidth)),
                  child: Text(
                    _formattedDate,
                    style: TextStyle(fontSize: (60 / 1080) * screenHeight),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      _formattedTime,
                      style: TextStyle(fontSize: (60 / 1080) * screenHeight),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: ((40 / 1920) * screenWidth)),
                  child:
                      _currentPageKey == "home"
                          ? DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value:
                                  _parkingName.isNotEmpty ? _parkingName : null,
                              hint: Text(
                                "Select Parking",
                                style: TextStyle(
                                  fontSize: (60 / 1080) * screenHeight,
                                ),
                              ),
                              icon: Icon(
                                Icons.arrow_drop_down,
                                size: (60 / 1080) * screenHeight,
                              ),
                              items:
                                  _allParkingNames.map((String name) {
                                    return DropdownMenuItem<String>(
                                      value: name,
                                      child: Text(
                                        name,
                                        style: TextStyle(
                                          fontSize: (60 / 1080) * screenHeight,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    _parkingName = newValue;
                                  });
                                  _getParkingData();
                                }
                              },
                            ),
                          )
                          : Text(
                            _parkingName.isNotEmpty
                                ? _parkingName
                                : "Loading...",
                            style: TextStyle(
                              fontSize: (60 / 1080) * screenHeight,
                            ),
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.white.withOpacity(0.86)),
          _getCurrentPage(),
        ],
      ),
    );
  }
}
