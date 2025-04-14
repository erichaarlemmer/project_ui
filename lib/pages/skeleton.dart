import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_ui/pages/duration_page.dart';
import 'package:project_ui/pages/login_page.dart';
import 'package:project_ui/pages/plate_page.dart';
import 'package:project_ui/pages/help_page.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
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

  final channel = WebSocketChannel.connect(Uri.parse(wsServerAddress));

  void _sendClientId() {
    final payload = jsonEncode({"client_id": totemId});
    channel.sink.add(payload);
  }

  Future<void> _fetchTotemData() async {
    final url = Uri.parse('$httpServerAddress/api/totem/$totemId');

    try {
      final response = await http.get(url);
      final Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        _parkingName = data["parking_name"]; // Triggers UI update
        _durations = List<int>.from(data["durations"]);
        _prices = List<int>.from(data["prices"]);
      });
    } catch (e) {
      setState(() {
        _parkingName = "Error loading name";
        _durations = [0, 1];
        _prices = [0, 100];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTotemData();
    _sendClientId();

    _setListener();

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
      if (_currentPage is LoginPage) {
        _username = decoded["username"];
        setPage("home");
      }
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    _timer
        .cancel(); // Make sure to cancel the timer when the widget is disposed
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
          _currentPage = EnterPlatePage(
            onNavButtonPressed: setPage,
            setPlate: (p) {
              _plate = p;
            },
          );
          break;
        case "duration":
          _currentPage = DurationPage(
            onNavButtonPressed: setPage,
            plate: _plate,
            durations: _durations,
            prices: _prices,
          );
          break;
        case "paye":
          _currentPage = Placeholder();
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
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 50,
              ), // Padding for date and time
              child: Text(_formattedDate, style: TextStyle(fontSize: 30)),
            ),
            Expanded(
              child: Center(
                // This will center the time horizontally
                child: Text(_formattedTime, style: TextStyle(fontSize: 30)),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 50),
            child: Text(
              _parkingName.isNotEmpty ? _parkingName : "Loading...",
              style: TextStyle(fontSize: 30),
            ),
          ),
        ],
        backgroundColor: Color(0xFFB0B0B0),
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
