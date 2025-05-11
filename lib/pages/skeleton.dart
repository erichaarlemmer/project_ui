import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_ui/pages/confirmation_page.dart';
import 'package:project_ui/pages/duration_page.dart';
import 'package:project_ui/pages/login_page.dart';
import 'package:project_ui/pages/plate_logged_page.dart';
import 'package:project_ui/pages/plate_page.dart';
import 'package:project_ui/pages/help_page.dart';
import 'dart:async';
import 'dart:convert';
import 'package:project_ui/pages/home_page.dart';
import 'package:project_ui/utils/config.dart';
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
  late Widget _currentPage;

  String _parkingName = "";
  List<int> _durations = [];
  List<int> _prices = [];
  String _plate = "";
  String _username = "";
  List<String> _userPlates = [];
  int _parkingDurationLeft = 0;

  int _curentTicketDuration = 0;
  int _curentTicketPrice = 0;

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

    _currentPage = HomePage(
      onButtonPressed: setPage,
      currentUsername: _username,
      setUsername: (username) {
        setState(() {
          _username = username;
        });
      },
    );

    _formattedDate = _getFormattedDate();
    _formattedTime = _getFormattedTime();
    // Update the time every minute
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      setState(() {
        _formattedDate = _getFormattedDate();
        _formattedTime = _getFormattedTime();
      });
    });
  }

  void _setListener() {
    channel.stream.listen((data) {
      final decoded = jsonDecode(data);
      print("decoded recv data : $decoded");
      if (decoded["type"] == "login") {
        if (_currentPage is LoginPage) {
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
          for (String s in decoded["plates"]) {
            _userPlates.add(s);
          }
        });
      } else if (decoded["type"] == "start") {
        if (_currentPage is HomePage) {
          setPage("plate");
        }
      } else if (decoded["type"] == "get_car_parcking_status") {
        setState(() {
          _parkingDurationLeft = decoded["time_left"];
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
    final dateFormatter = DateFormat('dd/MM/yyyy');
    return dateFormatter.format(now);
  }

  String _getFormattedTime() {
    final now = DateTime.now();
    final timeFormatter = DateFormat('HH:mm');
    return timeFormatter.format(now);
  }

  void createTicket() {
    print("I am creating ticket with data");
    final payload = jsonEncode({
      "type": "create_new_ticket",
      "totem_id": totemId,
      "price": _curentTicketPrice,
      "duration": _curentTicketDuration,
      "plate": _plate,
    });
    channel.sink.add(payload);
  }

  void setPage(String pageNb) {
    setState(() {
      switch (pageNb) {
        case "none":
          _currentPage = Placeholder();
          break;
        case "home":
          _currentPage = HomePage(
            onButtonPressed: setPage,
            currentUsername: _username,
            setUsername: (username) {
              setState(() {
                _username = username;
                if (username == "") {
                  _userPlates = [];
                }
              });
            },
          );
          break;
        case "help":
          _currentPage = HelpPage(
            onButtonPressed: setPage,
            prices: _prices,
            durations: _durations,
          );
          break;
        case "plate":
          if (_userPlates.isEmpty) {
            _currentPage = EnterPlatePage(
              onNavButtonPressed: setPage,
              setPlate: (p) {
                setState(() {
                  _plate = p;
                });
              },
            );
          } else {
            _currentPage = SelectionPage(
              options: _userPlates,
              onNavButtonPressed: setPage,
              setPlate: (p) {
                setState(() {
                  _plate = p;
                });
              },
            );
          }
          break;
        case "duration":
          _getCarParkingStatus();
          _currentPage = DurationPage(
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
          break;
        case "paye":
          _currentPage = ConfirmationPage(
            onButtonPressed: setPage,
            onTicketCreation: createTicket,
            plate: _plate,
            duration: _curentTicketDuration,
            price: _curentTicketPrice,
          );
          break;
        case "login":
          _currentPage = LoginPage(onNavButtonPressed: setPage);
          break;
        default:
          throw UnimplementedError();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(((60 / 1080) * screenHeight)),
        child: AppBar(
          title: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: ((50 / 1920) * screenWidth),
                ), // Padding for date and time
                child: Text(
                  _formattedDate,
                  style: TextStyle(fontSize: ((30 / 1080) * screenHeight)),
                ),
              ),
              Expanded(
                child: Center(
                  // This will center the time horizontally
                  child: Text(
                    _formattedTime,
                    style: TextStyle(fontSize: ((30 / 1080) * screenHeight)),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: ((50 / 1920) * screenWidth)),
              child: Text(
                _parkingName.isNotEmpty ? _parkingName : "Loading...",
                style: TextStyle(fontSize: ((30 / 1080) * screenHeight)),
              ),
            ),
          ],
          backgroundColor: Color(0xFFB0B0B0),
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
          _currentPage,
        ],
      ),
    );
  }
}
