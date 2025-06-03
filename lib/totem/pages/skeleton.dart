import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_ui/totem/pages/confirmation_page.dart';
import 'package:project_ui/totem/pages/duration_page.dart';
import 'package:project_ui/totem/pages/login_page.dart';
import 'package:project_ui/totem/pages/plate_logged_page.dart';
import 'package:project_ui/totem/pages/plate_page.dart';
import 'package:project_ui/totem/pages/help_page.dart';
import 'dart:async';
import 'dart:convert';
import 'package:project_ui/totem/pages/home_page.dart';
import 'package:project_ui/totem/pages/ticket_page.dart';
import 'package:project_ui/totem/utils/config_totem.dart';
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

  final channel = WebSocketChannel.connect(Uri.parse(wsServerAddress));

  void _sendClientId() {
    final payload = jsonEncode({"type": "set_client_id", "client_id": totemId});
    channel.sink.add(payload);
  }

  void _getTotemInfos() {
    final payload = jsonEncode({
      "type": "get_totem_infos",
      "totem_id": totemId,
    });
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

  void _setTotemInfos(Map<String, dynamic> data) {
    setState(() {
      _parkingName = data["parking_name"];
      _durations = List<int>.from(data["durations"]);
      _prices = List<int>.from(data["prices"]);
    });
  }

  @override
  void initState() {
    super.initState();
    _setListener();
    _getTotemInfos();
    _sendClientId();

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
      } else if (decoded["type"] == "totem_data") {
        _setTotemInfos(decoded);
      } else if (decoded["type"] == "user_cars") {
        setState(() {
          _userPlates = List<String>.from(decoded["plates"]);
        });
      } else if (decoded["type"] == "start") {
        if (_currentPageKey == "home") {
          setPage("plate");
        }
      } else if (decoded["type"] == "get_car_parcking_status") {
        setState(() {
          _parkingDurationLeft = decoded["time_left"];
        });
      } else if (decoded["type"] == "ticket_creation") {
        setState(() {
          _currentTicketCreationTime = decoded["creationTime"];
          _currentTicketId = decoded["ticketId"];
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
      "totem_id": totemId,
      "price": _curentTicketPrice,
      "duration": _curentTicketDuration,
      "token": token,
      "plate": _plate,
    });
    channel.sink.add(payload);
    setPage("visualise_ticket");
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
        return LoginPage(onNavButtonPressed: setPage);
      case "visualise_ticket":
        return TicketPage(
          onButtonPressed: setPage,
          plate: _plate,
          duration: _curentTicketDuration,
          price: _curentTicketPrice,
          ticketId: _currentTicketId,
          ticketCreationTime: _currentTicketCreationTime,
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
                  child: Text(
                    _parkingName.isNotEmpty ? _parkingName : "Loading...",
                    style: TextStyle(fontSize: (60 / 1080) * screenHeight),
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
