import 'package:flutter/material.dart';
import 'package:project_ui/web/widgets/big_button.dart';
import 'package:project_ui/web/widgets/wireless_payment.dart';

class HomePage extends StatelessWidget {
  final Function(String) onButtonPressed;
  final Function(String) setUsername;
  final String currentUsername;

  const HomePage({
    super.key,
    required this.onButtonPressed,
    required this.currentUsername,
    required this.setUsername,
  });

  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    Widget loginLogoutBtn;

    if (currentUsername.isEmpty) {
      loginLogoutBtn = BigButton(
        onButtonPressed: () => {onButtonPressed("login")},
        isLeft: true,
        isBottom: false,
        isCircle: false,
        color: Colors.grey,
        children: [
          Text(
            "Login",
            style: TextStyle(
              color: Colors.white,
              fontSize: ((100 / 1080) * screenHeight),
            ),
          ),
          SizedBox(width: 8),
          Icon(
            Icons.login,
            color: Colors.white,
            size: ((100 / 1080) * screenHeight),
          ),
        ],
      );
    } else {
      loginLogoutBtn = BigButton(
        onButtonPressed: () {
          this.setUsername("");
          onButtonPressed("home");
        },
        isLeft: true,
        isBottom: false,
        isCircle: false,
        color: Colors.grey,
        children: [
          Text(
            "Logout",
            style: TextStyle(
              color: Colors.white,
              fontSize: ((100 / 1080) * screenHeight),
            ),
          ),
          SizedBox(width: 8),
          Icon(
            Icons.logout,
            color: Colors.white,
            size: ((100 / 1080) * screenHeight),
          ),
        ],
      );
    }

    return Stack(
      children: [
        BigButton(
          onButtonPressed: () => {onButtonPressed("help")},
          isLeft: true,
          isBottom: true,
          isCircle: true,
          color: Colors.grey,
          children: [
            Padding(
              padding: EdgeInsets.all((50 / 1080) * screenHeight),
              child: Text(
                "?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ((100 / 1080) * screenHeight),
                ),
              ),
            ),
          ],
        ),
        WirelessPayment(
          color: Colors.green,
          children: [
            Text(
              "Start",
              style: TextStyle(
                color: Colors.white,
                fontSize: ((100 / 1080) * screenHeight),
              ),
            ),
            SizedBox(width: 20),
            Icon(
              Icons.payment_outlined,
              color: Colors.white,
              size: ((200 / 1080) * screenHeight),
            ),
            Icon(
              Icons.contactless_outlined,
              color: Colors.white,
              size: ((200 / 1080) * screenHeight),
            ),
          ],
        ),

        loginLogoutBtn,

        Center(
          child: Text(
            "Welcome $currentUsername",
            style: TextStyle(
              color: Colors.black,
              fontSize: ((182 / 1080) * screenHeight),
            ),
          ),
        ),
      ],
    );
  }
}
